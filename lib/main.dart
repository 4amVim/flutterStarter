import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: MyHomePage());
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String text = 'Go on do it!';
  String text1 = 'Go on do it!';
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Hi')),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text('You have pushed the button this many times:'),
              Text('$_counter', style: Theme.of(context).textTheme.headline4),
              Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerMove: (details) {
                    var dx = details.localPosition.dx.toStringAsFixed(2);
                    var dy = details.localPosition.dy.toStringAsFixed(2);
                    setState(() {
                      text = 'dx:$dx, dy:$dy';
                    });
                  },
                  child: SizedBox(
                      height: 200, child: Container(color: Colors.blue))),
              Text(text),
              Listener(
                behavior: HitTestBehavior.opaque,
                onPointerMove: (details) {
                  var dx = details.localPosition.dx.toStringAsFixed(2);
                  var dy = details.localPosition.dy.toStringAsFixed(2);
                  setState(() {
                    text1 = 'dx:$dx, dy:$dy';
                  });
                },
                child: SizedBox(
                    height: 150,
                    child: CustomPaint(
                      painter: Sky(),
                      child: Container(
                          // color: Color(0x3F3BF4BB),
                          ),
                    )),
              ),
              Text(text1)
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _counter++),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & Size(size.width, 1);
    // canvas.save();
    // canvas.clipRRect(RRect.fromRectXY(rect, 100.0, 100.0));
    // canvas.saveLayer(rect, Paint());
    // canvas.drawPaint(Paint()..color = Colors.red);
    // canvas.drawPaint(Paint()..color = Colors.white);
    // canvas.restore();
    // canvas.restore();
    canvas
      ..translate(0, size.height / 2)
      ..drawRect(rect, Paint()..color = Colors.white);

    Rect tens = Offset.fromDirection(0, 100) & Size(2.56, 50);
    Rect units = Offset.fromDirection(0, 200) & Size(1.6, 31.25);

    var pinky = Paint()..color = Color(0xFFFFB7FF);

    canvas
      ..translate(0, -50)
      ..drawRect(tens, pinky)
      ..drawRect(units, pinky)
      ..translate(0, 50);
  }

  @override
  bool shouldRepaint(Sky oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}

