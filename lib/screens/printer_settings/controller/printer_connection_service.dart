import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, MissingPluginException;
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:food_merchant/routes/app_pages.dart';
import 'package:food_merchant/screens/order_details/models/order_details_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'escpos_builder.dart';


enum PrinterStatus {
  notConfigured,
  disconnected,
  connecting,
  connected,
  error,
}

/// Our own transport enum — separate from flutter_thermal_printer's
/// ConnectionType (which only knows BLE/USB/NETWORK) so we can add
/// classicBluetooth (via print_bluetooth_thermal) without fighting a
/// third-party enum we don't control. BLE/USB still convert to/from
/// ConnectionType at the boundary where the plugin's API requires it.
enum PrinterTransport { ble, usb, network, classicBluetooth }

// PrinterTransport transportFromConnectionType(ConnectionType t) {
//   switch (t) {
//     case ConnectionType.USB:
//       return PrinterTransport.usb;
//     case ConnectionType.NETWORK:
//       return PrinterTransport.network;
//     case ConnectionType.BLE:
//     default:
//       return PrinterTransport.ble;
//   }
// }
PrinterTransport transportFromConnectionType(ConnectionType t) {
  return switch (t) {
    ConnectionType.USB => PrinterTransport.usb,
    ConnectionType.NETWORK => PrinterTransport.network,
    ConnectionType.BLE => PrinterTransport.ble,
  };
}

/// Only valid for ble/usb — classicBluetooth and network never need to
/// become a flutter_thermal_printer ConnectionType, since they're handled
/// by entirely separate code paths (print_bluetooth_thermal / raw sockets).
ConnectionType _toConnectionType(PrinterTransport t) {
  switch (t) {
    case PrinterTransport.usb:
      return ConnectionType.USB;
    case PrinterTransport.ble:
    default:
      return ConnectionType.BLE;
  }
}

/// Default raw ESC/POS port used by virtually all network thermal printers.
const int kDefaultNetworkPrinterPort = 9100;

/// How long we give the plugin's internal BLE stabilization
/// (service discovery + MTU negotiation) to settle before we consider a
/// connect "done". Cheap/older clone printer BLE modules are slower here
/// than modern ones — 3s covers both without a long user-facing wait.
/// IMPORTANT: our own outer timeout below is deliberately longer than this,
/// so our timeout never races the plugin's internal one.
const Duration kBleStabilizationDelay = Duration(seconds: 3);

/// Outer safety timeout around connect(). Must stay comfortably ABOVE
/// kBleStabilizationDelay + normal GATT connect time, or we risk cutting
/// the plugin off mid-negotiation — which is what was causing the printer
/// to disconnect (GATT status 19) right after MTU config.
const Duration kConnectTimeout = Duration(seconds: 16);

class SavedPrinterInfo {
  final String name;
  final String address; // BLE/USB: device address. Network: IP. Classic: MAC.
  final PrinterTransport type;
  final int? port; // only used when type == PrinterTransport.network

  SavedPrinterInfo({
    required this.name,
    required this.address,
    required this.type,
    this.port,
  });

  bool get isNetwork => type == PrinterTransport.network;
  bool get isClassicBluetooth => type == PrinterTransport.classicBluetooth;
}

/// Thin singleton — plugin (BLE/USB) + raw sockets (network) + GetStorage +
/// permission wrappers. No orchestration except print(). Use as
/// PrinterConnectionService.instance — no init() call needed.
class PrinterConnectionService {
  PrinterConnectionService._internal() {
    // Tune the plugin's own BLE stabilization window ONCE, globally, instead
    // of relying on its 10s default (which was racing our outer timeout and
    // causing the printer to be disconnected mid-negotiation).
    _plugin.bleConfig = BleConfig(connectionStabilizationDelay: kBleStabilizationDelay);
    _loadSaved();
  }
  static final PrinterConnectionService instance =
  PrinterConnectionService._internal();

  static const _kName = 'printer_name';
  static const _kAddress = 'printer_address';
  static const _kType = 'printer_type';
  static const _kPort = 'printer_port';

  final FlutterThermalPrinter _plugin = FlutterThermalPrinter.instance;
  final GetStorage _box = GetStorage();

  final Rx<PrinterStatus> status = PrinterStatus.notConfigured.obs;
  final Rx<SavedPrinterInfo?> savedPrinter = Rx<SavedPrinterInfo?>(null);
  final RxnString lastError = RxnString();

  /// Live BLE/USB device handle. Not used for network — network printing
  /// opens a fresh socket per print instead of holding a connection open.
  Printer? connectedDevice;

