import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OpenPainter tmp = new OpenPainter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Localization'),
        backgroundColor: Colors.red[700],
      ),
      body: Stack(children: [
        // Center(
        //   child: Image.asset('asstes/images/SBME Map full.png'),
        // ),
        Center(
            child: Container(
              width: 400,
              height: 640,
              child: CustomPaint(
                painter: tmp,
              ),
            )
        ),
      ]),

      floatingActionButton: FloatingActionButton(
        onPressed: move,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void move() {
    setState(() {
      this.tmp.move();
    });
  }
}

class OpenPainter extends CustomPainter {
  double y = 0;
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.red[700]
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 10;
    //list of points
    var points = [
      Offset(200, this.y),
    ];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void move() {
    this.y += 100;
    this.y %= 641;
  }
}
