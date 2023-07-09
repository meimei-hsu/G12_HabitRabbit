import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:g12/services/Database.dart';
import 'package:g12/services/PlanAlgo.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isFetchingData = true;

  @override
  void initState() {
    super.initState();
    getPlanData();
    getContractData();
  }

  void getPlanData() async {
    await PlanAlgo.execute();
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

  void getContractData() async {
    var contract = await ContractDB.getContractDetails();
    setState(() {
      contractData = contract ?? {};
    });
  }

  // Plan 相關資料
  Map workoutPlanList = {};
  Map progressList = {};
  List bothWeekWorkoutList = [];
  int currentIndex = 0;

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

  List<Widget> _getSportList(List content) {
    int length = content.length;

    // Generate the titles
    List title = [for (int i = 1; i <= length - 2; i++) "Round $i"];
    title.insert(0, "Warm up");
    title.insert(length - 1, "Cool down");

    List<ExpansionTile> expansionTitleList = [];
    for (int i = 0; i < length; i++) {
      List<ListTile> itemList = [
        for (int j = 0; j < content[i].length; j++)
          ListTile(
            title: Text('${content[i][j]}'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "${content[i][j]}",
                        style: const TextStyle(
                          color: Color(0xff0d3b66),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //content: Image.asset("assets/videos/${content[i][j]}.gif"),
                      content: Image.asset("assets/images/testPic.gif"),
                      actions: [
                        OutlinedButton(
                            child: const Text(
                              "返回",
                              style: TextStyle(
                                color: Color(0xff0d3b66),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    );
                  });
            },
          )
      ];

      // TODO: make prettier
      expansionTitleList.add(
        ExpansionTile(
          title: Text(
            '${title[i]}',
            style: const TextStyle(
                color: Color(0xff0d3b66),
                fontSize: 22,
                letterSpacing: 0,
                //percentages not used in flutter
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          children: itemList,
        ),
      );
    }
    return expansionTitleList;
  }

  Widget getAddExerciseBtn() {
    ElevatedButton addExerciseBtn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xfffaf0ca),
      ),
      onPressed: () {
        _showAddExerciseDialog();
      },
      child: const Text(
        "新增運動",
        style: TextStyle(
          color: Color(0xFF0D3B66),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return addExerciseBtn;
  }

  void _showAddExerciseDialog() async {
    await showDialog<double>(
      context: context,
      builder: (context) =>
          AddExerciseDialog(arguments: {"selectedDay": _selectedDay}),
    ).then((_) => refresh());
  }

  void _showChangeExerciseDayDialog() async {
    await showDialog<double>(
      context: context,
      builder: (context) =>
          ChangeExerciseDayDialog(arguments: {"selectedDay": _selectedDay}),
    ).then((_) => refresh());
  }

  void refresh() {
    getPlanData();
    setState(() {});
  }

  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  ShapeBorder? bottomBarShape = RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Scaffold(
           backgroundColor: Color(0xfffdfdf5),
         body: Column(
           children: [
             Container(
               color: const Color(0x193598f5),
               child: TableCalendar(
                 firstDay: firstDay,
                 lastDay: lastDay,
                 focusedDay: _focusedDay,
                 //startingDayOfWeek: StartingDayOfWeek.monday,
                 locale: 'zh_CN',
                 calendarFormat: CalendarFormat.week,
                 daysOfWeekHeight: 24,
                 daysOfWeekStyle: const DaysOfWeekStyle(
                   weekdayStyle: TextStyle(
                     color: Color(0xff0d3b66),
                     fontSize: 16,
                   ),
                   weekendStyle: TextStyle(
                     color: Color(0xff0d3b66),
                     fontSize: 16,
                   ),
                 ),
                 calendarStyle: CalendarStyle(
                   tablePadding: const EdgeInsets.only(
                       right: 10, left: 10, top: 10, bottom: 10),
                   todayDecoration: BoxDecoration(
                     color: const Color(0xffffa493),
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   todayTextStyle: const TextStyle(
                     color: Color(0xff0d3b66),
                     fontWeight: FontWeight.bold,
                     fontSize: 24,
                   ),
                   selectedDecoration: BoxDecoration(
                     color: const Color(0xfffbb87f),
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   selectedTextStyle: const TextStyle(
                     color: Color(0xff0d3b66),
                     fontWeight: FontWeight.bold,
                     fontSize: 24,
                   ),
                   defaultDecoration: BoxDecoration(
                     color: const Color(0xfffaf0ca),
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   defaultTextStyle: const TextStyle(
                     color: Color(0xff0d3b66),
                     fontWeight: FontWeight.bold,
                     fontSize: 24,
                   ),
                   weekendDecoration: BoxDecoration(
                     color: const Color(0xfffaf0ca),
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   weekendTextStyle: const TextStyle(
                     color: Color(0xff0d3b66),
                     fontWeight: FontWeight.bold,
                     fontSize: 24,
                   ),
                   outsideDecoration: BoxDecoration(
                     color: const Color(0xfffaf0ca),
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   outsideTextStyle: const TextStyle(
                     color: Color(0xff0d3b66),
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
             if (workoutPlanList[Calendar.toKey(_selectedDay!)] != null) ...[
               if (progressList[Calendar.toKey(_selectedDay!)] < 100 &&
                   _selectedDay!.isBefore(DateTime(_focusedDay.year,
                       _focusedDay.month, _focusedDay.day)) ==
                       false) ...[
                 Container(
                     padding: const EdgeInsets.only(right: 10),
                     height: 60,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         // TODO: Delete after line pay function connecting
                         Ink(
                           decoration: const ShapeDecoration(
                             color: Color(0x193598f5),
                             shape: CircleBorder(),
                           ),
                           child: IconButton(
                             icon: const Icon(Icons.bug_report_outlined),
                             iconSize: 40,
                             color: const Color(0xff0d3b66),
                             tooltip: "Line Pay Page",
                             onPressed: () async {
                               Navigator.pushNamed(context, '/pay',
                                   arguments: {'user': user});
                             },
                           ),
                         ),
                         const SizedBox(width: 10),
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
                             tooltip: "刪除計畫",
                             onPressed: () async {
                               await PlanDB.delete(
                                   Calendar.toKey(_selectedDay!));
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
                         )
                       ],
                     ))
               ] else ...[
                 Container()
               ]
             ] else ...[
               Container()
             ],
             const SizedBox(height: 10),
             if (progressList[Calendar.toKey(_selectedDay!)] != null) ...[
               (progressList[Calendar.toKey(_selectedDay!)] < 100)
                   ? Text(
                 "今天還有 ${100 - progressList[Calendar.toKey(_selectedDay!)]}% 的運動還沒完成噢~加油加油！",
                 textAlign: TextAlign.left,
                 style: const TextStyle(
                     color: Color(0xffffa493),
                     fontSize: 18,
                     letterSpacing: 0,
                     fontWeight: FontWeight.bold,
                     height: 1),
               )
                   : const Text(
                 "今天的運動都完成囉~很棒很棒！",
                 textAlign: TextAlign.left,
                 style: TextStyle(
                     color: Color(0xff5dbb63),
                     fontSize: 18,
                     letterSpacing: 0,
                     fontWeight: FontWeight.bold,
                     height: 1),
               ),
             ] else if (!isThisWeek) ...[
               (bothWeekWorkoutList.contains(Calendar.toKey(_selectedDay!)))
                   ? const Text("運動安排中...",
                   style: TextStyle(
                     color: Color(0xffffa493),
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ))
                   : const Text("Rest Day"),
             ] else ...[
               (isFetchingData)
                   ? const CircularProgressIndicator()
                   : const Text("Rest Day"),
             ],
             const SizedBox(height: 10),
             // (need check again) FIXME: 若運動都完成後 or 過期，不應該顯示新增運動按鈕？
             if (!isFetchingData) ...[
               if ((workoutPlanList[Calendar.toKey(_selectedDay!)] != null)) ...[
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.only(right: 10, left: 10),
                     child: ListView(
                       children: _getSportList(PlanDB.toList(
                           workoutPlanList[Calendar.toKey(_selectedDay!)])),
                     ),
                   ),
                 ),
               ] else if (!isThisWeek) ...[
                 (bothWeekWorkoutList.contains(Calendar.toKey(_selectedDay!)))
                     ? Container()
                     : getAddExerciseBtn(),
               ] else ...[
                 (_selectedDay!.isBefore(DateTime(
                     _focusedDay.year, _focusedDay.month, _focusedDay.day)))
                     ? Container()
                     : getAddExerciseBtn()
               ],
             ],
           ],
         ),

        //body:
        floatingActionButton: FloatingActionButton.large(
            onPressed: () {},
            backgroundColor: const Color(0xffffa493),
            child: Ink(
              decoration: const ShapeDecoration(
                //color: Color(0xffffa493),
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.play_arrow_rounded),
                iconSize: 80,
                color: const Color(0xff0d3b66),
                tooltip: "開始運動",
                onPressed: () {
                  if (progressList[Calendar.toKey(_focusedDay)] < 100) {
                    var workoutPlan =
                        workoutPlanList[Calendar.toKey(_focusedDay)];
                    List items = workoutPlan.split(", ");
                    for (int i = 0; i < items.length; i++) {
                      if (i <= 2) {
                        items[i] = "暖身：${items[i]}";
                      } else if (i >= items.length - 2) {
                        items[i] = "伸展：${items[i]}";
                      } else {
                        items[i] = "運動：${items[i]}";
                      }
                    }
                    Navigator.pushNamed(context, '/countdown', arguments: {
                      'totalExerciseItemLength': items.length,
                      'exerciseTime': items.sublist(currentIndex).length *
                          6, // should be 60s
                      'exerciseItem': items.sublist(currentIndex),
                      'currentIndex': currentIndex
                    });
                  } else {
                    MotionToast(
                      icon: Icons.done_all_rounded,
                      primaryColor: const Color(0xff5dbb63),
                      description: const Text(
                        "今天的運動都已經完成囉！",
                        style: TextStyle(
                          color: Color(0xff0d3b66),
                          fontSize: 17,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      position: MotionToastPosition.bottom,
                      animationType: AnimationType.fromBottom,
                      //displaySideBar: false,
                    ).show(context);
                  }
                },
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //centerDocked
        // FIXME: bottom bar overflow
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: snakeBarStyle,
          snakeShape: snakeShape,
          shape: bottomBarShape,
          padding: padding,
          height:80,
          backgroundColor:Color(0xfffdeed9),
          snakeViewColor:Color(0xfffdfdf5),
          selectedItemColor:Color(0xff4b3d70),
          unselectedItemColor:Color(0xff4b3d70),
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
           /* if(index == 4){
              Navigator.pushNamed(context, '/pay',
                  arguments: {'user': user});
            }*/
            print(index);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.insights,size: 40,), label: 'tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_outlined,size: 40,), label: 'calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined,size: 40,), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.request_quote_outlined,size: 40,), label: 'microphone'),
            BottomNavigationBarItem(icon: Icon(Icons.manage_accounts_outlined,size: 40,), label: 'search')
          ],
        )));
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "新增運動",
        style: TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("你要在 ${widget.arguments['selectedDay'].month}/"
              "${widget.arguments['selectedDay'].day} 新增幾分鐘的運動計畫呢？"),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
            width: double.maxFinite,
            child: ListView(
                scrollDirection: Axis.horizontal, children: _getTimeBtnList()),
          ),
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
              await PlanAlgo.generate(selectedDay, exerciseTime);
              print("$selectedDay add $exerciseTime minutes exercise plan.");
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
