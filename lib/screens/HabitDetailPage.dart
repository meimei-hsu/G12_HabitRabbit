import 'dart:async';
import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:g12/services/Database.dart';
import 'package:g12/services/PlanAlgo.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map arguments;

  const ExerciseDetailPage({super.key, required this.arguments});

  @override
  ExerciseDetailPageState createState() => ExerciseDetailPageState();
}

class ExerciseDetailPageState extends State<ExerciseDetailPage> {
  DateTime? day = Calendar.today();
  bool isBefore = false;
  bool isAfter = false;
  bool isToday = true;

  String? workoutPlan;
  int? workoutProgress;

  bool isFetchingData = false;

  List<Widget> _getSportList(List content) {
    int length = content.length;

    // Generate the titles
    List title = [for (int i = 1; i <= length - 2; i++) "Round $i"];
    title.insert(0, "Warm up");
    title.insert(length - 1, "Cool down");

    List<Widget> expansionTitleList = [];
    for (int i = 0; i < length; i++) {
      List<ListTile> itemList = [
        for (int j = 0; j < content[i].length; j++)
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            title: Text(
              '${content[i][j]}',
              style: const TextStyle(color: Color(0xff4b4370), fontSize: 18),
            ),
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(7.5),
                //TODO: Change to video name
                child: Image.asset("assets/images/testPic.gif")),
            onTap: () {
              Navigator.pushNamed(context, '/video',
                  arguments: {'item': content[i][j]});
            },
            visualDensity: const VisualDensity(vertical: 2),
          )
      ];

      Radius r = const Radius.circular(20);
      BorderRadius? borderRadius;

      if (i == 0) {
        //borderRadius = BorderRadius.only(topLeft: r, topRight: r);
        borderRadius = null;
      } else if (i == length - 1) {
        borderRadius = BorderRadius.only(bottomLeft: r, bottomRight: r);
      } else {
        borderRadius = null;
      }

      expansionTitleList.add(ExpansionTile(
        title: Text(
          '${title[i]}',
          style: const TextStyle(
              color: Color(0xff4b4370),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        children: itemList,
      ));
    }
    return expansionTitleList;
  }

