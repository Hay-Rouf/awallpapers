import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob/service.dart';
import '../constant.dart';
import '../controllers/binding.dart';
import '../views/downloaded_file.dart';

AppBar appBarWidget({Widget? title}) {
  return AppBar(
    backgroundColor: myBlack,
    title: title ??
        Text(
          appName,
          style: TextStyle(color: myWhite),
        ),
    actions: title == null
        ? [
            IconButton(
              onPressed: () {
                Get.to(() => const DownloadedFile(isDownload: true));
              },
              icon: const Icon(Icons.download),
              color: myBlue,
            ),
            IconButton(
              onPressed: () {
                Get.to(() => const DownloadedFile(isDownload: false));
              },
              icon: const Icon(Icons.favorite),
              color: myPink,
            )
          ]
        : null,
    elevation: 0,
    bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(
          color: Colors.white,
          height: 2.0,
        )),
    leading: title != null
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          )
        : null,
  );
}

