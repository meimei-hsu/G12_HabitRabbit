import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:g12/services/Database.dart';
import 'dart:async';

int workoutGem = 0;
int meditationGem = 0;
String workoutFragment = "";
String meditationFragment = "";
bool isFetchingData = true;

class MilestonePage extends StatefulWidget {
  final Map arguments;
  const MilestonePage({super.key, required this.arguments});

  @override
  _MilestonePage createState() => _MilestonePage();
}

class _MilestonePage extends State<MilestonePage> {
  void initState() {
    super.initState();
    _fetchExistingMilestoneData();
  }

  Future<void> _fetchExistingMilestoneData() async {
    Map<String?, dynamic>? milestoneData = await MilestoneDB.getMilestone();
    if (milestoneData != null) {
      setState(() {
        workoutGem = milestoneData["workoutGem"];
        meditationGem = milestoneData["meditationGem"];
        workoutFragment = milestoneData["workoutFragment"];
        meditationFragment = milestoneData["meditationFragment"];
        isFetchingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDF5),
        /*appBar: AppBar(
          title: const Text(
            '里程碑',
            style: TextStyle(
                color: Color(0xff4b3d70),
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          backgroundColor: const Color(0xFFFDFDF5),
          automaticallyImplyLeading: false,
        ),*/
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 16.0),
                  child: Row(
                    children: const [
                      Text(
                        'Mary的角色',
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          color: Color(0xFF0D3B66),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(width: 8),
                      //TODO: 根據等級改變Icon
                      Icon(
                        Icons.looks_two,
                        color: Color(0xFF0D3B66),
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
                      color: Color(0xFF0D3B66),
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

  Future<bool> hasContract() async {
    final contractDetails = await ContractDB.getContract();
    return contractDetails != null;
  }

  @override
  Widget build(BuildContext context) {
    double workoutPercent = Calculator.calcProgress(workoutFragment).toDouble();
    double meditationPercent = Calculator.calcProgress(meditationFragment).toDouble();
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
                  colors: [Color(0xFFFFFFFF), Color(0xFFFAF0CA)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(2.5, -0.75),
          //TODO: 根據等級改變角色
          child: Image.asset(
            'assets/images/second.png',
            height: screenHeight * 0.45,
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
              backgroundColor: const Color(0xFFFDFDFD),
              child: const Icon(Icons.quiz),
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
              backgroundColor: const Color(0xFFFDFDFD),
              child: const Icon(Icons.more_horiz_outlined),
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
              backgroundColor: const Color(0xFFFDFDFD),
              child: const Icon(Icons.map),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.4),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () async {
                final hasExistingContract = await hasContract();

                if (hasExistingContract) {
                  Navigator.pushNamed(context, '/contract/already');
                } else {
                  Navigator.pushNamed(context, '/contract/initial');
                }
              },
              backgroundColor: const Color(0xFFFDFDFD),
              child: const Icon(Icons.request_quote_outlined),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(-0.65, 0.55),
          child: Text(
            '本周運動習慣已達成：',
            style: TextStyle(
              fontFamily: 'WorkSans',
              color: Color(0xFF0D3B66),
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
                  color: Color(0xFFFDFDFD),
                  fontSize: 10,
                ),
              ),
              barRadius: const Radius.circular(16),
              backgroundColor: const Color(0xFFFDFDFD),
              progressColor: const Color(0xFF0D3B66),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(-0.65, 0.69),
          child: Text(
            '本周冥想習慣已達成：',
            style: TextStyle(
              fontFamily: 'WorkSans',
              color: Color(0xFF0D3B66),
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
                  color: Color(0xFFFDFDFD),
                  fontSize: 10,
                ),
              ),
              barRadius: const Radius.circular(16),
              backgroundColor: const Color(0xFFFDFDFD),
              progressColor: const Color(0xFF0D3B66),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(-0.65, 0.83),
          child: Text(
            '距離達成所有習慣養成：',
            style: TextStyle(
              fontFamily: 'WorkSans',
              color: Color(0xFF0D3B66),
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
                  color: Color(0xFFFDFDFD),
                  fontSize: 10,
                ),
              ),
              barRadius: const Radius.circular(16),
              backgroundColor: const Color(0xFFFDFDFD),
              progressColor: const Color(0xFF0D3B66),
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
      backgroundColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
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
    backgroundColor: Colors.black.withOpacity(0.5),
    // Darkened background color
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
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
  _QuizDialogState createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFFFAF0CA),
              child: Text(
                "寶物蒐集概況",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '運動寶物',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 170,
                width: 0.8 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFAF0CA)],
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
            const SizedBox(height: 5.0),
            Text(
              '冥想寶物',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 170,
                width: 0.8 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFAF0CA)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: [
                      for (int i = 0;
                          i < meditationGem;
                          i++) //冥寶數量
                        Image.asset(
                          height: 35,
                          width: 35,
                          'assets/images/treasure.png',
                        ),
                  ],
                ),
              ),
            ),
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
  _GrowDialogState createState() => _GrowDialogState();
}

class _GrowDialogState extends State<GrowDialog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFFFAF0CA),
              child: Text(
                "角色進化圖",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
            ),
            const SizedBox(height: 30.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120,
                width: 0.8 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFAF0CA)],
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
                            5), // Add some spacing between the image and text
                    const Text(
                      '第一階段',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120,
                width: 0.8 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFAF0CA)],
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
                    const SizedBox(width: 10),
                    const Text(
                      '第二階段',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120,
                width: 0.8 * screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFFAF0CA)],
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
                    const SizedBox(width: 10),
                    const Text(
                      '???',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
  _Level createState() => _Level();
}

class _Level extends State<Level> {
  double level = (workoutGem + meditationGem).toDouble();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFFAF0CA)],
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
                path: "assets/images/second.png",
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
          backgroundColor: const Color(0xFF0D3B66),
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