  void _loadSaved() {
    try {
      final address = _box.read<String>(_kAddress);
      final name = _box.read<String>(_kName);
      final typeStr = _box.read<String>(_kType);
      final port = _box.read<int>(_kPort);

      if (address == null || name == null || typeStr == null) {
        status.value = PrinterStatus.notConfigured;
        return;
      }

      final transport = PrinterTransport.values
          .where((t) => t.name.toLowerCase() == typeStr.toLowerCase())
          .firstOrNull;

      if (transport == null) {
        // Legacy/unrecognized value (e.g. saved before the PrinterTransport
        // migration, when this was stored as "BLE"/"USB"/"NETWORK" from
        // ConnectionType.name). Treat as not configured instead of
        // throwing — the user just needs to re-pick a printer once.
        status.value = PrinterStatus.notConfigured;
        return;
      }

      savedPrinter.value = SavedPrinterInfo(
        name: name,
        address: address,
        type: transport,
        port: port,
      );
      status.value = PrinterStatus.disconnected;
    } catch (e) {
      status.value = PrinterStatus.notConfigured;
      _notifyError('Storage error', 'Could not read saved printer: $e');
    }
  }

  // ---- Centralized error surface: every catch block funnels through
  // here so failures always reach the user via Get.snackbar, not just
  // the console / lastError. ----

