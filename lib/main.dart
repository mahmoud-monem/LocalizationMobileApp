import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';

// final FirebaseApp app = FirebaseApp(
//   options: FirebaseOptions(
//     googleAppID: '1:1095700650219:android:8ca7103efa898706be46ae',
//     apiKey: 'AIzaSyBW8KWbmFTv4J1XuPinCze7S25tGqSVB5I',
//     databaseURL: 'https://localization-9e689.firebaseio.com',
//   )
// );

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
  OpenPainter painter = new OpenPainter();
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  @override
  void initState() {
    super.initState();
    item = Item(0.0, 0.0);
    final FirebaseDatabase database = FirebaseDatabase.instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('/');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      item = items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
      painter.move(items[items.indexOf(old)].x, items[items.indexOf(old)].y);
    });
  }

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
          child: Text(item.x.toString()),
        ),
        Center(
            child: Container(
              width: 400,
              height: 640,
              child: CustomPaint(
                painter: painter,
              ),
            )
        ),
      ]),
    );
  }

  // void move(double x, double y) {
  //   setState(() {
  //     this.painter.move();
  //   });
  // }
}

class OpenPainter extends CustomPainter {
  double y = 0, x = 0;
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.red[700]
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 10;
    //list of points
    var points = [
      Offset(this.x, this.y),
    ];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void move(double x, double y) {
    this.y = y * 10;
    this.x = 200 - 10 * x;
  }
}

class Item {
  String key;
  double x, y;

  Item(this.x, this.y);

  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        x = snapshot.value["x"],
        y = snapshot.value["y"];

  toJson() {
    return {
      "x": x,
      "y": y,
    };
  }
}
