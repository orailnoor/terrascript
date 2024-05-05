import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';

import 'package:nativenadi/controller.dart';
import 'package:nativenadi/device_utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Uint8List? _imageFile;
  int spaceCount = 0;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    homepageController.ramdomizeSearch();
    super.initState();
  }

  final homepageController = Get.put(HomepageController());

  String backgroudImage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GetBuilder<HomepageController>(builder: (controller) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          height: MediaQuery.of(context).size.height < 700
                              ? MediaQuery.of(context).size.height * .9
                              : MediaQuery.of(context).size.height * .8,
                          width: MediaQuery.of(context).size.width < 700
                              ? MediaQuery.of(context).size.width * .9
                              : MediaQuery.of(context).size.width * .8,
                          child: Padding(
                            padding: EdgeInsets.all(
                                DeviceUtils.isMobile(context) ? 16 : 32.0),
                            //here
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.black45,
                                              Colors.transparent,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: TextField(
                                            onTap: () {
                                              setState(() {
                                                if (homepageController
                                                    .autoKeywords
                                                    .any((element) =>
                                                        element ==
                                                        homepageController
                                                            .textEditingController
                                                            .text)) {
                                                  homepageController.timer
                                                      .cancel();
                                                  homepageController
                                                      .textEditingController
                                                      .text = '';
                                                  homepageController
                                                      .displayedImages = [];
                                                }
                                              });
                                            },
                                            controller: homepageController
                                                .textEditingController,
                                            onChanged: (value) {
                                              spaceCount =
                                                  value.split(' ').first.length;
                                              homepageController.timer.cancel();
                                              homepageController
                                                  .updateDisplayedImages(value);
                                              controller.update();
                                              setState(() {});
                                            },
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white30,
                                            ),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              border: InputBorder.none,
                                              hintText: 'Start typing...',
                                              hintStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (homepageController
                                              .textEditingController
                                              .text
                                              .isNotEmpty) {
                                            homepageController
                                                .isDownloading.value = true;
                                            captureInvisible();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please type something first');
                                          }
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .05,
                                        width: DeviceUtils.isMobile(context)
                                            ? DeviceUtils.screenWidth(context,
                                                percentage: 20)
                                            : DeviceUtils.screenWidth(context,
                                                percentage: 10),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black12),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Text(homepageController
                                                .isDownloading.value
                                            ? 'Downloading...'
                                            : 'Download'),
                                      ).asGlass(
                                        clipBorderRadius:
                                            BorderRadius.circular(30),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: homepageController
                                                .textEditingController
                                                .text
                                                .isEmpty
                                            ? 5
                                            : homepageController
                                                        .textEditingController
                                                        .text
                                                        .length <
                                                    4
                                                ? 4
                                                : spaceCount != 0
                                                    ? spaceCount
                                                    : homepageController
                                                        .textEditingController
                                                        .text
                                                        .length,
                                        mainAxisSpacing: 8.0,
                                        crossAxisSpacing: 8.0,
                                      ),
                                      itemCount: homepageController
                                          .displayedImages.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () async {
                                            final Uri url = Uri.parse(
                                                'https://earth.google.com/web/search/${homepageController.imageData[homepageController.textEditingController.text[index].toLowerCase()]!['latlng']}');
                                            launchUrl(Uri(
                                              scheme: url.scheme,
                                              host: url.host,
                                              path: url.path,
                                              queryParameters:
                                                  url.queryParameters,
                                            ));
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: homepageController
                                                  .displayedImages[index],
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                period: const Duration(
                                                    milliseconds: 2000),
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.black54,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black54),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .2,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .2,
                                                  child: const Center(
                                                    child: Text(
                                                      'Loading...',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).asGlass(clipBorderRadius: BorderRadius.circular(30)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void captureInvisible() async {
    screenshotController
        .captureFromWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: DeviceUtils.isMobile(context)
                    ? const EdgeInsets.all(16.0)
                    : const EdgeInsets.all(48.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: homepageController
                            .textEditingController.text.isEmpty
                        ? 5
                        : homepageController.textEditingController.text.length <
                                4
                            ? 4
                            : spaceCount != 0
                                ? spaceCount
                                : homepageController
                                    .textEditingController.text.length,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: homepageController.displayedImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                          homepageController.displayedImages[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    )
        .then((capturedImage) {
      try {
        setState(() {
          _imageFile = capturedImage;
          homepageController.isDownloading.value = false;
        });

        final blob = html.Blob([_imageFile!]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download',
              'Terrascript-${DateTime.now().millisecondsSinceEpoch}${homepageController.textEditingController.text}.png');
        anchor.click();
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        Fluttertoast.showToast(msg: 'An error occurred $e');
        log(e.toString());
      }
    });
  }
}
