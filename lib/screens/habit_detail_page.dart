import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/services/database.dart';
import 'package:g12/services/page_data.dart';

class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({super.key});

  @override
  ExerciseDetailPageState createState() => ExerciseDetailPageState();
}

class ExerciseDetailPageState extends State<ExerciseDetailPage> {
  List<Widget> _getSportList(List content) {
    List<Widget> expansionTitleList = []; // return value
    Random rand = Random();
    List videos = ["深蹲", "上斜伏地挺身", "反向捲腹", "臀橋", "側弓箭步"];
    if (HomeData.isToday) {
      // Demo用5分鐘影片
      content = [
        videos.sublist(0, 1),
        videos.sublist(1, 4),
        videos.sublist(4, 5),
      ];
    }
    int length = content.length;

    // Generate the titles
    List title = [for (int i = 1; i <= length - 2; i++) "第 $i 回合"];
    title.insert(0, "熱身運動");
    title.insert(length - 1, "緩和運動");

    // Generate item list
    for (int i = 0; i < length; i++) {
      List<ListTile> itemList = [];
      for (int j = 0; j < content[i].length; j++) {
        String vidName =
            (HomeData.isToday) ? content[i][j] : videos[rand.nextInt(5)];
        itemList.add(ListTile(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          title: Text(
            '${content[i][j]}',
            style: const TextStyle(color: ColorSet.textColor, fontSize: 20),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(7.5),
            child: Image.asset("assets/videos/$vidName.gif"),
          ),
          onTap: () {
            _showVideoDialog(context, vidName);
          },
          visualDensity: const VisualDensity(vertical: 2),
        ));
      }

      // Combine titles and items
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
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.5),
                  child: Image.asset(
                    "assets/images/Exercise_2.gif",
                    width: MediaQuery.of(context).size.width * 0.8,
                  )),
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
                      backgroundColor:
                          (HomeData.isToday && HomeData.workoutProgress! < 100)
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
                                /*int currentIndex =
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
                                      }*/

                                int currentIndex = HomeData.currentIndex ~/
                                    (HomeData.workoutDuration / 5);
                                List items = [
                                  "暖身：深蹲",
                                  "運動：上斜伏地挺身",
                                  "運動：反向捲腹",
                                  "運動：臀橋",
                                  "緩和：側弓箭步"
                                ];

                                if (await ClockDB.getFromDate(
                                        "workout", DateTime.now()) ==
                                    null) {
                                  ClockDB.updateForecast("workout");
                                }

                                if (!mounted) return;
                                Navigator.pushNamed(context, '/countdown',
                                    arguments: {
                                      'type': 'exercise',
                                      'totalExerciseItemLength': items.length,
                                      'exerciseTime':
                                          (items.length - currentIndex) *
                                              6, // should be 60s
                                      'exerciseItem':
                                          items.sublist(currentIndex),
                                      'currentIndex': currentIndex
                                    });
                              }
                            : () {
                                InformDialog()
                                    .get(context, "Good:)", "已完成今日運動計畫！")
                                    .show();
                              }
                        : () {
                            ErrorDialog()
                                .get(context, "錯誤:(", "無法做非今日的運動計畫噢！")
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
      ),
    );
  }

  void _showVideoDialog(BuildContext context, String vidName) {
    List? description = {
      "深蹲": ["雙腳站立，與髖部同寬，雙臂伸直在你前面與肩同高。", "彎曲膝蓋，同時向後坐。", "恢復到起始位置，然後重複動作。"],
      "上斜伏地挺身": [
        "從桌子後方踏出一大步，雙手握住邊緣，與肩同寬。",
        "彎曲肘部，呈約90度角，將胸部靠近桌沿。",
        "推起身體，伸直手臂回到起始位置，然後重複動作。"
      ],
      "反向捲腹": [
        "背部貼地，彎曲膝蓋，腳底放在地板上，雙臂伸直並貼在身體兩側的地板上。",
        "慢慢將膝蓋靠近胸部，稍微提高臀部。",
        "放下腿部回到起始位置，然後重複動作。"
      ],
      "臀橋": [
        "背部貼地，彎曲膝蓋，腳底放在地板上，雙臂伸直並貼在身體兩側的地板上。",
        "提起臀部，使身體從膝蓋到胸部呈現一條直線。",
        "保持臀部抬起5秒，放下回到起始位置，然後重複動作。"
      ],
      "側弓箭步": [
        "雙腳並攏，雙手放在臀部。",
        "用右腳邁出一大步，彎曲膝蓋。當你向後邁步回到起始位置時，站起身來。",
        "重複動作，用左腳向前邁步，然後返回起始位置。"
      ],
    }[vidName];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: ColorSet.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/videos/$vidName.gif",
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    vidName,
                    style: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 8),
                  ),
                  const SizedBox(height: 10),
                  if (description == null) ...[
                    const Text(
                      "動作說明編輯中...",
                      style: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ] else ...[
                    for (String desc in description)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '\u2022',
                            style: TextStyle(
                              color: ColorSet.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              desc,
                              textAlign: TextAlign.left,
                              softWrap: true,
                              style: const TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 18,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      )
                  ],
                ],
              ),
            ),
          );
        });
  }
}

class MeditationDetailPage extends StatefulWidget {
  const MeditationDetailPage({super.key});

  @override
  MeditationDetailPageState createState() => MeditationDetailPageState();
}

class MeditationDetailPageState extends State<MeditationDetailPage> {
  String description = {
        "正念冥想": "「正念冥想」的益處包括對生活滿意度增加、降低焦慮、提升創意思考、學習成績提升、增加免疫力、提升睡眠品質等。",
        "工作冥想": "「工作冥想」的益處包括生產力增加、增添自信、具備人生目標、提升專注力等。",
        "慈心冥想": "「慈心冥想」的益處包括保持正向積極、維持友好關係、減緩焦慮、增強自我激勵等。"
      }[HomeData.meditationType] ??
      "";

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
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.5),
                    child: Image.asset(
                      "assets/images/Meditation_2.gif",
                      width: MediaQuery.of(context).size.width * 0.8,
                    )),
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
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "$description\n\n"
                            "今日的冥想主題是「${HomeData.meditationPlan}」，請選擇一個安靜的環境，調整成舒服的坐姿後，跟著語音的引導進行練習。",
                            style: const TextStyle(
                              color: ColorSet.textColor,
                              fontSize: 18,
                              height: 1.5,
                            ),
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
                                  Navigator.pushNamed(context, '/countdown',
                                      arguments: {
                                        'type': 'meditation',
                                        'meditationPlan':
                                            HomeData.meditationPlan,
                                        'meditationTime': 5,
                                        // should be HomeData.meditationDuration,
                                      });
                                }
                              : () {
                                  InformDialog()
                                      .get(context, "Good:)", "已完成今日冥想計畫！")
                                      .show();
                                }
                          : () {
                              ErrorDialog()
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
                          visualDensity: const VisualDensity(vertical: -4),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.accessibility_new_outlined,
                            color: ColorSet.iconColor,
                          ),
                          title: Text(
                            HomeData.meditationType!,
                            style: const TextStyle(
                                color: ColorSet.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
                          ),
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
