import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:speech_balloon/speech_balloon.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/services/page_data.dart';

// Parameters for this page's tutorial (showcaseview)
GlobalKey characterKey = GlobalKey();
GlobalKey weekProgressKey = GlobalKey();
GlobalKey gemKey = GlobalKey();
GlobalKey levelKey = GlobalKey();
GlobalKey allProgressKey = GlobalKey();

class GamificationPage extends StatefulWidget {
  const GamificationPage({super.key});

  @override
  GamificationPageState createState() => GamificationPageState();
}

class GamificationPageState extends State<GamificationPage> {
  @override
  void initState() {
    super.initState();
    if (GameData.showTutorial) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase(
            [characterKey, weekProgressKey, gemKey, levelKey, allProgressKey]),
      );

      GameData.showTutorial = false;
    }
  }

  void refresh() async {
    if (Data.updatingDB || Data.updatingUI[1]) await GameData.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '${Data.profile?["userName"]} 的角色',
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          backgroundColor: ColorSet.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 20),
                child: Text(
                  '請養成規律的運動與冥想習慣，蒐集寶物讓我長大吧！',
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
                child: CharacterWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharacterWidget extends StatelessWidget {
  const CharacterWidget({super.key});

  final TextStyle tutorialTitleStyle = const TextStyle(
      color: ColorSet.textColor, fontSize: 18, fontWeight: FontWeight.bold);
  final TextStyle tutorialDescStyle =
      const TextStyle(color: ColorSet.hintColor, fontSize: 14);

  double getImageWidthPercentage() {
    String character = Data.characterName;
    String characterImageURL = Data.characterImageURL;
    double percentage = 0;

    if (character == "Mouse") {
      percentage = 0.6;
    } else if (character == "Pig") {
      percentage = (characterImageURL.contains("_2")) ? 0.6 : 0.7;
    } else if (character == "Cat") {
      percentage = (characterImageURL.contains("_2")) ? 0.6 : 0.7;
    } else if (character == "Sheep") {
      percentage = (characterImageURL.contains("_2")) ? 0.65 : 0.6;
    } else if (character == "Dog") {
      percentage = (characterImageURL.contains("_2")) ? 0.7 : 0.6;
    } else if (character == "Lion") {
      percentage = (characterImageURL.contains("_2")) ? 0.75 : 0.8;
    } else if (character == "Fox") {
      percentage = (characterImageURL.contains("_2")) ? 0.75 : 0.65;
    } else if (character == "Sloth") {
      percentage = (characterImageURL.contains("_2")) ? 0.8 : 0.75;
    }
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: ClipPath(
            clipper: CharacterCardBackgroundClipper(),
            child: Container(
              height: 0.65 * screenHeight,
              width: 0.9 * screenWidth,
              decoration: const BoxDecoration(
                color: ColorSet.bottomBarColor,
              ),
            ),
          ),
        ),
        Column(children: [
          Showcase.withWidget(
            key: characterKey,
            targetBorderRadius: BorderRadius.circular(8.0),
            targetPadding: const EdgeInsets.all(5),
            overlayColor: ColorSet.hintColor,
            overlayOpacity: 0.7,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
            container: SpeechBalloon(
                color: ColorSet.backgroundColor,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.13,
                nipLocation: NipLocation.top,
                nipHeight: 25,
                borderColor: ColorSet.borderColor,
                borderRadius: 20,
                borderWidth: 6,
                child: Center(
                    child: Container(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "我是你的小${Data.characterNameZH}，\n請蒐集寶物讓我長大吧！",
                              style: tutorialTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '➤ 點擊螢幕查看下一個',
                              style: tutorialDescStyle,
                            )
                          ],
                        )))),
            child: Image.asset(
              Data.characterImageURL,
              height: screenHeight * 0.35,
              width: screenWidth * getImageWidthPercentage(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                Showcase.withWidget(
                  key: gemKey,
                  targetBorderRadius: BorderRadius.circular(8.0),
                  targetPadding: const EdgeInsets.all(5),
                  overlayColor: ColorSet.hintColor,
                  overlayOpacity: 0.7,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  container: SpeechBalloon(
                      color: ColorSet.backgroundColor,
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.13,
                      nipLocation: NipLocation.top,
                      nipHeight: 25,
                      borderColor: ColorSet.borderColor,
                      borderRadius: 20,
                      borderWidth: 6,
                      offset: const Offset(-120, 0),
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "在這裡查看已蒐集的寶物數量。\n每八個寶物能讓我長大一個階段~",
                                    style: tutorialTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '➤ 點擊螢幕查看下一個',
                                    style: tutorialDescStyle,
                                  )
                                ],
                              )))),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: ColorSet.backgroundColor,
                      tooltip: "寶物蒐集數量",
                      onPressed: () {
                        _showQuizDialog(context);
                      },
                      child:
                          const Icon(Icons.list_alt, color: ColorSet.iconColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Showcase.withWidget(
                  key: levelKey,
                  targetBorderRadius: BorderRadius.circular(8.0),
                  targetPadding: const EdgeInsets.all(5),
                  overlayColor: ColorSet.hintColor,
                  overlayOpacity: 0.7,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  container: SpeechBalloon(
                      color: ColorSet.backgroundColor,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.13,
                      nipLocation: NipLocation.top,
                      nipHeight: 25,
                      borderColor: ColorSet.borderColor,
                      borderRadius: 20,
                      borderWidth: 6,
                      offset: const Offset(-60, 0),
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "在這裡查看我的成長情況。\n我有六個階段等你來解鎖！",
                                    style: tutorialTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '➤ 點擊螢幕查看下一個',
                                    style: tutorialDescStyle,
                                  )
                                ],
                              )))),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: ColorSet.backgroundColor,
                      tooltip: "人格角色進化",
                      onPressed: () {
                        _showGrowDialog(context);
                      },
                      child: const Icon(Icons.style, color: ColorSet.iconColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    backgroundColor: ColorSet.backgroundColor,
                    tooltip: "承諾合約",
                    onPressed: () {
                      if (Data.contract != null) {
                        Navigator.pushNamed(context, '/contract/already');
                      } else {
                        Navigator.pushNamed(context, '/contract/initial');
                      }
                    },
                    child: const Icon(Icons.request_quote_outlined,
                        color: ColorSet.iconColor),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    backgroundColor: ColorSet.backgroundColor,
                    tooltip: "教學",
                    onPressed: () {
                      ShowCaseWidget.of(context).startShowCase([
                        characterKey,
                        weekProgressKey,
                        gemKey,
                        levelKey,
                        allProgressKey
                      ]);
                    },
                    child: const Icon(Icons.question_mark_outlined,
                        color: ColorSet.iconColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Showcase.withWidget(
                  key: weekProgressKey,
                  targetBorderRadius: BorderRadius.circular(8.0),
                  targetPadding: const EdgeInsets.all(5),
                  overlayColor: ColorSet.hintColor,
                  overlayOpacity: 0.7,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  container: SpeechBalloon(
                      color: ColorSet.backgroundColor,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.13,
                      nipLocation: NipLocation.top,
                      nipHeight: 25,
                      borderColor: ColorSet.borderColor,
                      borderRadius: 20,
                      borderWidth: 6,
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "本週習慣完成100%時，\n可以獲得運動或冥想寶物。",
                                    style: tutorialTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '➤ 點擊螢幕查看下一個',
                                    style: tutorialDescStyle,
                                  )
                                ],
                              )))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            '本周運動習慣已達成：',
                            style: TextStyle(
                              color: ColorSet.textColor,
                              fontSize: 16,
                            ),
                          )),
                      const SizedBox(height: 5),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * 0.76,
                        animation: true,
                        lineHeight: 15.0,
                        percent: GameData.workoutPercent / 100,
                        trailing: Text(
                          "${GameData.workoutPercent.round()}%",
                          style: const TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 12,
                          ),
                        ),
                        barRadius: const Radius.circular(16),
                        backgroundColor: ColorSet.backgroundColor,
                        progressColor: ColorSet.textColor,
                      ),
                      const SizedBox(height: 10),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            '本周冥想習慣已達成：',
                            style: TextStyle(
                              color: ColorSet.textColor,
                              fontSize: 16,
                            ),
                          )),
                      const SizedBox(height: 5),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * 0.76,
                        animation: true,
                        lineHeight: 15.0,
                        percent: GameData.meditationPercent / 100,
                        trailing: Text(
                          "${GameData.meditationPercent.round()}%",
                          style: const TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 12,
                          ),
                        ),
                        barRadius: const Radius.circular(16),
                        backgroundColor: ColorSet.backgroundColor,
                        progressColor: ColorSet.textColor,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Showcase.withWidget(
                  key: allProgressKey,
                  targetBorderRadius: BorderRadius.circular(8.0),
                  targetPadding: const EdgeInsets.all(5),
                  overlayColor: ColorSet.hintColor,
                  overlayOpacity: 0.7,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  container: SpeechBalloon(
                      color: ColorSet.backgroundColor,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.13,
                      nipLocation: NipLocation.top,
                      nipHeight: 25,
                      borderColor: ColorSet.borderColor,
                      borderRadius: 20,
                      borderWidth: 6,
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "所有進度達成100%時，\n就可以解鎖我的最終型態喔~",
                                    style: tutorialTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '➤ 點擊螢幕完成教學',
                                    style: tutorialDescStyle,
                                  )
                                ],
                              )))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            '距離所有習慣養成：',
                            style: TextStyle(
                              color: ColorSet.textColor,
                              fontSize: 16,
                            ),
                          )),
                      const SizedBox(height: 5),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * 0.76,
                        animation: true,
                        lineHeight: 15.0,
                        percent: GameData.totalPercent / 100,
                        trailing: Text(
                          "${GameData.totalPercent.round()}%",
                          style: const TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 12,
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
            ),
          ),
        ])
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
      backgroundColor: ColorSet.bottomBarColor,
      builder: (BuildContext context) {
        return const Padding(
            padding: EdgeInsets.all(8.0), child: GrowDialog(arguments: null));
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
    backgroundColor: ColorSet.bottomBarColor,
    builder: (BuildContext context) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: QuizDialog(),
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
  const QuizDialog({super.key});

  @override
  QuizDialogState createState() => QuizDialogState();
}

