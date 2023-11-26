import 'dart:math';
import 'dart:ui';

Color tranBlack = const Color(0x61000000).withOpacity(0.8);
Color myBlue = const Color(0xff030ec5);
Color myWhite = const Color(0xffd9d9e1);
Color myRed = const Color(0xffc50303);
Color myGreen = const Color(0xff3b9103);
Color myBlack = const Color(0xff000000);
Color myYellow = const Color(0xffF6BF0A);
String appName = 'Wallpapers';
String kAppName = ' Wallpapers';
String images = 'images';
String cam = 'assets/icons/cam.png';
String chrome = 'assets/icons/chrome.png';
String message = 'assets/icons/message.png';
String tel = 'assets/icons/tel.png';
const String parentDir = '/storage/emulated/0/Download/';

Color myPink = const Color(0xedff0000);
// Size size = Get.size;
int kAdIndex = 7;

int getDestinationItemIndex(int rawIndex) {
  if (rawIndex >= kAdIndex) {
    return rawIndex - 1;
  }
  return rawIndex;
}
int random(min, max) {
  var rn = Random();
  int ran = min + rn.nextInt(max - min);
  return ran;
}
