import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:starter/tapeMeasure.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: OnboardingPage());
}

class OnboardingPage extends StatefulWidget {
  OnboardingPage();
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  String _debugText = 'Go on do it!';
  late Offset touchStart;
  TapeMeasurePaint? tape;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Swipe vertically')),
      body: Center(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) =>
                      ColoredBox(
                          color: Colors.blue,
                          child: Stack(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Tape(
                                  width: constraints.maxWidth / 3,
                                  height: constraints.maxHeight),
                            ),
                            Positioned(
                                left: constraints.maxWidth / 3,
                                top: constraints.maxHeight / 2,
                                right: 0,

                                // alignment: AlignmentDirectional(
                                //     constraints.maxWidth / 3, 50),
                                child: Text(_debugText,
                                    softWrap: true,
                                    style: TextStyle(fontSize: 45))),
                            Positioned(
                                left: constraints.maxWidth / 3,
                                top: constraints.maxHeight / 8,
                                right: 0,

                                // alignment: AlignmentDirectional(
                                //     constraints.maxWidth / 3, 50),
                                child: Text(
                                    'readin =' +
                                        TapeMeasurePaint.readin
                                            .toStringAsFixed(5),
                                    softWrap: true,
                                    style: TextStyle(fontSize: 20))),
                          ]))))));

  Widget Tape({required double width, required double height}) {
    tape ??= TapeMeasurePaint(width, height);
    return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (details) => touchStart = details.localPosition,
        onPointerMove: (details) => setState(() {
              TapeMeasurePaint.offsetBy(
                  (details.localPosition.dy - touchStart.dy));
              _debugText = (((tape!.reading) / -81)+1.7).toStringAsFixed(1);
            }),
        onPointerUp: (_) => setState(() {
              TapeMeasurePaint.shiftStart();
              _debugText = ((tape!.reading) / -80).toString();
            }),
        child: CustomPaint(
          painter: tape, //TapeMeasurePaint(width, height),
          child: Container(width: width),
        ));
  }
}
