import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:food_merchant/screens/printer_settings/controller/printer_connection_service.dart';
import 'package:food_merchant/screens/printer_settings/controller/printer_settings_controller.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';



class PrinterSettingsView extends GetView<PrinterSettingsController> {
  const PrinterSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Printer Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSavedPrinterCard(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Obx(
                      () => FilledButton.icon(
                    onPressed: controller.scanning.value ? null : controller.scanAll,
                    icon: const Icon(Icons.bluetooth_searching),
                    label: Text(
                      controller.scanning.value ? 'Scanning…' : 'BLE/USB',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                    () => OutlinedButton.icon(
                  onPressed: controller.loadingClassic.value
                      ? null
                      : controller.loadClassicPairedDevices,
                  icon: const Icon(Icons.bluetooth_connected),
                  label: Text(controller.loadingClassic.value ? '...' : 'Classic'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _showAddNetworkPrinterDialog(context),
                icon: const Icon(Icons.wifi),
                label: const Text('WiFi'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Classic Bluetooth only lists printers already paired in your '
                "phone's Bluetooth settings — pair there first if yours isn't listed.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.foundPrinters.isEmpty &&
                controller.classicPairedDevices.isEmpty &&
                !controller.scanning.value &&
                !controller.loadingClassic.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No printers found yet. Tap "Scan BLE/USB" or "Classic" — '
                      'make sure the printer is powered on and, for '
                      'Bluetooth, paired/in range.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return Column(
              children: [
                ...controller.foundPrinters.map((d) => _buildDeviceTile(d)),
                ...controller.classicPairedDevices
                    .map((d) => _buildClassicDeviceTile(d)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSavedPrinterCard() {
    final service = controller.service;

    return Obx(() {
      final saved = service.savedPrinter.value;

      if (saved == null) {
        return const Card(
          child: ListTile(
            leading: Icon(Icons.print_disabled),
            title: Text('No printer configured'),
            subtitle: Text('Scan below and select a printer to save it.'),
          ),
        );
      }

      final status = service.status.value;
      final (icon, color, label) = switch (status) {
        PrinterStatus.connected => (Icons.check_circle, Colors.green, 'Connected'),
        PrinterStatus.connecting => (Icons.sync, Colors.orange, 'Connecting…'),
        PrinterStatus.error => (
        Icons.error,
        Colors.red,
        service.lastError.value ?? 'Connection failed',
        ),
        _ => (Icons.print, Colors.grey, 'Not connected'),
      };

      return Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, color: color),
              title: Text(saved.name),
              subtitle: Text('${_transportLabel(saved.type)} • $label'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: status == PrinterStatus.connecting
                          ? null
                          : controller.reconnect,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reconnect'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: controller.removeSaved,
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDeviceTile(Printer d) {
    return Obx(() {
      final isSaved = controller.service.savedPrinter.value?.address == d.address;
      return Card(
        child: ListTile(
          leading: Icon(_iconForType(d.connectionType)),
          title: Text(d.name ?? 'Unknown device'),
          subtitle: Text(d.address ?? ''),
          trailing: isSaved
              ? const Chip(label: Text('Saved'))
              : ElevatedButton(
            onPressed: () => controller.selectPrinter(d),
            child: const Text('Use this'),
          ),
        ),
      );
    });
  }

  Widget _buildClassicDeviceTile(BluetoothInfo d) {
    return Obx(() {
      final isSaved =
          controller.service.savedPrinter.value?.address == d.macAdress;
      return Card(
        child: ListTile(
          leading: const Icon(Icons.bluetooth_connected),
          title: Text(d.name),
          subtitle: Text('${d.macAdress} • Classic (paired)'),
          trailing: isSaved
              ? const Chip(label: Text('Saved'))
              : ElevatedButton(
            onPressed: () => controller.selectClassicPrinter(d),
            child: const Text('Use this'),
          ),
        ),
      );
    });
  }

  IconData _iconForType(ConnectionType? type) {
    switch (type) {
      case ConnectionType.USB:
        return Icons.usb;
      case ConnectionType.NETWORK:
        return Icons.wifi;
      case ConnectionType.BLE:
      default:
        return Icons.bluetooth;
    }
  }

  String _transportLabel(PrinterTransport type) {
    switch (type) {
      case PrinterTransport.usb:
        return 'USB';
      case PrinterTransport.network:
        return 'WiFi';
      case PrinterTransport.classicBluetooth:
        return 'Bluetooth (Classic)';
      case PrinterTransport.ble:
        return 'Bluetooth (BLE)';
    }
  }

  void _showAddNetworkPrinterDialog(BuildContext context) {
    final ipController = TextEditingController();
    final portController = TextEditingController(text: '9100');

    Get.dialog(
      AlertDialog(
        title: const Text('Add Network Printer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'IP Address',
                hintText: '192.168.1.50',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '9100',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Port 9100 is the standard raw ESC/POS port used by most '
                  'network thermal printers — leave as-is unless yours differs.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final port = int.tryParse(portController.text.trim()) ?? 9100;
              Get.back();
              controller.addNetworkPrinter(ipController.text, port);
            },
            child: const Text('Test & Save'),
          ),
        ],
      ),
    );
  }
}
