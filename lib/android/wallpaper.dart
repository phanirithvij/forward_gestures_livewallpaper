import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as developer;

/// A container of methods to interact with the wallpaper
class WallpaperAPI with ChangeNotifier {
  PageController scrollController;
  bool scroll = true;
  int pageCount = 7;

  /// Set [initColors] to true if need to fecth colors during initialization
  /// Scroll is enabled by default
  /// Use [enableScroll], [disableScroll], [toggleScroll] to control stuff
  /// The [controller] is used for scroll events if provided
  WallpaperAPI({
    PageController controller,
    bool initColors: false,
    bool subscribeWallpaperChanges: false,
    int pageCount,
  }) {
    if (subscribeWallpaperChanges)
      onWallpaperChanged(callback: (event) {
        print('Received Wallpaper changed event: $event');
      });
    if (initColors) getWallpaperColors();
    scrollController = (controller == null) ? PageController() : controller;
    if (pageCount != null) this.pageCount = pageCount;
  }

  static const platform = const MethodChannel(
    'com.example.forward_gestures_livewallpaper/wallpapers',
  );

  static const eventChannel = const EventChannel(
    'com.example.forward_gestures_livewallpaper/events',
  );

  /// The 3 dominant colors in the wallpaper provided by android
  List<Color> colors = [
    Colors.black,
    Colors.black,
    Colors.black,
  ];

  /// On wallpaper change execute the [callback]
  /// It recieves an argument [event]
  Future<void> onWallpaperChanged({Function callback}) async {
    eventChannel.receiveBroadcastStream().listen((dynamic event) {
      notifyListeners();
      if (callback != null) callback(event);
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    });
  }

  void updateScrollEvents() {
    if (scrollController.hasListeners) {
      scrollController.removeListener(scrollListener);
    }
    if (scroll) scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    // print("${scrollController.page} $pageCount");
    // TODO: Android change WallpaperOffsetSteps
    // This doesn't seem right
    setWallpaperOffsets(scrollController.page, pageCount);
  }

  void enableScroll() => scroll = true;
  void disableScroll() => scroll = false;
  void toggleScroll() => scroll = !scroll;

  /// Sends a command to live wallpapers so they could receive tap events
  Future<void> sendWallpaperCommand(TapDownDetails ev) async {
    try {
      await platform.invokeMethod(
        "wallpaperCommand",
        [ev.globalPosition.dx, ev.globalPosition.dy],
      );
    } on PlatformException catch (e) {
      debugPrint("Failed to send a Wallpaper command");
      print(e);
    }
  }

  /// Sets the wallpaper offsets
  /// [position] is a double in 0-[numPages]
  /// [numPages] must be >= 1
  Future<void> setWallpaperOffsets(double position, int numPages) async {
    try {
      await platform.invokeMethod("setWallpaperOffsets", [position, numPages]);
    } on PlatformException catch (e) {
      developer.log("Failed to change wallpaper offsets");
      print(e);
    }
  }

  Future<List<Color>> getWallpaperColors() async {
    try {
      List data = await platform.invokeMethod("wallpaperColors");
      colors.clear();
      data.forEach((c) {
        Color col;
        if (c != null) {
          col = Color(c as int);
        }
        colors.add(col);
      });
      developer.log("Colors $colors");
      notifyListeners();
      return colors;
    } on PlatformException catch (e) {
      developer.log("Failed to get Wallpaper colors");
      print(e);
      return [];
    }
  }
}
