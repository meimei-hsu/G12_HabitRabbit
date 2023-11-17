import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/services/plan_algo.dart';
import 'package:g12/services/page_data.dart';
import 'package:g12/services/database.dart';

// TODO: Delete after page testing
import 'package:firebase_auth/firebase_auth.dart';
import 'exercise_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  GlobalKey calendarKey = GlobalKey();
  GlobalKey rabbitKey = GlobalKey();
  GlobalKey bubbleKey = GlobalKey();
  GlobalKey bannerKey = GlobalKey();

  // banner's controller
  int selectedPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    if (Data.isFirstTime) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context)
            .startShowCase([calendarKey, bubbleKey, rabbitKey, bannerKey]),
      );
    }
    Data.isFirstTime = false;
  }

  Widget getBanner() {
    List<String> imgNames = [];
    if (HomeData.workoutPlan != null) imgNames.add("Exercise_1.jpg");
    if (HomeData.meditationPlan != null) imgNames.add("Meditation_1.jpg");
    if (imgNames.isEmpty) imgNames.add("Rest.PNG");

    return GestureDetector(
      onTap: () {
        int type = (imgNames.length > 1)
            ? selectedPage
            : ["Exercise_1.jpg", "Meditation_1.jpg", "Rest.PNG"]
                .indexOf(imgNames.first);

        switch (type) {
          case 0:
            Navigator.pushNamed(context, '/detail/exercise');
            break;
          case 1:
            Navigator.pushNamed(context, '/detail/meditation');
            break;
          case 2:
            InformDialog().get(context, "提醒", "今日沒有計畫喔~\n請點選兔子以新增計畫").show();
            break;
        }
      },
      onLongPress: () {
        // selected plan's information
        int type = (imgNames.length > 1)
            ? selectedPage
            : ["Exercise_1.jpg", "Meditation_1.jpg", "Rest.PNG"]
                .indexOf(imgNames.first);
        String typeZH = (type == 0) ? "運動" : "冥想";
        String date =
            "${HomeData.selectedDay?.month} / ${HomeData.selectedDay?.day}";

        // functions
        changeDate() {
          if (!HomeData.isAfter && HomeData.selectedDay?.weekday == 6) {
            InformDialog()
                .get(context, "警告:(", "今天已經星期六囉~\n無法再將計畫換到別天了！")
                .show();
          } else {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                backgroundColor: ColorSet.bottomBarColor,
                context: context,
                builder: (context) {
                  return ChangeDayBottomSheet(arguments: {
                    "day": HomeData.selectedDay,
                    "isToday": HomeData.isToday,
                    "type": type
                  });
                });
          }
        }

        regenerate() {
          btnOkOnPress() {
            (type == 0)
                ? PlanAlgo.regenerateWorkout(HomeData.selectedDay!)
                : PlanAlgo.regenerateMeditation(HomeData.selectedDay!);
            setState(() {
              HomeData.isFetchingData = true;
            });
            Timer(const Duration(seconds: 5), () async {
              setState(() {
                HomeData.isFetchingData = false;
              });
              if (!mounted) return;
              InformDialog()
                  .get(context, "完成重新生成:)",
                      "${(HomeData.isToday) ? "今天" : date}的$typeZH計畫\n已經重新生成囉！")
                  .show();
            });
          }

          ConfirmDialog()
              .get(
                  context,
                  "你確定嗎？",
                  "確定要重新生成\n${(HomeData.isToday) ? "今天" : date}的$typeZH計畫嗎？",
                  btnOkOnPress)
              .show();
        }

        delete() {
          btnOkOnPress() async {
            (type == 0)
                ? await PlanDB.delete(
                    "workout", Calendar.dateToString(HomeData.selectedDay!))
                : await PlanDB.delete(
                    "meditation", Calendar.dateToString(HomeData.selectedDay!));
            if (!mounted) return;
            Navigator.pushNamed(context, "/");
          }

          ConfirmDialog()
              .get(
                  context,
                  "你確定嗎？",
                  "確定要刪除\n${(HomeData.isToday) ? "今天" : date}的$typeZH計畫嗎？",
                  btnOkOnPress)
              .show();
        }

        // popup menu dialog
        if (type == 2) {
          InformDialog().get(context, "提醒", "今日沒有計畫喔~\n請點選兔子以新增計畫").show();
        } else {
          if (!HomeData.isBefore) {
            String title = "$date $typeZH計畫";
            List<String> funcNames = ["修改日期", "重新計畫", "刪除計畫"];
            List<Function> functions = [changeDate, regenerate, delete];
            MenuDialog().get(context, title, funcNames, functions).show();
          } else {
            InformDialog().get(context, "錯誤:(", "無法修改以前的計畫").show();
          }
        }
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.33,
            margin: const EdgeInsets.only(left: 0, right: 0),
            decoration: BoxDecoration(
              border: Border.all(color: ColorSet.borderColor, width: 1.5),
            ),
            child: PageView.builder(
              controller: controller,
              onPageChanged: (int page) => setState(() => selectedPage = page),
              itemCount: imgNames.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset("assets/images/${imgNames[index]}",
                    fit: BoxFit.fill);
              },
            ),
          ),
          (imgNames.length > 1)
              ? Container(
                  alignment: Alignment.bottomCenter,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: PageViewDotIndicator(
                    currentItem: selectedPage,
                    count: imgNames.length,
                    unselectedColor: Colors.black26,
                    selectedColor: Colors.blueGrey,
                    duration: const Duration(milliseconds: 200),
                    boxShape: BoxShape.circle,
                    onItemClicked: (index) {
                      setState(() => selectedPage = index);
                      controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  String getDialogText() {
    String dialogText = "";

    if (HomeData.workoutPlan == null && HomeData.meditationPlan == null) {
      // 運動沒有、冥想沒有 --> 新增運動 + 冥想
      // 今天之後 --> 新增；之前 --> 沒有
      dialogText =
          (HomeData.isBefore) ? "沒有運動計畫\n沒有冥想計畫" : "沒有運動計畫\n沒有冥想計畫\n點兔兔新增計畫！";
    } else if (HomeData.workoutPlan != null &&
        HomeData.meditationPlan == null) {
      // 運動有、冥想沒有 --> 運動完成度、新增冥想
      // 今天之後 --> 運動完成度、新增冥想；之前 --> 運動完成度、沒有冥想
      dialogText = (HomeData.isBefore)
          ? "今日運動計畫已完成 ${HomeData.workoutProgress} %\n目前尚未安排任何冥想計畫，點選兔兔新增"
          : (HomeData.isToday)
              ? "今日運動計畫已完成 ${HomeData.workoutProgress} %\n${(HomeData.workoutProgress == 100) ? "很棒噢~~\n" : "繼續加油加油~~\n"}沒有冥想計畫，\n點選兔兔新增！"
              : "今日有運動計畫\n記得要來完成噢~\n點選兔兔新增冥想計畫！";
    } else if (HomeData.workoutPlan == null &&
        HomeData.meditationPlan != null) {
      // 運動沒有、冥想有 --> 冥想完成度、新增運動
      // 今天之後 --> 冥想完成度、新增運動；之前 --> 冥想完成度、沒有運動
      dialogText = (HomeData.isBefore)
          ? "今日冥想計畫已完成 ${HomeData.meditationProgress} %\n目前尚未安排任何運動計畫，點選兔兔新增"
          : (HomeData.isToday)
              ? "今日冥想計畫已完成 ${HomeData.meditationProgress} %\n${(HomeData.meditationProgress == 100) ? "有夠讚！\n" : "讓我們一起加油~\n"}今日尚未安排運動計畫，\n點選兔兔新增"
              : "今日有冥想計畫\n記得要來完成噢~\n點選兔兔新增運動計畫！";
    } else {
      // 運動有、冥想有 --> 運動完成度、冥想完成度
      // 今天之後 --> 運動完成度、冥想完成度；之前 --> 運動完成度、冥想完成度
      dialogText = (HomeData.isBefore)
          ? "今日運動計畫已完成 ${HomeData.workoutProgress} %\n今日冥想計畫已完成 ${HomeData.meditationProgress} %"
          : (HomeData.isToday)
              ? "今日運動計畫已完成 ${HomeData.workoutProgress} %\n今日冥想計畫已完成 ${HomeData.meditationProgress} %${(HomeData.workoutProgress == 100 && HomeData.meditationProgress == 100) ? "\n有夠讚！" : "\n讓我們一起加油~"}"
              : "今日有運動和冥想計畫\n記得要來完成噢~";
    }
    return dialogText;
  }

  void refresh() async {
    if (Data.updatingDB || Data.updatingUI[2]) await HomeData.fetch();
    setState(() {});
  }

  Color selectedColor = (DateTime(HomeData.selectedDay!.year,
              HomeData.selectedDay!.month, HomeData.selectedDay!.day) ==
          DateTime(
              HomeData.today.year, HomeData.today.month, HomeData.today.day))
      ? ColorSet.buttonColor
      : ColorSet.backgroundColor;

  void addPlan(){
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
          ? ErrorDialog()
          .get(context, "警告:(", "溯及既往 打咩！")
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
      (HomeData.isBefore)
          ? InformDialog()
          .get(context, "提示:)", "要繼續努力養成習慣噢！")
          .show()
          : (HomeData.workoutProgress == 100 &&
          HomeData.meditationProgress == 100)
          ? InformDialog()
          .get(context, "你太棒了", "今天的計畫都已經完成了！")
          .show()
          : InformDialog()
          .get(context, "提示:)", "要記得完成計畫噢！")
          .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorSet.backgroundColor,
      body: (HomeData.isFetchingData)
          ? Center(
              child: Container(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: ColorSet.bottomBarColor,
                    border: Border.all(color: ColorSet.bottomBarColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                ),
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Showcase(
                    key: calendarKey,
                    description: '可滑動觀看近兩週的計畫',
                    child: Container(
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
                    )),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Showcase(
                        key: bubbleKey,
                        description: '顯示選取日的計畫完成進度',
                        child: GestureDetector(
                          onTap: addPlan, // Image tapped
                          child: BubbleSpecialThree(
                          text:
                              'Hello ${Data.profile?["userName"]}～\n${getDialogText()}',
                          color: ColorSet.buttonColor,
                          tail: true,
                          textStyle: const TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),)
                      ),
                      Expanded(
                          child: Showcase(
                        key: rabbitKey,
                        description: '點選可以新增計畫以培養運動和冥想習慣',
                        child: GestureDetector(
                          onTap: addPlan, // Image tapped
                          onLongPress: () async => Data.refresh(),
                          child: Image.asset(
                            "assets/images/Rabbit_2.png",
                            width: 125,
                            height: 150,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Showcase(
                    key: bannerKey,
                    description: '點擊查看計畫內容，長按修改計畫資訊',
                    child: getBanner()),
                const SizedBox(height: 5),
                Row(children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/questionnaire",
                            arguments: {"part": 0});
                      },
                      icon: const Icon(Icons.sticky_note_2_outlined, size: 40)),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/contract/initial",
                            arguments: {});
                      },
                      icon:
                          const Icon(Icons.monetization_on_outlined, size: 40)),
                  IconButton(
                      onPressed: () {
                        ErrorDialog().get(context, "警告:(", "溯及既往 打咩！").show();
                      },
                      icon: const Icon(Icons.notifications_none_outlined,
                          size: 40)),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/pay', arguments: {
                          'user': FirebaseAuth.instance.currentUser,
                          'money': "100",
                        });
                      },
                      icon: const Icon(Icons.credit_card_outlined, size: 40)),
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
                            backgroundColor: ColorSet.bottomBarColor,
                            context: context,
                            builder: (context) {
                              return Wrap(children: const [
                                FeedbackBottomSheet(
                                  arguments: {"type": 0},
                                )
                              ]);
                            });
                      },
                      icon: const Icon(Icons.accessibility_outlined, size: 40)),
                  IconButton(
                      onPressed: () {
                        ShowCaseWidget.of(context).startShowCase(
                            [calendarKey, bubbleKey, rabbitKey, bannerKey]);
                      },
                      icon: const Icon(Icons.question_mark_outlined, size: 40)),
                ])
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
    List meditationTypeList = ["正念冥想", "工作冥想", "慈心冥想"];
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
                  "請選擇$time想新增的時間(分鐘)？",
                  style:
                      const TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              : Text(
                  "想在$time新增什麼類型的冥想計畫呢？",
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

// 修改計畫日
class ChangeDayBottomSheet extends StatefulWidget {
  final Map arguments;

  const ChangeDayBottomSheet({super.key, required this.arguments});

  @override
  ChangeDayBottomSheetState createState() => ChangeDayBottomSheetState();
}

class ChangeDayBottomSheetState extends State<ChangeDayBottomSheet> {
  late DateTime day;
  late bool isToday;
  late int type;

  late DateTime today;

  String changedDayWeekday = "";
  DateTime changedDayDate = DateTime.now();

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    day = getDateOnly(widget.arguments['day']);
    isToday = widget.arguments['isToday'];
    type = widget.arguments['type'];

    today = getDateOnly(DateTime.now());

    super.initState();
  }

  DateTime getDateOnly(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  List<Widget> _getAllowedDayList() {
    List<Widget> allowedDayList = [];
    List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];

    OutlinedButton getDayBtn(int i) {
      OutlinedButton dayBtn = OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(
            color: ColorSet.borderColor,
          ),
          backgroundColor: (changedDayWeekday == weekdayNameList[i])
              ? (type == 0)
                  ? ColorSet.exerciseColor
                  : ColorSet.meditationColor
              : ColorSet.backgroundColor,
        ),
        onPressed: () {
          setState(() {
            changedDayWeekday = weekdayNameList[i];
            changedDayDate = day
                .add(Duration(days: (day.weekday == 7) ? 1 : i - day.weekday));
          });
        },
        child: Text(
          weekdayNameList[i],
          style: const TextStyle(
            color: ColorSet.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      return dayBtn;
    }

    final today = Calendar.todayWeekday % 7;
    final selected = day.weekday % 7;
    // if todayWeekday > selectedWeekday, then the selectedDays is in the next week
    for (int i = (today > selected ? 0 : today); i < 7; i++) {
      if (i != selected) {
        allowedDayList.add(getDayBtn(i));
        allowedDayList.add(const SizedBox(width: 10));
      }
    }
    return allowedDayList;
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
              "修改${(isToday) ? "今天" : " ${day.month} / ${day.day} "}的${(type == 0) ? "運動" : "冥想"}計畫到別天",
              style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              /*decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 2),
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
          Text(
              "你要將${(isToday) ? "今天" : " ${day.month} / ${day.day} "}的${(type == 0) ? "運動" : "冥想"}計畫換到哪天呢？",
              style: const TextStyle(color: ColorSet.textColor, fontSize: 16)),
          const SizedBox(height: 10),
          // FIXME: Add padding between choice and scrollbar
          SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                child: ListView(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    children: _getAllowedDayList()),
              )),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: ColorSet.backgroundColor,
                shadowColor: Colors.transparent,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                // FIXME: 如果修改天數，換到已經有計畫的日子怎麼辦? (現在是直接蓋掉原本的)
                DateTime originalDate = day;
                (type == 0)
                    ? await PlanDB.updateDate(
                        "workout", originalDate, changedDayDate)
                    : await PlanDB.updateDate(
                        "meditation", originalDate, changedDayDate);
                debugPrint(
                    "Change $day's ${(type == 0) ? "workout plan" : "meditation plan"} to $changedDayDate 星期$changedDayWeekday.");
                if (!mounted) return;

                btnOkOnPress() {
                  Navigator.pushNamed(context, "/");
                  debugPrint("Change!!!");
                }

                InformDialog()
                    .get(context, "修改完成:)",
                        "已經將${(isToday) ? "今天" : " ${day.month} / ${day.day} "}的${(type == 0) ? "運動" : "冥想"}計畫\n換到 ${changedDayDate.month} / ${changedDayDate.day} 星期$changedDayWeekday囉！",
                        btnOkOnPress: btnOkOnPress)
                    .show();
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: ColorSet.textColor,
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
