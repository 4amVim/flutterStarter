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

  ///
  Widget Tape({required double width, required double height}) => Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (details) => touchStart = details.localPosition,
      onPointerMove: (details) => setState(() {
            TapeMeasurePaint.offsetBy(
                (details.localPosition.dy - touchStart.dy));
            _debugText = TapeMeasurePaint.readin.toString();
          }),
      onPointerUp: (_) => setState(() {
            TapeMeasurePaint.shiftStart();
            _debugText = TapeMeasurePaint.readPls.toString();
          }),
      child: Container(
          height: height,
          // width: width,
          // color: Colors.black,
          child: CustomPaint(
            painter: TapeMeasurePaint(width, height),
            child: Container(width: width),
          )));
}

///Draws a vertical tape measure that gives a measurment [reading]
class TapeMeasurePaint extends CustomPainter {
  ///
  double get _offset =>
      offset / _unit; //(offset * 10000 / _unit).floorToDouble() / 10000;
  double get _start {
    if (start == 0) start = -7963 * _unit * _unit;
    return start / _unit;
  } //(start * 10000 / _unit).floorToDouble() / 10000;

  double height;
  double width;
  TapeMeasurePaint(this.width, this.height,
      {double tens = 1, double ones = 2, double gap = 7, int howMany = 5})
      : _unit = (height) / (((ones + 9 * tens + 10 * gap)) * howMany) {
    _tenthSize = tens * _unit;
    _oneSize = ones * _unit;
    _gapSize = gap * _unit;
  }
  //? 2 for tens, 1 for each unit and 7 for each of the 10 spaces

  late final double _unit;
  static double unit = 0;

  late final double _tenthSize;
  late final double _oneSize;
  late final double _gapSize;

  static double readin = 0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas //? Color the background, centre x-axis and do x-translation
      ..drawRect(Offset.zero & size, Paint()..color = Colors.amber)
      ..save() //? We're saving basic state for later when we draw an arrow
      ..translate(size.width, .0) //? Vertically centre the x-axis
      ..translate(0, _start) //? Offset the start (to persist between touches)
      ..translate(0, _offset) //? immidiate offset for current fingering
      ..rotate(pi / 2); //* remember that hereon the axes are switched

    ///Add [howMany] number of segments to the tape
    Canvas _addSegmentsAbove(Canvas cvs, int howMany, bool showText) {
      //* Some functions to ease modigying drawing bit
      //Draw longer lines for tens

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

      //* Draw segments
      cvs.save();
      for (var no = 0; no < howMany; no++) {
        var black = Paint()..color = Colors.black;
        //* Draw a segment
        cvs.drawRect(Offset.zero & Size(_oneSize, 0.35 * size.width), black);
        cvs.translate(_oneSize, 0);
        if (showText) {
          cvs.rotate(-pi / 2);
          tensText(0, no);
          cvs.rotate(pi / 2);
        }
        for (var i = 1; i <= 9; i++) {
          cvs.drawRect(
              Offset(i * _gapSize + (i - 1) * _tenthSize, 0) &
                  Size(_tenthSize, .15 * size.width),
              black);
        }
        cvs.translate(10 * _gapSize + 9 * _tenthSize, 0);
      }
      return cvs..restore();
    }

    _addSegmentsAbove(canvas, 250, true);

    Matrix4 poka = Matrix4.translationValues(0, size.width, 0)
      ..scale(1.0, -1.0, 1.0);
    canvas.transform(poka.storage);

    _addSegmentsAbove(canvas, 250, false);

    var arrowPath = Path()
      ..addRect(Offset(size.width / 2, size.height / 3) &
          Size(size.width, size.height / 80))
      ..lineTo(size.width / 2, -20 + size.height / 3) //?Line up
      ..lineTo(-30 + size.width / 2, (163 * size.height / 480))
      ..lineTo(size.width / 2, 20 + (83 * size.height / 240));
    canvas
      ..restore()
      ..translate(-30, 0)
      ..drawPath(arrowPath, Paint()..color = Colors.white)
      ..translate(30, 0);

    ///Update Reading
    readin = (_offset + _start) / _unit;
    print('_offset    ->' + _offset.toString());
    print('_start    ->' + _start.toString());
    print('reading    ->' + readin.toString());
  }

  String get reading => ((_offset + _start) / _unit).toStringAsFixed(0);
  static double get readPls => (start + offset) / unit;

  @override
  bool shouldRepaint(TapeMeasurePaint oldDelegate) => false;

  static void offsetBy(double displacement) => offset = displacement;
  static double offset = 0;
  static double start = 0;
  // -27580; //-27800 is 101 and -27520 is 100 AND -30~a tenth;

  static void shiftStart() {
    start = offset + start;
    offset = 0;
  }

  static String get string => 'Start position: ${start.toStringAsFixed(1)}'
      '  offset: ${offset.toStringAsFixed(1)}';
}
