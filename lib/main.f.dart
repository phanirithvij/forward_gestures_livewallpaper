import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: FrostedDemo()));
}

class FrostedDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FrostedExample(),
    );
  }
}

class FrostedExample extends StatelessWidget {
  const FrostedExample({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ConstrainedBox(
            constraints: const BoxConstraints.expand(), child: FlutterLogo()),
        Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration:
                    BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                child: Center(
                  child: Text('Frosted',
                      style: Theme.of(context).textTheme.display3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
