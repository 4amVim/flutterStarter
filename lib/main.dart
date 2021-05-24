import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector4;

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

class TapeMeasure extends CustomPainter {
  static double offset = 0;
  static double start = 0;

  static Duration? looptime;

  static late double width;

  @override
  void paint(Canvas canvas, Size size) {
    canvas //? Color the background, centre x-axis and do x-translation
      ..drawRect(Offset.zero & size, Paint()..color = Colors.amber)
      // ..translate(0, size.height / 2) //? Vertically centre the x-axis
      ..translate(start, 0) //? Offset the start (to persist between touches)
      ..translate(offset, 0); //? immidiate offset for current fingering
    // canvas
    // ..save()
    // ..rotate(pi / 2);

    ///Add [howMany] number of segments to the tape
    Canvas _addSegmentsAbove(Canvas cvs, int howMany, bool showText) {
      //* Some functions to ease modigying drawing bit
      //Draw longer lines for tens
      Rect tensLine(double xOffset) =>
          Offset(xOffset, 0) & Size(2.56, 0.35 * width);
      //Label them
      void tensText(double xOffset, int no) => TextPainter(
          text: TextSpan(
              text: no.toString(),
              style: TextStyle(fontSize: 40, color: Colors.red)),
          textDirection: TextDirection.ltr)
        ..layout()
        ..paint(cvs, Offset(-0.6 * width, xOffset - 125));

      // Draw shorter lines for units
      Rect unitLine(double xOffset) => Offset(xOffset, 0) & Size(1.6, 20);
      var black = Paint()..color = Colors.black;

      //* Draw segments
      for (var no = 0; no < howMany; no++) {
        //* Draw a segment
        cvs.drawRect(tensLine(no * 100), black);
        if (showText) {
          // cvs.save();
          cvs.rotate(-pi / 2);
          tensText(no * 100, no);
          cvs.rotate(pi / 2);
          // cvs.restore();
        }
        for (var i = 1; i < 10; i++) {
          cvs.drawRect(unitLine(i * 10 + no * 100), black);
        }
        cvs.drawRect(tensLine((no + 1) * 100), black);
      }
      return cvs;
    }

    _addSegmentsAbove(canvas, 9, true);
    // canvas
    //   ..translate(0, size.height)
    //   ..scale(1, -1);
    // Matrix4 poka = Matrix4.translationValues(0, size.height, 0)
    //   ..scale(1.0, -1.0, 1.0);
    late Matrix4 poka = Matrix4.identity();

    ///*Remember that co-ords are [x,y,z,1] to be multiplied from the left
    var startTime = DateTime.now();
    print('before loop:\n' + poka.toString() + '\n');
    // for (var i = 0; i < 1; i++) {
    poka = Matrix4.columns(
            Vector4(1.0, 0.0, 0.0, 0.0),
            Vector4(0.0, -1.0, 0.0, 0.01 * width),
            Vector4(0.0, 0.0, 1.0, 0.0),
            Vector4(0.0, -0.003 /* offset / 1000*/ /*8e-4*/, 0.0, 1.0))
        .transposed();
    // }
    print('after loop:\n' + poka.toString() + '\n');

    // canvas.save();
    canvas.transform(poka.storage);

    looptime = DateTime.now().difference(startTime);
    _addSegmentsAbove(canvas, 9, false);
    // canvas.restore();
    // poka = Matrix4.columns(
    //         Vector4(1.0, 0.0, 0.0, 0.0),
    //         Vector4(0.0, -1.0, 0.0, 1 * width),
    //         Vector4(0.0, 0.0, 1.0, 0.0),
    //         Vector4(0.0, -0.003 /* offset / 1000*/ /*8e-4*/, 0.0, 1.0))
    //     .transposed();
    // canvas.transform(poka.storage);
    // _addSegmentsAbove(canvas, 9, false);
  }

  @override
  bool shouldRepaint(TapeMeasure oldDelegate) => false;

  static void offsetBy(double displacement) => offset = displacement;

  static void shiftStart() {
    start = offset + start;
    offset = 0;
  }

  static String get string => 'Start position: ${start.toStringAsFixed(1)}'
      '  offset: ${offset.toStringAsFixed(1)}';
}

class _MyHomePageState extends State<MyHomePage> {
  String _debugText = 'Go on do it!';

  late Offset touchStart;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Swipe horizontally')),
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.green,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  Container(
                color: Colors.blue,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tape(width: constraints.maxWidth / 2.5, height: 200),
                      Text(_debugText)
                    ]),
              ),
            ),
          ),
        ),
      );

  ///
  Widget Tape({required double width, required double height}) {
    print('width->>> $width');
    TapeMeasure.width = width;
    return Transform.rotate(
      angle: pi / 2,
      child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (details) => touchStart = details.localPosition,
          onPointerMove: (details) => setState(() {
                TapeMeasure.offsetBy(
                    (details.localPosition.dx - touchStart.dx));
                _debugText = TapeMeasure.string +
                    ' loopTime:' +
                    (TapeMeasure.looptime?.inMilliseconds.toString() ??
                        'undefined');
              }),
          onPointerUp: (_) => setState(() {
                TapeMeasure.shiftStart();
                _debugText = TapeMeasure.string;
              }),
          child: Container(
              height: width,
              width: height,
              child: CustomPaint(painter: TapeMeasure()))),
    );
  }
}
