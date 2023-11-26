import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:square_progress_bar/square_progress_bar.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/services/database.dart';
import 'package:g12/services/plan_algo.dart';
import 'package:g12/Services/notification.dart';
import 'package:g12/services/page_data.dart';

class DoExercisePage extends StatefulWidget {
  final Map arguments;

  const DoExercisePage({super.key, required this.arguments});

  @override
  DoExercisePageState createState() => DoExercisePageState();
}

class DoExercisePageState extends State<DoExercisePage> {
  final audioPlayer = AudioPlayer();

  String sport = "運動項目";
  late int totalTime;
  late int countdownTime;
  double _progress = 0.0;
  int countDown = 6; // 60s
  bool ifStart = false;
  var period = const Duration(seconds: 1);

  /* 計時器時間設定 */
  // 時間格式化，根據總秒數轉換為對應的 hh:mm:ss 格式
  String constructTime(int seconds) {
    //int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return "${formatTime(minute)}:${formatTime(second)}";
    //return formatTime(hour) + ":" + formatTime(minute) + ":" + formatTime(second);
  }

  // 時間格式化，將 0~9 的時間轉換為 00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0$timeNum" : timeNum.toString();
  }

  /* 計時器時間設定 */

  /* 播放影片 delete??? */
  //late VideoPlayerController _controller;
  //late Future<void> _initializeVideoPlayerFuture;

  /* 播放影片 delete??? */

  /*  GIF 輪播 */
  late PageController _pageController; //輪播圖 PageView 使用的控制器
  int currentIndex = 0; //當前顯示的索引
  int exerciseItemListLength = 0;
  int totalExerciseItemLength = 0;
  int playIndex = 0;

  Widget buildVideoBanner(List videoList) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          //輪播圖片
          buildVideoBannerWidget(videoList),
        ],
      ),
    );
  }

  buildVideoBannerWidget(List videoList) {
    // 懶載入方式構建
    return PageView.builder(
      // 構建每一個子Item的佈局
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return buildPageViewItemWidget(index, videoList);
      },
      controller: _pageController, // 控制器
      itemCount: videoList.length, // 輪播個數 無限輪播 ??
    );
  }

  // 輪播顯示圖片
  buildPageViewItemWidget(int index, List videoList) {
    //return VideoPlayerController.asset('assets/videos/videoTest.mp4');
    return Image.asset(
      videoList[index % videoList.length],
      //fit: BoxFit.fill,
    );
  }

  // Get Gif List to play.
  List<String> _getVideoList(List exerciseItem) {
    List exerciseItemList = exerciseItem;
    List<String> videoList = [
      for (int i = 0; i < exerciseItemList.length; i++)
        "assets/videos/${exerciseItem[i].replaceAll(RegExp(r'\W\W：'), '')}.gif"
    ];
    videoList.add("assets/videos/休息.gif");
    return videoList;
  }

  // Get exerciseItem name List.
  List _getExerciseItemNameList() {
    List exerciseItemList = widget.arguments['exerciseItem'];
    return exerciseItemList;
  }

  /*  GIF 輪播 */

  Future<bool> checkExit() async {
    bool canExit = false;

    /*
    btnCancelOnPress() {
      startTimer();
      canExit = false;
    }
     */

    btnNoOnPress() {
      DurationDB.update("workout", {
        Calendar.today: (currentIndex / 5 * HomeData.workoutDuration).round()
      });
      canExit = true;
      showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          backgroundColor: ColorSet.bottomBarColor,
          context: context,
          builder: (context) {
            return Wrap(children: const [
              FeedbackBottomSheet(
                arguments: {"type": 0},
              )
            ]);
          });
    }

    btnYesOnPress() async {
      await DurationDB.update("workout", {
        Calendar.today: (currentIndex / 5 * HomeData.workoutDuration).round()
      });
      canExit = true;
      NotificationService().scheduleNotification(
          title: '該開始運動囉',
          body: '就快完成了，加油！',
          scheduledNotificationDateTime:
              DateTime.now().add(const Duration(seconds: 5)));
      HomeData.fetch();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/', (Route<dynamic> route) => false);
    }

    setState(() {
      ifStart = false;
    });

    AwesomeDialog dlg = ConfirmDialog().get(
        context,
        "提示:)",
        "目前運動已經完成 ${(currentIndex / totalExerciseItemLength * 100).round()}% 囉！\n請問今天會回來繼續完成嗎？",
        btnYesOnPress,
        btnCancelOnPress: btnNoOnPress,
        options: ["會的", "不會"]);
    // ["會，請等等通知我", "不會，明天再回來"]

    await dlg.show();
    return Future.value(canExit);
  }

  void startTimer() {
    if (ifStart) {
      ifStart = false;
    } else {
      ifStart = true;
    }

    Timer.periodic(period, (timer) async {
      if (totalTime < 1) {
        DurationDB.update(
            "workout", {Calendar.today: HomeData.workoutDuration});
        GamificationDB.updateFragment("workout");
        timer.cancel();
        await audioPlayer.stop();

        if (!mounted) return;
        CongratsDialog.show(context,
            habit: "workout",
            widgetAfterDismiss: Wrap(children: const [
              FeedbackBottomSheet(
                arguments: {"type": 0},
              )
            ]));
      } else if (ifStart == false) {
        timer.cancel();
        await audioPlayer.pause();
        //_controller.pause();
      } else {
        await audioPlayer.play();

        // Appbar timer
        totalTime--;
        _progress = (countdownTime - totalTime) / countdownTime;
        //_controller.play();

        // Video timer
        countDown--;
        if (countDown < 1 && totalTime >= 1) {
          List nameList = _getExerciseItemNameList();

          countDown = 6; // 60s
          /*if (currentIndex < 2 || currentIndex >= totalExerciseItemLength - 3) {
            currentIndex++;
            playIndex ++;
            _pageController.animateToPage(playIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
            sport = nameList[playIndex];
          } else {
            currentIndex++;
            playIndex++;
            _pageController.animateToPage(playIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
            sport = nameList[playIndex];

            // 運動 5 秒後休息 1 秒
            Timer(const Duration(seconds: 5), () {
              _pageController.animateToPage(nameList.length + 1,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.ease);
              sport = nameList[playIndex].replaceAll("運動", "休息");
            });
          }*/
          currentIndex++;
          playIndex++;
          _pageController.animateToPage(playIndex,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
          sport = nameList[playIndex];
          debugPrint(
              "currentIndex: $currentIndex ... sport: $sport ... totalTime: $totalTime");

          playAudio(sport);
        } else if (sport.contains("運動") && countDown == 1) {
          // 運動 5 秒後休息 1 秒
          playAudio("休息");
          _pageController.animateToPage(_getExerciseItemNameList().length + 1,
              duration: const Duration(milliseconds: 5),
              curve: Curves.ease);
          sport = sport.replaceAll("運動", "休息");
        }
      }
      if (totalTime >= 1) setState(() {});
    });
  }

  Future<void> playAudio(String sport) async {
    sport = sport.contains("休息") ? "休息" : sport.substring(3);
    await audioPlayer.setAsset('assets/audios/$sport.mp3');
    await audioPlayer.play();
  }

  @override
  void initState() {
    // Create and store the VideoPlayerController.
    //_controller = VideoPlayerController.asset('assets/videos/videoTest.mp4');
    // Initialize the controller and store the Future for later use.
    //_initializeVideoPlayerFuture = _controller.initialize();
    // Use the controller to loop the video.
    //_controller.setLooping(true);

    super.initState();
    totalTime = widget.arguments['exerciseTime']; // initial totalTime
    countdownTime = totalTime;
    currentIndex = widget.arguments['currentIndex']; // get currentIndex
    // get whole plan list's length to calculate progress.
    totalExerciseItemLength = widget.arguments['totalExerciseItemLength'];

    // initial first exercise's name
    List nameList = _getExerciseItemNameList();
    sport = nameList[0];
    _pageController = PageController(initialPage: 0);
    debugPrint(
        "currentIndex_init: $currentIndex ... sport: $sport ... totalTime: $totalTime");

    if (currentIndex >= 2 && currentIndex < totalExerciseItemLength - 3) {
      // 運動 5 秒後休息 1 秒
      Timer(const Duration(seconds: 5), () {
        _pageController.animateToPage(nameList.length + 1,
            duration: const Duration(milliseconds: 5), curve: Curves.ease);
        sport = sport.replaceAll("運動", "休息");
      });
    }

    ///當前頁面繪製完第一幀後回撥
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startTimer();
      playAudio(sport);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: checkExit,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: ColorSet.backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(
                    color: ColorSet.exerciseColor,
                    borderRadius: BorderRadius.all(Radius.circular(13))),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                height: 60,
                width: MediaQuery.of(context).size.width - 20,
                child: Center(
                    child: Text(
                  sport,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 32,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      height: 1),
                )),
              ),
              const SizedBox(height: 10),
              // TODO: Change the gradient color of SquareProgressBar
              SquareProgressBar(
                  width: MediaQuery.of(context).size.width - 25,
                  // default: max available space
                  height: MediaQuery.of(context).size.width - 25,
                  // default: max available space
                  progress: _progress,
                  // provide the progress in a range from 0.0 to 1.0
                  solidBarColor: Colors.amber,
                  emptyBarColor: ColorSet.exerciseColor,
                  strokeWidth: 10,
                  gradientBarColor: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[Colors.pinkAccent, Colors.blueAccent],
                    tileMode: TileMode.repeated,
                  ),
                  // 漸層顏色
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: buildVideoBanner(
                          _getVideoList(widget.arguments['exerciseItem'])),
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  constructTime(totalTime),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 48,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Ink(
                    decoration: const ShapeDecoration(
                      color: ColorSet.exerciseColor,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        ifStart
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: ColorSet.iconColor,
                      ),
                      iconSize: 60,
                      color: ColorSet.iconColor,
                      onPressed: () => startTimer(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        )));
  }
}

