import 'dart:async';
import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:g12/screens/page_material.dart';

import 'package:g12/services/database.dart';
import 'package:g12/services/plan_algo.dart';

import '../services/page_data.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map arguments;

  const ExerciseDetailPage({super.key, required this.arguments});

  @override
  ExerciseDetailPageState createState() => ExerciseDetailPageState();
}

class ExerciseDetailPageState extends State<ExerciseDetailPage> {
  DateTime? day = DateTime.now();
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
              style: const TextStyle(color: ColorSet.textColor, fontSize: 20),
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

      /*
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
      */

      expansionTitleList.add(ExpansionTile(
        title: Text(
          '${title[i]}',
          style: const TextStyle(
              color: ColorSet.textColor,
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
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorSet.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: ColorSet.iconColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '運動計畫',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: ColorSet.textColor,
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
                        color: ColorSet.iconColor),
                    color: ColorSet.backgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    tooltip: "功能清單",
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.edit_calendar_outlined,
                                color: ColorSet.iconColor),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "修改日期",
                              style: TextStyle(
                                  color: ColorSet.textColor, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.cached, color: ColorSet.iconColor),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "重新計畫",
                              style: TextStyle(
                                  color: ColorSet.textColor, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.delete_outline,
                                color: Colors.deepOrangeAccent),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "刪除計畫",
                              style: TextStyle(
                                  color: Colors.deepOrangeAccent, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 1) {
                        if (!isAfter && day?.weekday == 6) {
                          InformDialog()
                              .get(context, "無法修改:(", "今天已經星期六囉~\n無法再將計畫換到別天了！")
                              .show();
                        } else if (isAfter && day?.weekday == 6) {
                          InformDialog()
                              .get(context, "無法修改:(", "星期六的計畫無法換到別天噢！")
                              .show();
                        } else {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                              ),
                              backgroundColor: ColorSet.backgroundColor,
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
                        btnOkOnPress() {
                          PlanAlgo.regenerateWorkout(day!);
                          setState(() {
                            isFetchingData = true;
                          });
                          Timer(const Duration(seconds: 5), () async {
                            var date = Calendar.dateToString(day!);
                            setState(() {
                              workoutPlan = HomeData.planList["workout"]?[date];
                              workoutProgress =
                                  HomeData.progressList["workout"]?[date];
                              isFetchingData = false;
                            });
                            if (!mounted) return;
                            InformDialog()
                                .get(context, "完成重新生成:)",
                                    "${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的運動計畫\n已經重新生成囉！")
                                .show();
                          });
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要重新生成\n${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的運動計畫嗎？",
                                btnOkOnPress)
                            .show();
                      } else {
                        btnOkOnPress() async {
                          await PlanDB.delete(
                              "workout", Calendar.dateToString(day!));
                          if (!mounted) return;
                          Navigator.pushNamed(context, "/");
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要刪除\n${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的運動計畫嗎？",
                                btnOkOnPress)
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
                        color: ColorSet.backgroundColor,
                        border: Border.all(color: ColorSet.backgroundColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingAnimationWidget.horizontalRotatingDots(
                          color: ColorSet.textColor,
                          size: 100,
                        ),
                        const Text(
                          "重新載入計畫中...",
                          style: TextStyle(
                            color: ColorSet.textColor,
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
                          color: ColorSet.backgroundColor,
                          border: Border.all(color: ColorSet.backgroundColor),
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
                            children: _getSportList(
                                PlanDB.toWorkoutList(workoutPlan!)),
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
                                color: ColorSet.iconColor),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (isToday)
                                  ? const Color(0xfff6cdb7)
                                  : const Color(0xffd4d6fc),
                              shadowColor: const Color(0xfffdfdf5),
                              elevation: 0,
                              minimumSize: const Size(0, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (isToday)
                                ? () {
                                    int currentIndex =
                                        widget.arguments['currentIndex'];
                                    debugPrint("Current Index: $currentIndex");
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
                                  color: ColorSet.textColor,
                                  fontSize: 24,
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
  DateTime? day = DateTime.now();
  bool isBefore = false;
  bool isAfter = false;
  bool isToday = true;

  String? meditationPlan;
  int? meditationTime;
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
    meditationTime = widget.arguments["meditationTime"];
    meditationProgress = widget.arguments["percentage"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorSet.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: ColorSet.iconColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          title: const Text(
            '冥想計畫',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: ColorSet.textColor,
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
                        color: ColorSet.iconColor),
                    color: ColorSet.backgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    tooltip: "功能清單",
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.edit_calendar_outlined,
                                color: ColorSet.iconColor),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "修改日期",
                              style: TextStyle(
                                  color: ColorSet.textColor, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.cached, color: ColorSet.iconColor),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "重新計畫",
                              style: TextStyle(
                                  color: ColorSet.textColor, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.delete_outline,
                                color: Colors.deepOrangeAccent),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "刪除計畫",
                              style: TextStyle(
                                  color: Colors.deepOrangeAccent, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      if (value == 1) {
                        if (!isAfter && day?.weekday == 6) {
                          InformDialog()
                              .get(context, "無法修改:(", "今天已經星期六囉~\n無法再將計畫換到別天了！")
                              .show();
                        } else if (isAfter && day?.weekday == 6) {
                          InformDialog()
                              .get(context, "無法修改:(", "星期六的計畫無法換到別天噢！")
                              .show();
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
                        btnOkOnPress() {
                          PlanAlgo.regenerateMeditation(day!);
                          setState(() {
                            isFetchingData = true;
                          });
                          Timer(const Duration(seconds: 5), () async {
                            var date = Calendar.dateToString(day!);
                            setState(() {
                              meditationPlan =
                                  HomeData.planList["workout"]?[date];
                              meditationProgress =
                                  HomeData.progressList["workout"]?[date];
                              isFetchingData = false;
                            });
                            if (!mounted) return;
                            InformDialog()
                                .get(context, "完成重新生成:)",
                                    "${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的冥想計畫\n已經重新生成囉！")
                                .show();
                          });
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要重新生成\n${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的冥想計畫嗎？",
                                btnOkOnPress)
                            .show();
                      } else {
                        btnOkOnPress() async {
                          await PlanDB.delete(
                              "meditation", Calendar.dateToString(day!));
                          if (!mounted) return;
                          Navigator.pushNamed(context, "/");
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要刪除\n${(isToday) ? "今天" : " ${day?.month} / ${day?.day} "}的冥想計畫嗎？",
                                btnOkOnPress)
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
                        color: ColorSet.backgroundColor,
                        border: Border.all(color: ColorSet.backgroundColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingAnimationWidget.horizontalRotatingDots(
                          color: ColorSet.textColor,
                          size: 100,
                        ),
                        const Text(
                          "重新載入計畫中...",
                          style: TextStyle(
                            color: ColorSet.textColor,
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
                          color: ColorSet.backgroundColor,
                          border: Border.all(color: ColorSet.backgroundColor),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: MeditationPlanDetailItem(
                        percentage: meditationProgress!,
                        meditationPlan: meditationPlan!,
                        meditationTime: meditationTime!,
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
                          Expanded(child: ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded,
                                color: ColorSet.iconColor),
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
                                          'meditationPlan': meditationPlan,
                                          'meditationTime': meditationTime,
                                        });
                                  }
                                : null,
                            label: const Text(
                              "開始冥想",
                              style: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 24,
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
                    color: ColorSet.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
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
                          color: ColorSet.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: ColorSet.textColor,
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
                            color: ColorSet.iconColor,
                          ),
                          title: Text(
                            "${workoutPlan.length * 6} 秒運動",
                            style: const TextStyle(
                                color: ColorSet.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
                          ),
                          subtitle: const Text("TEXT"), // TODO: content?
                          visualDensity: const VisualDensity(vertical: -4),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.accessibility_new_outlined,
                            color: ColorSet.iconColor,
                          ),
                          title: Text(
                            "${workoutPlan.length} 個項目",
                            style: const TextStyle(
                                color: ColorSet.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
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
    required this.meditationTime,
  });

  final int percentage;
  final String meditationPlan;
  final int meditationTime;

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
                    color: ColorSet.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
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
                          color: ColorSet.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: ColorSet.textColor,
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
                            color: ColorSet.iconColor,
                          ),
                          title: Text(
                            "$meditationTime 分冥想",
                            style: const TextStyle(
                                color: ColorSet.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
                          ),
                          subtitle: const Text("TEXT"), // TODO: content?
                          visualDensity: const VisualDensity(vertical: -4),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.accessibility_new_outlined,
                            color: ColorSet.iconColor,
                          ),
                          title: Text(
                            meditationPlan, // TODO: 名稱對應中文
                            style: const TextStyle(
                                color: ColorSet.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
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

    today = getDateOnly(DateTime.now());

    super.initState();
  }

  DateTime getDateOnly(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  List<Widget> _getAllowedDayList() {
    List<Widget> allowedDayList = [];
    List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];

    OutlinedButton getDayBtn(int i) {
      OutlinedButton dayBtn = OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(
            color: ColorSet.borderColor,
          ),
          backgroundColor: (changedDayWeekday == weekdayNameList[i])
              ? const Color(0xfff6cdb7)
              : ColorSet.backgroundColor,
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
            color: ColorSet.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return dayBtn;
    }

    if (day.weekday == 7) {
      for (int i = 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
        allowedDayList.add(const SizedBox(
          width: 10,
        ));
      }
    } else if (isToday) {
      for (int i = day.weekday + 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
        allowedDayList.add(const SizedBox(
          width: 10,
        ));
      }
    } else {
      for (int i = day.weekday + 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
        allowedDayList.add(const SizedBox(
          width: 10,
        ));
      }
      for (int i = day.weekday - 1; i >= 0; i--) {
        allowedDayList.insert(
            0,
            const SizedBox(
              width: 10,
            ));
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
                  color: ColorSet.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 2),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorSet.iconColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Text(
              "你要將${(isToday) ? "今天" : " ${day.month} / ${day.day} "}的${(type == 0) ? "運動" : "冥想"}計畫換到哪天呢？",
              style: const TextStyle(color: ColorSet.textColor, fontSize: 16)),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: _getAllowedDayList()),
          ),
          const SizedBox(
            height: 15,
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
                    ? await PlanDB.updateDate("workout", originalDate, changedDayDate)
                    : await PlanDB.updateDate("meditation", originalDate, changedDayDate);
                debugPrint(
                    "Change $day's ${(type == 0) ? "workout plan" : "meditation plan"} to $changedDayDate 星期$changedDayWeekday.");
                if (!mounted) return;

                btnOkOnPress() {
                  Navigator.pushNamed(context, "/");
                  debugPrint("Change!!!");
                }

                InformDialog()
                    .get(context, "修改完成:)",
                        "已經將${(isToday) ? "今天" : " ${day.month} / ${day.day} "}的${(type == 0) ? "運動" : "冥想"}計畫\n換到 ${changedDayDate.month} / ${changedDayDate.day} 星期$changedDayWeekday囉！",
                        btnOkOnPress: btnOkOnPress)
                    .show();
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]));
  }
}
