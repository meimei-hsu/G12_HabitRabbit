import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

final BorderRadius _borderRadius = const BorderRadius.only(
  topLeft: Radius.circular(25),
  topRight: Radius.circular(25),
);

ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
  topLeft: Radius.circular(25),
  topRight: Radius.circular(25),
));
SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.pinned;
EdgeInsets padding = EdgeInsets.zero;

int _selectedItemPosition = 2;
SnakeShape snakeShape = SnakeShape.circle;

bool showSelectedLabels = false;
bool showUnselectedLabels = false;

Color selectedColor = Colors.black;
Color unselectedColor = Colors.blueGrey;

Gradient selectedGradient =
    const LinearGradient(colors: [Colors.red, Colors.amber]);
Gradient unselectedGradient =
    const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

class MilestonePage extends StatefulWidget {
  const MilestonePage({super.key});

  @override
  _MilestonePage createState() => _MilestonePage();
}

class _MilestonePage extends State<MilestonePage> {
  User user = FirebaseAuth.instance.currentUser!;
  int exerciseDays = 7; //默認運動天數為7
  // TODO: 抓使用者設定的運動天數
  double currentLevel = 1.0; // 每個人從起點出發都是1
  final int totalLevels = 24;

  void showOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('功能選擇'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 返回至主頁的操作
                  Navigator.of(context).pop();
                  // TODO: 執行返回至主頁的操作
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA493), // 設定按鈕的背景顏色
                ),
                child: Text(
                  '返回至主頁',
                  style: TextStyle(
                    color: Colors.white, // 設定內部文字的顏色
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 繼續觀看里程碑的操作
                  Navigator.of(context).pop();
                  // TODO: 執行繼續觀看里程碑的操作
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA493), // 設定按鈕的背景顏色
                ),
                child: Text(
                  ''
                  '觀看里程碑',
                  style: TextStyle(
                    color: Colors.white, // 設定內部文字的顏色
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('規則'),
                        content: Text('//內容尚在思考'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFA493), // 設定按鈕的背景顏色
                            ),
                            child: Text('確認'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA493), // 設定按鈕的背景顏色
                ),
                child: Text(
                  '里程碑規則',
                  style: TextStyle(
                    color: Colors.white, // 設定內部文字的顏色
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                      size: Size(600, 100),
                      imagePositionFactor: 1.0,
                    ),
                    //終點Image
                    pathEndImage: ImageParams(
                      path: "assets/images/end.jpg",
                      size: Size(150, 100),
                      imagePositionFactor: 0.0,
                    ),
                    bgImagesToBePaintedRandomly: [
                      ImageParams(
                          path: "assets/images/star.jpg",
                          size: Size(40, 40),
                          repeatCountPerLevel: 0.5),
                      ImageParams(
                          path: "assets/images/rocket.jpg",
                          size: Size(50, 50),
                          repeatCountPerLevel: 0.2),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () {
                showOptions();
              },
            ),
            bottomNavigationBar: SnakeNavigationBar.color(
              behaviour: snakeBarStyle,
              snakeShape: snakeShape,
              shape: bottomBarShape,
              padding: padding,
              height: 80,
              //backgroundColor: const Color(0xfffdeed9),
              backgroundColor: const Color(0xffd4d6fc),
              snakeViewColor: const Color(0xfffdfdf5),
              selectedItemColor: const Color(0xff4b3d70),
              unselectedItemColor: const Color(0xff4b3d70),

              ///configuration for SnakeNavigationBar.color
              // snakeViewColor: selectedColor,
              // selectedItemColor:
              //  snakeShape == SnakeShape.indicator ? selectedColor : null,
              //unselectedItemColor: Colors.blueGrey,

              ///configuration for SnakeNavigationBar.gradient
              //snakeViewGradient: selectedGradient,
              //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
              //unselectedItemGradient: unselectedGradient,

              showUnselectedLabels: showUnselectedLabels,
              showSelectedLabels: showSelectedLabels,

              currentIndex: _selectedItemPosition,
              //onTap: (index) => setState(() => _selectedItemPosition = index),
              onTap: (index) {
                _selectedItemPosition = index;
                if (index == 0) {
                  Navigator.pushNamed(context, '/statistic',
                      arguments: {'user': user});
                }
                if (index == 1) {
                  Navigator.pushNamed(context, '/milestone',
                      arguments: {'user': user});
                }
                if (index == 2) {
                  Navigator.pushNamed(context, '/', arguments: {'user': user});
                }
                if (index == 3) {
                  Navigator.pushNamed(context, '/contract/initial',
                      arguments: {'user': user});
                }
                //3
                if (index == 4) {
                  Navigator.pushNamed(context, '/settings',
                      arguments: {'user': user});
                }
                print(index);
              },
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.insights,
                      size: 40,
                    ),
                    label: 'tickets'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.workspace_premium_outlined,
                      size: 40,
                    ),
                    label: 'calendar'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                      size: 40,
                    ),
                    label: 'home'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.request_quote_outlined,
                      size: 40,
                    ),
                    label: 'microphone'),
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.manage_accounts_outlined,
                      size: 40,
                    ),
                    label: 'search')
              ],
            )));
  }
}
