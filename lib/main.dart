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
                  onPointerUp: (_) {
                    nextTime = Ticker.zeTick!.offset;
                  },
                  child: SizedBox(
                      height: 150,
                      child: CustomPaint(
                          painter: Ticker.offset(offset, nextTime),
                          child: Container()))),
              Text(text1)
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _counter++),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}

/// What we do is, to build a Ticker given a start position,
class Ticker extends CustomPainter {
  double offset;

  static Ticker? zeTick;
  double zeroPosition;

  Ticker(this.offset, this.zeroPosition);

  factory Ticker.offset(offset, start) {
    if (zeTick == null) {
      print('pokoka');
      zeTick = Ticker(offset, 50); //zeTick!.offset + offset);
    } else {
      zeTick = Ticker(offset,
          zeTick!.offset + zeTick!.zeroPosition); //zeTick!.offset + offset);
    }
    return zeTick!;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var xAxis = size.height / 2;
    canvas
      // ..translate(zeroPosition, 0)
      ..drawRect(Offset.zero & size, Paint()..color = Color(0xFFFFCA28))
      ..translate(0, xAxis);
    canvas.translate(offset, 0);
    canvas.translate(zeroPosition, 0);
    print('current offset' + (offset + zeroPosition).toString());

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
  bool shouldRepaint(Ticker oldDelegate) {
    // if (offset > 10) {
    //   print('repaint' + (oldDelegate.offset - offset).toString());
    //   return true;
    // }
    // print((oldDelegate.offset - offset).toStringAsFixed(1) + 'Wont ');
    return false;
  }
}
