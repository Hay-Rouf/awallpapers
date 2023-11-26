import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admob/service.dart';
import '../constant.dart';
import '../controllers/binding.dart';
import '../main.dart';
import '../views/home.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/app_icon.jpeg',
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width * .3,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .35,
            child: Text(
              kAppName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .1,
            child: Center(
              child: Column(
                      children: [
                        const Text(
                          'Please wait',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CircularProgressIndicator(
                          color: myBlue,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    adManager.loadInterstitialAd();
    appController.getAppImages().then((value) {
      Get.offNamed(HomeScreen.id);
      super.onInit();
    });
  }

}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
