import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:g12/screens/page_material.dart';

import 'package:g12/services/database.dart';

int workoutGem = 0;
int meditationGem = 0;
String workoutFragment = "";
String meditationFragment = "";
bool isFetchingData = true;
bool hasContract = false;

class MilestonePage extends StatefulWidget {
  final Map arguments;
  const MilestonePage({super.key, required this.arguments});

  @override
  MilestonePageState createState() => MilestonePageState();
}

class MilestonePageState extends State<MilestonePage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchExistingMilestoneData();
  }

  Future<void> _fetchExistingMilestoneData() async {
    final milestoneData = await MilestoneDB.getMilestone();
    final contractDetails = await ContractDB.getContract();
    if (milestoneData != null) {
      setState(() {
        workoutGem = milestoneData["workoutGem"];
        meditationGem = milestoneData["meditationGem"];
        workoutFragment = milestoneData["workoutFragment"];
        meditationFragment = milestoneData["meditationFragment"];
        if (contractDetails != null) hasContract = true;
        isFetchingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 16.0),
                  child: Row(
                    children: [
                      Text(
                        '${user?.displayName!} 的角色',
                        style: const TextStyle(
                          fontFamily: 'WorkSans',
                          color: ColorSet.textColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      //TODO: 根據等級改變Icon
                      const Icon(
                        Icons.looks_two,
                        color: ColorSet.iconColor,
                        size: 40,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0),
                  child: Text(
                    '請養成規律的運動與冥想習慣蒐集寶物讓我長大吧！',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: ColorSet.textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Expanded(
                  child: isFetchingData ? Container() : const CharacterWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CharacterWidget extends StatelessWidget {
  const CharacterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double workoutPercent = Calculator.calcProgress(workoutFragment).toDouble();
    double meditationPercent =
        Calculator.calcProgress(meditationFragment).toDouble();
    double totalPercent = (workoutGem + meditationGem) / 48 * 100;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: CharacterCardBackgroundClipper(),
            child: Container(
              height: 0.7 * screenHeight,
              width: 0.9 * screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorSet.backgroundColor, ColorSet.backgroundColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.45, -0.85),
          //TODO: 根據等級改變角色
          child: Image.asset(
            'assets/images/Rabbit_2.png',
            height: screenHeight * 0.4,
          ),
        ),
        Align(
          alignment: const Alignment(-0.75, 0.4),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                _showQuizDialog(context);
              },
              backgroundColor: ColorSet.backgroundColor,
              child: const Icon(Icons.quiz, color: ColorSet.iconColor),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(-0.5, 0.4),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                _showGrowDialog(context);
              },
              backgroundColor: ColorSet.backgroundColor,
              child: const Icon(Icons.more_horiz_outlined,
                  color: ColorSet.iconColor),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(-0.25, 0.4),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Level()),
                );
              },
              backgroundColor: ColorSet.backgroundColor,
              child: const Icon(Icons.map, color: ColorSet.iconColor),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.4),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                if (hasContract) {
                  Navigator.pushNamed(context, '/contract/already');
                } else {
                  Navigator.pushNamed(context, '/contract/initial');
                }
              },
              backgroundColor: ColorSet.backgroundColor,
              child: const Icon(Icons.request_quote_outlined,
                  color: ColorSet.iconColor),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(-0.65, 0.55),
          child: Text(
            '本周運動習慣已達成：',
            style: TextStyle(
              fontFamily: 'WorkSans',
              color: ColorSet.textColor,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Align(
            alignment: const Alignment(2, 0.62),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.85,
              animation: true,
              lineHeight: 15.0,
              //TODO: 根據完成度改變 percent
              percent: workoutPercent / 100,
              center: Text(
                "${workoutPercent.round()}%",
                style: const TextStyle(
                  color: ColorSet.backgroundColor,
                  fontSize: 10,
                ),
              ),
              barRadius: const Radius.circular(16),
              backgroundColor: ColorSet.backgroundColor,
              progressColor: ColorSet.textColor,
            ),
          ),
        ),
        const Align(
          alignment: Alignment(-0.65, 0.69),
          child: Text(
            '本周冥想習慣已達成：',
            style: TextStyle(
              fontFamily: 'WorkSans',
              color: ColorSet.textColor,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Align(
            alignment: const Alignment(2, 0.76),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.85,
              animation: true,
              lineHeight: 15.0,
              //TODO: 根據完成度改變 percent
              percent: meditationPercent / 100,
              center: Text(
                "${meditationPercent.round()}%",
                style: const TextStyle(
                  color: ColorSet.backgroundColor,
                  fontSize: 10,
                ),
              ),
              barRadius: const Radius.circular(16),
              backgroundColor: ColorSet.backgroundColor,
              progressColor: ColorSet.textColor,
            ),
          ),
        ),
        const Align(
          alignment: Alignment(-0.65, 0.83),
          child: Text(
            '距離達成所有習慣養成：',
            style: TextStyle(
              fontFamily: 'WorkSans',
              color: ColorSet.textColor,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Align(
            alignment: const Alignment(2, 0.9),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.85,
              animation: true,
              lineHeight: 15.0,
              //TODO: 根據完成度改變 percent
              percent: totalPercent / 100,
              center: Text(
                "${totalPercent.round()}%",
                style: const TextStyle(
                  color: ColorSet.backgroundColor,
                  fontSize: 10,
                ),
              ),
              barRadius: const Radius.circular(16),
              backgroundColor: ColorSet.backgroundColor,
              progressColor: ColorSet.textColor,
            ),
          ),
        ),
        // },
        //),
      ],
    );
  }

  void _showGrowDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorSet.backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: GrowDialog(arguments: null),
        );
      },
    );
  }
}

