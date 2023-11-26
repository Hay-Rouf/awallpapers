import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home.dart';
import 'constant.dart';
import 'controllers/binding.dart';
import 'controllers/controller.dart';
import 'views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

late final SharedPreferences prefs;

String apiKey = 'lljeytngFn4zU1AGHx1TbTgFAoN3vpeTwAZse5bUuF83EK6thDxC4IEx';

//lljeytngFn4zU1AGHx1TbTgFAoN3vpeTwAZse5bUuF83EK6thDxC4IExmax
//ExiZxHYblX1cSSWY9pDBfVRf2Q8YZkVDR1angqTccb66AzDQhISOTA8Y

// Future<void> initializeDefault() async {
//   FirebaseApp app = await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   print('Initialized default app $app');
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primaryColor: Colors.black38,
      ),
      initialRoute: SplashScreen.id,
      getPages: [
        GetPage(
          name: HomeScreen.id,
          page: () => HomeScreen(),
        ),
        GetPage(
          name: SplashScreen.id,
          page: () => const SplashScreen(),
          binding: SplashBinding(),
        ),
      ],
    );
  }
}
