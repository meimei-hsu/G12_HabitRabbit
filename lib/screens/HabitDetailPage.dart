import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:g12/services/Database.dart';

class ExerciseDetailPage extends StatefulWidget {
  final Map arguments;

  const ExerciseDetailPage({super.key, required this.arguments});

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffdfdf5),
        appBar: AppBar(
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
          backgroundColor: const Color(0xfffdfdf5),
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.5),
                    child: Image.asset("assets/images/personality_SGF.png")),
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
                  percentage: widget.arguments['percentage'],
                  workoutPlan: widget.arguments['workoutPlan'].split(", "),
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
                          PlanDB.toList(widget.arguments['workoutPlan'])),
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
                        backgroundColor: (widget.arguments['isToday'])
                            ? const Color(0xfff6cdb7)
                            : const Color(0xffd4d6fc),
                        shadowColor: const Color(0xfffdfdf5),
                        minimumSize: const Size(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: widget.arguments['isToday']
                          ? () {
                              print("True");
                              int currentIndex =
                                  widget.arguments['currentIndex'];
                              print("Current Index: $currentIndex");
                              List items =
                                  widget.arguments['workoutPlan'].split(", ");
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
                                    'totalExerciseItemLength': items.length,
                                    'exerciseTime':
                                        items.sublist(currentIndex).length *
                                            6, // should be 60s
                                    'exerciseItem': items.sublist(currentIndex),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfffdfdf5),
        appBar: AppBar(
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
          backgroundColor: const Color(0xfffdfdf5),
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.5),
                    child: Image.asset("assets/images/personality_NGC.png")),
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
                  percentage: widget.arguments['percentage'],
                  meditationPlan:
                      widget.arguments['meditationPlan'].split(", "),
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
                        backgroundColor: (widget.arguments['isToday'])
                            ? const Color(0xfff6cdb7)
                            : const Color(0xffd4d6fc),
                        shadowColor: const Color(0xfffdfdf5),
                        minimumSize: const Size(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: widget.arguments['isToday']
                          ? () {
                              print("True");
                            Navigator.pushNamed(context, '/countdown',
                                arguments: {
                                  'type': 'meditation',
                                  'meditationPlan': widget.arguments['meditationPlan'].split(", ")[0]
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
