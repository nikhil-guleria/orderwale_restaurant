import 'package:get/get.dart';

import 'printer_settings_controller.dart';

class PrinterSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrinterSettingsController>(() => PrinterSettingsController(), fenix: true);
  }

}