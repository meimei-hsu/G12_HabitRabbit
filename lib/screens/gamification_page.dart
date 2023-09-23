import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:g12/screens/page_material.dart';

import 'package:g12/services/database.dart';

int workoutGem = 0;
int meditationGem = 0;
double workoutPercent = 0;
double meditationPercent = 0;
double totalPercent = 0;
bool hasContract = false;

class GamificationPage extends StatefulWidget {
  final Map arguments;
  const GamificationPage({super.key, required this.arguments});

  @override
  GamificationPageState createState() => GamificationPageState();
}

class GamificationPageState extends State<GamificationPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchGamificationData();
  }

  Future<void> _fetchGamificationData() async {
    final game = await GamificationDB.getGamification();
    final contract = await ContractDB.getContract();
    if (game != null) {
      setState(() {
        workoutPercent =
            Calculator.calcProgress(game["workoutFragment"]).toDouble();
        meditationPercent =
            Calculator.calcProgress(game["meditationFragment"]).toDouble();
        totalPercent = (workoutGem + meditationGem) / 48 * 100;
        if (contract != null) hasContract = true;
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
                  child: Text(
                    '${user?.displayName!} 的角色',
                    style: const TextStyle(
                      fontFamily: 'WorkSans',
                      color: ColorSet.textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
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
                const Expanded(
                  child: CharacterWidget(),
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
                color: ColorSet.bottomBarColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 120),
          child: Image.asset(
            'assets/images/Rabbit_2.png',
            height: screenHeight * 0.4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 400, left: 40),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    _showQuizDialog(context);
                  },
                  backgroundColor: ColorSet.backgroundColor,
                  child: const Icon(Icons.list_alt, color: ColorSet.iconColor),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 40,
                height: 40,
                child: FloatingActionButton(
                  onPressed: () {
                    _showGrowDialog(context);
                  },
                  backgroundColor: ColorSet.backgroundColor,
                  child: const Icon(Icons.style,
                      color: ColorSet.iconColor),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 450, left: 30),
          child: Column(
            children: [
              const Text(
                '本周運動達成率：',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: ColorSet.textColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width * 0.85,
                animation: true,
                lineHeight: 15.0,
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
              const SizedBox(height: 10),
              const Text(
                '本周冥想達成率：',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: ColorSet.textColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width * 0.85,
                animation: true,
                lineHeight: 15.0,
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
              const SizedBox(height: 10),
              const Text(
                '全部完成率：',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  color: ColorSet.textColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width * 0.85,
                animation: true,
                lineHeight: 15.0,
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
            ],
          ),
        ),
      ],
    );
  }

  void _showGrowDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: GrowDialog(arguments: null)
        );
      },
    );
  }
}

void _showQuizDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
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
      color: ColorSet.bottomBarColor,
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left:20, right:20),
              child: Column(
                children: [
                  const Text(
                    '運動寶物',
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 170,
                    width: 0.85 * screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: ColorSet.textColor, width: 1),
                      color: ColorSet.backgroundColor,
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
                  const SizedBox(height: 20.0),
                  const Text(
                    '冥想寶物',
                    style: TextStyle(
                        fontSize: 20,
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 170,
                    width: 0.85 * screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: ColorSet.textColor, width: 1),
                      color: ColorSet.backgroundColor,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      color: ColorSet.bottomBarColor,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
              title: const Text("角色進化圖",
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                /*decoration: BoxDecoration(
                  border: Border.all(color: ColorSet.textColor, width: 2),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 0.9 * screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: ColorSet.textColor, width: 1),
                      color: ColorSet.backgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          height: 100,
                          width: 100,
                          'assets/images/Rabbit_1.png',
                        ),
                        const SizedBox(width: 25),
                        const Text('第一階段',
                          style: TextStyle(
                            fontSize: 20,
                            color: ColorSet.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    width: 0.9 * screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: ColorSet.textColor, width: 1),
                      color: ColorSet.backgroundColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          height: 100,
                          width: 100,
                          'assets/images/Rabbit_2.png',
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
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    width: 0.9 * screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: ColorSet.textColor, width: 1),
                      color: ColorSet.backgroundColor,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
