import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:g12/screens/PageMaterial.dart';

import 'package:g12/services/Database.dart';
import 'package:g12/services/PlanAlgo.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  bool isInit = true;

  User? user = FirebaseAuth.instance.currentUser;
  bool isFetchingData = true;

  // Plan 相關資料
  String? workoutPlan;
  Map workoutPlanList = {};
  int? workoutProgress;
  Map progressList = {};
  List bothWeekWorkoutList = [];
  int currentIndex = 0;

  //Meditation Plan 相關資料
  String? meditationPlan;
  Map meditationPlanList = {};
  int? meditationProgress;
  Map meditationProgressList = {};
  List bothWeekMeditationList = [];
  int meditationCurrentIndex = 0;

  // Contract 資料
  Map contractData = {};

  // Calendar 相關設定
  DateTime today = Calendar.today();
  DateTime _focusedDay = DateTime(
      Calendar.today().year, Calendar.today().month, Calendar.today().day);

  DateTime? _selectedDay = Calendar.today();

  get firstDay => Calendar.firstDay();

  get lastDay => firstDay.add(const Duration(days: 13));

  get isThisWeek => Calendar.isThisWeek(_selectedDay!);

  bool isBefore = false;
  bool isAfter = false;
  bool isToday = true;

  String time = "今天";

  Widget getBannerCarousel() {
    const String banner1 = "assets/images/Exercise_1.jpg";
    const String banner2 = "assets/images/Meditation_1.jpg";

    List<BannerModel> listBanners;

    if (workoutPlan == null && meditationPlan == null) {
      listBanners = [];
    } else if (workoutPlan != null && meditationPlan == null) {
      listBanners = [BannerModel(imagePath: banner1, id: "1")];
    } else if (workoutPlan == null && meditationPlan != null) {
      listBanners = [BannerModel(imagePath: banner2, id: "2")];
    } else {
      listBanners = [
        BannerModel(imagePath: banner1, id: "1"),
        BannerModel(imagePath: banner2, id: "2"),
      ];
    }

    return (listBanners != [])
        ? BannerCarousel(
            height: 300,
            margin: const EdgeInsets.only(left: 0, right: 0),
            viewportFraction: 0.9,
            spaceBetween: 5,
            borderRadius: 10,
            activeColor: const Color(0xff4b3d70),
            disableColor: const Color(0xfff6cdb7),
            showIndicator: false,
            banners: listBanners,
            onTap: (id) async {
              // Exercise
              if (id == "1") {
                Navigator.pushNamed(context, '/detail/exercise', arguments: {
                  'user': user,
                  'day': _selectedDay,
                  'isToday': isToday ? true : false,
                  'isBefore': isBefore ? true : false,
                  'isAfter': isAfter ? true : false,
                  'percentage': workoutProgress,
                  'currentIndex': currentIndex,
                  'workoutPlan': workoutPlan
                });
              }

              // Meditation
              if (id == "2") {
                Navigator.pushNamed(context, '/detail/meditation', arguments: {
                  'user': user,
                  'day': _selectedDay,
                  'isToday': isToday ? true : false,
                  'isBefore': isBefore ? true : false,
                  'isAfter': isAfter ? true : false,
                  'percentage': meditationProgress,
                  'meditationTime': await UserDB.getMeditationTime(),
                  'meditationPlan': meditationPlan
                });
              }
            },
          )
        : Container();
  }

  String getDialogText() {
    String dialogText = "";

    if (workoutPlan == null && meditationPlan == null) {
      // 運動沒有、冥想沒有 --> 新增運動 + 冥想
      // 今天之後 --> 新增；之前 --> 沒有
      dialogText =
          (isBefore) ? "沒有運動計畫\n沒有冥想計畫" : "沒有運動計畫\n沒有冥想計畫\n點我新增計畫！";
    } else if (workoutPlan != null && meditationPlan == null) {
      // 運動有、冥想沒有 --> 運動完成度、新增冥想
      // 今天之後 --> 運動完成度、新增冥想；之前 --> 運動完成度、沒有冥想
      dialogText = (isBefore)
          ? "運動計畫完成了 $workoutProgress %\n沒有冥想計畫"
          : (isToday)
              ? "運動計畫已完成 $workoutProgress %\n${(workoutProgress == 100) ? "很棒噢~~\n" : "繼續加油加油~~\n"}沒有冥想計畫，點我新增！"
              : "有運動計畫\n記得要來完成噢~\n點我新增冥想計畫！";
    } else if (workoutPlan == null && meditationPlan != null) {
      // 運動沒有、冥想有 --> 冥想完成度、新增運動
      // 今天之後 --> 冥想完成度、新增運動；之前 --> 冥想完成度、沒有運動
      dialogText = (isBefore)
          ? "冥想計畫完成了 $meditationProgress %\n沒有運動計畫"
          : (isToday)
              ? "冥想計畫已完成 $meditationProgress %\n${(meditationProgress == 100) ? "很棒噢~~\n" : "繼續加油加油~~\n"}沒有運動計畫，點我新增！"
              : "有冥想計畫\n記得要來完成噢~\n點我新增運動計畫！";
    } else {
      // 運動有、冥想有 --> 運動完成度、冥想完成度
      // 今天之後 --> 運動完成度、冥想完成度；之前 --> 運動完成度、冥想完成度
      dialogText = (isBefore)
          ? "運動計畫完成了 $workoutProgress %\n冥想計畫完成了 $meditationProgress %"
          : (isToday)
              ? "運動計畫已完成 $workoutProgress %\n冥想計畫已完成 $meditationProgress %${(workoutProgress == 100 && meditationProgress == 100) ? "\n很棒噢~~" : "\n繼續加油加油~~"}"
              : "有運動和冥想計畫\n記得要來完成噢~";
    }
    return dialogText;
  }

  void getPlanData() async {
    if (user != null) await PlanAlgo.execute();
    isFetchingData = true;
    var plan = await PlanDB.getThisWeekByName();
    var progress = await DurationDB.getWeekProgress();
    var workoutDays = await UserDB.getBothWeekWorkoutDays();
    var index = await DurationDB.getFromDate(today);
    setState(() {
      workoutPlanList = plan ?? {};
      progressList = progress ?? {};
      bothWeekWorkoutList = workoutDays ?? [];
      currentIndex = index ?? 0;
      isFetchingData = false;
      isInit = false;
    });

    setState(() {
      workoutPlan = workoutPlanList[Calendar.dateToString(_selectedDay!)];
      workoutProgress = progressList[Calendar.dateToString(_selectedDay!)];
    });
  }

  void getMeditationPlanData() async {
    if (user != null) await MeditationPlanAlgo.execute();
    isFetchingData = true;
    var plan = await MeditationPlanDB.getThisWeekByName();
    var progress = await MeditationDurationDB.getWeekProgress();
    var meditationDays = await UserDB.getBothWeekMeditationDays();
    var index = await MeditationDurationDB.getFromDate(today);
    setState(() {
      meditationPlanList = plan ?? {};
      meditationProgressList = progress ?? {};
      bothWeekMeditationList = meditationDays ?? [];
      meditationCurrentIndex = index ?? 0;
      isFetchingData = false;
      isInit = false;
    });

    setState(() {
      meditationPlan = meditationPlanList[Calendar.dateToString(_selectedDay!)];
      meditationProgress =
          meditationProgressList[Calendar.dateToString(_selectedDay!)];
    });
  }

  void getContractData() async {
    var contract = await ContractDB.getContract();
    setState(() {
      contractData = contract ?? {};
    });
  }

  @override
  void initState() {
    super.initState();

    getPlanData();
    getMeditationPlanData();
    getContractData();
  }

  void refresh() {
    setState(() {
      isFetchingData = true;
    });
    getPlanData();
    getMeditationPlanData();
    setState(() {});
  }

  void refreshLists() {
    setState(() {
      workoutPlan = workoutPlanList[Calendar.dateToString(_selectedDay!)];
      workoutProgress = progressList[Calendar.dateToString(_selectedDay!)];
      meditationPlan = meditationPlanList[Calendar.dateToString(_selectedDay!)];
      meditationProgress =
          meditationProgressList[Calendar.dateToString(_selectedDay!)];

      isBefore =
          DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
              .isBefore(_focusedDay);
      isAfter =
          DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
              .isAfter(_focusedDay);
      isToday = (DateTime(
              _selectedDay!.year, _selectedDay!.month, _selectedDay!.day) ==
          _focusedDay);
    });
    setState(() {
      time =
          (isToday) ? "今天" : " ${_selectedDay!.month} / ${_selectedDay!.day} ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: (isInit || isFetchingData)
          ? Center(
              child: Container(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: (isInit)
                          ? const Color(0xffd4d6fc)
                          : const Color(0xFFfdeed9),
                      border: Border.all(
                          color: (isInit)
                              ? const Color(0xffd4d6fc)
                              : const Color(0xFFfdeed9)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingAnimationWidget.horizontalRotatingDots(
                        color: const Color(0xff4b3d70),
                        size: 100,
                      ),
                      Text(
                        (isInit) ? "載入計畫中..." : "重新整理中...",
                        style: const TextStyle(
                          color: Color(0xff4b3d70),
                        ),
                      )
                    ],
                  )))
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  //color: const Color(0x193598f5),
                  color: const Color(0xFFFDFDFD), //日曆背景
                  child: TableCalendar(
                    firstDay: firstDay,
                    lastDay: lastDay,
                    focusedDay: _focusedDay,
                    //startingDayOfWeek: StartingDayOfWeek.monday,
                    //locale: 'zh_CN',
                    calendarFormat: CalendarFormat.week,
                    daysOfWeekHeight: 24,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        //color: Color(0xff0d3b66),
                        //color: Color(0xff4b3d70),
                        color: Color(0xfff6cdb7),
                        fontSize: 16,
                      ),
                      weekendStyle: TextStyle(
                        //color: Color(0xff0d3b66),
                        //color: Color(0xff4b3d70),
                        color: Color(0xfff6cdb7),
                        fontSize: 16,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      tablePadding: const EdgeInsets.only(
                          right: 10, left: 10, top: 10, bottom: 10),
                      todayDecoration: BoxDecoration(
                        //color: const Color(0xffffa493),
                        color: const Color(0xfff6cdb7), //今天顏色
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      todayTextStyle: const TextStyle(
                        //color: Color(0xff0d3b66),
                        color: Color(0xff4b3d70),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      selectedDecoration: BoxDecoration(
                        //color: const Color(0xfffbb87f),
                        color: (DateTime(_selectedDay!.year,
                                    _selectedDay!.month, _selectedDay!.day) ==
                                _focusedDay)
                            ? const Color(0xfff6cdb7)
                            : const Color(0xfffdeed9), //點到的天數顏色
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(
                                0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      selectedTextStyle: const TextStyle(
                        //color: Color(0xff0d3b66),
                        color: Color(0xff4b3d70),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      defaultDecoration: BoxDecoration(
                        //color: const Color(0xfffaf0ca),
                        color: const Color(0xfffdeed9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      defaultTextStyle: const TextStyle(
                        //color: Color(0xff0d3b66),
                        color: Color(0xff4b3d70),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      weekendDecoration: BoxDecoration(
                        //color: const Color(0xfffaf0ca),
                        color: const Color(0xfffdeed9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      weekendTextStyle: const TextStyle(
                        //color: Color(0xff0d3b66),
                        color: Color(0xff4b3d70),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      outsideDecoration: BoxDecoration(
                        //color: const Color(0xfffaf0ca),
                        color: const Color(0xfffdeed9),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      outsideTextStyle: const TextStyle(
                        //color: Color(0xff0d3b66),
                        color: Color(0xff4b3d70),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    headerVisible: false,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      // 選中的日期變成橘色
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                        });
                        refreshLists();
                      }
                    },
                    onPageChanged: (focusedDay) {
                      // 選第2頁的日期時不會跳回第一頁
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BubbleSpecialThree(
                        text: 'Hello ${user?.displayName}～\n${getDialogText()}',
                        color: const Color(0xFFfdeed9),
                        tail: true,
                        textStyle: const TextStyle(
                          color: Color(0xFF4b3d70),
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (workoutPlan == null && meditationPlan == null) {
                              // 運動沒有、冥想沒有 --> 新增運動 + 冥想
                              // 今天之後 --> 新增；之前 --> 沒有
                              (isBefore)
                                  ? null
                                  : showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20)),
                                      ),
                                      backgroundColor: const Color(0xfffdeed9),
                                      context: context,
                                      builder: (context) {
                                        return AddPlanBottomSheet(arguments: {
                                          "selectedDay": _selectedDay,
                                          "addWorkout": true,
                                          "addMeditation": true,
                                          "time": time,
                                          "isToday": isToday
                                        });
                                      });
                            } else if (workoutPlan != null &&
                                meditationPlan == null) {
                              // 運動有、冥想沒有 --> 運動完成度、新增冥想
                              // 今天之後 --> 運動完成度、新增冥想；之前 --> 運動完成度、沒有冥想
                              (isBefore)
                                  ? null
                                  : showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20)),
                                      ),
                                      backgroundColor: const Color(0xfffdeed9),
                                      context: context,
                                      builder: (context) {
                                        return AddPlanBottomSheet(arguments: {
                                          "selectedDay": _selectedDay,
                                          "addWorkout": false,
                                          "addMeditation": true,
                                          "time": time,
                                          "isToday": isToday
                                        });
                                      });
                            } else if (workoutPlan == null &&
                                meditationPlan != null) {
                              // 運動沒有、冥想有 --> 冥想完成度、新增運動
                              // 今天之後 --> 冥想完成度、新增運動；之前 --> 冥想完成度、沒有運動
                              (isBefore)
                                  ? null
                                  : showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20)),
                                      ),
                                      backgroundColor: const Color(0xfffdeed9),
                                      context: context,
                                      builder: (context) {
                                        return AddPlanBottomSheet(arguments: {
                                          "selectedDay": _selectedDay,
                                          "addWorkout": true,
                                          "addMeditation": false,
                                          "time": time,
                                          "isToday": isToday
                                        });
                                      });
                            } else {
                              // 運動有、冥想有 --> 運動完成度、冥想完成度
                              // 今天之後 --> 運動完成度、冥想完成度；之前 --> 運動完成度、冥想完成度
                              (isBefore) ? null : null;
                            }
                          }, // Image tapped
                          child: Image.asset(
                            "assets/images/Rabbit_2.png",
                            width: 125,
                            height: 150,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                (workoutPlan != null || meditationPlan != null)
                    ? Expanded(child: getBannerCarousel())
                    : Container(),
                const SizedBox(height: 5),
                // TODO: delete after QuestionnairePage & ContractPage testing

                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/contract/initial",
                              arguments: {});
                        },
                        icon: const Icon(Icons.workspace_premium_outlined,
                            size: 40)),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/questionnaire",
                              arguments: {"part": 0});
                        },
                        icon: const Icon(Icons.quiz_rounded, size: 40)),
                  ],
                ),
                const SizedBox(height: 5),
                // TODO: delete after ExercisePage's feedback testing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isDismissible: false,
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                              ),
                              backgroundColor: const Color(0xfffdeed9),
                              context: context,
                              builder: (context) {
                                return Wrap(children: const [
                                  FeedbackBottomSheet(
                                    arguments: {"type": 0},
                                  )
                                ]);
                              });
                        },
                        icon: const Icon(Icons.fitness_center_outlined,
                            size: 40)),
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isDismissible: false,
                              isScrollControlled: true,
                              enableDrag: false,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                              ),
                              backgroundColor: const Color(0xfffdeed9),
                              context: context,
                              builder: (context) {
                                return Wrap(children: const [
                                  FeedbackBottomSheet(
                                    arguments: {"type": 1},
                                  )
                                ]);
                              });
                        },
                        icon: const Icon(Icons.self_improvement_outlined,
                            size: 40))
                  ],
                ),*/
              ],
            ),
    ));
  }
}

