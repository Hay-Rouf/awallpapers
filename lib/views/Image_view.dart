import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constant.dart';
import '../model/wallpaper_model.dart';
import '../views/home.dart';

import '../controllers/binding.dart';
import '../controllers/controller.dart';

class ImageView extends GetWidget<Controller> {
  const ImageView({
    super.key,
    required this.imgData,
  });
  final WallpaperModel imgData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(imgData.link);
    return Scaffold(
        body: Hero(
          tag: imgData.id,
          child: Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
                child: CachedNetworkImage(
                  imageUrl: imgData.link,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) {
                    return CachedNetworkImage(
                      imageUrl: imgData.link.replaceAll('originals', '236x'),
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: myBlue,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Center(
                          child: Icon(
                            Icons.error,
                            color: myRed,
                          )),
                    );
                  },
                  progressIndicatorBuilder: (_, child, downloadProgress) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    );
                  },
                ),
              ),
              Obx(() {
                bool value = controller.preview.value;
                return value
                    ? const PreviewWidget()
                    : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        color: myBlack.withOpacity(.45),
                        borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    width: size.width * .9,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageViewIcons(
                          iconData: Icons.image,
                          iconText: 'Set Wallpaper',
                          onTap: () {
                            controller.setAsWallpaper(
                              context: context,
                              file: imgData.link,
                              isOnline: true,
                            );
                          },
                        ),
                        ImageViewIcons(
                          iconData: Icons.download_for_offline_outlined,
                          iconText: 'Download',
                          onTap: () {
                            controller.saveImg(imgData: imgData).then(
                                  (value) => controller.setAsWallpaper(
                                context: context,
                                file: value,
                                isOnline: false,
                                // download: true,
                              ),
                            );
                          },
                        ),
                        GetX<Controller>(
                          initState: (_) {
                            _.controller!.favImgCheck(imgData);
                          },
                          builder: (logic) {
                            return ImageViewIcons(
                              onTap: () async {
                                await logic.writeFavouritesImg(imgData);
                                // logic.favCheck(imgData);

                                logic.favImg.value
                                    ? logic.snackBar('Added to Favourites')
                                    : logic.snackBar(
                                    'Removed from Favourites');
                              },
                              iconData: logic.favImg.value
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: myRed,
                              iconText: 'Favourite',
                            );
                          },
                        ),
                        // ImageViewIcons(
                        //   iconData: Icons.download_for_offline_outlined,
                        //   iconText: 'Save',
                        //   onTap: () {
                        //
                        //     // adManager.loadInterstitialAd();
                        //     controller.saveImg(imgData: imgData).then(
                        //           (file) async =>
                        //               await ImageGallerySaver.saveFile(file)
                        //                   .then(
                        //             (value) => controller.snackBar(
                        //               'Success',
                        //               txt1: 'Saved to phone',
                        //             ),
                        //           ),
                        //         );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                );
              }),
              Obx(() {
                return Positioned(
                  top: size.height * .09,
                  right: size.width * .03,
                  child: ImageViewIcons(
                    iconData: controller.preview.value
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                    iconText: 'Preview',
                    onTap: controller.previewSetter,
                  ),
                );
              }),
            ],
          ),
        ));
  }
}

class DownloadImageView extends GetWidget<Controller> {
  const DownloadImageView({
    super.key,
    required this.imgData,
  });
  final String imgData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(imgUrl);
    return Scaffold(
        body: Stack(
          children: [
            Image.file(
              File(imgData),
              fit: BoxFit.cover,
              height: size.height,
              width: size.width,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * .09),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.setAsWallpaper(
                          context: context,
                          file: imgData,
                          isOnline: false,
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: tranBlack,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 1.5,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54, width: 1),
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.black26,
                                  Colors.black12,
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Set as Wallpaper',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class PreviewWidget extends StatelessWidget {
  const PreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, d MMM').format(now);
    String formattedTime = DateFormat('kk:mm').format(now);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 80,
          ),
          Text(
            formattedTime,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 65.0,
              color: myWhite,
            ),
          ),
          Text(
            formattedDate,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 25.0, color: myWhite),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                message,
                height: 50,
              ),
              Image.asset(
                tel,
                height: 50,
              ),
              Image.asset(
                cam,
                height: 50,
              ),
              Image.asset(
                chrome,
                height: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ImageViewIcons extends StatelessWidget {
  const ImageViewIcons({
    super.key,
    this.iconData,
    required this.iconText,
    this.onTap,
    this.color,
    this.icon,
  });

  final IconData? iconData;
  final Widget? icon;
  final String iconText;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: icon ??
              Icon(
                iconData,
                color: color ?? myWhite,
                size: 30,
              ),
          onPressed: onTap,
        ),
        Text(
          iconText,
          style: TextStyle(color: myWhite),
        )
      ],
    );
  }
}

