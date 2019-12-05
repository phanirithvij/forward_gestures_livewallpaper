import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as developer;

class WallpaperAPI with ChangeNotifier {
  PageController scrollController;
  bool scroll = true;
  int pageCount = 5;

  /// Set [initColors] to true if need to fecth colors during initialization
  /// Scroll is enabled by default
  /// Use [enableScroll], [disableScroll], [toggleScroll] to control stuff
  WallpaperAPI({
    /// This controller is used for scroll events if provided
    PageController controller,
    bool initColors: false,
    bool subscribeWallpaperChanges: false,
  }) {
    if (subscribeWallpaperChanges) onWallpaperChangedEvent();
    if (initColors) getWallpaperColors();
    scrollController = (controller == null) ? PageController() : controller;
  }

  static const platform = const MethodChannel(
    'com.example.forward_gestures_livewallpaper/wallpapers',
  );

  static const eventChannel = const EventChannel(
    'com.example.forward_gestures_livewallpaper/events',
  );

  List<Color> colors = [
    Colors.black,
    Colors.black,
    Colors.black,
  ];

  Future<void> onWallpaperChangedEvent() async {
    eventChannel.receiveBroadcastStream().listen((dynamic event) {
      print('Received Wallpaper changed event: $event');
      notifyListeners();
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
    // print(scrollController.page);
    setWallpaperOffsets(scrollController.page, 5);
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
  Future<void> setWallpaperOffsets(double position, int numPages) async {
    try {
      await platform.invokeMethod("setWallpaperOffsets", [position, numPages]);
    } on PlatformException catch (e) {
      developer.log("Failed to change wallpaper offsets");
      print(e);
    }
  }

  Future<void> getWallpaperColors() async {
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
    } on PlatformException catch (e) {
      developer.log("Failed to get Wallpaper colors");
      print(e);
    }
  }
}
