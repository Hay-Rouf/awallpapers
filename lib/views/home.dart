import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import '../admob/service.dart';

import '../constant.dart';
import '../controllers/controller.dart';
import '../model/wallpaper_model.dart';
import '../widgets/widget.dart';
import 'Image_view.dart';

class HomeScreen extends GetView<Controller> {
  HomeScreen({super.key});

  static const String id = '/home';

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    return Scaffold(
      appBar: appBarWidget(),
      bottomNavigationBar: const BannerWidget(),
      backgroundColor: myBlack,
      body: Obx(() {
        List<WallpaperModel> trends = controller.walls;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.count(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: trends.length,
              crossAxisCount: 3,
              itemBuilder: (BuildContext context, int index) {
                var wallpaper = trends[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => ImageView(
                        imgData: wallpaper,
                      ),
                    );
                  },
                  child: SizedBox(
                    height: random((height * .3).toInt(), (height * .4).toInt())
                        .toDouble(),
                    child: ImageWidget(
                      wallpaper: wallpaper,
                    ),
                  ),
                );
              }),
        );
      }),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.wallpaper,
    this.isCat,
  });

  final bool? isCat;

  final WallpaperModel wallpaper;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: wallpaper.link,
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.5),
          border: Border.all(color: myWhite, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: wallpaper.link,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) {
              return CachedNetworkImage(
                imageUrl: wallpaper.link.replaceAll('originals', '236x'),
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    isCat != null
                        ? Container()
                        : Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: myBlue,
                            ),
                          ),
                errorWidget: (_, __, ___) => Center(
                    child: isCat != null
                        ? Container()
                        : Icon(
                            Icons.error,
                            color: myRed,
                          )),
              );
            },
            progressIndicatorBuilder: (_, child, downloadProgress) {
              return isCat != null
                  ? Container()
                  : Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: myBlue,
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