  @override
  void initState() {
    super.initState();

    day = widget.arguments["day"];
    isBefore = widget.arguments["isBefore"];
    isAfter = widget.arguments["isAfter"];
    isToday = widget.arguments["isToday"];

    workoutPlan = widget.arguments["workoutPlan"];
    workoutProgress = widget.arguments["percentage"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffdfdf5),
        appBar: AppBar(
          backgroundColor: const Color(0xfffdfdf5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xff4b4370)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '運動計畫',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(0xff4b4370),
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          actions: (workoutProgress! < 100 && !isBefore)
              ? [
                  PopupMenuButton(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.35,
                    ),
                    offset: const Offset(0, 50),
                    icon: const Icon(Icons.more_vert_outlined,
                        color: Color(0xff4b4370)),
                    color: const Color(0xfffdfdf5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    tooltip: "功能清單",
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_calendar_outlined,
                                color: Color(0xff4b4370)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "修改日期",
                              style: TextStyle(color: Color(0xff4b4370)),
                            )
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cached, color: Color(0xff4b4370)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "重新計畫",
                              style: TextStyle(color: Color(0xff4b4370)),
                            )
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline,
                                color: Colors.deepOrangeAccent),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "刪除計畫",
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            )
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 1) {
                        if (!isAfter && day?.weekday == 6) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.noHeader,
                            width: MediaQuery.of(context).size.width * 0.9,
                            buttonsBorderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            dialogBackgroundColor: const Color(0xfffdfdf5),
                            dismissOnTouchOutside: true,
                            dismissOnBackKeyPress: true,
                            headerAnimationLoop: false,
                            animType: AnimType.bottomSlide,
                            body: const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "無法修改:(",
                                    style: TextStyle(
                                        color: Color(0xfff6cdb7),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "今天已經星期六囉~\n無法再將計畫換到別天了！",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            btnOkText: '好吧',
                            btnOkColor: const Color(0xfff6cdb7),
                            buttonsTextStyle: const TextStyle(
                                color: Color(0xff4b4370),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            btnOkOnPress: () {},
                          ).show();
                        } else if (isAfter && day?.weekday == 6) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.noHeader,
                            width: MediaQuery.of(context).size.width * 0.9,
                            buttonsBorderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            dialogBackgroundColor: const Color(0xfffdfdf5),
                            dismissOnTouchOutside: true,
                            dismissOnBackKeyPress: true,
                            headerAnimationLoop: false,
                            animType: AnimType.bottomSlide,
                            body: const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "無法修改:(",
                                    style: TextStyle(
                                        color: Color(0xfff6cdb7),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "星期六的計畫無法換到別天噢！",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            btnOkText: '好吧',
                            btnOkColor: const Color(0xfff6cdb7),
                            buttonsTextStyle: const TextStyle(
                                color: Color(0xff4b4370),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                              ),
                              backgroundColor: const Color(0xfffdeed9),
                              context: context,
                              builder: (context) {
                                return ChangeDayBottomSheet(arguments: {
                                  "day": day,
                                  "isToday": isToday,
                                  "type": 0
                                });
                              });
                        }
                      } else if (value == 2) {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                width: MediaQuery.of(context).size.width * 0.9,
                                buttonsBorderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                dialogBackgroundColor: const Color(0xfffdfdf5),
                                dismissOnTouchOutside: true,
                                dismissOnBackKeyPress: true,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                body: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "確定要重新生成${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的運動計畫嗎？",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Color(0xff4b4370),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                btnOkText: '確定',
                                btnOkColor: const Color(0xfff6cdb7),
                                buttonsTextStyle: const TextStyle(
                                    color: Color(0xff4b4370),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                btnOkOnPress: () {
                                  PlanAlgo.regenerate(day!);
                                  setState(() {
                                    isFetchingData = true;
                                  });
                                  Timer(const Duration(seconds: 5), () async {
                                    var plan = await PlanDB.getThisWeekByName();
                                    var progress =
                                        await DurationDB.getWeekProgress();
                                    setState(() {
                                      workoutPlan = plan?[Calendar.toKey(day!)];
                                      workoutProgress =
                                          progress?[Calendar.toKey(day!)];
                                      isFetchingData = false;
                                    });
                                  });
                                },
                                btnCancelText: '取消',
                                btnCancelColor: const Color(0xfffdfdf5),
                                btnCancelOnPress: () {})
                            .show();
                      } else {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                width: MediaQuery.of(context).size.width * 0.9,
                                buttonsBorderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                dialogBackgroundColor: const Color(0xfffdfdf5),
                                dismissOnTouchOutside: true,
                                dismissOnBackKeyPress: true,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                body: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "確定要刪除${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的運動計畫嗎？",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Color(0xff4b4370),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                btnOkText: '確定',
                                btnOkColor: const Color(0xfff6cdb7),
                                buttonsTextStyle: const TextStyle(
                                    color: Color(0xff4b4370),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                btnOkOnPress: () async {
                                  await PlanDB.delete(Calendar.toKey(day!));
                                  Navigator.pushNamed(context, "/");
                                },
                                btnCancelText: '取消',
                                btnCancelColor: const Color(0xfffdfdf5),
                                btnCancelOnPress: () {})
                            .show();
                      }
                    },
                  ),
                ]
              : [],
        ),
        body: (isFetchingData)
            ? Center(
                child: Container(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    decoration: BoxDecoration(
                        color: const Color(0xFFfdeed9),
                        border: Border.all(color: const Color(0xFFfdeed9)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingAnimationWidget.horizontalRotatingDots(
                          color: const Color(0xff4b3d70),
                          size: 100,
                        ),
                        const Text(
                          "重新載入計畫中...",
                          style: TextStyle(
                            color: Color(0xff4b3d70),
                          ),
                        )
                      ],
                    )))
            : SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(7.5),
                          child:
                              Image.asset("assets/images/personality_SGF.png")),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      decoration: BoxDecoration(
                          color: const Color(0xfffdeed9),
                          border: Border.all(color: const Color(0xffffeed9)),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: ExercisePlanDetailItem(
                        percentage: workoutProgress!,
                        workoutPlan: workoutPlan!.split(", "),
                      ),
                    ),
                    /*const SizedBox(
                height: 10,
              ),*/
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ListView(
                            children:
                                _getSportList(PlanDB.toList(workoutPlan!)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded,
                                color: Color(0xff4b4370)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (isToday)
                                  ? const Color(0xfff6cdb7)
                                  : const Color(0xffd4d6fc),
                              shadowColor: const Color(0xfffdfdf5),
                              minimumSize: const Size(0, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (isToday)
                                ? () {
                                    int currentIndex =
                                        widget.arguments['currentIndex'];
                                    print("Current Index: $currentIndex");
                                    List items = workoutPlan!.split(", ");
                                    for (int i = 0; i < items.length; i++) {
                                      if (i <= 2) {
                                        items[i] = "暖身：${items[i]}";
                                      } else if (i >= items.length - 2) {
                                        items[i] = "伸展：${items[i]}";
                                      } else {
                                        items[i] = "運動：${items[i]}";
                                      }
                                    }
                                    Navigator.pushNamed(context, '/countdown',
                                        arguments: {
                                          'type': 'exercise',
                                          'totalExerciseItemLength':
                                              items.length,
                                          'exerciseTime': items
                                                  .sublist(currentIndex)
                                                  .length *
                                              6, // should be 60s
                                          'exerciseItem':
                                              items.sublist(currentIndex),
                                          'currentIndex': currentIndex
                                        });
                                  }
                                : null,
                            label: const Text(
                              "開始運動",
                              style: TextStyle(
                                  color: Color(0xff4b4370),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ));
  }
}

class MeditationDetailPage extends StatefulWidget {
  final Map arguments;

  const MeditationDetailPage({super.key, required this.arguments});

  @override
  MeditationDetailPageState createState() => MeditationDetailPageState();
}

class MeditationDetailPageState extends State<MeditationDetailPage> {
  DateTime? day = Calendar.today();
  bool isBefore = false;
  bool isAfter = false;
  bool isToday = true;

  String? meditationPlan;
  int? meditationProgress;

  bool isFetchingData = false;

  @override
  void initState() {
    super.initState();

    day = widget.arguments["day"];
    isBefore = widget.arguments["isBefore"];
    isAfter = widget.arguments["isAfter"];
    isToday = widget.arguments["isToday"];

    meditationPlan = widget.arguments["meditationPlan"];
    meditationProgress = widget.arguments["percentage"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffdfdf5),
        appBar: AppBar(
          backgroundColor: const Color(0xfffdfdf5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xff4b4370)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '冥想計畫',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(0xff4b4370),
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          actions: (meditationProgress! < 100 && !isBefore)
              ? [
                  PopupMenuButton(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.35,
                    ),
                    offset: const Offset(0, 50),
                    icon: const Icon(Icons.more_vert_outlined,
                        color: Color(0xff4b4370)),
                    color: const Color(0xfffdfdf5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    tooltip: "功能清單",
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_calendar_outlined,
                                color: Color(0xff4b4370)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "修改日期",
                              style: TextStyle(color: Color(0xff4b4370)),
                            )
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cached, color: Color(0xff4b4370)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "重新計畫",
                              style: TextStyle(color: Color(0xff4b4370)),
                            )
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline,
                                color: Colors.deepOrangeAccent),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "刪除計畫",
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            )
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 1) {
                        if (!isAfter && day?.weekday == 6) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.noHeader,
                            width: MediaQuery.of(context).size.width * 0.9,
                            buttonsBorderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            dialogBackgroundColor: const Color(0xfffdfdf5),
                            dismissOnTouchOutside: true,
                            dismissOnBackKeyPress: true,
                            headerAnimationLoop: false,
                            animType: AnimType.bottomSlide,
                            body: const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "無法修改:(",
                                    style: TextStyle(
                                        color: Color(0xfff6cdb7),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "今天已經星期六囉~\n無法再將計畫換到別天了！",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            btnOkText: '好吧',
                            btnOkColor: const Color(0xfff6cdb7),
                            buttonsTextStyle: const TextStyle(
                                color: Color(0xff4b4370),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            btnOkOnPress: () {},
                          ).show();
                        } else if (isAfter && day?.weekday == 6) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.noHeader,
                            width: MediaQuery.of(context).size.width * 0.9,
                            buttonsBorderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            dialogBackgroundColor: const Color(0xfffdfdf5),
                            dismissOnTouchOutside: true,
                            dismissOnBackKeyPress: true,
                            headerAnimationLoop: false,
                            animType: AnimType.bottomSlide,
                            body: const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "無法修改:(",
                                    style: TextStyle(
                                        color: Color(0xfff6cdb7),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "星期六的計畫無法換到別天噢！",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            btnOkText: '好吧',
                            btnOkColor: const Color(0xfff6cdb7),
                            buttonsTextStyle: const TextStyle(
                                color: Color(0xff4b4370),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                              ),
                              backgroundColor: const Color(0xfffdeed9),
                              context: context,
                              builder: (context) {
                                return ChangeDayBottomSheet(arguments: {
                                  "day": day,
                                  "isToday": isToday,
                                  "type": 1
                                });
                              });
                        }
                      } else if (value == 2) {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                width: MediaQuery.of(context).size.width * 0.9,
                                buttonsBorderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                dialogBackgroundColor: const Color(0xfffdfdf5),
                                dismissOnTouchOutside: true,
                                dismissOnBackKeyPress: true,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                body: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "確定要重新生成${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的冥想計畫嗎？",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Color(0xff4b4370),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                btnOkText: '確定',
                                btnOkColor: const Color(0xfff6cdb7),
                                buttonsTextStyle: const TextStyle(
                                    color: Color(0xff4b4370),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                btnOkOnPress: () {
                                  MeditationPlanAlgo.regenerate(day!);
                                  setState(() {
                                    isFetchingData = true;
                                  });
                                  Timer(const Duration(seconds: 5), () async {
                                    var plan = await MeditationPlanDB
                                        .getThisWeekByName();
                                    var progress = await MeditationDurationDB
                                        .getWeekProgress();
                                    setState(() {
                                      meditationPlan =
                                          plan?[Calendar.toKey(day!)];
                                      meditationProgress =
                                          progress?[Calendar.toKey(day!)];
                                      isFetchingData = false;
                                    });
                                  });
                                },
                                btnCancelText: '取消',
                                btnCancelColor: const Color(0xfffdfdf5),
                                btnCancelOnPress: () {})
                            .show();
                      } else {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                width: MediaQuery.of(context).size.width * 0.9,
                                buttonsBorderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                dialogBackgroundColor: const Color(0xfffdfdf5),
                                dismissOnTouchOutside: true,
                                dismissOnBackKeyPress: true,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                body: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "確定要刪除${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的冥想計畫嗎？",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Color(0xfff6cdb7),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                btnOkText: '確定',
                                btnOkColor: const Color(0xfff6cdb7),
                                buttonsTextStyle: const TextStyle(
                                    color: Color(0xff4b4370),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                btnOkOnPress: () async {
                                  await MeditationPlanDB.delete(
                                      Calendar.toKey(day!));
                                  Navigator.pushNamed(context, "/");
                                },
                                btnCancelText: '取消',
                                btnCancelColor: const Color(0xfffdfdf5),
                                btnCancelOnPress: () {})
                            .show();
                      }
                    },
                  ),
                ]
              : [],
        ),
        body: (isFetchingData)
            ? Center(
                child: Container(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    decoration: BoxDecoration(
                        color: const Color(0xFFfdeed9),
                        border: Border.all(color: const Color(0xFFfdeed9)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingAnimationWidget.horizontalRotatingDots(
                          color: const Color(0xff4b3d70),
                          size: 100,
                        ),
                        const Text(
                          "重新載入計畫中...",
                          style: TextStyle(
                            color: Color(0xff4b3d70),
                          ),
                        )
                      ],
                    )))
            : SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(7.5),
                          child:
                              Image.asset("assets/images/personality_NGC.png")),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, left: 20),
                      decoration: BoxDecoration(
                          color: const Color(0xfffdeed9),
                          border: Border.all(color: const Color(0xffffeed9)),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: MeditationPlanDetailItem(
                        percentage: meditationProgress!,
                        meditationPlan: meditationPlan!.split(", "),
                      ),
                    ),
                    /*const SizedBox(
                height: 10,
              ),*/
                    Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 10),
                        child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: Column(
                              children: [
                                Image.asset("assets/videos/v3.gif"),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "感覺這裡可以說明一下這個冥想項目能幹嘛，e.g. 放鬆什麼或是能助眠、能集中注意力之類的",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            )),
                      ),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded,
                                color: Color(0xff4b4370)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (isToday)
                                  ? const Color(0xfff6cdb7)
                                  : const Color(0xffd4d6fc),
                              shadowColor: const Color(0xfffdfdf5),
                              minimumSize: const Size(0, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (isToday)
                                ? () {
                                    Navigator.pushNamed(context, '/countdown',
                                        arguments: {
                                          'type': 'meditation',
                                          'meditationPlan':
                                              meditationPlan!.split(", ")[0]
                                        });
                                  }
                                : null,
                            label: const Text(
                              "開始冥想",
                              style: TextStyle(
                                  color: Color(0xff4b4370),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ));
  }
}

