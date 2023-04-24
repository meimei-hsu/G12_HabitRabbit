import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

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
    // Create and store the VideoPlayerController.
    _controller = VideoPlayerController.asset('images/videoTest.mp4');
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();
    // Use the controller to loop the video.
    _controller.setLooping(true);

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
      if (seconds < 1) {
        showAlertDialog(context);//彈出回饋框
        timer.cancel();
        dispose();
        //ifStart = true;
        //Navigator.pushNamed(context, '/exercise');
      } else if (ifStart == false){
        timer.cancel();
        _controller.pause();
      } else{
        seconds--;
        _controller.play();
      }
      setState(() {});
    });
  }

  void dispose() {  //銷毀 controller
    _controller.dispose();
    super.dispose();
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
          /*Container(
            child: Image(
              image: AssetImage('images/testPic.gif'),//video
            ),
          ),*/
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Container(
              padding: EdgeInsets.only(right: 10),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: () => startTimer(),
                      icon: Icon(ifStart?Icons.pause:Icons.play_arrow_rounded, color: Color(0xff0d3b66),),
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
              )
          ),
        ],
      ),
    );
  }
}

//回饋框框
showAlertDialog(BuildContext context) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text("恭喜完成運動！"),
    actions: [
      ElevatedButton(
          child: Text("讚"),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          }
      ),
    ],
  );

  // Show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      }
  );
}