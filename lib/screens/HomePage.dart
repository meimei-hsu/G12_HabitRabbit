import 'package:flutter/material.dart';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:motion_toast/motion_toast.dart';
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
  User? user = FirebaseAuth.instance.currentUser;
  bool isFetchingData = true;

  // Plan 相關資料
  Map workoutPlanList = {};
  Map progressList = {};
  List bothWeekWorkoutList = [];
  int currentIndex = 0;

  //Meditation Plan 相關資料
  Map meditationPlanList = {};
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

  Widget getBannerCarousel() {
    // TODO: 拉出重複部分
    var workoutPlan = workoutPlanList[Calendar.toKey(_selectedDay!)];
    var meditationPlan = meditationPlanList[Calendar.toKey(_selectedDay!)];

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
            //spaceBetween : 100,
            banners: listBanners,
            onTap: (id) async {
              print(id);
              // Exercise
              if (id == "1") {
                Navigator.pushNamed(context, '/detail/exercise', arguments: {
                  'user': user,
                  'isToday': (DateTime(_selectedDay!.year, _selectedDay!.month,
                              _selectedDay!.day) ==
                          _focusedDay)
                      ? true
                      : false,
                  'percentage': progressList[Calendar.toKey(_selectedDay!)],
                  'currentIndex': currentIndex,
                  'workoutPlan': workoutPlanList[Calendar.toKey(_selectedDay!)]
                });
              }

              // Meditation
              if (id == "2") {
                Navigator.pushNamed(context, '/detail/meditation', arguments: {
                  'user': user,
                  'isToday': (DateTime(_selectedDay!.year, _selectedDay!.month,
                              _selectedDay!.day) ==
                          _focusedDay)
                      ? true
                      : false,
                  'percentage':
                      meditationProgressList[Calendar.toKey(_selectedDay!)],
                  //'currentIndex': currentIndex,
                  'meditationPlan':
                      meditationPlanList[Calendar.toKey(_selectedDay!)]
                });
              }
            },
          )
        : Container();
  }

  String getDialogText() {
    String dialogText = "";

    var workoutPlan = workoutPlanList[Calendar.toKey(_selectedDay!)];
    var meditationPlan = meditationPlanList[Calendar.toKey(_selectedDay!)];

    var workoutProgress = progressList[Calendar.toKey(_selectedDay!)];
    var meditationProgress =
        meditationProgressList[Calendar.toKey(_selectedDay!)];

    bool isBefore =
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
            .isBefore(_focusedDay);
    bool isToday =
        (DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day) ==
            _focusedDay);

    String time =
        (isToday) ? "今天" : "${_selectedDay!.month} / ${_selectedDay!.day} ";

    if (workoutPlan == null && meditationPlan == null) {
      // 運動沒有、冥想沒有 --> 新增運動 + 冥想
      // 今天之後 --> 新增；之前 --> 沒有
      dialogText = (isBefore)
          ? "$time沒有運動計畫\n$time沒有冥想計畫"
          : "$time沒有運動計畫\n$time沒有冥想計畫\n點我新增計畫！";
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

  void _showAddExerciseDialog(
      bool needAddWorkoutPlan, bool needAddMeditation) async {
    await showDialog<double>(
      context: context,
      builder: (context) => AddExerciseDialog(arguments: {
        "selectedDay": _selectedDay,
        "addWorkout": needAddWorkoutPlan,
        "addMeditation": needAddMeditation
      }),
    ).then((_) => refresh());
  }

  void _showChangeExerciseDayDialog() async {
    await showDialog<double>(
      context: context,
      builder: (context) =>
          ChangeExerciseDayDialog(arguments: {"selectedDay": _selectedDay}),
    ).then((_) => refresh());
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
    });
    print("meditationPlanList: $meditationPlanList");
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
    getPlanData();
    getMeditationPlanData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xfffdfdf5),
      body: Column(
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
                  color: (DateTime(_selectedDay!.year, _selectedDay!.month,
                              _selectedDay!.day) ==
                          _focusedDay)
                      ? const Color(0xfff6cdb7)
                      : const Color(0xfffdeed9), //點到的天數顏色
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 5), // changes position of shadow
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
                }
              },
              onPageChanged: (focusedDay) {
                // 選第2頁的日期時不會跳回第一頁
                _focusedDay = focusedDay;
              },
            ),
          ),
          const SizedBox(height: 10),
          // TODO: 加入冥想判斷
          if (workoutPlanList[Calendar.toKey(_selectedDay!)] != null) ...[
            if (progressList[Calendar.toKey(_selectedDay!)] < 100 &&
                DateTime(_selectedDay!.year, _selectedDay!.month,
                            _selectedDay!.day)
                        .isBefore(_focusedDay) ==
                    false) ...[
              Container(
                  padding: const EdgeInsets.only(right: 10),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Color(0xfffaf0ca),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit_calendar_outlined),
                          iconSize: 40,
                          color: const Color(0xff0d3b66),
                          tooltip: "修改運動日",
                          onPressed: () {
                            _showChangeExerciseDayDialog();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // TODO: Delete after coding (實際無刪除功能, 測試方便而加)
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Color(0xfffbb87f),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          iconSize: 40,
                          color: const Color(0xff0d3b66),
                          tooltip: "刪除運動計畫",
                          onPressed: () async {
                            await PlanDB.delete(Calendar.toKey(_selectedDay!));
                            refresh();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Ink(
                        decoration: const ShapeDecoration(
                          color: Color(0xffffa493),
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.cached),
                          iconSize: 40,
                          color: const Color(0xff0d3b66),
                          tooltip: "重新計畫",
                          onPressed: () {
                            PlanAlgo.regenerate(_selectedDay!);
                            refresh();
                            MotionToast(
                              icon: Icons.done_all_rounded,
                              primaryColor: const Color(0xffffa493),
                              description: Text(
                                "${_selectedDay?.month}/"
                                "${_selectedDay?.day} 的運動計畫已經更新囉！",
                                style: const TextStyle(
                                  color: Color(0xff0d3b66),
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                              position: MotionToastPosition.bottom,
                              animationType: AnimationType.fromBottom,
                              animationCurve: Curves.bounceIn,
                              //displaySideBar: false,
                            ).show(context);
                          },
                        ),
                      ),
                      if (meditationPlanList[Calendar.toKey(_selectedDay!)] !=
                          null) ...[
                        if (meditationProgressList[
                                    Calendar.toKey(_selectedDay!)] <
                                100 &&
                            DateTime(_selectedDay!.year, _selectedDay!.month,
                                        _selectedDay!.day)
                                    .isBefore(_focusedDay) ==
                                false) ...[
                          const SizedBox(width: 10),
                          // TODO: Delete after coding (實際無刪除功能, 測試方便而加)
                          Ink(
                            decoration: const ShapeDecoration(
                              color: Color(0xff0d3b66),
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              iconSize: 40,
                              color: const Color(0xfffbb87f),
                              tooltip: "刪除冥想計畫",
                              onPressed: () async {
                                await MeditationPlanDB.delete(
                                    Calendar.toKey(_selectedDay!));
                                refresh();
                              },
                            ),
                          ),
                        ]
                      ]
                    ],
                  )),
            ] else ...[
              Container()
            ]
          ] else ...[
            Container()
          ],
          const SizedBox(height: 0),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                GestureDetector(
                  onTap: () {
                    var workoutPlan =
                        workoutPlanList[Calendar.toKey(_selectedDay!)];
                    var meditationPlan =
                        meditationPlanList[Calendar.toKey(_selectedDay!)];

                    bool isBefore = DateTime(_selectedDay!.year,
                            _selectedDay!.month, _selectedDay!.day)
                        .isBefore(_focusedDay);

                    if (workoutPlan == null && meditationPlan == null) {
                      // 運動沒有、冥想沒有 --> 新增運動 + 冥想
                      // 今天之後 --> 新增；之前 --> 沒有
                      (isBefore) ? null : _showAddExerciseDialog(true, true);
                    } else if (workoutPlan != null && meditationPlan == null) {
                      // 運動有、冥想沒有 --> 運動完成度、新增冥想
                      // 今天之後 --> 運動完成度、新增冥想；之前 --> 運動完成度、沒有冥想
                      (isBefore) ? null : _showAddExerciseDialog(false, true);
                    } else if (workoutPlan == null && meditationPlan != null) {
                      // 運動沒有、冥想有 --> 冥想完成度、新增運動
                      // 今天之後 --> 冥想完成度、新增運動；之前 --> 冥想完成度、沒有運動
                      (isBefore) ? null : _showAddExerciseDialog(true, false);
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
                )
              ],
            ),
          ),
          const SizedBox(height: 0),
          (workoutPlanList[Calendar.toKey(_selectedDay!)] != null ||
                  meditationPlanList[Calendar.toKey(_selectedDay!)] != null)
              ? getBannerCarousel()
              : Container(),
          const SizedBox(height: 10),
        ],
      ),
    ));
  }
}

