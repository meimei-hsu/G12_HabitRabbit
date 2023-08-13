import 'package:flutter/material.dart';
import 'package:level_map/level_map.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g12/services/Database.dart';
import 'dart:async';

class MilestonePage extends StatefulWidget {
  final Map arguments;
  const MilestonePage({super.key, required this.arguments});

  @override
  _MilestonePage createState() => _MilestonePage();


}




class _MilestonePage extends State<MilestonePage> {
  int? _workoutGem;
  int? _meditationGem;
  String? _workoutFragment;
  String? _meditationFragment;

  void initState() {
    super.initState();
    _fetchExistingMilestoneData();

  }

  Future<void> _fetchExistingMilestoneData() async {
    Map<String?, dynamic>? milestoneData = await MilestoneDB.getMilestone();
    if (milestoneData != null) {
      setState(() {
        _workoutGem = milestoneData["workoutGem"];
        _meditationGem = milestoneData["meditationGem"];
        _workoutFragment = milestoneData["workoutFragment"];
        _workoutFragment = milestoneData["workoutFragment"];
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
  /*void getPlanData() async {
    Map<String?, dynamic>? milestoneData = await MilestoneDB.getMilestone();
    if (milestoneData != null) {

        /*_workoutGem = milestoneData["workoutGem"];
        _meditationGem = milestoneData["meditationGem"];
        _workoutFragment = milestoneData["workoutFragment"];
        _workoutFragment = milestoneData["workoutFragment"];*/
      };
    }*/

  @override
  /*Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  }*/
  Widget build(BuildContext context) {
    String? _workoutGem;
    String? _meditationGem;
    String? _workoutFragment;
    String? _meditationFragment;
    double? workoutPersent;

    void getPlanData() async {
      Map<String?, dynamic>? milestoneData = await MilestoneDB.getMilestone();
      if (milestoneData != null) {

        _workoutGem = milestoneData["workoutGem"];
        _meditationGem = milestoneData["meditationGem"];
        _workoutFragment = milestoneData["workoutFragment"];
        _meditationFragment = milestoneData["meditationFragment"];

        print("測試");
        print(_workoutGem);
        print(_workoutFragment);
        workoutPersent=double.parse(_workoutGem!)/10;
        print(workoutPersent);

      };
    }
    //getPlanData();
    /*double getworkoutPersent() {

      getPlanData();
      print("分開");
      print(_workoutGem);
      print(_workoutFragment?.split(", "));
      if(workoutPersent!=null){
        double a =workoutPersent!;
      return a;}
      print("這裡");
      return 0;
    }*/
    //Map<String, dynamic>? milestoneData = await MilestoneDB.getMilestone() ;
    //Future<Map<String, dynamic>?> milestoneData =  MilestoneDB.getMilestone() as Future<Map<String, dynamic>?>;
    //Map<String, dynamic> milestoneData = await MilestoneDB.getMilestone() as Map<String, dynamic>;
    //String? _workoutFragment = milestoneData["workoutFragment"];
    //print(milestoneData["workoutgem"]);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    getPlanData();
    return Stack(

      children: [

          //FutureBuilder<Map<String, dynamic>?>(
          // future: MilestoneDB.getMilestone(),
          //builder(context,snapshot){

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
            child:

            Align(


              alignment: const Alignment(2, 0.62),
              child: LinearPercentIndicator(

                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                animation: true,
                lineHeight: 15.0,

                //String? fragment=milestoneData["workoutFragment"];
                //TODO: 根據完成度改變 percent

                percent: 0.8,
                //percent:MilestoneDB.getWorkoutpercent(),
                //if(_workoutGem!=null)
                //percent:double.parse(_workoutGem!)/10,
                center: const Text(
                  "80.0%",
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                animation: true,
                lineHeight: 15.0,
                //TODO: 根據完成度改變 percent
                percent: 0.2,
                center: const Text(
                  "20.0%",
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
                animation: true,
                lineHeight: 15.0,
                //TODO: 根據完成度改變 percent
                percent: 0.6,
                center: const Text(
                  "60.0%",
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
  String? _workoutGem;
  String? _meditationGem;
  String? _workoutFragment;
  String? _meditationFragment;

  void initState() {
    super.initState();
    _fetchExistingMilestoneData();

  }

  Future<void> _fetchExistingMilestoneData() async {
    Map<String?, dynamic>? milestoneData = await MilestoneDB.getMilestone();
    if (milestoneData != null) {
      setState(() {
        _workoutGem = milestoneData["workoutGem"];
        _meditationGem = milestoneData["meditationGem"];
        _workoutFragment = milestoneData["workoutFragment"];
        _workoutFragment = milestoneData["workoutFragment"];
      });
    }
  }
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
                    if(_workoutGem!=null)
                      for (int i = 0; i < int.parse(_workoutGem!); i++) //運寶數量
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
                    if(_meditationGem!=null)
                    for (int i = 0; i <int.parse(_meditationGem!) ; i++)//冥寶數量
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
  String? _workoutGem;
  String? _meditationGem;
  String? _workoutFragment;
  String? _meditationFragment;
  double? l;
  void initState() {
    super.initState();
    _fetchExistingMilestoneData();

  }

  Future<void> _fetchExistingMilestoneData() async {
    Map<String?, dynamic>? milestoneData = await MilestoneDB.getMilestone();
    if (milestoneData != null) {
      setState(() {
        _workoutGem = milestoneData["workoutGem"];
        _meditationGem = milestoneData["meditationGem"];
        _workoutFragment = milestoneData["workoutFragment"];
        _workoutFragment = milestoneData["workoutFragment"];
      });
      l=double.parse(_workoutGem!)+double.parse(_meditationGem!);
      print(l);
    }
  }
  double user_currentLevel = 1; // 初始等級均為1

  //double? user_currentLevel = l;
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
              currentLevel: l!,
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
