import 'package:get/get.dart';
import '../views/splash_screen.dart';

import '../admob/service.dart';
import 'controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(Controller());
    Get.put(AdManager());
  }
}

Controller appController = Get.find();