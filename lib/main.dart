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
  double offset = 0;

  late Offset initialX;

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
                onPointerDown: (details) {
                  initialX = details.localPosition;
                  print(initialX);
                },
                onPointerMove: (details) {
                  var dx = details.localPosition.dx.toStringAsFixed(2);
                  var dy = details.localPosition.dy.toStringAsFixed(2);
                  setState(() {
                    var poka = details.localPosition - initialX;
                    offset = poka.dx; //double.parse(dx);
                    text1 = '$initialX' 'poka.dx:${poka.dx}';
                  });
                },
                child: SizedBox(
                    height: 150,
                    child: CustomPaint(
                      painter: Ticker(offset),
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

class Ticker extends CustomPainter {
  var offset;
  Ticker(this.offset);
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & Size(size.width, 1);
    var xAxis = size.height / 2;
    canvas
      ..translate(0, xAxis)
      ..drawRect(rect, Paint()..color = Colors.white);

    Rect tens(double xOffset) => Offset(xOffset, -25) & Size(2.56, 50);
    Rect unit(double xOffset) => Offset(xOffset, -10) & Size(1.6, 20);

    var pinky = Paint()..color = Color(0xFFFFB7FF);

    canvas.translate(offset, 0);
    canvas
      ..drawRect(tens(100), pinky)
      ..drawRect(unit(110), pinky)
      ..drawRect(unit(120), pinky)
      ..drawRect(unit(130), pinky)
      ..drawRect(unit(140), pinky)
      ..drawRect(unit(150), pinky)
      ..drawRect(unit(160), pinky)
      ..drawRect(unit(170), pinky)
      ..drawRect(unit(180), pinky)
      ..drawRect(unit(190), pinky)
      ..drawRect(tens(200), pinky);
  }

  @override
  bool shouldRepaint(Ticker oldDelegate) {
    print('repaint');
    return oldDelegate.offset - offset > 1;
  }
}