void _showQuizDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: ColorSet.backgroundColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: QuizDialog(arguments: null),
      );
    },
  );
}

class CharacterCardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

//quiz
class QuizDialog extends StatefulWidget {
  const QuizDialog({super.key, required arguments});

  @override
  QuizDialogState createState() => QuizDialogState();
}

class QuizDialogState extends State<QuizDialog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      //color: ColorSet.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
              title: const Text(
                "寶物蒐集概況",
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
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
            const SizedBox(height: 10.0),
            const Text(
              '運動寶物',
              style: TextStyle(
                  fontSize: 20,
                  color: ColorSet.textColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 170,
                width: 0.9 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: [
                      ColorSet.backgroundColor,
                      ColorSet.backgroundColor
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                // TODO:根據使用者的成功與否增加寶物數量
                child: Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i < workoutGem; i++) //運寶數量
                      Image.asset(
                        height: 35,
                        width: 35,
                        'assets/images/treasure.png',
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              '冥想寶物',
              style: TextStyle(
                  fontSize: 20,
                  color: ColorSet.textColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 170,
                width: 0.9 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: [
                      ColorSet.backgroundColor,
                      ColorSet.backgroundColor
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: [
                    for (int i = 0; i < meditationGem; i++) //冥寶數量
                      Image.asset(
                        height: 35,
                        width: 35,
                        'assets/images/treasure.png',
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}

//more
class GrowDialog extends StatefulWidget {
  const GrowDialog({super.key, required arguments});

  @override
  GrowDialogState createState() => GrowDialogState();
}

class GrowDialogState extends State<GrowDialog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      //color: ColorSet.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
              title: const Text(
                "角色進化圖",
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorSet.textColor, width: 2),
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
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120,
                width: 0.9 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: [
                      ColorSet.backgroundColor,
                      ColorSet.backgroundColor
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      height: 120,
                      width: 120,
                      'assets/images/first.png',
                    ),
                    const SizedBox(
                        width:
                            25), // Add some spacing between the image and text
                    const Text(
                      '第一階段',
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorSet.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120,
                width: 0.9 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: [
                      ColorSet.backgroundColor,
                      ColorSet.backgroundColor
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      height: 120,
                      width: 120,
                      'assets/images/second.png',
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      '第二階段',
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorSet.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120,
                width: 0.9 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: [
                      ColorSet.backgroundColor,
                      ColorSet.backgroundColor
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      height: 120,
                      width: 120,
                      'assets/images/third_unknown.png',
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      '???',
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorSet.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}

//map
class Level extends StatefulWidget {
  const Level({super.key});

  @override
  LevelState createState() => LevelState();
}

class LevelState extends State<Level> {
  double level = (workoutGem + meditationGem).toDouble();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorSet.backgroundColor, ColorSet.backgroundColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: LevelMap(
            backgroundColor: Colors
                .transparent, // Set the background color of LevelMap to transparent
            levelMapParams: LevelMapParams(
              levelCount: 48,
              //levelHeight: 50,
              //currentLevel: user_currentLevel,
              currentLevel: level,
              pathColor: Colors.black,
              currentLevelImage: ImageParams(
                path: "assets/images/Rabbit_2.png",
                size: const Size(120, 120),
              ),
              lockedLevelImage: ImageParams(
                path: "assets/images/lock.png",
                size: const Size(30, 30),
              ),
              completedLevelImage: ImageParams(
                path: "assets/images/completed.png",
                size: const Size(100, 100),
              ),
              startLevelImage: ImageParams(
                path: "assets/images/start.png",
                size: const Size(80, 80),
              ),
              pathEndImage: ImageParams(
                path: "assets/images/finish.png",
                size: const Size(80, 80),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff4b3d70),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
