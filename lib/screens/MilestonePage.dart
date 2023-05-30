import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';

class MilestonePage extends StatefulWidget {
  final Map arguments;

  const MilestonePage({super.key, required this.arguments});

  @override
  _MilestonePage createState() => _MilestonePage();
}

class _MilestonePage extends State<MilestonePage> {
  int exerciseDays = 7; //默認運動天數為7
  double currentLevel = 1.0; // 每個人從起點出發都是0?
  final int totalLevels = 24;

  @override
  void initState() {
    super.initState();

    double progressRatio = getProgressRatio(exerciseDays);
    currentLevel += progressRatio;
  }

  //需要抓使用者的運動天數
  double getProgressRatio(int exerciseDays) {
    if (exerciseDays >= 7) {
      return 1.0 / exerciseDays;
    } else if (exerciseDays == 6) {
      return 0.143;
    } else if (exerciseDays == 5) {
      return 0.167;
    } else if (exerciseDays == 4) {
      return 0.2;
    } else if (exerciseDays == 3) {
      return 0.25;
    } else if (exerciseDays == 2) {
      return 0.333;
    } else if (exerciseDays == 1) {
      return 0.5;
    } else {
      return 0.0;
    }
  }

  //圖片跟設計我都隨便亂放主要是看一下怎麼跑動
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/desert.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            LevelMap(
              backgroundColor: Colors.black,
              levelMapParams: LevelMapParams(
                levelCount: totalLevels,
                currentLevel: currentLevel,
                pathColor: Colors.white,
                //現在所在Image
                currentLevelImage: ImageParams(
                  path: "assets/images/currentLevel.png",
                  size: Size(80, 80),
                ),
                //尚未解鎖的Image
                lockedLevelImage: ImageParams(
                  path: "assets/images/lockedLevel.jpg",
                  size: Size(60, 60),
                ),
                //已經完成的Image
                completedLevelImage: ImageParams(
                  path: "assets/images/completedLevel.jpg",
                  size: Size(80, 80),
                ),
                //起點Image
                startLevelImage: ImageParams(
                  path: "assets/images/start.jpg",
                  size: Size(300, 100),
                ),
                //終點Image //這個圖一定要改掉太醜了
                pathEndImage: ImageParams(
                  path: "assets/images/end.jpg",
                  size: Size(100, 100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
