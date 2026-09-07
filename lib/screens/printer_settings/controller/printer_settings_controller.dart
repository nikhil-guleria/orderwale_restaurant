import 'dart:async';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'printer_connection_service.dart';



class PrinterSettingsController extends GetxController {
  final PrinterConnectionService service = PrinterConnectionService.instance;

  final RxList<Printer> foundPrinters = <Printer>[].obs;
  final RxList<BluetoothInfo> classicPairedDevices = <BluetoothInfo>[].obs;
  final RxBool scanning = false.obs;
  final RxBool loadingClassic = false.obs;
  final RxBool permissionGranted = true.obs; // optimistic until checked

  StreamSubscription<List<Printer>>? _scanSub;

  @override
  void onInit() {
    super.onInit();
    // Ask for Bluetooth permission the moment this screen opens, per your
    // requirement — this is the only screen that should ever prompt.
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final granted = await service.requestBluetoothPermissions();
    permissionGranted.value = granted;
    if (!granted) {
      Get.snackbar(
        'Permission needed',
        service.lastError.value ??
            'Bluetooth permission is required to find and connect printers.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Scans BLE + USB at once (network intentionally left out for now).
  Future<void> scanAll() async {
    if (!permissionGranted.value) {
      // User denied earlier — try asking again instead of silently failing.
      await _requestPermissions();
      if (!permissionGranted.value) return;
    }

    try {
      foundPrinters.clear();
      scanning.value = true;

      final stream = await service.scan([ConnectionType.BLE, ConnectionType.USB]);
      _scanSub = stream.listen(
            (devices) => foundPrinters.assignAll(devices),
        onError: (e) {
          Get.snackbar('Scan error', e.toString(), snackPosition: SnackPosition.BOTTOM);
        },
      );


      await Future.delayed(const Duration(seconds: 6));
    } catch (e) {
      Get.snackbar('Scan error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      service.stopScan();
      await _scanSub?.cancel();
      scanning.value = false;
    }
  }

  /// User tapped "Use this" on a BLE/USB found device — connect, then save
  /// as THE printer (overwrites whatever was saved before).
  Future<void> selectPrinter(Printer device) async {
    final connType = device.connectionType ?? ConnectionType.BLE;
    service.status.value = PrinterStatus.connecting;

    try {
      final ok = await service.connectDevice(device);
      if (!ok) {
        service.status.value = PrinterStatus.error;
        return;
      }

      service.connectedDevice = device;
      service.saveSavedPrinter(
        SavedPrinterInfo(
          name: device.name ?? 'Unknown',
          address: device.address ?? '',
          type: transportFromConnectionType(connType),
        ),
      );
      service.status.value = PrinterStatus.connected;
    } catch (e) {
      service.status.value = PrinterStatus.error;
      Get.snackbar('Unexpected error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Classic Bluetooth (SPP) has no live scan — it only lists devices
  /// already paired via the phone's own Bluetooth settings. Pair there
  /// first, then this picks it up.
  Future<void> loadClassicPairedDevices() async {
    loadingClassic.value = true;
    try {
      final devices = await service.getClassicPairedDevices();
      classicPairedDevices.assignAll(devices);
    } finally {
      loadingClassic.value = false;
    }
  }

  /// User tapped "Use this" on a Classic Bluetooth paired device.
  Future<void> selectClassicPrinter(BluetoothInfo device) async {
    service.status.value = PrinterStatus.connecting;

    final ok = await service.connectClassicDevice(device.macAdress);
    if (!ok) {
      service.status.value = PrinterStatus.error;
      return;
    }

    service.saveSavedPrinter(
      SavedPrinterInfo(
        name: device.name,
        address: device.macAdress,
        type: PrinterTransport.classicBluetooth,
      ),
    );
    service.status.value = PrinterStatus.connected;
  }

  /// Validates + tests + saves a network (WiFi) printer by IP/port.
  /// Used by the "Add Network Printer" dialog on the settings screen.
  Future<void> addNetworkPrinter(String ip, int port) async {
    final trimmedIp = ip.trim();

    if (!service.isValidIPv4(trimmedIp)) {
      Get.snackbar('Invalid IP', 'Enter a valid IP address, e.g. 192.168.1.50',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (port <= 0 || port > 65535) {
      Get.snackbar('Invalid port', 'Port must be between 1 and 65535',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    service.status.value = PrinterStatus.connecting;

    final reachable = await service.testNetworkConnection(trimmedIp, port);
    if (!reachable) {
      service.status.value = PrinterStatus.error;
      Get.snackbar('Connection failed', service.lastError.value ?? 'Could not reach printer',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    service.saveSavedPrinter(
      SavedPrinterInfo(
        name: 'Network Printer ($trimmedIp)',
        address: trimmedIp,
        type: PrinterTransport.network,
        port: port,
      ),
    );
    service.status.value = PrinterStatus.connected;
  }

  /// "Reconnect" button — Classic re-connects by MAC directly (no scan
  /// needed); BLE/USB re-scan and connect; network just re-tests the socket.
  Future<void> reconnect() async {
    final saved = service.savedPrinter.value;
    if (saved == null) return;

    if (saved.isNetwork) {
      service.status.value = PrinterStatus.connecting;
      final ok = await service.testNetworkConnection(
        saved.address,
        saved.port ?? kDefaultNetworkPrinterPort,
      );
      service.status.value = ok ? PrinterStatus.connected : PrinterStatus.error;
      return;
    }

    if (saved.isClassicBluetooth) {
      service.status.value = PrinterStatus.connecting;
      final ok = await service.connectClassicDevice(saved.address);
      service.status.value = ok ? PrinterStatus.connected : PrinterStatus.error;
      return;
    }

    if (!permissionGranted.value) {
      await _requestPermissions();
      if (!permissionGranted.value) return;
    }

    service.status.value = PrinterStatus.connecting;

    try {
      final connType = saved.type == PrinterTransport.usb
          ? ConnectionType.USB
          : ConnectionType.BLE;
      final stream = await service.scan([connType]);
      final devices = await stream
          .firstWhere(
            (list) => list.any((d) => d.address == saved.address),
        orElse: () => <Printer>[],
      )
          .timeout(const Duration(seconds: 6), onTimeout: () => <Printer>[]);
      service.stopScan();

      final match = devices.where((d) => d.address == saved.address).firstOrNull;
      if (match == null) {
        service.status.value = PrinterStatus.error;
        service.lastError.value = '${saved.name} not found — is it powered on?';
        return;
      }

      final ok = await service.connectDevice(match);
      if (!ok) {
        service.status.value = PrinterStatus.error;
        return;
      }

      service.connectedDevice = match;
      service.status.value = PrinterStatus.connected;
    } catch (e) {
      service.status.value = PrinterStatus.error;
      service.lastError.value = 'Reconnect failed: $e';
    }
  }

  /// "Remove" button — disconnects (if live) and clears saved storage.
  Future<void> removeSaved() async {
    try {
      if (service.connectedDevice != null) {
        await service.disconnectDevice(service.connectedDevice!);
      }
    } finally {
      service.clearSavedPrinter();
    }
  }

  @override
  void onClose() {
    _scanSub?.cancel();
    service.stopScan();
    super.onClose();
  }
}


/*
import 'dart:async';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'printer_connection_service.dart';



class PrinterSettingsController extends GetxController {
  final PrinterConnectionService service = PrinterConnectionService.instance;

  final RxList<Printer> foundPrinters = <Printer>[].obs;
  final RxBool scanning = false.obs;
  final RxBool permissionGranted = true.obs; // optimistic until checked

  StreamSubscription<List<Printer>>? _scanSub;

  @override
  void onInit() {
    super.onInit();
    // Ask for Bluetooth permission the moment this screen opens, per your
    // requirement — this is the only screen that should ever prompt.
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final granted = await service.requestBluetoothPermissions();
    permissionGranted.value = granted;
    if (!granted) {
      Get.snackbar(
        'Permission needed',
        service.lastError.value ??
            'Bluetooth permission is required to find and connect printers.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Scans BLE + USB at once (network intentionally left out for now).
  Future<void> scanAll() async {
    if (!permissionGranted.value) {
      // User denied earlier — try asking again instead of silently failing.
      await _requestPermissions();
      if (!permissionGranted.value) return;
    }

    try {
      foundPrinters.clear();
      scanning.value = true;

      final stream = await service.scan([ConnectionType.BLE, ConnectionType.USB]);
      _scanSub = stream.listen(
            (devices) => foundPrinters.assignAll(devices),
        onError: (e) {
          Get.snackbar('Scan error', e.toString(), snackPosition: SnackPosition.BOTTOM);
        },
      );


      await Future.delayed(const Duration(seconds: 6));
    } catch (e) {
      Get.snackbar('Scan error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      service.stopScan();
      await _scanSub?.cancel();
      scanning.value = false;
    }
  }

  /// User tapped "Use this" — connect, then save as THE printer
  /// (overwrites whatever was saved before).
  Future<void> selectPrinter(Printer device) async {
    final type = device.connectionType ?? ConnectionType.BLE;
    service.status.value = PrinterStatus.connecting;

    try {
      final ok = await service.connectDevice(device);
      if (!ok) {
        service.status.value = PrinterStatus.error;
        return;
      }

      service.connectedDevice = device;
      service.saveSavedPrinter(
        SavedPrinterInfo(
          name: device.name ?? 'Unknown',
          address: device.address ?? '',
          type: type,
        ),
      );
      service.status.value = PrinterStatus.connected;
    } catch (e) {
      service.status.value = PrinterStatus.error;
      service.lastError.value = 'Unexpected error: $e';
    }
  }

  /// Validates + tests + saves a network (WiFi) printer by IP/port.
  /// Used by the "Add Network Printer" dialog on the settings screen.
  Future<void> addNetworkPrinter(String ip, int port) async {
    final trimmedIp = ip.trim();

    if (!service.isValidIPv4(trimmedIp)) {
      Get.snackbar('Invalid IP', 'Enter a valid IP address, e.g. 192.168.1.50',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (port <= 0 || port > 65535) {
      Get.snackbar('Invalid port', 'Port must be between 1 and 65535',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    service.status.value = PrinterStatus.connecting;

    final reachable = await service.testNetworkConnection(trimmedIp, port);
    if (!reachable) {
      service.status.value = PrinterStatus.error;
      Get.snackbar('Connection failed', service.lastError.value ?? 'Could not reach printer',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    service.saveSavedPrinter(
      SavedPrinterInfo(
        name: 'Network Printer ($trimmedIp)',
        address: trimmedIp,
        type: ConnectionType.NETWORK,
        port: port,
      ),
    );
    service.status.value = PrinterStatus.connected;
  }

  /// "Reconnect" button — for BLE/USB, re-scans and connects; for network,
  /// just re-tests the socket since there's no held connection to restore.
  Future<void> reconnect() async {
    final saved = service.savedPrinter.value;
    if (saved == null) return;

    if (saved.isNetwork) {
      service.status.value = PrinterStatus.connecting;
      final ok = await service.testNetworkConnection(
        saved.address,
        saved.port ?? kDefaultNetworkPrinterPort,
      );
      service.status.value = ok ? PrinterStatus.connected : PrinterStatus.error;
      return;
    }

    if (!permissionGranted.value) {
      await _requestPermissions();
      if (!permissionGranted.value) return;
    }

    service.status.value = PrinterStatus.connecting;

    try {
      final stream = await service.scan([saved.type]);
      final devices = await stream
          .firstWhere(
            (list) => list.any((d) => d.address == saved.address),
        orElse: () => <Printer>[],
      )
          .timeout(const Duration(seconds: 6), onTimeout: () => <Printer>[]);
      service.stopScan();

      final match = devices.where((d) => d.address == saved.address).firstOrNull;
      if (match == null) {
        service.status.value = PrinterStatus.error;
        service.lastError.value = '${saved.name} not found — is it powered on?';
        return;
      }

      final ok = await service.connectDevice(match);
      if (!ok) {
        service.status.value = PrinterStatus.error;
        return;
      }

      service.connectedDevice = match;
      service.status.value = PrinterStatus.connected;
    } catch (e) {
      service.status.value = PrinterStatus.error;
      service.lastError.value = 'Reconnect failed: $e';
    }
  }

  /// "Remove" button — disconnects (if live) and clears saved storage.
  Future<void> removeSaved() async {
    try {
      if (service.connectedDevice != null) {
        await service.disconnectDevice(service.connectedDevice!);
      }
    } finally {
      service.clearSavedPrinter();
    }
  }

  @override
  void onClose() {
    _scanSub?.cancel();
    service.stopScan();
    super.onClose();
  }
}*/