// 新增運動
class AddExerciseDialog extends StatefulWidget {
  final Map arguments;

  const AddExerciseDialog({super.key, required this.arguments});

  @override
  AddExerciseDialogState createState() => AddExerciseDialogState();
}

class AddExerciseDialogState extends State<AddExerciseDialog> {
  int exerciseTime = 0;
  int planToAdd = 0; // 0 = 運動, 1 = 冥想

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
            color: Color(0xff0d3b66),
          ),
          backgroundColor: (exerciseTime == choice)
              ? const Color(0xffffa493)
              : Colors.white70,
        ),
        onPressed: () {
          setState(() {
            exerciseTime = choice;
          });
        },
        child: Text(
          "$choice",
          style: const TextStyle(
            color: Color(0xff0d3b66),
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

    if (addWorkout && !addMeditation) {
      planToAdd = 0;
    } else if (!addWorkout && addMeditation) {
      planToAdd = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "新增計畫",
        style: TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (addWorkout && addMeditation)
              ? Row(
                  children: [
                    const Text("新增 "),
                    ToggleSwitch(
                      minHeight: 35,
                      initialLabelIndex: planToAdd,
                      cornerRadius: 10.0,
                      radiusStyle: true,
                      labels: const ['運動', '冥想'],
                      icons: const [
                        Icons.fitness_center_outlined,
                        Icons.self_improvement_outlined
                      ],
                      iconSize: 16,
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
                    ),
                    const Text(" 計畫")
                  ],
                )
              : Container(),
          (planToAdd == 0)
              ? Text("你要在 ${widget.arguments['selectedDay'].month}/"
                  "${widget.arguments['selectedDay'].day} 新增幾分鐘的運動計畫呢？")
              : Container(),
          const SizedBox(height: 20),
          (planToAdd == 0)
              ? SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: double.maxFinite,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _getTimeBtnList()),
                )
              : Container(),
          (planToAdd == 1) ? const Text("確定要新增冥想計畫嗎？") : Container(),
        ],
      ),
      actions: [
        OutlinedButton(
            child: const Text(
              "取消",
              style: TextStyle(
                color: Color(0xff0d3b66),
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfffbb87f),
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
              Navigator.pop(context);
            },
            child: const Text(
              "確定",
              style: TextStyle(
                color: Color(0xff0d3b66),
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }
}

// TODO: 修改冥想日
// 修改運動日
class ChangeExerciseDayDialog extends StatefulWidget {
  final Map arguments;

  const ChangeExerciseDayDialog({super.key, required this.arguments});

  @override
  ChangeExerciseDayDialogState createState() => ChangeExerciseDayDialogState();
}

class ChangeExerciseDayDialogState extends State<ChangeExerciseDayDialog> {
  late DateTime selectedDay;
  late DateTime today;

  String changedDayWeekday = "";
  DateTime changedDayDate = DateTime.now();

  @override
  void initState() {
    selectedDay = getDateOnly(widget.arguments['selectedDay']);
    today = getDateOnly(Calendar.today());

    super.initState();
  }

  DateTime getDateOnly(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  List<Widget> _getAllowedDayList() {
    List<OutlinedButton> allowedDayList = [];
    List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];

    OutlinedButton getDayBtn(int i) {
      OutlinedButton dayBtn = OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: const BorderSide(
            color: Color(0xff0d3b66),
          ),
          backgroundColor: (changedDayWeekday == weekdayNameList[i])
              ? const Color(0xffffa493)
              : Colors.white70,
        ),
        onPressed: () {
          setState(() {
            changedDayWeekday = weekdayNameList[i];
            changedDayDate = widget.arguments['selectedDay'].add(Duration(
                days:
                    (selectedDay.weekday == 7) ? 1 : i - selectedDay.weekday));
          });
        },
        child: Text(
          weekdayNameList[i],
          style: const TextStyle(
            color: Color(0xff0d3b66),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return dayBtn;
    }

    if (selectedDay.weekday == 7) {
      for (int i = 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
      }
    } else if (selectedDay == today) {
      for (int i = selectedDay.weekday + 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
      }
    } else {
      for (int i = selectedDay.weekday + 1; i <= 6; i++) {
        allowedDayList.add(getDayBtn(i));
      }
      for (int i = selectedDay.weekday - 1; i >= 0; i--) {
        if (today.weekday != 7) {
          if (i >= today.weekday) {
            allowedDayList.insert(0, getDayBtn(i));
          }
        } else {
          allowedDayList.insert(0, getDayBtn(i));
        }
      }
    }
    return allowedDayList;
  }

  List<Widget> _getButtonList() {
    List<ElevatedButton> btnList = [];

    ElevatedButton cancelBtn = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          "取消",
          style: TextStyle(
            color: Color(0xff0d3b66),
            fontWeight: FontWeight.bold,
          ),
        ));
    ElevatedButton confirmBtn = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xfffbb87f),
        ),
        onPressed: () async {
          // FIXME: 如果修改天數，換到已經有計畫的日子怎麼辦? (現在是直接蓋掉原本的)
          DateTime originalDate = widget.arguments['selectedDay'];
          await PlanDB.updateDate(originalDate, changedDayDate);
          print("Change $selectedDay to $changedDayDate 星期$changedDayWeekday.");
          if (!mounted) return;
          Navigator.pop(context);
        },
        child: const Text(
          "確定",
          style: TextStyle(
            color: Color(0xff0d3b66),
            fontWeight: FontWeight.bold,
          ),
        ));
    ElevatedButton confirmBtn2 = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          "確認",
          style: TextStyle(
            color: Color(0xff0d3b66),
            fontWeight: FontWeight.bold,
          ),
        ));

    if (selectedDay.isBefore(today)) {
      btnList.add(confirmBtn2);
    } else {
      if (!selectedDay.isAfter(today) && selectedDay.weekday == 6) {
        btnList.add(confirmBtn2);
      } else if (selectedDay.isAfter(today) && selectedDay.weekday == 6) {
        btnList.add(confirmBtn2);
      } else {
        btnList.add(cancelBtn);
        btnList.add(confirmBtn);
      }
    }
    return btnList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "修改運動日",
        style: TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        if (selectedDay.isBefore(today)) ...[
          const Text(
            "逝者已矣，來者可追......\n認真運動吧！",
            textAlign: TextAlign.center,
          ),
        ] else ...[
          if (!selectedDay.isAfter(today) && selectedDay.weekday == 6) ...[
            const Text("今天已經星期六囉~無法再換到別天了！")
          ] else if (selectedDay.isAfter(today) &&
              selectedDay.weekday == 6) ...[
            const Text("星期六的計畫無法換到別天噢！")
          ] else ...[
            Text("你要將 ${widget.arguments['selectedDay'].month}/"
                "${widget.arguments['selectedDay'].day} 的運動計畫移到哪天呢？"),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              width: double.maxFinite,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _getAllowedDayList()),
            ),
          ]
        ]
      ]),
      actions: _getButtonList(),
    );
  }
}
