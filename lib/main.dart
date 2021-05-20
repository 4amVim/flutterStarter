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

class Ticker1 extends CustomPainter {
  static double currentOffset = 0;
  static double currentStart = 0;
  // static Ticker1? zeTick;

  Ticker1();

  @override
  void paint(Canvas canvas, Size size) {
    print('gonna paint');
    var xAxis = size.height / 2;
    canvas
      ..drawRect(Offset.zero & size, Paint()..color = Colors.white)
      ..translate(currentStart, 0)
      ..translate(0, xAxis);
    // canvas.translate(offset, 0);
    canvas.translate(currentOffset, 0);
    // currentOffset = offset;

    ///Add [howMany] number of segments to the tape
    Canvas _addSegments(Canvas cvs, int howMany) {
      Rect tensLine(double xOffset) => Offset(xOffset, -25) & Size(2.56, 50);
      Rect unitLine(double xOffset) => Offset(xOffset, -10) & Size(1.6, 20);
      var black = Paint()..color = Colors.black;
      //* Draw segments
      for (var no = 0; no < howMany; no++) {
        //* Draw a segment
        cvs.drawRect(tensLine(no * 100), black);
        for (var i = 1; i < 10; i++) {
          cvs.drawRect(unitLine(i * 10 + no * 100), black);
        }
        cvs.drawRect(tensLine((no + 1) * 100), black);
      }
      return cvs;
    }

    _addSegments(canvas, 9);
  }

  @override
  bool shouldRepaint(Ticker1 oldDelegate) {
    return false;
  }

  static offsetBy(double offset) {
    print('offsetting by $offset');
    currentOffset = offset;
    // currentOffset += offset;
  }

  static void shiftStart() {
    currentStart = currentOffset + currentStart;
    currentOffset = 0;
    print('told to start at $currentStart');
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String text = 'Go on do it!';
  String text1 = 'Go on do it!';
  double offset = 0;
  double nextTime = 0;

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
                  //1
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (details) {
                    initialX = details.localPosition;
                  },
                  onPointerMove: (details) {
                    var poka = details.localPosition.dx - initialX.dx;
                    setState(() {
                      Ticker1.offsetBy(poka);
                      text1 =
                          'Start: ${Ticker1.currentStart.toStringAsFixed(1)}'
                          'offset: ${Ticker1.currentOffset.toStringAsFixed(1)}';
                      // offset = offset + 1;
                    });
                  },
                  onPointerUp: (_) {
                    // nextTime = T+icker1.zeTick!.offset;
                    print('current ??' + Ticker1.currentOffset.toString());
                    setState(() {
                      Ticker1.shiftStart();
                      text1 =
                          'Start: ${Ticker1.currentStart.toStringAsFixed(1)}'
                          'offset: ${Ticker1.currentOffset.toStringAsFixed(1)}';
                      // offset = offset + 1;
                    });
                  },
                  child: SizedBox(
                      height: 150,
                      child:
                          CustomPaint(painter: Ticker1(), child: Container()))),
              Text(text1)
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _counter++),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}
