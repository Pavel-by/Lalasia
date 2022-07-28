import 'package:flutter/material.dart';
import 'package:lalasia_flutter_app/utils/adaptive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

enum RectType {
  smallBlue,
  bigRed,
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Adaptive
    Widget adaptive = AdaptiveLayoutBuilder<RectType>(
      initialStateIdentifier: RectType.bigRed,
      buildCallback: (BuildContext context, RectType type, BoxConstraints _) {
        switch (type) {
          case RectType.bigRed:
            return Container(constraints: BoxConstraints(minHeight: 100, minWidth: 1000), color: Colors.red);
          case RectType.smallBlue:
            return Container(width: 200, height: 100, color: Colors.blue);
        }
      },
      checkCallback: (AdaptiveInfo<RectType> info) {
        if (info.layoutResult == AdaptiveLayoutResult.great) {
          return info.stateIdentifier;
        }
        switch (info.stateIdentifier) {
          case RectType.bigRed:
            return RectType.smallBlue;
          case RectType.smallBlue:
            return RectType.smallBlue;
        }
      },
    );
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(maxWidth: 1200),
        child: Padding(padding: EdgeInsets.all(10), child: adaptive),
      ),
    );
  }
}