class DoMeditationPage extends StatefulWidget {
  final Map arguments;

  const DoMeditationPage({super.key, required this.arguments});

  @override
  DoMeditationPageState createState() => DoMeditationPageState();
}

class DoMeditationPageState extends State<DoMeditationPage> {
  final audioPlayer = AudioPlayer();

  late int totalTime;
  late int countdownTime;
  double _progress = 0.0;
  int countDown = 6; // 60s
  bool ifStart = false;
  var period = const Duration(seconds: 1);

  /* 計時器時間設定 */
  // 時間格式化，根據總秒數轉換為對應的 hh:mm:ss 格式
  String constructTime(int seconds) {
    //int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return "${formatTime(minute)}:${formatTime(second)}";
  }

  // 時間格式化，將 0~9 的時間轉換為 00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0$timeNum" : timeNum.toString();
  }

  Future<bool> checkExit() async {
    bool canExit = false;

    /*
    btnCancelOnPress() {
      startTimer();
      canExit = false;
    }
     */

    btnNoOnPress() {
      DurationDB.update("meditation",
          {Calendar.today: (HomeData.meditationDuration * _progress).round()});
      canExit = true;
      showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          backgroundColor: ColorSet.bottomBarColor,
          context: context,
          builder: (context) {
            return Wrap(children: const [
              FeedbackBottomSheet(
                arguments: {"type": 1},
              )
            ]);
          });
    }

    btnYesOnPress() async {
      await DurationDB.update("meditation",
          {Calendar.today: (HomeData.meditationDuration * _progress).round()});
      canExit = true;
      NotificationService().scheduleNotification(
          title: '該開始冥想囉',
          body: '就快完成了，加油！',
          scheduledNotificationDateTime:
              DateTime.now().add(const Duration(seconds: 3)));
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/', (Route<dynamic> route) => false);
    }

    setState(() {
      ifStart = false;
    });

    AwesomeDialog dlg = ConfirmDialog().get(
        context,
        "退出計畫",
        "目前冥想已經完成 ${(_progress.toDouble() * 100).round()}% 囉！\n請問今天會回來繼續完成嗎？'",
        btnYesOnPress,
        btnCancelOnPress: btnNoOnPress,
        options: ["會的", "不會"]);
    // ["會，請等等通知我", "不會，明天再回來"]

    await dlg.show();
    return Future.value(canExit);
  }

  void startTimer() {
    if (ifStart) {
      ifStart = false;
    } else {
      ifStart = true;
    }

    Timer.periodic(period, (timer) async {
      if (totalTime < 1) {
        DurationDB.update(
            "meditation", {Calendar.today: HomeData.meditationDuration});
        GamificationDB.updateFragment("meditation");

        timer.cancel();
        await audioPlayer.stop();

        if (!mounted) return;
        CongratsDialog.show(context,
            habit: "meditation",
            widgetAfterDismiss: Wrap(children: const [
              FeedbackBottomSheet(
                arguments: {"type": 1},
              )
            ]));
      } else if (ifStart == false) {
        timer.cancel();
        await audioPlayer.pause();
      } else {
        // Appbar timer
        totalTime--;
        _progress = (countdownTime - totalTime) / countdownTime;
        await audioPlayer.play();
      }
      if (totalTime >= 1) setState(() {});
    });
  }

  Future<void> initPlayer() async {
    await audioPlayer.setAsset('assets/audios/冥想.mp3');
  }

  @override
  void initState() {
    super.initState();
    totalTime = widget.arguments['meditationTime'] * 6; // should be 60s
    countdownTime = totalTime;

    initPlayer();

    startTimer();
    audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: checkExit,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: ColorSet.backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(
                    color: ColorSet.meditationColor,
                    borderRadius: BorderRadius.all(Radius.circular(13))),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                height: 60,
                width: MediaQuery.of(context).size.width - 20,
                child: Center(
                    child: Text(
                  widget.arguments['meditationPlan'],
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 32,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      height: 1),
                )),
              ),
              const SizedBox(height: 10),
              SquareProgressBar(
                  width: MediaQuery.of(context).size.width - 25,
                  // default: max available space
                  height: MediaQuery.of(context).size.width - 25,
                  // default: max available space
                  progress: _progress,
                  // provide the progress in a range from 0.0 to 1.0
                  solidBarColor: Colors.amber,
                  emptyBarColor: ColorSet.meditationColor,
                  strokeWidth: 10,
                  gradientBarColor: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[Colors.pinkAccent, Colors.blueAccent],
                    tileMode: TileMode.repeated,
                  ),
                  // 漸層顏色
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Image.asset("assets/videos/冥想.gif"),
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  constructTime(totalTime),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 48,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Ink(
                    decoration: const ShapeDecoration(
                      color: ColorSet.meditationColor,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        ifStart
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: ColorSet.iconColor,
                      ),
                      iconSize: 60,
                      color: ColorSet.iconColor,
                      onPressed: () => startTimer(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        )));
  }
}

