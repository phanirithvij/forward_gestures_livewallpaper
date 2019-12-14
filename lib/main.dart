import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:forward_gestures_livewallpaper/android/wallpaper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RootWidget());
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WallpaperAPI>(
      create: (_) => WallpaperAPI(
        initColors: true,
        pageCount: 8,
        subscribeWallpaperChanges: true,
      ),
      child: MaterialApp(
        home: MyHome(),
        title: "Double Tap",
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var home = Homepage();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: home,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.palette),
        onPressed: () {
          Provider.of<WallpaperAPI>(context).getWallpaperColors();
          // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        },
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({
    Key key,
  }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<WallpaperAPI>(context).updateScrollEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Consumer<WallpaperAPI>(
          builder: (BuildContext context, value, Widget child) {
            // return FrostedExample();
            return ColorWidgets();
          },
        ),
        GestureDetector(
          child: SizedBox.expand(
            child: Container(
              child: PageView(
                controller: Provider.of<WallpaperAPI>(context).scrollController,
                children: _getPages(),
              ),
            ),
          ),
          onTapDown: (ev) =>
              Provider.of<WallpaperAPI>(context).sendWallpaperCommand(ev),
        ),
      ],
    );
  }

  List<Widget> _getPages() {
    var pages = <Widget>[];
    int pageCount = Provider.of<WallpaperAPI>(context).pageCount;
    for (int i = 0; i < pageCount; i++) {
      pages.add(
        Container(
          child: Center(
            child: Text(
              "Page ${i + 1}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
    }
    return pages;
  }
}

class ColorWidgets extends StatelessWidget {
  const ColorWidgets({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            color: Provider.of<WallpaperAPI>(context).colors[0],
          ),
          Container(
            width: 100,
            height: 100,
            color: Provider.of<WallpaperAPI>(context).colors[1],
          ),
          Container(
            width: 100,
            height: 100,
            color: Provider.of<WallpaperAPI>(context).colors[2],
          ),
        ],
      ),
    );
  }
}
