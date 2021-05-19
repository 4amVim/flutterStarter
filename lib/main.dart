import 'dart:developer';
import 'dart:math';
import 'dart:typed_data';

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
  late double start;

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
                  start = offset;
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
  double _start = 0;
  double offset;

  Ticker(this.offset);
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & Size(size.width, 1);
    var xAxis = size.height / 2;
    canvas
          ..drawRect(Offset.zero & size, Paint()..color = Color(0xFFFFCA28))
          ..translate(0, xAxis)
        // ..drawRect(rect, Paint()..color = Colors.white)
        ;

    Rect tens(double xOffset) => Offset(xOffset, -25) & Size(2.56, 50);
    Rect unit(double xOffset) => Offset(xOffset, -10) & Size(1.6, 20);

    var black = Paint()..color = Colors.black;
    // canvas.drawPaint(Paint()..color = Colors.blue);

    canvas.translate(_start + offset, 0);
    canvas
      ..drawRect(tens(00), black)
      ..drawRect(unit(10), black)
      ..drawRect(unit(20), black)
      ..drawRect(unit(30), black)
      ..drawRect(unit(40), black)
      ..drawRect(unit(50), black)
      ..drawRect(unit(60), black)
      ..drawRect(unit(70), black)
      ..drawRect(unit(80), black)
      ..drawRect(unit(90), black)
      ..drawRect(tens(100), black);

    Canvas drawRect(cvs, double no) => canvas
      ..drawRect(tens(00 + no), black)
      ..drawRect(unit(10 + no), black)
      ..drawRect(unit(20 + no), black)
      ..drawRect(unit(30 + no), black)
      ..drawRect(unit(40 + no), black)
      ..drawRect(unit(50 + no), black)
      ..drawRect(unit(60 + no), black)
      ..drawRect(unit(70 + no), black)
      ..drawRect(unit(80 + no), black)
      ..drawRect(unit(90 + no), black)
      ..drawRect(tens(no), black);

    drawRect(canvas, 100);
    drawRect(canvas, 200);
    drawRect(canvas, 300);
    drawRect(canvas, 400);
  }

  @override
  bool shouldRepaint(Ticker oldDelegate) {
    if ((oldDelegate._start - offset).abs() > 10) {
      
      print('repaint' + (oldDelegate.offset - offset).toString());
      return true;
    }
    print((oldDelegate.offset - offset).toStringAsFixed(1) + 'Wont ');
    return false;
  }
}
