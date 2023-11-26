import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../admob/service.dart';
import '../constant.dart';
import '../model/wallpaper_model.dart';
import 'binding.dart';

class Controller extends GetxController {
  ScrollController scrollController = ScrollController();

  // Future popOut() async {
  //   print('pop');
  //   // adManager.loadInterstitialAd();
  //   Get.back();
  //   return false;
  // }

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        getMore();
        print('max');
      }
    });
    initFolder();
    print('box ree: ${readList()}');
    setRan();
    super.onInit();
  }

  RxList<WallpaperModel> walls = <WallpaperModel>[].obs;

  setWalls() {
    walls.addAll(readList()[_ran]);
    print('walls: $walls');
  }

  @override
  void onReady() {
    // initFolder();
    super.onReady();
  }

  initFolder() async {
    folder = await getApplicationDocumentsDirectory();
    await GetStorage.init();
  }

  late final Directory folder;

  RxString searchText = 'Trending WallPapers'.obs;

  updateText(String text) {
    searchText.value = text == '' ? 'Trending WallPapers' : text;
  }

  RxBool showAppBar = true.obs;

  changeShow(bool value) {
    showAppBar.value = value;
  }


  RxBool preview = false.obs;

  void previewSetter() {
    preview.value = !preview.value;
  }

  RxString downloaded = ''.obs;

  snackBar(String txt, {String? txt1}) {
    Get.snackbar(
      txt,
      txt1 ?? '',
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      padding: const EdgeInsets.all(10),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  List<String> getDownloaded() {
    List<String> downloadedFiles = [];
    try {
      List<FileSystemEntity> files =
      Directory('$parentDir${appName.replaceAll(' ', '')}/').listSync();
      for (var element in files) {
        downloadedFiles.add(element.path);
      }
    } catch (e) {
      print(e);
    }
    return downloadedFiles;
  }


  List favourites() {
    List fav = box.read('favourites') ?? [];
    return fav;
  }

  writeList(value) {
    box.write('data', value);
    print('written');
    print(box.read('data'));
  }

  readList() {
    var data = box.read('data');
    return data;
  }

  deleteFile(String file) {
    File(file).delete();
  }

  RxBool fav = false.obs;

  favCheck(String value) {
    List favourite = favourites();
    if (favourite.contains(value)) {
      fav.value = true;
    } else {
      fav.value = false;
    }
    // print(fav.value);
    return fav.value;
  }

  writeFavourites(String value) {
    List favourite = favourites();
    if (favourite.contains(value)) {
      favourite.remove(value);
      Get.back();
      Get.back();
    } else {
      favourite.add(value);
    }
    box.write('favourites', favourite);
    // print(favourite);
  }

  setAsWallpaper({
    required BuildContext context,
    required String file,
    required bool isOnline,
    // bool? download,
  }) {
    showModalBottomSheet(
        backgroundColor: const Color(0x00757575),
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * .2,
            padding: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: tranBlack,
            ),
            child: ListView(
              children: [
                ListTile(
                  title: const Text(
                    'Home and Lock Screen',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap: () async {
                    isOnline
                        ? _setUrlWallPaper(file, 3)
                        : setFileWallPaper(
                        file, 3); // screen = 'to Both Screen';
                    Get.back();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Home Screen',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap: () async {
                    isOnline
                        ? _setUrlWallPaper(file, 1)
                        : setFileWallPaper(
                        file, 1); // screen = 'to Both Screen';
                    Get.back();
                  },
                ),
                ListTile(
                  title: const Text(
                    'Lock Screen',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap: () async {
                    isOnline
                        ? _setUrlWallPaper(file, 2)
                        : setFileWallPaper(
                        file, 2); // screen = 'to Both Screen';
                    Get.back();
                  },
                ),
              ],
            ),
          );
        });
  }
  getPermission() async {
    if (!(await Permission.storage.isGranted)) {
      Permission.storage.request();
    }
  }

  Future<String> saveImg({required WallpaperModel imgData}) async {
    getPermission();
    await adManager.rewardedAd();
    File? result;
    // List<String> downloads = getDownloaded();
    String file = 'WallpaperX/img-${imgData.id}.jpg';
    downloaded.value = '0%';
    // print(await File('$parentDir$file').exists());
    if (!(await File('$parentDir$file').exists())) {
      snackBar('Downloading',txt1: 'Check Your Notifications');
      result = await FileDownloader.downloadFile(
          url: imgData.link,
          name: file,
          // notificationType: NotificationType.disabled,
          downloadDestination: DownloadDestinations.publicDownloads,
          onProgress: (String? fileName, double progress) {
            print('FILE $fileName HAS PROGRESS $progress');
            downloaded.value = progress.toStringAsFixed(0);
          },
          onDownloadCompleted: (String path) {
            downloaded.value = '';
            print('filePath: $path');
            snackBar('Downloaded');
          },
          onDownloadError: (String error) async {
            result = await FileDownloader.downloadFile(
                url: imgData.link.replaceAll('originals', '236x'),
                name: file,
                // notificationType: NotificationType.disabled,
                downloadDestination: DownloadDestinations.publicDownloads,
                onProgress: (String? fileName, double progress) {
                  print('FILE $fileName HAS PROGRESS $progress');
                  downloaded.value = progress.toStringAsFixed(0);
                },
                onDownloadCompleted: (String path) {
                  downloaded.value = '';
                  snackBar('Downloaded');
                });
          });
    } else {
      snackBar('Downloaded', txt1: 'check My Downloads');
      result = File('$parentDir$file');
    }
    return result!.path;
  }

  Future<void> _setUrlWallPaper(String url, int setter) async {
    await adManager.rewardedAd();
    Get.back();
    String screen = '';
    if (setter == 1) {
      screen = 'as Home Screen';
    } else if (setter == 2) {
      screen = 'as Lock Screen';
    } else {
      screen = 'to Both Screen';
    }
    snackBar('Waiting', txt1: "Please wait");
    await AsyncWallpaper.setWallpaper(
      url: url,
      wallpaperLocation: setter,
      toastDetails: ToastDetails.success(),
      errorToastDetails: ToastDetails.error(),
    ).whenComplete(() {
      snackBar('Done', txt1: 'image set $screen Wallpaper');
    });
  }
  
  Future<void> setFileWallPaper(String file, int setter) async {
    await adManager.rewardedAd();
    await AsyncWallpaper.setWallpaperFromFile(
      filePath: file,
      wallpaperLocation: setter,
      toastDetails: ToastDetails.success(),
      errorToastDetails: ToastDetails.error(),
    );
    String screen = '';
    if (setter == 1) {
      screen = 'as Home Screen';
    } else if (setter == 2) {
      screen = 'as Lock Screen';
    } else {
      screen = 'to Both Screen';
    }
    snackBar('Done', txt1: 'image set $screen Wallpaper');
  }

  int random(min, max) {
    var rn = Random();
    int ran = min + rn.nextInt(max - min);
    return ran;
  }

  int _ran = 10;

  setRan() {
    _ran = random(1, 100);
    print(_ran);
  }

  RxInt data = 1.obs;

  // get listOfList => box.read('list') ?? {};

  Future getAppImages() async {
    print('data: ${readList()}');
    List<WallpaperModel> newAppWallpapers = [];
    String fileName = 'assets/data.json';
    var file = await rootBundle.loadString(fileName);
    Map<String, dynamic> jsonData = jsonDecode(file);
    jsonData['pints'].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel(
        id: element['id'],
        link: element['link'] ?? element['src']['portrait'],
      );
      newAppWallpapers.add(wallpaperModel);
    });
    newAppWallpapers.shuffle();
    walls.addAll(newAppWallpapers);
  }

  final GetStorage box = GetStorage('favourites');

  void getMore() {
    if (_ran < 100) {
      _ran++;
    } else {
      _ran = 1;
    }
    walls.addAll(readList()[_ran]);
  }

  @override
  void refresh() {
    walls.clear();
    setRan();
    walls.addAll(readList()[_ran]);
    super.refresh();
  }

  RxBool favImg = false.obs;
  RxBool favVid = false.obs;

  favImgCheck(WallpaperModel model) {
    String value = json.encode(model.toMap());
    List favourite = favourites();
    favImg.value = favourite.contains(value);
    return favImg.value;
  }

  writeFavouritesImg(WallpaperModel model) async {
    List favourite = favourites();
    String value = json.encode(model.toMap());
    favImg.value ? favourite.remove(value) : favourite.add(value);
    favImg.value = favourite.contains(value);
    await box.write('favourites', favourite);
  }
}
// await WallpaperManager.setWallpaperFromFile(file, setter);