// Exercise Plan Detail
class ExercisePlanDetailItem extends StatelessWidget {
  const ExercisePlanDetailItem({
    super.key,
    required this.percentage,
    required this.workoutPlan,
  });

  final int percentage;
  final List workoutPlan;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
            const ListTile(
              title: Text(
                "運動細節",
                style: TextStyle(
                    color: Color(0xff4b4370),
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: percentage.toDouble() / 100,
                    center: Text(
                      "$percentage %",
                      style: const TextStyle(
                          color: Color(0xff4b4370),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: const Color(0xff483d70),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.timer_outlined,
                            color: Color(0xff4b4370),
                          ),
                          title: Text(
                            "${workoutPlan.length * 6} 秒運動",
                            style: const TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 21.0),
                          ),
                          subtitle: const Text("TEXT"), // TODO: content?
                          visualDensity: const VisualDensity(vertical: -4),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.accessibility_new_outlined,
                            color: Color(0xff4b4370),
                          ),
                          title: Text(
                            "${workoutPlan.length} 個項目",
                            style: const TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 21.0),
                          ),
                          subtitle: const Text("TEXT"), // TODO: content?
                          visualDensity: const VisualDensity(vertical: -4),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
          ],
        ));
  }
}

// Meditation Plan Detail
class MeditationPlanDetailItem extends StatelessWidget {
  const MeditationPlanDetailItem({
    super.key,
    required this.percentage,
    required this.meditationPlan,
  });

