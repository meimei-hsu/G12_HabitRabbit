import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MilestonePage extends StatefulWidget {
  final Map arguments;
  const MilestonePage({super.key, required this.arguments});

  @override
  _MilestonePage createState() => _MilestonePage();
}

class _MilestonePage extends State<MilestonePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '里程碑',
            style: TextStyle(
              color: Color(0xFF0D3B66),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: const Color(0xFFFAF0CA),
          automaticallyImplyLeading: false,
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 32.0, top: 32.0),
                  child: Text(
                    'Mary的角色',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: Color(0xFF0D3B66),
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 10.0),
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
              height: 0.6 * screenHeight,
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
          alignment: const Alignment(2.5, -0.6),
          child: Image.asset(
            'assets/images/second.png',
            height: screenHeight * 0.45,
          ),
        ),
        Align(
          alignment: const Alignment(-0.75, 0.65),
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
          alignment: const Alignment(-0.5, 0.65),
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
          alignment: const Alignment(-0.25, 0.65),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExerciseLevel()),
                );
              },
              backgroundColor: const Color(0xFFFDFDFD),
              child: const Icon(Icons.map),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(-0.72, 0.8),
          child: Text(
            '距離下一階段已完成：',
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
            alignment: const Alignment(2, 0.88),
            child: LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.85,
              animation: true,
              lineHeight: 15.0,
              percent: 0.7,
              center: const Text(
                "70.0%",
                style: TextStyle(
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
      ],
    );
  }

  void _showGrowDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.black.withOpacity(0.5), // Darkened background color
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
            const SizedBox(height: 30.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 180,
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
                    for (int i = 0; i < 17; i++)
                      Image.asset(
                        height: 40,
                        width: 40,
                        'assets/images/treasure.png',
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 180,
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
                    for (int i = 0; i < 12; i++)
                      Image.asset(
                        height: 40,
                        width: 40,
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
              color: Colors.grey.shade200,
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
class ExerciseLevel extends StatefulWidget {
  const ExerciseLevel({super.key});

  @override
  _ExerciseLevel createState() => _ExerciseLevel();
}

class _ExerciseLevel extends State<ExerciseLevel> {
  double user_currentLevel = 1; // 初始等級均為1

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
              levelCount: 24,
              //levelHeight: 50,
              currentLevel: user_currentLevel,
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
            Icons.home,
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