// 新增運動
class AddPlanBottomSheet extends StatefulWidget {
  final Map arguments;

  const AddPlanBottomSheet({super.key, required this.arguments});

  @override
  AddPlanBottomSheetState createState() => AddPlanBottomSheetState();
}

class AddPlanBottomSheetState extends State<AddPlanBottomSheet> {
  int exerciseTime = 0;
  int meditationType = 1;
  int planToAdd = 0; // 0 = 運動, 1 = 冥想

  String time = "";
  bool isToday = true;

  late bool addWorkout;
  late bool addMeditation;

  List<Widget> _getTimeBtnList() {
    List<OutlinedButton> btnList = [];

    for (int i = 1; i <= 4; i++) {
      int choice = 15 * i;
      btnList.add(OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(
            color: Color(0xff4b4370),
          ),
          backgroundColor: (exerciseTime == choice)
              ? const Color(0xfff6cdb7)
              : const Color(0xfffdfdf5),
        ),
        onPressed: () {
          setState(() {
            exerciseTime = choice;
          });
        },
        child: Text(
          "$choice",
          style: const TextStyle(
            color: Color(0xff4b4370),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }
    return btnList;
  }

  List<Widget> _getMeditationTypeBtnList() {
    List meditationTypeList = ["正念禪", "工作禪", "慈心禪"];
    List<OutlinedButton> btnList = [];

    for (final type in meditationTypeList) {
      String choice = type;
      btnList.add(OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(
            color: Color(0xff4b4370),
          ),
          backgroundColor: (meditationTypeList[meditationType - 1] == choice)
              ? const Color(0xfff6cdb7)
              : const Color(0xfffdfdf5),
        ),
        onPressed: () {
          setState(() {
            meditationType = meditationTypeList.indexOf(choice) + 1;
          });
        },
        child: Text(
          choice,
          style: const TextStyle(
            color: Color(0xff4b4370),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }
    return btnList;
  }

  @override
  void initState() {
    super.initState();

    addWorkout = widget.arguments['addWorkout'];
    addMeditation = widget.arguments['addMeditation'];
    time = widget.arguments['time'];
    isToday = widget.arguments['isToday'];

    if (addWorkout && !addMeditation) {
      planToAdd = 0;
    } else if (!addWorkout && addMeditation) {
      planToAdd = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "新增$time的${((planToAdd == 0) ? "運動" : "冥想")}計畫",
              style: const TextStyle(
                  color: Color(0xff4b4370),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff4b4370), width: 2),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Color(0xff4b4370),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          (addWorkout && addMeditation)
              ? ToggleSwitch(
                  minWidth: MediaQuery.of(context).size.width,
                  //minHeight: 35,
                  initialLabelIndex: planToAdd,
                  cornerRadius: 10.0,
                  radiusStyle: true,
                  labels: const ['運動', '冥想'],
                  icons: const [
                    Icons.fitness_center_outlined,
                    Icons.self_improvement_outlined
                  ],
                  fontSize: 18,
                  iconSize: 20,
                  activeBgColors: const [
                    [Color(0xfff6cdb7)],
                    [Color(0xffd4d6fc)]
                  ],
                  activeFgColor: const Color(0xff4b4370),
                  inactiveBgColor: const Color(0xfffdfdf5),
                  inactiveFgColor: const Color(0xff4b4370),
                  totalSwitches: 2,
                  onToggle: (index) {
                    planToAdd = index!;
                    setState(() {});
                  },
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          (planToAdd == 0)
              ? Text(
                  "你要在$time新增幾分鐘的運動計畫呢？",
                  style:
                      const TextStyle(color: Color(0xff4b4370), fontSize: 18),
                )
              : Text(
                  "你要在$time新增什麼類型的冥想計畫呢？",
                  style:
                      const TextStyle(color: Color(0xff4b4370), fontSize: 18),
                ),
          const SizedBox(height: 10),
          (planToAdd == 0)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _getTimeBtnList(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _getMeditationTypeBtnList(),
                ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: (planToAdd == 0)
                    ? const Color(0xfff6cdb7)
                    : const Color(0xffd4d6fc),
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                DateTime selectedDay = widget.arguments['selectedDay'];
                (planToAdd == 0)
                    ? await PlanAlgo.generate(selectedDay, exerciseTime)
                    : await MeditationPlanAlgo.generate(
                        selectedDay, meditationType);

                print((planToAdd == 0)
                    ? "$selectedDay add $exerciseTime minutes exercise plan."
                    : "$selectedDay add $meditationType meditation plan.");
                if (!mounted) return;
                Navigator.pushNamed(context, "/");
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: Color(0xff4b4370),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 運動回饋
class FeedbackBottomSheet extends StatefulWidget {
  final Map arguments;

  const FeedbackBottomSheet({super.key, required this.arguments});

  @override
  FeedbackBottomSheetState createState() => FeedbackBottomSheetState();
}

class FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  int type = 0; // 0 = 運動, 1 = 冥想

  double satisfiedScore = 1; // Q1
  double tiredScore = 1; // Q2
  bool isAnxious = false; // Q3-1
  bool haveToSprint = false; // Q3-2
  bool isSatisfied = false; // Q3-3
  List<int> feedbackData = [];

  onSatisfiedScoreUpdate(rating) {
    setState(() {
      satisfiedScore = rating;
    });
  }

  onTiredScoreUpdate(rating) {
    setState(() {
      tiredScore = rating;
    });
  }

  @override
  void initState() {
    super.initState();
    type = widget.arguments["type"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "${(type == 0) ? "運動" : "冥想"}回饋",
              style: const TextStyle(
                  color: Color(0xff4b4370),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextLiquidFill(
            text: 'Well Done!',
            waveColor: const Color(0xffd4d6fc),
            boxBackgroundColor: const Color(0xfffdeed9),
            textStyle: const TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
            ),
            boxHeight: 80.0,
          ),
          const Divider(
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          Text(
            "是否滿意今天的${(type == 0) ? "運動" : "冥想"}計劃呢？",
            style: const TextStyle(
                color: Color(0xff4b4370),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          RatingScoreBar().getSatisfiedScoreBar(onSatisfiedScoreUpdate),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
          ),
          Text(
            (type == 0) ? "今天的運動計劃\n做起來是否會很疲憊呢？" : "今天的冥想計劃\n是否會太長或太短呢？",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xff4b4370),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          RatingScoreBar().getTiredScoreBar(onTiredScoreUpdate, type),
          (type == 0)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          (type == 0)
              ? Container()
              : const Divider(
                  thickness: 1.5,
                  indent: 20,
                  endIndent: 20,
                ),
          (type == 0)
              ? Container()
              : const Text(
                  "最近狀況調查",
                  style: TextStyle(
                      color: Color(0xff4b4370),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
          (type == 0)
              ? Container()
              : const SizedBox(
                  height: 10,
                ),
          (type == 0)
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "最近是否有憂慮、失眠、\n或是壓力大的情況？",
                            style: TextStyle(
                                color: Color(0xff4b4370), fontSize: 18),
                          ),
                          RoundCheckBox(
                            isChecked: isAnxious,
                            borderColor: const Color(0xff4b4370),
                            uncheckedColor: const Color(0xfffdfdf5),
                            checkedColor: const Color(0xfff6cdb7),
                            size: 30,
                            onTap: (selected) {
                              setState(() {
                                isAnxious = selected!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "最近是否有一個短期目標需要衝刺？",
                            style: TextStyle(
                                color: Color(0xff4b4370), fontSize: 18),
                          ),
                          RoundCheckBox(
                            isChecked: haveToSprint,
                            borderColor: const Color(0xff4b4370),
                            uncheckedColor: const Color(0xfffdfdf5),
                            checkedColor: const Color(0xfff6cdb7),
                            size: 30,
                            onTap: (selected) {
                              setState(() {
                                haveToSprint = selected!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "最近是否感到情感上的滿足？",
                            style: TextStyle(
                                color: Color(0xff4b4370), fontSize: 18),
                          ),
                          RoundCheckBox(
                            isChecked: isSatisfied,
                            borderColor: const Color(0xff4b4370),
                            uncheckedColor: const Color(0xfffdfdf5),
                            checkedColor: const Color(0xfff6cdb7),
                            size: 30,
                            onTap: (selected) {
                              setState(() {
                                isSatisfied = selected!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  )),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: const Color(0xfff6cdb7),
                shadowColor: Colors.transparent,
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (type == 0) {
                  feedbackData.add(satisfiedScore.toInt());
                  feedbackData.add(tiredScore.toInt());
                  print("Exercise feedbackData: $feedbackData");
                  /*Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => false);
                  var type = await PlanDB.getWorkoutType(DateTime.now());
                  if (type != null) {
                    UserDB.updateByFeedback(type, feedbackData);
                  }
                  await PlanAlgo.execute();*/
                } else {
                  feedbackData.add(satisfiedScore.toInt());
                  feedbackData.add(tiredScore.toInt());
                  // True = 1, false = 0
                  feedbackData.add((isAnxious) ? 1 : 0);
                  feedbackData.add((haveToSprint) ? 1 : 0);
                  feedbackData.add((isSatisfied) ? 1 : 0);

                  print("Meditation feedbackData: $feedbackData");
                }
                Navigator.pop(context);
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: Color(0xff4b4370),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]));
  }
}