  final int percentage;
  final List meditationPlan;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
            const ListTile(
              title: Text(
                "冥想細節",
                style: TextStyle(
                    color: Color(0xff4b4370),
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 10.0,
                    animation: true,
                    percent: percentage.toDouble() / 100,
                    center: Text(
                      "$percentage %",
                      style: const TextStyle(
                          color: Color(0xff4b4370),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: const Color(0xff483d70),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.timer_outlined,
                            color: Color(0xff4b4370),
                          ),
                          title: Text(
                            "${meditationPlan.length * 30} 分冥想", // TODO: 冥想時間？
                            style: const TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 21.0),
                          ),
                          subtitle: const Text("TEXT"), // TODO: content?
                          visualDensity: const VisualDensity(vertical: -4),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.accessibility_new_outlined,
                            color: Color(0xff4b4370),
                          ),
                          title: Text(
                            "${meditationPlan[0]}", // TODO: 名稱對應中文
                            style: const TextStyle(
                                color: Color(0xff4b4370),
                                fontWeight: FontWeight.bold,
                                fontSize: 21.0),
                          ),
                          subtitle: const Text("TEXT"), // TODO: content?
                          visualDensity: const VisualDensity(vertical: -4),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
          ],
        ));
  }
}

// TODO: need to TEST
// 修改計畫日
class ChangeDayBottomSheet extends StatefulWidget {
  final Map arguments;

