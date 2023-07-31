import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              color: Color(0xFFFDFDFD),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: const Color(0xFF98D98E),
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
                    'Characters'
                        '\n這邊看需要寫些甚麼或放甚麼東西(不然太空?',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      color: Color(0xFF98D98E),
                      fontSize: 32,
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
                  colors: [Color(0xFFFFFFFF), Color(0xFF98D98E)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.75, 0.3),
          child: Image.asset(
            'assets/images/1.png',
            height: screenHeight * 0.4,
          ),
        ),
        Align(
          alignment: const Alignment(-0.75, 0.65),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                _showGrowDialog(context);
              },
              backgroundColor: Colors.black26,
              child: const Icon(Icons.quiz),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(-0.75, 0.9),
          child: SizedBox(
            width: 40,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExerciseLevel()),
                );
              }, // 替換為你想要的圖示
              backgroundColor: Colors.black26,
              child: const Icon(Icons.map), // 替換為你想要的按鈕背景顏色
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GrowDialog(arguments: null),
        );
      },
    );
  }
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

class GrowDialog extends StatefulWidget {
  GrowDialog({super.key, required arguments});

  @override
  _GrowDialogState createState() => _GrowDialogState();
}

//more
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
                    colors: [Color(0xFFFFFFFF), Color(0xFF98D98E)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Image.asset(
                  height: 100,
                  width: 80,
                  'assets/images/1.png',
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
                    colors: [Color(0xFFFFFFFF), Color(0xFF98D98E)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Image.asset(
                  height: 100,
                  width: 80,
                  'assets/images/3.png',
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
                    colors: [Color(0xFFFFFFFF), Color(0xFF98D98E)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Image.asset(
                  height: 100,
                  width: 80,
                  'assets/images/2.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//地圖
class ExerciseLevel extends StatefulWidget {
  const ExerciseLevel({super.key});

  @override
  _ExerciseLevel createState() => _ExerciseLevel();
}

class _ExerciseLevel extends State<ExerciseLevel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LevelMap(
          backgroundColor: Colors.white,
          levelMapParams: LevelMapParams(
            levelCount: 24,
            //levelHeight: 50,
            currentLevel: 4,
            pathColor: Colors.black,
            currentLevelImage: ImageParams(
              path: "assets/images/1.png",
              size: const Size(100, 100),
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/lock.png",
              size: const Size(20, 20),
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/completed.png",
              size: const Size(80, 80),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
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
