import 'dart:async';
import 'package:flutter/material.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key, required this.title});

  final String title;

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  String sport = "運動項目";
  int seconds = 5;
  bool ifStart = false;

  var period = const Duration(seconds: 1);

  //時間格式化，根據總秒數轉換為對應的 hh:mm:ss 格式
  String constructTime(int seconds) {
    //int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(minute) + ":" + formatTime(second);
    //return formatTime(hour) + ":" + formatTime(minute) + ":" + formatTime(second);
  }

  //時間格式化，將 0~9 的時間轉換為 00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  @override
  void initState(){
    super.initState();
    startTimer();
  }

  void startTimer(){
    if (ifStart){
      ifStart = false;
    }else{
      ifStart = true;
    }

    Timer.periodic(period, (timer) {
      if (seconds == 1 || ifStart == false) {
        timer.cancel();
        //ifStart = true;
        //Navigator.pushNamed(context, '/exercise');
      }else{
        seconds--;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: Color(0xfffaf0ca),
            child: Text(
              constructTime(seconds),
              //'$seconds',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xff0d3b66),
                  fontSize: 32,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  height: 1
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Color(0x193598f5),borderRadius: const BorderRadius.all(Radius.circular(13))),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            height: 60,
            width: MediaQuery.of(context).size.width - 20,
            child: Text("$sport",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xff0d3b66),
                  fontSize: 32,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  height: 1
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Image(
              image: AssetImage('images/testPic.gif'),//video
            ),
          ),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.only(right: 10),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: () => startTimer(),
                      icon: Icon(Icons.pause, color: Color(0xff0d3b66),),
                      label: Text(
                        ifStart?'暫停':'繼續',
                        style: TextStyle(
                          color: Color(0xff0d3b66),
                          fontSize: 24,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          height: 1
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffffa493),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
