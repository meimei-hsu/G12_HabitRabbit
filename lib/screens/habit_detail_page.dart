import 'dart:async';
import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:g12/screens/page_material.dart';

import 'package:g12/services/database.dart';
import 'package:g12/services/plan_algo.dart';

import '../services/page_data.dart';

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({super.key});

  @override
  ExerciseDetailPageState createState() => ExerciseDetailPageState();
}

class ExerciseDetailPageState extends State<ExerciseDetailPage> {
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
        iconColor: ColorSet.buttonColor,
        collapsedIconColor: ColorSet.iconColor,
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorSet.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: ColorSet.iconColor),
            tooltip: "返回首頁",
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
          actions: (HomeData.workoutProgress! < 100 && !HomeData.isBefore)
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
                        if (!HomeData.isAfter &&
                            HomeData.selectedDay?.weekday == 6) {
                          InformDialog()
                              .get(context, "無法修改:(", "今天已經星期六囉~\n無法再將計畫換到別天了！")
                              .show();
                        } else if (HomeData.isAfter &&
                            HomeData.selectedDay?.weekday == 6) {
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
                              backgroundColor: ColorSet.bottomBarColor,
                              context: context,
                              builder: (context) {
                                return ChangeDayBottomSheet(arguments: {
                                  "day": HomeData.selectedDay,
                                  "isToday": HomeData.isToday,
                                  "type": 0
                                });
                              });
                        }
                      } else if (value == 2) {
                        btnOkOnPress() {
                          PlanAlgo.regenerateWorkout(HomeData.selectedDay!);
                          setState(() {
                            HomeData.isFetchingData = true;
                          });
                          Timer(const Duration(seconds: 5), () async {
                            setState(() {
                              HomeData.isFetchingData = false;
                            });
                            if (!mounted) return;
                            InformDialog()
                                .get(context, "完成重新生成:)",
                                    "${(HomeData.isToday) ? "今天" : " ${HomeData.selectedDay?.month} / ${HomeData.selectedDay?.day} "}的運動計畫\n已經重新生成囉！")
                                .show();
                          });
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要重新生成\n${(HomeData.isToday) ? "今天" : " ${HomeData.selectedDay?.month} / ${HomeData.selectedDay?.day} "}的運動計畫嗎？",
                                btnOkOnPress)
                            .show();
                      } else {
                        btnOkOnPress() async {
                          await PlanDB.delete("workout",
                              Calendar.dateToString(HomeData.selectedDay!));
                          if (!mounted) return;
                          Navigator.pushNamed(context, "/");
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要刪除\n${(HomeData.isToday) ? "今天" : " ${HomeData.selectedDay?.month} / ${HomeData.selectedDay?.day} "}的運動計畫嗎？",
                                btnOkOnPress)
                            .show();
                      }
                    },
                  ),
                ]
              : [],
        ),
        body: (HomeData.isFetchingData)
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
                      child: const ExercisePlanDetailItem(),
                    ),
                    const Divider(
                      color: ColorSet.borderColor,
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ListView(
                            children: _getSportList(
                                PlanDB.toWorkoutList(HomeData.workoutPlan!)),
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
                              backgroundColor: (HomeData.isToday &&
                                      HomeData.workoutProgress! < 100)
                                  ? ColorSet.exerciseColor
                                  : ColorSet.chartLineColor,
                              shadowColor: ColorSet.backgroundColor,
                              elevation: 0,
                              minimumSize: const Size(0, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (HomeData.isToday)
                                ? (HomeData.workoutProgress! < 100)
                                    ? () async {
                                        int currentIndex =
                                            HomeData.currentIndex;
                                        List items =
                                            HomeData.workoutPlan!.split(", ");
                                        for (int i = 0; i < items.length; i++) {
                                          if (i <= 2) {
                                            items[i] = "暖身：${items[i]}";
                                          } else if (i >= items.length - 2) {
                                            items[i] = "伸展：${items[i]}";
                                          } else {
                                            items[i] = "運動：${items[i]}";
                                          }
                                        }

                                        if (await ClockDB.getFromDate(
                                                "workout", DateTime.now()) ==
                                            null) {
                                          ClockDB.updateForecast("workout");
                                        }

                                        if (!mounted) return;
                                        Navigator.pushNamed(
                                            context, '/countdown',
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
                                    : () {
                                        InformDialog()
                                            .get(
                                                context, "Good:)", "已完成今日冥想計畫！")
                                            .show();
                                      }
                                : () {
                                    InformDialog()
                                        .get(context, "錯誤:(", "無法做非今日的冥想計畫噢！")
                                        .show();
                                  },
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
  const MeditationDetailPage({super.key});

  @override
  MeditationDetailPageState createState() => MeditationDetailPageState();
}

class MeditationDetailPageState extends State<MeditationDetailPage> {
  String getDescription() {
    switch (HomeData.meditationType) {
      case "正念冥想":
        return "正念冥想益處包括對生活滿意度增加、降低焦慮、提升創意思考、學習成績提升、增加免疫力、提升睡眠品質等。";
      case "工作冥想":
        return "工作冥想益處包括生產力增加、增添自信、具備人生目標、提升專注力等。";
      case "慈心冥想":
        return "慈心冥想益處包括保持正向積極、維持友好關係、減緩焦慮、增強自我激勵等。";
    }
    return "";
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
            tooltip: "返回首頁",
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
          actions: (HomeData.meditationProgress! < 100 && !HomeData.isBefore)
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
                        if (!HomeData.isAfter &&
                            HomeData.selectedDay?.weekday == 6) {
                          InformDialog()
                              .get(context, "無法修改:(", "今天已經星期六囉~\n無法再將計畫換到別天了！")
                              .show();
                        } else if (HomeData.isAfter &&
                            HomeData.selectedDay?.weekday == 6) {
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
                              backgroundColor: ColorSet.bottomBarColor,
                              context: context,
                              builder: (context) {
                                return ChangeDayBottomSheet(arguments: {
                                  "day": HomeData.selectedDay,
                                  "isToday": HomeData.isToday,
                                  "type": 1
                                });
                              });
                        }
                      } else if (value == 2) {
                        btnOkOnPress() {
                          PlanAlgo.regenerateMeditation(HomeData.selectedDay!);
                          setState(() {
                            HomeData.isFetchingData = true;
                          });
                          Timer(const Duration(seconds: 5), () async {
                            setState(() {
                              HomeData.isFetchingData = false;
                            });
                            if (!mounted) return;
                            InformDialog()
                                .get(context, "完成重新生成:)",
                                    "${(HomeData.isToday) ? "今天" : " ${HomeData.selectedDay?.month} / ${HomeData.selectedDay?.day} "}的冥想計畫\n已經重新生成囉！")
                                .show();
                          });
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要重新生成\n${(HomeData.isToday) ? "今天" : " ${HomeData.selectedDay?.month} / ${HomeData.selectedDay?.day} "}的冥想計畫嗎？",
                                btnOkOnPress)
                            .show();
                      } else {
                        btnOkOnPress() async {
                          await PlanDB.delete("meditation",
                              Calendar.dateToString(HomeData.selectedDay!));
                          if (!mounted) return;
                          Navigator.pushNamed(context, "/");
                        }

                        ConfirmDialog()
                            .get(
                                context,
                                "你確定嗎？",
                                "確定要刪除\n${(HomeData.isToday) ? "今天" : " ${HomeData.selectedDay?.month} / ${HomeData.selectedDay?.day} "}的冥想計畫嗎？",
                                btnOkOnPress)
                            .show();
                      }
                    },
                  ),
                ]
              : [],
        ),
        body: (HomeData.isFetchingData)
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
                      child: const MeditationPlanDetailItem(),
                    ),
                    const Divider(
                      color: ColorSet.borderColor,
                      thickness: 0.5,
                      indent: 20,
                      endIndent: 20,
                    ),
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
                                // FIXME: 冥想Detail畫面看起來有點空
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  getDescription(),
                                  style: const TextStyle(fontSize: 16),
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
                                color: ColorSet.iconColor),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (HomeData.isToday &&
                                      HomeData.meditationProgress! < 100)
                                  ? ColorSet.meditationColor
                                  : ColorSet.chartLineColor,
                              shadowColor: ColorSet.backgroundColor,
                              elevation: 0,
                              minimumSize: const Size(0, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (HomeData.isToday)
                                ? (HomeData.meditationProgress! < 100)
                                    ? () async {
                                        if (await ClockDB.getFromDate(
                                                "meditation", DateTime.now()) ==
                                            null) {
                                          ClockDB.updateForecast("meditation");
                                        }

                                        if (!mounted) return;
                                        Navigator.pushNamed(
                                            context, '/countdown',
                                            arguments: {
                                              'type': 'meditation',
                                              'meditationPlan':
                                                  HomeData.meditationPlan,
                                              'meditationTime':
                                                  HomeData.meditationDuration,
                                            });
                                      }
                                    : () {
                                        InformDialog()
                                            .get(
                                                context, "Good:)", "已完成今日冥想計畫！")
                                            .show();
                                      }
                                : () {
                                    InformDialog()
                                        .get(context, "錯誤:(", "無法做非今日的冥想計畫噢！")
                                        .show();
                                  },
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
  const ExercisePlanDetailItem({super.key});

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
                    percent: HomeData.workoutProgress!.toDouble() / 100,
                    center: Text(
                      "${HomeData.workoutProgress!} %",
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
                            "${HomeData.workoutDuration} 分鐘",
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
                            HomeData.workoutType!,
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
  const MeditationPlanDetailItem({super.key});

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
                    percent: HomeData.meditationProgress!.toDouble() / 100,
                    center: Text(
                      "${HomeData.meditationProgress!} %",
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
                            "${HomeData.meditationDuration} 分鐘",
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
                            HomeData.meditationType!, // TODO: 名稱對應中文
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

  final ScrollController _controller = ScrollController();

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
              ? (type == 0)
                  ? ColorSet.exerciseColor
                  : ColorSet.meditationColor
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
              /*decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 2),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),*/
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorSet.iconColor,
                ),
                tooltip: "關閉",
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
          // FIXME: Add padding between choice and scrollbar
          SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                child: ListView(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    children: _getAllowedDayList()),
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: ColorSet.backgroundColor,
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
                    ? await PlanDB.updateDate(
                        "workout", originalDate, changedDayDate)
                    : await PlanDB.updateDate(
                        "meditation", originalDate, changedDayDate);
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
