import 'package:flutter/material.dart';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
    const String banner1 = "assets/images/Exercise.jpg";
    const String banner2 = "assets/images/Meditation.jpg";

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
            height: 350,
            margin: const EdgeInsets.only(left: 5, right: 5),
            viewportFraction: 0.95,
            spaceBetween: 5,
            borderRadius: 10,
            activeColor: const Color(0xff4b3d70),
            disableColor: const Color(0xfff6cdb7),
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
                  //'currentIndex': currentIndex,
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
          (isBefore) ? "$time沒有運動計畫\n沒有冥想計畫" : "$time沒有運動計畫\n沒有冥想計畫\n點我新增計畫！";
    } else if (workoutPlan != null && meditationPlan == null) {
      // 運動有、冥想沒有 --> 運動完成度、新增冥想
      // 今天之後 --> 運動完成度、新增冥想；之前 --> 運動完成度、沒有冥想
      dialogText = (isBefore)
          ? "$time的運動計畫完成了 $workoutProgress %\n沒有冥想計畫"
          : (isToday)
              ? "$time的運動計畫已完成 $workoutProgress %\n${(workoutProgress == 100) ? "很棒噢~~\n" : "繼續加油加油~~\n"}沒有冥想計畫，點我新增！"
              : "$time有運動計畫\n記得要來完成噢~\n點我新增冥想計畫！";
    } else if (workoutPlan == null && meditationPlan != null) {
      // 運動沒有、冥想有 --> 冥想完成度、新增運動
      // 今天之後 --> 冥想完成度、新增運動；之前 --> 冥想完成度、沒有運動
      dialogText = (isBefore)
          ? "$time的冥想計畫完成了 $meditationProgress %\n沒有運動計畫"
          : (isToday)
              ? "$time的冥想計畫已完成 $meditationProgress %\n${(meditationProgress == 100) ? "很棒噢~~\n" : "繼續加油加油~~\n"}沒有運動計畫，點我新增！"
              : "$time有冥想計畫\n記得要來完成噢~\n點我新增運動計畫！";
    } else {
      // 運動有、冥想有 --> 運動完成度、冥想完成度
      // 今天之後 --> 運動完成度、冥想完成度；之前 --> 運動完成度、冥想完成度
      dialogText = (isBefore)
          ? "$time的運動計畫完成了 $workoutProgress %\n冥想計畫完成了 $meditationProgress %"
          : (isToday)
              ? "$time的運動計畫已完成 $workoutProgress %\n冥想計畫已完成 $meditationProgress %${(workoutProgress == 100 && meditationProgress == 100) ? "\n很棒噢~~" : "\n繼續加油加油~~"}"
              : "$time有運動和冥想計畫\n記得要來完成噢~";
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
      workoutPlan = workoutPlanList[Calendar.toKey(_selectedDay!)];
      workoutProgress = progressList[Calendar.toKey(_selectedDay!)];
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
      meditationPlan = meditationPlanList[Calendar.toKey(_selectedDay!)];
      meditationProgress =
          meditationProgressList[Calendar.toKey(_selectedDay!)];
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
      workoutPlan = workoutPlanList[Calendar.toKey(_selectedDay!)];
      workoutProgress = progressList[Calendar.toKey(_selectedDay!)];
      meditationPlan = meditationPlanList[Calendar.toKey(_selectedDay!)];
      meditationProgress =
          meditationProgressList[Calendar.toKey(_selectedDay!)];

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
      backgroundColor: const Color(0xfffdfdf5),
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
                  color: const Color(0xfffdfdf5), //日曆背景
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
                //const SizedBox(height: 10),
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
                          fontSize: 16,
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
                            "assets/images/rabbit.png",
                            width: 125,
                            height: 160,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                (workoutPlan != null || meditationPlan != null)
                    ? Expanded(child: getBannerCarousel())
                    : Container(),
                const SizedBox(height: 5),
                // TODO: delete after QuestionnairePage testing
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/questionnaire", arguments: {"part": 0});
                    },
                    icon: Icon(Icons.accessibility_outlined, size:40))
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
          shape: const CircleBorder(),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Color(0xff4b4370),
              ),
              // FIXME: setting border doesn't work
              style: IconButton.styleFrom(
                shape: const CircleBorder(
                    side: BorderSide(color: Color(0xff4b4370))),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
          // TODO: 新增冥想類型?
          (planToAdd == 0)
              ? Text(
                  "你要在$time新增幾分鐘的運動計畫呢？",
                  style:
                      const TextStyle(color: Color(0xff4b4370), fontSize: 16),
                )
              : Container(),
          (planToAdd == 0) ? const SizedBox(height: 10) : Container(),
          (planToAdd == 0)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _getTimeBtnList(),
                )
              : Container(),
          (planToAdd == 1)
              ? const Text(
                  "確定要新增冥想計畫嗎？",
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 16),
                )
              : Container(),
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
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                DateTime selectedDay = widget.arguments['selectedDay'];
                (planToAdd == 0)
                    ? await PlanAlgo.generate(selectedDay, exerciseTime)
                    : await MeditationPlanAlgo.generate(selectedDay);
                print((planToAdd == 0)
                    ? "$selectedDay add $exerciseTime minutes exercise plan."
                    : "$selectedDay add meditation plan.");
                if (!mounted) return;
                Navigator.pushNamed(context, "/");
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: Color(0xff4b4370),
                  fontSize: 18,
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
