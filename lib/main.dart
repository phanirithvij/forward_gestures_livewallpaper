import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(RootWidget());
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  static const platform = const MethodChannel(
    'com.example.forward_gestures_livewallpaper/events',
  );

  const Homepage({
    Key key,
  }) : super(key: key);

  Future<void> _sendWallpaperEvent(TapDownDetails ev) async {
    try {
      await platform.invokeMethod(
        "wallpaperEvent",
        [ev.globalPosition.dx, ev.globalPosition.dy],
      );
    } on PlatformException catch (e) {
      debugPrint("Failed to send a Wallpaper command");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox.expand(
        child: Container(
          child: PageView(
            children: <Widget>[
              Container(
                child: Center(
                  child: Text("Page 1"),
                ),
              ),
              Container(
                color: Colors.black12,
                child: Center(
                  child: Text("Page 2"),
                ),
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Text("Page 3"),
                ),
              ),
              Container(
                color: Colors.black38,
                child: Center(
                  child: Text("Page 4"),
                ),
              ),
              Container(
                color: Colors.black45,
                child: Center(
                  child: Text("Page 5"),
                ),
              ),
            ],
          ),
        ),
      ),
      onTapDown: (ev) {
        // print(ev.globalPosition.dx);
        // print(ev.globalPosition.dy);
        _sendWallpaperEvent(ev);
      },
    );
  }
}
