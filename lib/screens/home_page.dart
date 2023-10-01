import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/services/plan_algo.dart';
import 'package:g12/services/page_data.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  Widget getBannerCarousel() {
    const String banner1 = "assets/images/Exercise_1.jpg";
    const String banner2 = "assets/images/Meditation_1.jpg";

    List<BannerModel> listBanners;

    if (HomeData.workoutPlan == null && HomeData.meditationPlan == null) {
      listBanners = [];
    } else if (HomeData.workoutPlan != null &&
        HomeData.meditationPlan == null) {
      listBanners = [BannerModel(imagePath: banner1, id: "1")];
    } else if (HomeData.workoutPlan == null &&
        HomeData.meditationPlan != null) {
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
              print("isToday: ${HomeData.isToday}");
              // Exercise
              if (id == "1") {
                Navigator.pushNamed(context, '/detail/exercise', arguments: {
                  'user': Data.user,
                  'day': HomeData.selectedDay,
                  'isToday': HomeData.isToday,
                  'isBefore': HomeData.isBefore,
                  'isAfter': HomeData.isAfter,
                  'percentage': HomeData.workoutProgress,
                  'currentIndex': HomeData.currentIndex,
                  'workoutPlan': HomeData.workoutPlan
                });
              }

              // Meditation
              if (id == "2") {
                Navigator.pushNamed(context, '/detail/meditation', arguments: {
                  'user': Data.user,
                  'day': HomeData.selectedDay,
                  'isToday': HomeData.isToday,
                  'isBefore': HomeData.isBefore,
                  'isAfter': HomeData.isAfter,
                  'percentage': HomeData.meditationProgress,
                  'meditationTime': Data.profile!["meditationTime"],
                  'meditationPlan': HomeData.meditationPlan
                });
              }
            },
          )
        : Container();
  }

  String getDialogText() {
    String dialogText = "";

    if (HomeData.workoutPlan == null && HomeData.meditationPlan == null) {
      // 運動沒有、冥想沒有 --> 新增運動 + 冥想
      // 今天之後 --> 新增；之前 --> 沒有
      dialogText =
          (HomeData.isBefore) ? "沒有運動計畫\n沒有冥想計畫" : "沒有運動計畫\n沒有冥想計畫\n點我新增計畫！";
    } else if (HomeData.workoutPlan != null &&
        HomeData.meditationPlan == null) {
      // 運動有、冥想沒有 --> 運動完成度、新增冥想
      // 今天之後 --> 運動完成度、新增冥想；之前 --> 運動完成度、沒有冥想
      dialogText = (HomeData.isBefore)
          ? "運動計畫完成了 ${HomeData.workoutProgress} %\n沒有冥想計畫"
          : (HomeData.isToday)
              ? "運動計畫已完成 ${HomeData.workoutProgress} %\n${(HomeData.workoutProgress == 100) ? "很棒噢~~\n" : "繼續加油加油~~\n"}沒有冥想計畫，點我新增！"
              : "有運動計畫\n記得要來完成噢~\n點我新增冥想計畫！";
    } else if (HomeData.workoutPlan == null &&
        HomeData.meditationPlan != null) {
      // 運動沒有、冥想有 --> 冥想完成度、新增運動
      // 今天之後 --> 冥想完成度、新增運動；之前 --> 冥想完成度、沒有運動
      dialogText = (HomeData.isBefore)
          ? "冥想計畫完成了 ${HomeData.meditationProgress} %\n沒有運動計畫"
          : (HomeData.isToday)
              ? "冥想計畫已完成 ${HomeData.meditationProgress} %\n${(HomeData.meditationProgress == 100) ? "很棒噢~~\n" : "繼續加油加油~~\n"}沒有運動計畫，點我新增！"
              : "有冥想計畫\n記得要來完成噢~\n點我新增運動計畫！";
    } else {
      // 運動有、冥想有 --> 運動完成度、冥想完成度
      // 今天之後 --> 運動完成度、冥想完成度；之前 --> 運動完成度、冥想完成度
      dialogText = (HomeData.isBefore)
          ? "運動計畫完成了 ${HomeData.workoutProgress} %\n冥想計畫完成了 ${HomeData.meditationProgress} %"
          : (HomeData.isToday)
              ? "運動計畫已完成 ${HomeData.workoutProgress} %\n冥想計畫已完成 ${HomeData.meditationProgress} %${(HomeData.workoutProgress == 100 && HomeData.meditationProgress == 100) ? "\n很棒噢~~" : "\n繼續加油加油~~"}"
              : "有運動和冥想計畫\n記得要來完成噢~";
    }
    return dialogText;
  }

  void refresh() async {
    if (Data.updated) await HomeData.fetch();
    setState(() {});
  }

  Color selectedColor = ColorSet.buttonColor;

  @override
  Widget build(BuildContext context) {
    refresh();
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorSet.backgroundColor,
      body: (Data.updated)
          ? Center(
              child: Container(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: ColorSet.bottomBarColor,
                      border: Border.all(color: ColorSet.bottomBarColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingAnimationWidget.horizontalRotatingDots(
                        color: ColorSet.textColor,
                        size: 100,
                      ),
                      const Text(
                        "重新整理中...",
                        style: TextStyle(
                          color: ColorSet.textColor,
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
                  color: ColorSet.backgroundColor, //日曆背景
                  child: TableCalendar(
                    firstDay: HomeData.firstDay,
                    lastDay: HomeData.lastDay,
                    focusedDay: HomeData.focusedDay,
                    //startingDayOfWeek: StartingDayOfWeek.monday,
                    //locale: 'zh_CN',
                    calendarFormat: CalendarFormat.week,
                    daysOfWeekHeight: 24,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 16,
                      ),
                      weekendStyle: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 16,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      tablePadding: const EdgeInsets.only(
                          right: 10, left: 10, top: 10, bottom: 10),
                      todayDecoration: BoxDecoration(
                        color: ColorSet.buttonColor, //今天顏色
                        border: Border.all(color: ColorSet.borderColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      todayTextStyle: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: selectedColor, //點到的天數顏色
                        border: Border.all(color: ColorSet.borderColor),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: ColorSet.borderColor.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(
                                0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      selectedTextStyle: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      defaultDecoration: BoxDecoration(
                        //color: const Color(0xfffdeed9),
                        border: Border.all(color: ColorSet.borderColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      defaultTextStyle: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      weekendDecoration: BoxDecoration(
                        //color: const Color(0xfffdeed9),
                        border: Border.all(color: ColorSet.borderColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      weekendTextStyle: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      outsideDecoration: BoxDecoration(
                        //color: const Color(0xfffdeed9),
                        border: Border.all(color: ColorSet.borderColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      outsideTextStyle: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    headerVisible: false,
                    selectedDayPredicate: (day) {
                      return isSameDay(HomeData.selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      print("focusedDay: $focusedDay");
                      // 選中的日期變成橘色
                      if (!isSameDay(HomeData.selectedDay, selectedDay)) {
                        setState(() {
                          HomeData.selectedDay = selectedDay;
                        });
                        HomeData.setSelectedDay();
                        setState(() {});
                      }

                      DateTime today = DateTime(HomeData.today.year,
                          HomeData.today.month, HomeData.today.day);
                      DateTime sDay = DateTime(selectedDay.year,
                          selectedDay.month, selectedDay.day);
                      setState(() {
                        selectedColor = (sDay == today)
                            ? ColorSet.buttonColor
                            : ColorSet.backgroundColor;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      // 選第2頁的日期時不會跳回第一頁
                      HomeData.focusedDay = focusedDay;
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
                        text:
                            'Hello ${Data.user!.displayName}～\n${getDialogText()}',
                        color: ColorSet.buttonColor,
                        tail: true,
                        textStyle: const TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("workoutPlan: ${HomeData.workoutPlan}");
                            debugPrint(
                                "meditationPlan: ${HomeData.meditationPlan}");
                            debugPrint("isBefore: ${HomeData.isBefore}");
                            debugPrint("_selectedDay: ${HomeData.selectedDay}");
                            debugPrint("_focusedDay: ${HomeData.focusedDay}");
                            debugPrint(DateTime(
                                    HomeData.selectedDay!.year,
                                    HomeData.selectedDay!.month,
                                    HomeData.selectedDay!.day)
                                .toString());
                            if (HomeData.workoutPlan == null &&
                                HomeData.meditationPlan == null) {
                              // 運動沒有、冥想沒有 --> 新增運動 + 冥想
                              // 今天之後 --> 新增；之前 --> 沒有
                              (HomeData.isBefore)
                                  ? InformDialog()
                                      .get(context, ":(", "溯及既往 打咩！")
                                      .show()
                                  : showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20)),
                                      ),
                                      backgroundColor: ColorSet.bottomBarColor,
                                      context: context,
                                      builder: (context) {
                                        return AddPlanBottomSheet(arguments: {
                                          "selectedDay": HomeData.selectedDay,
                                          "addWorkout": true,
                                          "addMeditation": true,
                                          "time": HomeData.time,
                                          "isToday": HomeData.isToday
                                        });
                                      });
                            } else if (HomeData.workoutPlan != null &&
                                HomeData.meditationPlan == null) {
                              // 運動有、冥想沒有 --> 運動完成度、新增冥想
                              // 今天之後 --> 運動完成度、新增冥想；之前 --> 運動完成度、沒有冥想
                              (HomeData.isBefore)
                                  ? InformDialog()
                                      .get(context, ":(", "溯及既往 打咩！")
                                      .show()
                                  : showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20)),
                                      ),
                                      backgroundColor: ColorSet.bottomBarColor,
                                      context: context,
                                      builder: (context) {
                                        return AddPlanBottomSheet(arguments: {
                                          "selectedDay": HomeData.selectedDay,
                                          "addWorkout": false,
                                          "addMeditation": true,
                                          "time": HomeData.time,
                                          "isToday": HomeData.isToday
                                        });
                                      });
                            } else if (HomeData.workoutPlan == null &&
                                HomeData.meditationPlan != null) {
                              // 運動沒有、冥想有 --> 冥想完成度、新增運動
                              // 今天之後 --> 冥想完成度、新增運動；之前 --> 冥想完成度、沒有運動
                              (HomeData.isBefore)
                                  ? InformDialog()
                                      .get(context, ":(", "溯及既往 打咩！")
                                      .show()
                                  : showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20)),
                                      ),
                                      backgroundColor: ColorSet.bottomBarColor,
                                      context: context,
                                      builder: (context) {
                                        return AddPlanBottomSheet(arguments: {
                                          "selectedDay": HomeData.selectedDay,
                                          "addWorkout": true,
                                          "addMeditation": false,
                                          "time": HomeData.time,
                                          "isToday": HomeData.isToday
                                        });
                                      });
                            } else {
                              // 運動有、冥想有 --> 運動完成度、冥想完成度
                              // 今天之後 --> 運動完成度、冥想完成度；之前 --> 運動完成度、冥想完成度
                              (HomeData.isBefore) ? null : null;
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
                (HomeData.workoutPlan != null ||
                        HomeData.meditationPlan != null)
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
            color: ColorSet.borderColor,
          ),
          backgroundColor: (exerciseTime == choice)
              ? ColorSet.exerciseColor
              : ColorSet.backgroundColor,
        ),
        onPressed: () {
          setState(() {
            exerciseTime = choice;
          });
        },
        child: Text(
          "$choice",
          style: const TextStyle(
            color: ColorSet.textColor,
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
            color: ColorSet.textColor,
          ),
          backgroundColor: (meditationTypeList[meditationType - 1] == choice)
              ? ColorSet.meditationColor
              : ColorSet.backgroundColor,
        ),
        onPressed: () {
          setState(() {
            meditationType = meditationTypeList.indexOf(choice) + 1;
          });
        },
        child: Text(
          choice,
          style: const TextStyle(
            color: ColorSet.textColor,
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
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              /*decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff4b4370), width: 2),
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
                tooltip: "關閉",
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
                    [ColorSet.exerciseColor],
                    [ColorSet.meditationColor]
                  ],
                  activeFgColor: ColorSet.textColor,
                  inactiveBgColor: ColorSet.backgroundColor,
                  inactiveFgColor: ColorSet.textColor,
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
                      const TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              : Text(
                  "你要在$time新增什麼類型的冥想計畫呢？",
                  style:
                      const TextStyle(color: ColorSet.textColor, fontSize: 18),
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
                // FIXME: 感覺白底按鈕不是很明顯？還是加邊框？
                //side: const BorderSide(color: ColorSet.borderColor, width: 2),
                //BorderSide(color: (planToAdd == 0)?ColorSet.exerciseColor:ColorSet.meditationColor, width: 3),
                backgroundColor: (planToAdd == 0)
                    // FIXME: 需要區分exercise和meditation顏色嗎
                    ? ColorSet.backgroundColor
                    : ColorSet.backgroundColor,
                shadowColor: ColorSet.borderColor,
                //elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                // FIXME: 新增運動計畫有錯誤：Null check operator used on a null value
                // FIXME: 新增冥想計畫有錯誤：NoSuchMethodError: The method '[]' was called on null.
                DateTime selectedDay = widget.arguments['selectedDay'];
                (planToAdd == 0)
                    ? await PlanAlgo.generateWorkout(selectedDay, exerciseTime)
                    : await PlanAlgo.generateMeditation(
                        selectedDay, meditationType);

                debugPrint((planToAdd == 0)
                    ? "$selectedDay add $exerciseTime minutes exercise plan."
                    : "$selectedDay add $meditationType meditation plan.");
                if (!mounted) return;
                Navigator.pushNamed(context, "/");
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: ColorSet.textColor,
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

// TODO: Delete after feedback testing
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
  bool haveToSdebugPrint = false; // Q3-2
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
                            isChecked: haveToSdebugPrint,
                            borderColor: const Color(0xff4b4370),
                            uncheckedColor: const Color(0xfffdfdf5),
                            checkedColor: const Color(0xfff6cdb7),
                            size: 30,
                            onTap: (selected) {
                              setState(() {
                                haveToSdebugPrint = selected!;
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
                  debugPrint("Exercise feedbackData: $feedbackData");
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
                  feedbackData.add((haveToSdebugPrint) ? 1 : 0);
                  feedbackData.add((isSatisfied) ? 1 : 0);

                  debugPrint("Meditation feedbackData: $feedbackData");
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
