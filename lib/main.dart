import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Swipe vertically')),
      body: Center(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.green,
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
                                top: constraints.maxHeight / 4,
                                right: 0,

                                // alignment: AlignmentDirectional(
                                //     constraints.maxWidth / 3, 50),
                                child: Text(
                                    TapeMeasurePaint.reading
                                            ?.toStringAsFixed(2) ??
                                        'Scroll on the yellow tape to set height',
                                    softWrap: true,
                                    style: TextStyle(fontSize: 45))),
                          ]))))));

  ///
  Widget Tape({required double width, required double height}) => Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (details) => touchStart = details.localPosition,
      onPointerMove: (details) => setState(() {
            TapeMeasurePaint.offsetBy(
                (details.localPosition.dy - touchStart.dy));
            _debugText = TapeMeasurePaint.string +
                ' loopTime:' +
                (TapeMeasurePaint.looptime?.inMilliseconds.toString() ??
                    'undefined');
          }),
      onPointerUp: (_) => setState(() {
            TapeMeasurePaint.shiftStart();
            _debugText = TapeMeasurePaint.string;
          }),
      child: Container(
          height: height,
          // width: width,
          // color: Colors.black,
          child: CustomPaint(
            painter: TapeMeasurePaint(),
            child: Container(width: width),
          )));
}

class TapeMeasurePaint extends CustomPainter {
  static double offset = 0;
  static double start = -14600;
  static double? get reading {
    double read = (-start - offset + 253.7) / (100 * unitHigh);
    return read > 1000 ? null : read;
  }

  static double unitHigh = 0;

  static Duration? looptime;

  @override
  void paint(Canvas canvas, Size size) {
    var arrowPath = Path()
      ..addRect(Offset(size.width / 2, size.height / 3) &
          Size(size.width, size.height / 80))
      ..lineTo(size.width / 2, -20 + size.height / 3) //?Line up
      ..lineTo(-30 + size.width / 2, (163 * size.height / 480))
      ..lineTo(size.width / 2, 20 + (83 * size.height / 240));

    canvas //? Color the background, centre x-axis and do x-translation
      ..drawRect(Offset.zero & size, Paint()..color = Colors.amber)
      ..save()
      ..translate(size.width, .0) //? Vertically centre the x-axis
      ..translate(0, start) //? Offset the start (to persist between touches)
      ..translate(0, offset) //? immidiate offset for current fingering
      // canvas
      // ..save()
      ..rotate(pi / 2); //* remember that hereon the axes are switched

    ///Add [howMany] number of segments to the tape
    Canvas _addSegmentsAbove(Canvas cvs, int howMany, bool showText) {
      //* Some functions to ease modigying drawing bit
      //Draw longer lines for tens

      unitHigh = size.height / 511;

      Rect tensLine(double xOffset) =>
          Offset(xOffset, 0) & Size(2 * unitHigh, 0.35 * size.width);
      //Label them
      double fontSize = 40; //size.width*0.2>
      void tensText(double xOffset, int no) => TextPainter(
          text: TextSpan(
              text: no.toString(),
              style: TextStyle(fontSize: fontSize, color: Colors.red)),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: size.width * 0.2, maxWidth: size.width * 0.8)
        ..paint(cvs, Offset(-0.65 * size.width, xOffset - 0.04 * size.width));
      print(size.width * 0.2);

      // Draw shorter lines for units
      Rect unitLine(double xOffset) =>
          Offset(xOffset, 0) & Size(unitHigh, 0.15 * size.width);
      var black = Paint()..color = Colors.black;

      //* Draw segments
      for (var no = 0; no < howMany; no++) {
        //* Draw a segment
        cvs.drawRect(tensLine(no * 100 * unitHigh), black);
        if (showText) {
          // cvs.save();
          cvs.rotate(-pi / 2);
          tensText(no * 100 * unitHigh, no);
          cvs.rotate(pi / 2);
          // cvs.restore();
        }
        for (var i = 1; i < 10; i++) {
          cvs.drawRect(unitLine((i * 10 + no * 100) * unitHigh), black);
        }
      }
      return cvs;
    }

    _addSegmentsAbove(canvas, 250, true);

    ///*Remember that co-ords are [x,y,z,1] to be multiplied from the left
    var startTime = DateTime.now();

    Matrix4 poka = Matrix4.translationValues(0, size.width, 0)
      ..scale(1.0, -1.0, 1.0);
    canvas.transform(poka.storage);

    looptime = DateTime.now().difference(startTime);
    _addSegmentsAbove(canvas, 250, false);

    canvas
      ..restore()
      ..translate(-30, 0)
      ..drawPath(arrowPath, Paint()..color = Colors.white)
      ..translate(30, 0);
  }

  @override
  bool shouldRepaint(TapeMeasurePaint oldDelegate) => false;

  static void offsetBy(double displacement) => offset = displacement;

  static void shiftStart() {
    start = offset + start;
    offset = 0;
  }

  static String get string => 'Start position: ${start.toStringAsFixed(1)}'
      '  offset: ${offset.toStringAsFixed(1)}';
}
