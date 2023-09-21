import 'dart:async';
import 'package:flutter/material.dart';

import 'package:g12/screens/PageMaterial.dart';

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
        if (widget.arguments['type'] == 'exercise') {
          Navigator.popAndPushNamed(context, '/exercise', arguments: {
            'totalExerciseItemLength':
                widget.arguments['totalExerciseItemLength'],
            'exerciseTime': widget.arguments['exerciseTime'],
            'exerciseItem': widget.arguments['exerciseItem'],
            'currentIndex': widget.arguments['currentIndex']
          });
        } else {
          Navigator.popAndPushNamed(context, '/meditation', arguments: {
            'meditationPlan': widget.arguments['meditationPlan'],
            'meditationTime': widget.arguments['meditationTime'],
          });
        }
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
        backgroundColor: ColorSet.backgroundColor,
        body: Center(
          child: Text('$time',
              style: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 100,
                fontWeight: FontWeight.bold,
              )),
        ));
  }
}
