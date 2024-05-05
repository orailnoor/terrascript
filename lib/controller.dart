import 'dart:async';
import 'dart:math'; // Import the dart:math library for Random

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:nativenadi/api_request.dart';

class HomepageController extends GetxController {
  @override
  void onInit() {
    typeAuto();
    super.onInit();
  }

  var backgroudImage = ''.obs;
  late List<String> displayedImages = [];
  TextEditingController textEditingController = TextEditingController();
  late Timer timer;
  RxBool isSearching = false.obs;
  RxBool isDownloading = false.obs;

  List<String> searchItem = [
    'space',
    'dark',
    'nature',
    'earth',
    'black',
    'grey',
    'indoor',
    'outdoor',
    'city',
    'town',
    'village',
    'forest',
  ];
  List<String> autoKeywords = [
    'start',
    'writing',
    'your',
    'name',
  ];

  var imageData = {
    "a": {"image": "assets/images/A.png", "latlng": "27.599180,-80.401348"},
    "b": {"image": "assets/images/B.png", "latlng": "40.886634,-72.346309"},
    "c": {"image": "assets/images/C.png", "latlng": "29.211522,-81.038615"},
    "d": {"image": "assets/images/D.png", "latlng": "25.983149,-80.126472"},
    "e": {"image": "assets/images/E.png", "latlng": "43.023303,-120.671358"},
    "f": {"image": "assets/images/F.png", "latlng": "26.064034,-80.406933"},
    "g": {"image": "assets/images/G.png", "latlng": "25.672922,-80.272674"},
    "h": {"image": "assets/images/H.png", "latlng": "25.815743,-80.375563"},
    "i": {"image": "assets/images/I.png", "latlng": "26.0988524,-80.2905868"},
    "j": {"image": "assets/images/J.png", "latlng": "27.141177,-80.201604"},
    "k": {"image": "assets/images/K.png", "latlng": "26.744367,-81.926809"},
    "l": {"image": "assets/images/L.png", "latlng": "26.071722,-80.223107"},
    "m": {"image": "assets/images/M.png", "latlng": "26.061899,-80.303208"},
    "n": {"image": "assets/images/N.png", "latlng": "26.071092,-80.258394"},
    "o": {"image": "assets/images/O.png", "latlng": "26.048711,-80.282398"},
    "p": {"image": "assets/images/P.png", "latlng": "67.475624,168.525541"},
    "q": {"image": "assets/images/Q.png", "latlng": "19.979332,76.508306"},
    "r": {"image": "assets/images/R.png", "latlng": "26.546213,-82.012332"},
    "s": {"image": "assets/images/S.png", "latlng": "27.568833,-80.411984"},
    "t": {"image": "assets/images/T.png", "latlng": "26.019855,-80.259426"},
    "u": {"image": "assets/images/U.png", "latlng": "39.850474,-74.926265"},
    "v": {"image": "assets/images/V.png", "latlng": "26.023747,-80.283641"},
    "w": {"image": "assets/images/W.png", "latlng": "26.110176,-80.342424"},
    "x": {"image": "assets/images/X.png", "latlng": "25.671801,-80.459545"},
    "y": {"image": "assets/images/Y.png", "latlng": "26.000404,-80.385910"},
    "z": {"image": "assets/images/Z.png", "latlng": "25.562572,-80.352135"},
  };

  void typeAuto() {
    int index = 0;
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      textEditingController.text = autoKeywords[index];
      updateDisplayedImages(textEditingController.text);
      update();
      index = (index + 1) % autoKeywords.length;
    });
  }

  void ramdomizeSearch() async {
    var random = DateTime.now().millisecondsSinceEpoch;
    var index = random % searchItem.length;
    var search = searchItem[index];
    var response = await APIRequest().getPexelImages(search);
    backgroudImage.value = response['photos'][index]['src']['original'];
  }

  void updateDisplayedImages(String input) {
    print('displayedImages: orailnoor');
    List<String> images = [];

    for (var i = 0; i < input.length; i++) {
      if (imageData.containsKey(input[i].toLowerCase())) {
        images.add(imageData[input[i].toLowerCase()]!['image']!);
      }
    }
    displayedImages = images;
    update();
  }
}
