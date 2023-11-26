import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../admob/service.dart';
import '../constant.dart';
import '../controllers/controller.dart';
import '../model/wallpaper_model.dart';
import 'Image_view.dart';

class DownloadedFile extends GetView<Controller> {
  const DownloadedFile({
    Key? key,
    required this.isDownload,
  }) : super(key: key);

  final bool isDownload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            bottomNavigationBar: const BannerWidget(),
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                isDownload?'Downloads':'Favourite',
                style: TextStyle(color: myWhite),
              ),
              elevation: 0,
              // centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: myWhite,
                ),
                onPressed: () {
                  // adManager.showAppOpenAdIfAvailable();
                  Get.back();
                },
              ),
            ),
            body: DownNFavWallpaperWidget(
              downloads: isDownload,
            ),
            // bottomNavigationBar: const AppBottom(),
          );
  }
}

class DownNFavWallpaperWidget extends GetView<Controller> {
  const DownNFavWallpaperWidget({
    super.key,
    required this.downloads,
  });

  final bool downloads;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        List trends =
            downloads ? controller.getDownloaded() : controller.favourites();
        return trends.isEmpty
            ? Center(
                child: Text(
                  downloads ? 'No Downloaded File' : 'No Favourite Found',
                  style: TextStyle(
                      color: myWhite,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              )
            : GridView.count(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                children: trends.map((wallpaper) {
                  var imgData = downloads
                      ? wallpaper
                      : WallpaperModel.fromMap(jsonDecode(wallpaper));
                  return GridTile(
                    child: GestureDetector(
                      onTap: () {
                        // adManager.loadInterstitialAd();
                        Get.to(() => downloads
                            ? DownloadImageView(
                                imgData: imgData,
                              )
                            : ImageView(imgData: imgData));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.5),
                            border: Border.all(color: myWhite)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: downloads
                              ? Image.file(
                                  File(imgData),
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: imgData.link,
                                  filterQuality: FilterQuality.high,
                                  errorWidget: (_, __, ___) => Icon(
                                    Icons.error_outline,
                                    color: myRed,
                                  ),
                                  progressIndicatorBuilder: (_, __, ___) =>
                                      Center(
                                    child: CircularProgressIndicator(
                                      value: ___.progress,
                                      color: myBlue,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
      },
    );
  }
}