  void _notifyError(String title, String message) {
    lastError.value = message;
    // Defer to after the current frame: _notifyError can be triggered from
    // places that run mid-build (e.g. this singleton's lazy constructor
    // firing the first time a widget's build() touches .instance) —
    // calling Get.snackbar synchronously there crashes with "setState()
    // called during build". A post-frame callback sidesteps that
    // regardless of what triggered the error.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
      );
    });
  }

  /// Turns raw plugin/OS exception text into a specific, human message.
  String _describeError(Object e) {
    final raw = e.toString().toLowerCase();

    if (raw.contains('poweredoff') ||
        raw.contains('bluetooth is turned off') ||
        raw.contains('bluetoothnotenabled') ||
        raw.contains('not enabled')) {
      return 'Bluetooth is turned off. Please enable Bluetooth and try again.';
    }
    if (raw.contains('permission')) {
      return 'Permission denied — check Bluetooth/Location permission in phone Settings.';
    }
    if (raw.contains('133')) {
      // Classic Android BLE GATT_ERROR — connection is dead even though
      // status may still say "connected".
      return 'Printer connection was lost. Please reconnect from Settings.';
    }
    if (raw.contains('not found') || raw.contains('unknown deviceid')) {
      // Device was purged from the native BLE registry after a disconnect —
      // a stale handle was reused instead of rediscovering it.
      return 'Printer connection was lost. Please reconnect from Settings.';
    }
    if (raw.contains('usb')) {
      return 'USB access denied — check the system USB permission prompt.';
    }
    if (e is PlatformException) {
      return e.message ?? 'Platform error (${e.code})';
    }
    return e.toString();
  }

  // ---- Permissions (Bluetooth/USB only — network needs none) ----

  Future<bool> requestBluetoothPermissions() async {
    try {
      if (GetPlatform.isAndroid) {
        final statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();
        final granted = statuses.values.every((s) => s.isGranted);
        if (!granted) {
          _notifyError('Permission needed', 'Bluetooth/location permission was denied.');
        }
        return granted;
      } else if (GetPlatform.isIOS) {
        final result = await Permission.bluetooth.request();
        final granted = result.isGranted;
        if (!granted) {
          _notifyError('Permission needed', 'Bluetooth permission was denied.');
        }
        return granted;
      }
      return true;
    } catch (e) {
      _notifyError('Permission error', _describeError(e));
      return false;
    }
  }

  Future<bool> hasBluetoothPermission() async {
    try {
      if (GetPlatform.isAndroid) {
        return await Permission.bluetoothScan.isGranted &&
            await Permission.bluetoothConnect.isGranted;
      } else if (GetPlatform.isIOS) {
        return await Permission.bluetooth.isGranted;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---- BLE / USB wrappers (via plugin) ----

  /// IMPORTANT: async, and AWAITS the plugin call before returning the
  /// stream. getPrinters() can throw (e.g. Bluetooth off) — if that call
  /// isn't awaited, the exception fires in an unmanaged future and shows
  /// up as an "Unhandled Exception" instead of something we can catch.
  Future<Stream<List<Printer>>> scan(List<ConnectionType> types) async {
    try {
      await _plugin.getPrinters(connectionTypes: types);
      return _plugin.devicesStream;
    } catch (e) {
      _notifyError('Scan failed', _describeError(e));
      return const Stream.empty();
    }
  }

  void stopScan() {
    try {
      _plugin.stopScan();
    } catch (_) {}
  }

  /// Connects and lets the plugin's own BLE stabilization (service
  /// discovery + MTU negotiation, tuned via bleConfig above) finish fully
  /// before we return. Our outer timeout is deliberately longer than that
  /// stabilization window so we never abandon the connect mid-negotiation
  /// — abandoning it early was what caused the printer to disconnect
  /// itself (GATT status 19) right after MTU config in your logs.
  Future<bool> connectDevice(Printer device) async {
    try {
      await _plugin
          .connect(device, connectionStabilizationDelay: kBleStabilizationDelay)
          .timeout(kConnectTimeout);
      return true;
    } on TimeoutException {
      _notifyError('Connection timeout', 'Printer out of range or powered off.');
      return false;
    } on MissingPluginException {
      _notifyError('Not supported', 'Printer plugin not available on this platform.');
      return false;
    } catch (e) {
      _notifyError('Connection failed', _describeError(e));
      return false;
    }
  }

  Future<void> disconnectDevice(Printer device) async {
    try {
      await _plugin.disconnect(device);
    } catch (e) {
      // Device already gone — not alarming enough for a snackbar.
      lastError.value = 'Disconnect warning: $e';
    }
  }

  /// Briefly re-scans to get a LIVE Printer object for [address]/[type].
  /// Needed because once a BLE link drops, the native stack often purges
  /// that device's id from its registry — reusing the old Printer object
  /// then fails with "Unknown deviceId". Re-scanning gets a fresh, valid
  /// handle before we try to reconnect. Works the same for old and new
  /// printers since it's just re-running discovery.
  Future<Printer?> _rediscoverByAddress(String? address, ConnectionType? type) async {
    if (address == null || type == null) return null;
    try {
      await _plugin.getPrinters(connectionTypes: [type]);
      final match = await _plugin.devicesStream
          .firstWhere(
            (list) => list.any((d) => d.address == address),
        orElse: () => <Printer>[],
      )
          .timeout(const Duration(seconds: 6), onTimeout: () => <Printer>[]);
      _plugin.stopScan();
      return match.where((d) => d.address == address).firstOrNull;
    } catch (_) {
      return null;
    }
  }

  /// Prints raw bytes. On failure, treats the connection as dead — clears
  /// connectedDevice and flips status to error — so the NEXT print/reconnect
  /// does a real fresh connect instead of retrying a stale GATT handle.
  ///
  /// Does one retry: re-scans for a LIVE handle at the same address (old
  /// handles can be purged from the native BLE registry after a drop),
  /// reconnects with that fresh handle (giving it the full stabilization
  /// window), then retries the write.
  Future<bool> printRaw(Printer device, Uint8List bytes) async {
    Printer currentDevice = device;

    for (int attempt = 1; attempt <= 2; attempt++) {
      try {
        await _plugin.printData(currentDevice, bytes).timeout(const Duration(seconds: 15));
        connectedDevice = currentDevice;
        status.value = PrinterStatus.connected;
        return true;
      } on TimeoutException {
        if (attempt == 2) {
          _notifyError('Print timed out', 'Check the printer connection and try again.');
          connectedDevice = null;
          status.value = PrinterStatus.error;
          return false;
        }
        final recovered = await _recoverConnection(currentDevice);
        if (recovered == null) {
          _notifyError('Print failed', 'Check the printer connection and try again.');
          connectedDevice = null;
          status.value = PrinterStatus.error;
          return false;
        }
        currentDevice = recovered;
      } catch (e) {
        if (attempt == 2) {
          _notifyError('Print failed', _describeError(e));
          connectedDevice = null;
          status.value = PrinterStatus.error;
          return false;
        }
        final recovered = await _recoverConnection(currentDevice);
        if (recovered == null) {
          _notifyError('Print failed', _describeError(e));
          connectedDevice = null;
          status.value = PrinterStatus.error;
          return false;
        }
        currentDevice = recovered;
      }
    }
    return false;
  }

  /// Re-scans for a live handle to [device]'s address, then reconnects
  /// (with the full stabilization window). Returns the fresh, connected
  /// Printer object, or null if it couldn't be found/reconnected.
  Future<Printer?> _recoverConnection(Printer device) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final fresh = await _rediscoverByAddress(device.address, device.connectionType);
    if (fresh == null) return null;

    final reconnected = await connectDevice(fresh);
    if (!reconnected) return null;
    return fresh;
  }

  // ---- Network (WiFi) printer — raw TCP socket, independent of the
  // plugin's network discovery which is unreliable across router setups.
  // Standard raw ESC/POS port is 9100. ----

  bool isValidIPv4(String ip) {
    final parts = ip.trim().split('.');
    if (parts.length != 4) return false;
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null || n < 0 || n > 255) return false;
    }
    return true;
  }

  /// Opens a socket, confirms the printer is reachable, closes it.
  /// Use this before saving a network printer so bad IP/port is caught
  /// immediately instead of failing silently on the first real print.
  Future<bool> testNetworkConnection(String ip, int port) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
      return true;
    } on SocketException catch (e) {
      _notifyError('Connection failed', _describeSocketException(e, ip, port));
      return false;
    } on TimeoutException {
      _notifyError(
        'Connection timed out',
        'Could not reach $ip:$port — check IP/port and that the printer '
            'and phone are on the same network.',
      );
      return false;
    } catch (e) {
      _notifyError('Connection failed', 'Could not reach $ip:$port — $e');
      return false;
    } finally {
      await socket?.close();
    }
  }

  /// Opens a fresh socket, writes the ESC/POS bytes, flushes, closes.
  /// A new connection per print job is intentional — network printers
  /// commonly drop idle sockets, so holding one open long-term is fragile.
  Future<bool> printNetworkRaw(String ip, int port, Uint8List bytes) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
      socket.add(bytes);
      await socket.flush().timeout(const Duration(seconds: 10));
      return true;
    } on SocketException catch (e) {
      _notifyError('Print failed', _describeSocketException(e, ip, port));
      return false;
    } on TimeoutException {
      _notifyError('Print timed out', 'No response from $ip:$port.');
      return false;
    } catch (e) {
      _notifyError('Print failed', 'Network print failed: $e');
      return false;
    } finally {
      await socket?.close();
    }
  }

  String _describeSocketException(SocketException e, String ip, int port) {
    final msg = e.message.toLowerCase();
    if (msg.contains('refused')) {
      return 'Connection refused by $ip:$port — printer may be off or port is wrong';
    }
    if (msg.contains('unreachable') || msg.contains('no route')) {
      return 'Cannot reach $ip — check the printer and phone are on the same WiFi network';
    }
    if (msg.contains('timed out')) {
      return 'Connection to $ip:$port timed out';
    }
    return e.message.isNotEmpty ? e.message : 'Network error connecting to $ip:$port';
  }

  // ---- Classic Bluetooth (SPP) via print_bluetooth_thermal ----
  // No GATT/MTU negotiation at all — a continuous serial byte stream — so
  // it sidesteps the GATT-133/MTU-disconnect problem some cheap BLE printer
  // chips have entirely. Only lists devices already paired via the phone's
  // OS Bluetooth settings (no live scanning, that's normal for Classic SPP).
  // Only ONE Classic connection can be live at a time, which fits our
  // "one saved printer" design perfectly.

  Future<List<BluetoothInfo>> getClassicPairedDevices() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (e) {
      _notifyError('Could not list paired devices', _describeError(e));
      return const [];
    }
  }

  Future<bool> isClassicConnected() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (_) {
      return false;
    }
  }

  Future<bool> connectClassicDevice(String mac) async {
    try {
      final ok = await PrintBluetoothThermal.connect(macPrinterAddress: mac)
          .timeout(const Duration(seconds: 12));
      if (!ok) {
        _notifyError('Connection failed', 'Could not connect to $mac.');
      }
      return ok;
    } on TimeoutException {
      _notifyError('Connection timeout', 'Printer out of range, off, or not paired.');
      return false;
    } catch (e) {
      _notifyError('Connection failed', _describeError(e));
      return false;
    }
  }

  Future<bool> disconnectClassic() async {
    try {
      return await PrintBluetoothThermal.disconnect;
    } catch (e) {
      lastError.value = 'Disconnect warning: $e';
      return false;
    }
  }

  Future<bool> printClassicRaw(Uint8List bytes) async {
    try {
      final connected = await isClassicConnected();
      if (!connected) {
        _notifyError('Printer not connected', 'Classic Bluetooth printer is not connected.');
        return false;
      }
      // .toList() converts the Uint8List to a plain growable List<int>.
      // This matters: Flutter's platform-channel codec encodes a Uint8List
      // as a native Java byte[], but this plugin's Android side casts the
      // argument to java.util.List — passing the Uint8List directly causes
      // "byte[] cannot be cast to java.util.List". A plain List<int>
      // encodes as a Java ArrayList instead, which is what it expects.
      final ok = await PrintBluetoothThermal.writeBytes(bytes.toList())
          .timeout(const Duration(seconds: 15));
      if (!ok) {
        _notifyError('Print failed', 'The printer rejected the print job.');
      }
      return ok;
    } on TimeoutException {
      _notifyError('Print timed out', 'Check the printer connection and try again.');
      return false;
    } catch (e) {
      _notifyError('Print failed', _describeError(e));
      return false;
    }
  }

  // ---- GetStorage wrappers ----

  void saveSavedPrinter(SavedPrinterInfo info) {
    try {
      _box.write(_kName, info.name);
      _box.write(_kAddress, info.address);
      _box.write(_kType, info.type.name);
      if (info.port != null) {
        _box.write(_kPort, info.port);
      } else {
        _box.remove(_kPort);
      }
      savedPrinter.value = info;
    } catch (e) {
      _notifyError('Storage error', 'Could not save printer: $e');
    }
  }

  void clearSavedPrinter() {
    final wasClassic = savedPrinter.value?.isClassicBluetooth ?? false;
    try {
      _box.remove(_kName);
      _box.remove(_kAddress);
      _box.remove(_kType);
      _box.remove(_kPort);
    } catch (e) {
      _notifyError('Storage error', 'Could not clear saved printer: $e');
    } finally {
      savedPrinter.value = null;
      connectedDevice = null;
      status.value = PrinterStatus.notConfigured;
      if (wasClassic) {
        // Fire-and-forget — clearing storage shouldn't block on this.
        disconnectClassic();
      }
    }
  }

  // ---- high-level print, callable from anywhere ----

  /// Checks permission/status directly and prints, or shows a dialog
  /// pointing to Settings. Branches on saved printer type: network prints
  /// via a fresh socket every time; BLE/USB use the held connection.
  Future<void> printBill(Uint8List bytes) async {
    final saved = savedPrinter.value;
    if (saved == null) {
      _showConnectPrompt();
      return;
    }

    if (saved.isNetwork) {
      status.value = PrinterStatus.connecting;
      final ok = await printNetworkRaw(saved.address, saved.port ?? kDefaultNetworkPrinterPort, bytes);
      status.value = ok ? PrinterStatus.connected : PrinterStatus.error;
      if (!ok) _showConnectPrompt();
      return;
    }

    if (saved.isClassicBluetooth) {
      // No Bluetooth runtime permission needed for Classic on most Android
      // versions the way BLE needs it, and no live device handle to hold —
      // print_bluetooth_thermal tracks its own single connection globally.
      status.value = PrinterStatus.connecting;
      var connected = await isClassicConnected();
      if (!connected) {
        connected = await connectClassicDevice(saved.address);
      }
      if (!connected) {
        status.value = PrinterStatus.error;
        _showConnectPrompt();
        return;
      }
      final ok = await printClassicRaw(bytes);
      status.value = ok ? PrinterStatus.connected : PrinterStatus.error;
      if (!ok) _showConnectPrompt();
      return;
    }

    // BLE / USB path
    final hasPermission = await hasBluetoothPermission();
    if (!hasPermission) {
      lastError.value = 'Bluetooth permission not granted';
      _showConnectPrompt(permissionIssue: true);
      return;
    }

    if (connectedDevice != null) {
      // Cached status isn't trusted alone anymore — printRaw self-heals
      // via re-scan/reconnect if the link actually dropped while idle.
      final ok = await printRaw(connectedDevice!, bytes);
      if (!ok) _showConnectPrompt();
      return;
    }

    // No live handle at all — try to recover one from the saved address
    // before giving up, so the user isn't forced back to Settings just
    // because the app was killed/backgrounded.
    status.value = PrinterStatus.connecting;
    final recovered = await _rediscoverByAddress(saved.address, _toConnectionType(saved.type));
    if (recovered == null) {
      status.value = PrinterStatus.error;
      _showConnectPrompt();
      return;
    }
    final reconnected = await connectDevice(recovered);
    if (!reconnected) {
      status.value = PrinterStatus.error;
      _showConnectPrompt();
      return;
    }
    connectedDevice = recovered;
    final ok = await printRaw(recovered, bytes);
    if (!ok) _showConnectPrompt();
  }

  void _showConnectPrompt({bool permissionIssue = false}) {
    Get.dialog(
      AlertDialog(
        title: Text(permissionIssue ? 'Permission required' : 'Printer not connected'),
        content: Text(
          permissionIssue
              ? 'Bluetooth permission is needed to print. Please grant it from Settings.'
              : 'Please connect a printer from Settings before printing.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.printerSettings);
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }


  Future<void> printRestaurantOrderBill({
    required OrderDetailsData? order,
    required double gst,
    required String gstLabel,
    required double packagingCharges,
    required double deliveryCharges,
    required double discountPrice,
    required double totalPrice,
    required String roundOff,
    required int paymentType,
    bool noCharge = false,
    bool useCurrentDate = false,
    int splitByPersons = 1,
    Set<int> selectedItemIds = const {},
  }){

    final Uint8List data;
    if(splitByPersons > 1){
      data = RestaurantPrintBuilder.restaurantBillSplitByPersons(
          order: order,
          gst: gst,
          gstLabel: gstLabel,
          packagingCharges: packagingCharges,
          deliveryCharges: deliveryCharges,
          discountPrice: discountPrice,
          totalPrice: totalPrice,
          roundOff: roundOff,
          paymentType: paymentType,
          noCharge: noCharge,
          useCurrentDate: useCurrentDate,
          numberOfPersons: splitByPersons
      ).build();
    } else if(selectedItemIds.isNotEmpty){
      data = RestaurantPrintBuilder.restaurantBillSplitByItems(
          order: order,
          gst: gst,
          gstLabel: gstLabel,
          packagingCharges: packagingCharges,
          deliveryCharges: deliveryCharges,
          discountPrice: discountPrice,
          totalPrice: totalPrice,
          roundOff: roundOff,
          paymentType: paymentType,
          noCharge: noCharge,
          useCurrentDate: useCurrentDate,
          selectedItemIds: selectedItemIds
      ).build();
    } else {
      data = RestaurantPrintBuilder.restaurantBill(
          order: order,
          gst: gst,
          gstLabel: gstLabel,
          packagingCharges: packagingCharges,
          deliveryCharges: deliveryCharges,
          discountPrice: discountPrice,
          totalPrice: totalPrice,
          roundOff: roundOff,
          paymentType: paymentType,
          noCharge: noCharge,
          useCurrentDate: useCurrentDate
      ).build();
    }

    debugPrint('data --> ${order?.orderId}');

    return printBill(data);
  }
}


/*
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, MissingPluginException;
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:food_merchant/routes/app_pages.dart';
import 'package:food_merchant/screens/order_details/models/order_details_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'escpos_builder.dart';


enum PrinterStatus {
  notConfigured,
  disconnected,
  connecting,
  connected,
  error,
}

/// Default raw ESC/POS port used by virtually all network thermal printers.
const int kDefaultNetworkPrinterPort = 9100;

class SavedPrinterInfo {
  final String name;
  final String address; // BLE/USB: device address. Network: IP address.
  final ConnectionType type;
  final int? port; // only used when type == ConnectionType.NETWORK

  SavedPrinterInfo({
    required this.name,
    required this.address,
    required this.type,
    this.port,
  });

  bool get isNetwork => type == ConnectionType.NETWORK;
}

/// Thin singleton — plugin (BLE/USB) + raw sockets (network) + GetStorage +
/// permission wrappers. No orchestration except print(). Use as
/// PrinterConnectionService.instance — no init() call needed.
class PrinterConnectionService {
  PrinterConnectionService._internal() {
    _loadSaved();
  }
  static final PrinterConnectionService instance =
  PrinterConnectionService._internal();

  static const _kName = 'printer_name';
  static const _kAddress = 'printer_address';
  static const _kType = 'printer_type';
  static const _kPort = 'printer_port';

  final FlutterThermalPrinter _plugin = FlutterThermalPrinter.instance;
  final GetStorage _box = GetStorage();

  final Rx<PrinterStatus> status = PrinterStatus.notConfigured.obs;
  final Rx<SavedPrinterInfo?> savedPrinter = Rx<SavedPrinterInfo?>(null);
  final RxnString lastError = RxnString();

  /// Live BLE/USB device handle. Not used for network — network printing
  /// opens a fresh socket per print instead of holding a connection open.
  Printer? connectedDevice;

  void _loadSaved() {
    try {
      final address = _box.read<String>(_kAddress);
      final name = _box.read<String>(_kName);
      final typeStr = _box.read<String>(_kType);
      final port = _box.read<int>(_kPort);

      if (address == null || name == null || typeStr == null) {
        status.value = PrinterStatus.notConfigured;
        return;
      }

      savedPrinter.value = SavedPrinterInfo(
        name: name,
        address: address,
        type: ConnectionType.values.firstWhere((t) => t.name == typeStr),
        port: port,
      );
      status.value = PrinterStatus.disconnected;
    } catch (e) {
      status.value = PrinterStatus.notConfigured;
      _notifyError('Storage error', 'Could not read saved printer: $e');
    }
  }

  // ---- Centralized error surface: every catch block funnels through
  // here so failures always reach the user via Get.snackbar, not just
  // the console / lastError. ----

  void _notifyError(String title, String message) {
    lastError.value = message;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
    );
  }

  /// Turns raw plugin/OS exception text into a specific, human message.
  String _describeError(Object e) {
    final raw = e.toString().toLowerCase();

    if (raw.contains('poweredoff') ||
        raw.contains('bluetooth is turned off') ||
        raw.contains('bluetoothnotenabled') ||
        raw.contains('not enabled')) {
      return 'Bluetooth is turned off. Please enable Bluetooth and try again.';
    }
    if (raw.contains('permission')) {
      return 'Permission denied — check Bluetooth/Location permission in phone Settings.';
    }
    if (raw.contains('133')) {
      // Classic Android BLE GATT_ERROR — connection is dead even though
      // status may still say "connected".
      return 'Printer connection was lost. Please reconnect from Settings.';
    }
    if (raw.contains('usb')) {
      return 'USB access denied — check the system USB permission prompt.';
    }
    if (e is PlatformException) {
      return e.message ?? 'Platform error (${e.code})';
    }
    return e.toString();
  }

  // ---- Permissions (Bluetooth/USB only — network needs none) ----

  Future<bool> requestBluetoothPermissions() async {
    try {
      if (GetPlatform.isAndroid) {
        final statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();
        final granted = statuses.values.every((s) => s.isGranted);
        if (!granted) {
          _notifyError('Permission needed', 'Bluetooth/location permission was denied.');
        }
        return granted;
      } else if (GetPlatform.isIOS) {
        final result = await Permission.bluetooth.request();
        final granted = result.isGranted;
        if (!granted) {
          _notifyError('Permission needed', 'Bluetooth permission was denied.');
        }
        return granted;
      }
      return true;
    } catch (e) {
      _notifyError('Permission error', _describeError(e));
      return false;
    }
  }

  Future<bool> hasBluetoothPermission() async {
    try {
      if (GetPlatform.isAndroid) {
        return await Permission.bluetoothScan.isGranted &&
            await Permission.bluetoothConnect.isGranted;
      } else if (GetPlatform.isIOS) {
        return await Permission.bluetooth.isGranted;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---- BLE / USB wrappers (via plugin) ----

  /// IMPORTANT: async, and AWAITS the plugin call before returning the
  /// stream. getPrinters() can throw (e.g. Bluetooth off) — if that call
  /// isn't awaited, the exception fires in an unmanaged future and shows
  /// up as an "Unhandled Exception" instead of something we can catch.
  Future<Stream<List<Printer>>> scan(List<ConnectionType> types) async {
    try {
      await _plugin.getPrinters(connectionTypes: types);
      return _plugin.devicesStream;
    } catch (e) {
      _notifyError('Scan failed', _describeError(e));
      return const Stream.empty();
    }
  }

  void stopScan() {
    try {
      _plugin.stopScan();
    } catch (_) {}
  }

  Future<bool> connectDevice(Printer device) async {
    try {
      await _plugin.connect(device).timeout(const Duration(seconds: 10));

      // Settle delay: Android needs a moment after connect() to finish
      // GATT service discovery / MTU negotiation. Writing immediately is
      // the single most common cause of GATT error 133 on first write.
      await Future.delayed(const Duration(milliseconds: 400));

      return true;
    } on TimeoutException {
      _notifyError('Connection timeout', 'Printer out of range or powered off.');
      return false;
    } on MissingPluginException {
      _notifyError('Not supported', 'Printer plugin not available on this platform.');
      return false;
    } catch (e) {
      _notifyError('Connection failed', _describeError(e));
      return false;
    }
  }

  Future<void> disconnectDevice(Printer device) async {
    try {
      await _plugin.disconnect(device);
    } catch (e) {
      // Device already gone — not alarming enough for a snackbar.
      lastError.value = 'Disconnect warning: $e';
    }
  }

  /// Prints raw bytes. On failure, treats the connection as dead — clears
  /// connectedDevice and flips status to error — so the NEXT print/reconnect
  /// does a real fresh connect instead of retrying a stale GATT handle.
  /// Does one silent retry first (reconnect + rewrite), since a single
  /// dropped write (e.g. GATT 133) is common and often recoverable.
  Future<bool> printRaw(Printer device, Uint8List bytes) async {
    for (int attempt = 1; attempt <= 2; attempt++) {
      try {
        await _plugin.printData(device, bytes).timeout(const Duration(seconds: 15));
        return true;
      } on TimeoutException {
        if (attempt == 2) {
          _notifyError('Print timed out', 'Check the printer connection and try again.');
          connectedDevice = null;
          status.value = PrinterStatus.error;
          return false;
        }
      } catch (e) {
        if (attempt == 2) {
          _notifyError('Print failed', _describeError(e));
          connectedDevice = null;
          status.value = PrinterStatus.error;
          return false;
        }
        // First failure: brief pause, reconnect once, then retry the write.
        await Future.delayed(const Duration(milliseconds: 300));
        final reconnected = await connectDevice(device);
        if (!reconnected) {
          _notifyError('Print failed', _describeError(e));
          connectedDevice = null;
          status.value = PrinterStatus.error;
          return false;
        }
      }
    }
    return false;
  }

  // ---- Network (WiFi) printer — raw TCP socket, independent of the
  // plugin's network discovery which is unreliable across router setups.
  // Standard raw ESC/POS port is 9100. ----

  bool isValidIPv4(String ip) {
    final parts = ip.trim().split('.');
    if (parts.length != 4) return false;
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null || n < 0 || n > 255) return false;
    }
    return true;
  }

  /// Opens a socket, confirms the printer is reachable, closes it.
  /// Use this before saving a network printer so bad IP/port is caught
  /// immediately instead of failing silently on the first real print.
  Future<bool> testNetworkConnection(String ip, int port) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
      return true;
    } on SocketException catch (e) {
      _notifyError('Connection failed', _describeSocketException(e, ip, port));
      return false;
    } on TimeoutException {
      _notifyError(
        'Connection timed out',
        'Could not reach $ip:$port — check IP/port and that the printer '
            'and phone are on the same network.',
      );
      return false;
    } catch (e) {
      _notifyError('Connection failed', 'Could not reach $ip:$port — $e');
      return false;
    } finally {
      await socket?.close();
    }
  }

  /// Opens a fresh socket, writes the ESC/POS bytes, flushes, closes.
  /// A new connection per print job is intentional — network printers
  /// commonly drop idle sockets, so holding one open long-term is fragile.
  Future<bool> printNetworkRaw(String ip, int port, Uint8List bytes) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 5));
      socket.add(bytes);
      await socket.flush().timeout(const Duration(seconds: 10));
      return true;
    } on SocketException catch (e) {
      _notifyError('Print failed', _describeSocketException(e, ip, port));
      return false;
    } on TimeoutException {
      _notifyError('Print timed out', 'No response from $ip:$port.');
      return false;
    } catch (e) {
      _notifyError('Print failed', 'Network print failed: $e');
      return false;
    } finally {
      await socket?.close();
    }
  }

  String _describeSocketException(SocketException e, String ip, int port) {
    final msg = e.message.toLowerCase();
    if (msg.contains('refused')) {
      return 'Connection refused by $ip:$port — printer may be off or port is wrong';
    }
    if (msg.contains('unreachable') || msg.contains('no route')) {
      return 'Cannot reach $ip — check the printer and phone are on the same WiFi network';
    }
    if (msg.contains('timed out')) {
      return 'Connection to $ip:$port timed out';
    }
    return e.message.isNotEmpty ? e.message : 'Network error connecting to $ip:$port';
  }

  // ---- GetStorage wrappers ----

  void saveSavedPrinter(SavedPrinterInfo info) {
    try {
      _box.write(_kName, info.name);
      _box.write(_kAddress, info.address);
      _box.write(_kType, info.type.name);
      if (info.port != null) {
        _box.write(_kPort, info.port);
      } else {
        _box.remove(_kPort);
      }
      savedPrinter.value = info;
    } catch (e) {
      _notifyError('Storage error', 'Could not save printer: $e');
    }
  }

  void clearSavedPrinter() {
    try {
      _box.remove(_kName);
      _box.remove(_kAddress);
      _box.remove(_kType);
      _box.remove(_kPort);
    } catch (e) {
      _notifyError('Storage error', 'Could not clear saved printer: $e');
    } finally {
      savedPrinter.value = null;
      connectedDevice = null;
      status.value = PrinterStatus.notConfigured;
    }
  }

  // ---- high-level print, callable from anywhere ----

  /// Checks permission/status directly and prints, or shows a dialog
  /// pointing to Settings. Branches on saved printer type: network prints
  /// via a fresh socket every time; BLE/USB use the held connection.
  Future<void> printBill(Uint8List bytes) async {
    final saved = savedPrinter.value;
    if (saved == null) {
      _showConnectPrompt();
      return;
    }

    if (saved.isNetwork) {
      // No Bluetooth permission needed, no held connection to check —
      // just attempt the socket print directly.
      status.value = PrinterStatus.connecting;
      final ok = await printNetworkRaw(saved.address, saved.port ?? kDefaultNetworkPrinterPort, bytes);
      status.value = ok ? PrinterStatus.connected : PrinterStatus.error;
      if (!ok) _showConnectPrompt();
      return;
    }

    // BLE / USB path
    final hasPermission = await hasBluetoothPermission();
    if (!hasPermission) {
      lastError.value = 'Bluetooth permission not granted';
      _showConnectPrompt(permissionIssue: true);
      return;
    }

    if (status.value == PrinterStatus.connected && connectedDevice != null) {
      final ok = await printRaw(connectedDevice!, bytes);
      if (!ok) _showConnectPrompt();
      return;
    }

    _showConnectPrompt();
  }

  void _showConnectPrompt({bool permissionIssue = false}) {
    Get.dialog(
      AlertDialog(
        title: Text(permissionIssue ? 'Permission required' : 'Printer not connected'),
        content: Text(
          permissionIssue
              ? 'Bluetooth permission is needed to print. Please grant it from Settings.'
              : 'Please connect a printer from Settings before printing.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.printerSettings);
            },
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }


  Future<void> printRestaurantOrderBill({
    required OrderDetailsData? order,
    required double gst,
    required String gstLabel,
    required double packagingCharges,
    required double deliveryCharges,
    required double discountPrice,
    required double totalPrice,
    required String roundOff,
    required int paymentType,
    bool noCharge = false,
    bool useCurrentDate = false,
    int splitByPersons = 1,
    Set<int> selectedItemIds = const {},
  }){

    final Uint8List data;
    if(splitByPersons > 1){
      data = RestaurantPrintBuilder.restaurantBillSplitByPersons(
          order: order,
          gst: gst,
          gstLabel: gstLabel,
          packagingCharges: packagingCharges,
          deliveryCharges: deliveryCharges,
          discountPrice: discountPrice,
          totalPrice: totalPrice,
          roundOff: roundOff,
          paymentType: paymentType,
          noCharge: noCharge,
          useCurrentDate: useCurrentDate,
          numberOfPersons: splitByPersons
      ).build();
    } else if(selectedItemIds.isNotEmpty){
      data = RestaurantPrintBuilder.restaurantBillSplitByItems(
          order: order,
          gst: gst,
          gstLabel: gstLabel,
          packagingCharges: packagingCharges,
          deliveryCharges: deliveryCharges,
          discountPrice: discountPrice,
          totalPrice: totalPrice,
          roundOff: roundOff,
          paymentType: paymentType,
          noCharge: noCharge,
          useCurrentDate: useCurrentDate,
          selectedItemIds: selectedItemIds
      ).build();
    } else {
      data = RestaurantPrintBuilder.restaurantBill(
          order: order,
          gst: gst,
          gstLabel: gstLabel,
          packagingCharges: packagingCharges,
          deliveryCharges: deliveryCharges,
          discountPrice: discountPrice,
          totalPrice: totalPrice,
          roundOff: roundOff,
          paymentType: paymentType,
          noCharge: noCharge,
          useCurrentDate: useCurrentDate
      ).build();
    }

    debugPrint('data --> ${order?.orderId}');

    return printBill(data);
  }
}*/
