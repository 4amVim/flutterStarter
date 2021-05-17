import 'dart:developer';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
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
                    height: 200,
                    child: Container(color: Colors.blue),
                  )),
              Text(text)
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _counter++),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}
