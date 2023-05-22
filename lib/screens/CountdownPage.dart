import 'dart:async';
import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  final Map arguments;

  const CountdownPage({super.key, required this.arguments});

  @override
  CountdownPageState createState() => CountdownPageState();
}

class CountdownPageState extends State<CountdownPage> {
  int time = 3;
  bool ifEnd = false;

  var period = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    Timer.periodic(period, (timer) {
      if (time == 1) {
        timer.cancel();
        ifEnd = true;
        //Navigator.pushNamed(context, '/exercise');
        Navigator.popAndPushNamed(context, '/exercise', arguments: {
          'user': widget.arguments['user'],
          'exerciseTime': widget.arguments['exerciseTime'],
          'exerciseItem': widget.arguments['exerciseItem']
        });
        //timer = null;
      } else {
        time--;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffaf0ca),
        body: Center(
          child: Text('$time',
              style: const TextStyle(
                color: Color(0xff0d3b66),
                fontSize: 100,
                fontWeight: FontWeight.bold,
              )),
        ));
  }
}
