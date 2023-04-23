import 'dart:async';
import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key, required this.title});

  final String title;

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int time = 3;
  bool ifEnd = false;

  var period = const Duration(seconds: 1);

  @override
  void initState(){
    super.initState();
    Timer.periodic(period, (timer) {
      if (time == 1) {
        timer.cancel();
        ifEnd = true;
        Navigator.pushNamed(context, '/exercise');
        //timer = null;
      }
      else{
        time--;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffaf0ca),
        body: Center(
            child: Text(
                '$time',
                style: TextStyle(
                  color: Color(0xff0d3b66),
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                )
            ),
        )
    );
  }
}