// 運動回饋
class FeedbackBottomSheet extends StatefulWidget {
  final Map arguments;

  const FeedbackBottomSheet({super.key, required this.arguments});

  @override
  FeedbackBottomSheetState createState() => FeedbackBottomSheetState();
}

class FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  int type = 0; // 0 = 運動, 1 = 冥想

  double satisfiedScore = 1; // Q1
  double tiredScore = 1; // Q2
  bool isAnxious = false; // Q3-1
  bool haveToSprint = false; // Q3-2
  bool isSatisfied = false; // Q3-3
  List<int> feedbackData = [];

  onSatisfiedScoreUpdate(rating) {
    setState(() {
      satisfiedScore = rating;
    });
  }

  onTiredScoreUpdate(rating) {
    setState(() {
      tiredScore = rating;
    });
  }

  @override
  void initState() {
    super.initState();
    type = widget.arguments["type"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "${(type == 0) ? "運動" : "冥想"}回饋",
              style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            "assets/images/Rabbit_shining.png",
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "是否滿意今天的${(type == 0) ? "運動" : "冥想"}計劃呢？",
            style: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          RatingScoreBar().getSatisfiedScoreBar(onSatisfiedScoreUpdate),
          // Exercise-specific questions:
          (type == 0)
              ? const SizedBox(
                  height: 10,
                )
              : Container(),
          (type == 0)
              ? const Divider(
                  thickness: 1.5,
                  indent: 20,
                  endIndent: 20,
                )
              : Container(),
          (type == 0)
              ? const Text(
                  "今天的運動計劃\n做起來是否會很疲憊呢？",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              : Container(),
          (type == 0)
              ? const SizedBox(
                  height: 10,
                )
              : Container(),
          (type == 0)
              ? RatingScoreBar().getTiredScoreBar(onTiredScoreUpdate, type)
              : Container(),
          // Meditation-specific questions:
          (type == 0)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          (type == 0)
              ? Container()
              : const Divider(
                  thickness: 1.5,
                  indent: 20,
                  endIndent: 20,
                ),
          (type == 0)
              ? Container()
              : const Text(
                  "最近狀況調查",
                  style: TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
          (type == 0)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          (type == 0)
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "最近是否有憂慮、失眠、\n或是壓力大的情況？",
                            style: TextStyle(
                                color: ColorSet.textColor, fontSize: 18),
                          ),
                          RoundCheckBox(
                            isChecked: isAnxious,
                            borderColor: ColorSet.borderColor,
                            uncheckedColor: ColorSet.backgroundColor,
                            checkedColor: ColorSet.buttonColor,
                            size: 30,
                            onTap: (selected) {
                              setState(() {
                                isAnxious = selected!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "最近是否有一個短期目標需要衝刺？",
                            style: TextStyle(
                                color: ColorSet.textColor, fontSize: 18),
                          ),
                          RoundCheckBox(
                            isChecked: haveToSprint,
                            borderColor: ColorSet.borderColor,
                            uncheckedColor: ColorSet.backgroundColor,
                            checkedColor: ColorSet.buttonColor,
                            size: 30,
                            onTap: (selected) {
                              setState(() {
                                haveToSprint = selected!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "最近是否感到情感上的滿足？",
                            style: TextStyle(
                                color: ColorSet.textColor, fontSize: 18),
                          ),
                          RoundCheckBox(
                            isChecked: isSatisfied,
                            borderColor: ColorSet.borderColor,
                            uncheckedColor: ColorSet.backgroundColor,
                            checkedColor: ColorSet.buttonColor,
                            size: 30,
                            onTap: (selected) {
                              setState(() {
                                isSatisfied = selected!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: ColorSet.backgroundColor,
                shadowColor: ColorSet.borderColor,
                //elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (type == 0) {
                  // 運動
                  feedbackData.add(satisfiedScore.toInt());
                  feedbackData.add(tiredScore.toInt());
                  debugPrint("Exercise feedbackData: $feedbackData");

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (Route<dynamic> route) => false);
                  var type = PlanDB.toPlanType("workout");
                  if (type != null) {
                    UserDB.updateWorkoutFeedback(type, feedbackData);
                  }
                  await PlanAlgo.execute();
                } else {
                  // 冥想
                  feedbackData.add(satisfiedScore.toInt());
                  // True = 1, false = 0
                  feedbackData.add((isAnxious) ? 1 : 0);
                  feedbackData.add((haveToSprint) ? 1 : 0);
                  feedbackData.add((isSatisfied) ? 1 : 0);
                  debugPrint("Meditation feedbackData: $feedbackData");

                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (Route<dynamic> route) => false);
                  var type = PlanDB.toPlanType("meditation");
                  if (type != null) {
                    UserDB.updateMeditationFeedback(type, feedbackData);
                  }
                  await PlanAlgo.execute();
                }
                //Navigator.pop(context);
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]));
  }
}