  const ChangeDayBottomSheet({super.key, required this.arguments});

  @override
  ChangeDayBottomSheetState createState() => ChangeDayBottomSheetState();
}

class ChangeDayBottomSheetState extends State<ChangeDayBottomSheet> {
  late DateTime day;
  late bool isToday;
  late int type;

  late DateTime today;

  String changedDayWeekday = "";
  DateTime changedDayDate = DateTime.now();

  @override
  void initState() {
    day = getDateOnly(widget.arguments['day']);
    isToday = widget.arguments['isToday'];
    type = widget.arguments['type'];

    today = getDateOnly(Calendar.today());

    super.initState();
  }

  DateTime getDateOnly(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  List<Widget> _getAllowedDayList() {
    List<OutlinedButton> allowedDayList = [];
    List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];

    OutlinedButton getDayBtn(int i) {
      OutlinedButton dayBtn = OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: const BorderSide(
            color: Color(0xff0d3b66),
          ),
          backgroundColor: (changedDayWeekday == weekdayNameList[i])
              ? const Color(0xffffa493)
              : Colors.white70,
        ),
        onPressed: () {
          setState(() {
            changedDayWeekday = weekdayNameList[i];
            changedDayDate = day
                .add(Duration(days: (day.weekday == 7) ? 1 : i - day.weekday));
          });
        },
        child: Text(
          weekdayNameList[i],
          style: const TextStyle(
            color: Color(0xff0d3b66),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return dayBtn;
    }

    if (day.weekday == 7) {
      for (int i = 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
      }
    } else if (isToday) {
      for (int i = day.weekday + 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
      }
    } else {
      for (int i = day.weekday + 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
      }
      for (int i = day.weekday - 1; i >= 0; i--) {
        if (today.weekday != 7) {
          if (i >= today.weekday) {
            allowedDayList.insert(0, getDayBtn(i));
          }
        } else {
          allowedDayList.insert(0, getDayBtn(i));
        }
      }
    }
    return allowedDayList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "修改${(isToday) ? "今天" : " ${day.month} / ${day.day} "}的${(type == 0) ? "運動" : "冥想"}計畫到別天",
              style: const TextStyle(
                  color: Color(0xff4b4370),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Color(0xff4b4370),
              ),
              // FIXME: setting border doesn't work
              style: IconButton.styleFrom(
                shape: const CircleBorder(
                    side: BorderSide(color: Color(0xff4b4370))),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Text(
              "你要將${(isToday) ? "今天" : " ${day.month} / ${day.day} "}的${(type == 0) ? "運動" : "冥想"}計畫換到哪天呢？"),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
            width: double.maxFinite,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: _getAllowedDayList()),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: const Color(0xfff6cdb7),
                shadowColor: Colors.transparent,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                // FIXME: 如果修改天數，換到已經有計畫的日子怎麼辦? (現在是直接蓋掉原本的)
                DateTime originalDate = day;
                (type == 0)
                    ? await PlanDB.updateDate(originalDate, changedDayDate)
                    : await MeditationPlanDB.updateDate(
                        originalDate, changedDayDate);
                print(
                    "Change $day's ${(type == 0) ? "workout plan" : "meditation plan"} to $changedDayDate 星期$changedDayWeekday.");
                if (!mounted) return;
                Navigator.pop(context);
                //Navigator.pushNamed(context, "/");
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: Color(0xff4b4370),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]));
  }
}