class QuizDialogState extends State<QuizDialog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: ColorSet.bottomBarColor,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
              title: const Text(
                "寶物蒐集數量",
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
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
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    '運動寶物 (${GameData.workoutGem} / 24)',
                    style: const TextStyle(
                        fontSize: 20,
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 0.2 * screenHeight,
                    width: 0.9 * screenWidth,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: ColorSet.textColor, width: 1),
                      color: ColorSet.backgroundColor,
                    ),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        ...List.generate(
                          GameData.workoutGem,
                          (index) => Image.asset(
                              height: 35, width: 35, Data.workoutGemImageUrl),
                        ),
                        ...List.generate(
                          24 - GameData.workoutGem,
                          (index) => Image.asset(
                            height: 35,
                            width: 35,
                            Data.workoutGemImageUrl
                                .replaceFirst(RegExp(r'.png'), "_black.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    '冥想寶物 (${GameData.meditationGem} / 24)',
                    style: const TextStyle(
                        fontSize: 20,
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 0.2 * screenHeight,
                    width: 0.9 * screenWidth,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: ColorSet.textColor, width: 1),
                      color: ColorSet.backgroundColor,
                    ),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        ...List.generate(
                          GameData.meditationGem,
                          (index) => Image.asset(
                              height: 35,
                              width: 35,
                              Data.meditationGemImageUrl),
                        ),
                        ...List.generate(
                          24 - GameData.meditationGem,
                          (index) => Image.asset(
                            height: 35,
                            width: 35,
                            Data.meditationGemImageUrl
                                .replaceFirst(RegExp(r'.png'), "_black.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
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
              title: const Text(
                "人格角色進化",
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
                  for (int i = 0; i < GameData.characterLevel + 1; i++) ...[
                    Container(
                      height: 120,
                      width: 0.9 * screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: ColorSet.textColor, width: 1),
                        color: (i + 1 == GameData.characterLevel)
                            ? ColorSet.usersColor
                            : ColorSet.backgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            height: 100,
                            width: 100,
                            (i == GameData.characterLevel)
                                ? 'assets/images/${Data.characterName}_${i + 1}_black.png'
                                : 'assets/images/${Data.characterName}_${i + 1}.png',
                          ),
                          const SizedBox(width: 25),
                          Text(
                            '第${["一", "二", "三", "四", "五", "六"][i]}階段',
                            style: const TextStyle(
                              fontSize: 20,
                              color: ColorSet.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoDialog extends StatefulWidget {
  const InfoDialog({super.key, required arguments});

  @override
  InfoDialogState createState() => InfoDialogState();
}

class InfoDialogState extends State<InfoDialog> {
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
                "疑難雜症區",
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
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
              child: Container(
                  height: 280,
                  width: 0.9 * screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: ColorSet.textColor, width: 1),
                    color: ColorSet.backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 20,
                          color: ColorSet.textColor,
                        ),
                        children: [
                          TextSpan(
                              text:
                                  '每次運動與冥想結束後，您將會獲取寶物碎片，這些碎片會在本周的運動或冥想習慣達成率至100%時組合成寶物，而寶物是讓角色晉級的關鍵。\n\n'),
                          TextSpan(
                            text: '點選',
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.list_alt,
                              color: ColorSet.iconColor,
                              size: 30,
                            ),
                          ),
                          TextSpan(text: '可查看獲取的寶物數量。\n'),
                          TextSpan(
                            text: '點選',
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.style,
                              color: ColorSet.iconColor,
                              size: 30,
                            ),
                          ),
                          TextSpan(text: '可查看角色狀態。\n'),
                          TextSpan(
                            text: '點選',
                          ),
                          WidgetSpan(
                            child: Icon(
                              Icons.request_quote_outlined,
                              color: ColorSet.iconColor,
                              size: 30,
                            ),
                          ),
                          TextSpan(text: '可查看合約及建立新合約。\n'),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
