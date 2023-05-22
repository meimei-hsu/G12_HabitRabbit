import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:g12/services/Database.dart';
import 'package:g12/services/PlanAlgo.dart';

class Homepage extends StatefulWidget {
  final Map arguments;

  //final User user;
  //const Homepage({super.key, required this.user});
  const Homepage({super.key, required this.arguments});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _myKey = GlobalKey();

  // Calendar 相關設定
  DateTime _focusedDay = Calendar.today();
  DateTime? _selectedDay = Calendar.today();

  get firstDay => Calendar.firstDay();

  get lastDay => firstDay.add(const Duration(days: 13));

  // Local variable: workoutPlan
  String workoutPlan = "";

  bool isThisWeek() {
    DateFormat fmt = DateFormat('yyyy-MM-dd');
    String selectedDayDate = fmt.format(
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day));
    return (Calendar.thisWeek().contains(selectedDayDate)) ? true : false;
  }

  Future<bool> getWorkoutDay(int weekday) async {
    Map workoutDaysMap = {};
    Map? user = await UserDB.getUser(widget.arguments["user"].uid);
    List workoutDays = user!["workoutDays"].split('');
    for (int i = 0; i < workoutDays.length; i++) {
      workoutDaysMap["${i + 1}"] = workoutDays[i];
    }
    return (workoutDaysMap[weekday.toString()] == "1") ? true : false;
  }

  List<Widget> _getSportList(List content, List title) {
    int length = content.length;

    List<ExpansionTile> expansionTitleList = [];
    for (int i = 0; i < length; i++) {
      List<ListTile> itemList = [
        for (int j = 0; j < content[i].length; j++)
          ListTile(title: Text('${content[i][j]}'))
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

  void _showAddExerciseDialog() async {
    await showDialog<double>(
      context: context,
      builder: (context) => AddExerciseDialog(arguments: {
        'user': widget.arguments['user'],
        "selectedDay": _selectedDay
      }),
    ).then((_) => refresh());
  }

  void _showChangeExerciseDayDialog() async {
    await showDialog<double>(
      context: context,
      builder: (context) => ChangeExerciseDayDialog(arguments: {
        'user': widget.arguments['user'],
        "selectedDay": _selectedDay
      }),
    ).then((_) => refresh());
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${_selectedDay!.month}/${_selectedDay!.day} Plan',
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 32,
              letterSpacing: 0,
              //percentages not used in flutter
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: const [],
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, //關掉返回鍵
      ),
      body: Column(
        children: [
          Container(
            color: Color(0x193598f5),
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
          // TODO: To be better.....程式碼重複，maybe 參考 getWorkoutDay()?
          FutureBuilder<String?>(
              // Exercise plan
              future:
                  PlanDB.getByName(widget.arguments['user'].uid, _selectedDay!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // If snapshot has no error, return plan
                    workoutPlan = snapshot.data ?? "";
                    if (workoutPlan.isNotEmpty) {
                      return Container(
                          padding: const EdgeInsets.only(right: 10),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Ink(
                                  decoration: const ShapeDecoration(
                                    color: Color(0xfffaf0ca),
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.edit_calendar_outlined),
                                    iconSize: 40,
                                    color: const Color(0xff0d3b66),
                                    tooltip: "修改運動日",
                                    onPressed: () {
                                      _showChangeExerciseDayDialog();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                child: Ink(
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
                                      PlanAlgo.regenerate(
                                          widget.arguments['user'].uid,
                                          _selectedDay!);
                                      refresh();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ));
                    }
                    /*else if (ifThisWeek()) {
                      return Container();
                    }*/
                    else {
                      return Container();
                    }
                }
              }),
          const SizedBox(height: 10),
          // FIXME: 修改運動日後未更新
          FutureBuilder(
              // Exercise plan
              future: Future.wait([
                DurationDB.calcProgress(
                    widget.arguments['user'].uid, _selectedDay!),
                getWorkoutDay(_selectedDay!.weekday)
              ]),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // If snapshot has no error, return plan
                    // num? uncompletedPercentage = snapshot.data;
                    num? uncompletedPercentage = snapshot.data?[0] as num?;
                    bool? isWorkoutDay = snapshot.data?[1] as bool?;
                    if (uncompletedPercentage != null) {
                      // Return the plan information
                      if (uncompletedPercentage < 100) {
                        return Text(
                          "今天還有 $uncompletedPercentage% 的運動還沒完成噢~加油加油！",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Color(0xffffa493),
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        );
                      } else {
                        return const Text(
                          "今天的運動都完成囉~很棒很棒！",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff5dbb63),
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        );
                      }
                    } else if (!isThisWeek()) {
                      return (isWorkoutDay == true)
                          ? const Text(
                              "這天要運動噢！",
                              style: const TextStyle(
                                color: Color(0xffffa493),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text("Rest Day");
                    } else {
                      return const Text("Rest Day");
                    }
                }
              }),
          const SizedBox(height: 10),
          // FIXME: 若運動都完成後 or 過期，不應該顯示新增運動按鈕？
          FutureBuilder(
              // Exercise plan
              future: Future.wait([
                PlanDB.getByName(widget.arguments['user'].uid, _selectedDay!),
                getWorkoutDay(_selectedDay!.weekday)
              ]),
              /*future:
                  PlanDB.getByName(widget.arguments['user'].uid, _selectedDay!),*/
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // If snapshot has no error, return plan
                    String? plan = snapshot.data?[0] as String?;
                    workoutPlan = plan ?? "";
                    bool? isWorkoutDay = snapshot.data?[1] as bool?;

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

                    if (workoutPlan.isNotEmpty) {
                      // Convert the String of plan into a List of workouts
                      List content = PlanDB.toList(workoutPlan);
                      int length = content.length;
                      // Generate the titles
                      List title = [
                        for (int i = 1; i <= length - 2; i++) "Round $i"
                      ];
                      title.insert(0, "Warm up");
                      title.insert(length - 1, "Cool down");

                      // Return the plan information
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: ListView(
                            children: _getSportList(content, title),
                          ),
                        ),
                      );
                    } else if (!isThisWeek()) {
                      return (isWorkoutDay == true)
                          ? Container()
                          : addExerciseBtn;
                    } else {
                      return addExerciseBtn;
                      //return const Text("Generate Workout Button");
                    }
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
          backgroundColor: const Color(0xffffa493),
          child: Container(
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
                  List items = workoutPlan.split(", ");
                  Navigator.pushNamed(context, '/countdown', arguments: {
                    'user': widget.arguments['user'],
                    'exerciseTime': items.length * 6, // should be 60s
                    'exerciseItem': items
                  });
                },
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: const Color(0xfffaf0ca),
          shape: const CircularNotchedRectangle(),
          child: Container(
              color: const Color(0xfffaf0ca),
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: IconButton(
                      icon: const Icon(Icons.insights),
                      iconSize: 60,
                      color: const Color(0xff0d3b66),
                      tooltip: "統計資料",
                      onPressed: () {
                        Navigator.pushNamed(context, '/statistic',
                            arguments: {'user': widget.arguments['user']});
                      },
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      iconSize: 60,
                      color: const Color(0xff0d3b66),
                      tooltip: "選單",
                      onPressed: () => _myKey.currentState!.openEndDrawer(),
                    ),
                  ),
                ],
              ))),
      key: _myKey,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                //require email
                decoration: const BoxDecoration(
                  //to be better
                  color: Color(0x193598f5),
                ),
                accountName: Text(
                  "${widget.arguments['user'].displayName}",
                  style: const TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 24,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                accountEmail: Text(
                  "${widget.arguments['user'].email}",
                  style: const TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    height: 1,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                  //backgroundImage: NetworkImage(
                  //"https://avatars2.githubusercontent.com/u/18156421?s=400&u=1f91dcf74134827fde071751f95522845223ed6a&v=4",
                  //),
                  child: Icon(
                    Icons.face,
                    color: Color(0xffCCCCCC),
                  ),
                ),
                onDetailsPressed: () {
                  Navigator.popAndPushNamed(context, '/customized',
                      arguments: {'user': widget.arguments['user']});
                },
              ),
              ListTile(
                title: const Text(
                  '首頁',
                  style: TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, '/');
                  //點擊後做什麼事
                  //切換頁面
                  //收合drawer
                },
              ),
              ListTile(
                title: const Text(
                  '承諾合約',
                  style: TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                onTap: () {
                  // TODO: 判斷是否有立過合約，有 -> /constract；沒有 -> /constract/initial
                  Navigator.popAndPushNamed(context, '/constract/initial',
                      arguments: {'user': widget.arguments['user']});
                  //點擊後做什麼事
                  //切換頁面
                  //收合drawer
                },
              ),
              ListTile(
                title: const Text(
                  '客製計畫',
                  style: TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                onTap: () {
                  //點擊後做什麼事
                  //切換頁面
                  //收合drawer
                },
              ),
              ListTile(
                title: const Text(
                  '里程碑',
                  style: TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                onTap: () {
                  //點擊後做什麼事
                  //切換頁面
                  //收合drawer
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 新增運動
class AddExerciseDialog extends StatefulWidget {
  final Map arguments;

  const AddExerciseDialog({super.key, required this.arguments});

  @override
  _AddExerciseDialogState createState() => new _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
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
          Container(
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
            onPressed: () {
              // TODO: (backend) 新增運動
              print(
                  "${widget.arguments['selectedDay']} add $exerciseTime minutes exercise plan.");
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
  _ChangeExerciseDayDialogState createState() =>
      new _ChangeExerciseDayDialogState();
}

class _ChangeExerciseDayDialogState extends State<ChangeExerciseDayDialog> {
  late DateTime selectedDay;
  late DateTime today;

  String changedDayWeekday = "";
  DateTime changedDayDate = DateTime.now();

  @override
  void initState() {
    selectedDay = getDateOnly(widget.arguments['selectedDay']);
    today = getDateOnly(Calendar.today());
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
        if (i >= today.weekday) {
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
          backgroundColor: Color(0xfffbb87f),
        ),
        onPressed: () async {
          // TODO: (backend) 修改運動天數
          String uid = widget.arguments['user'].uid;
          DateTime originalDate = widget.arguments['selectedDay'];
          await PlanDB.updateDate(uid, originalDate, changedDayDate);
          print("Change $selectedDay to $changedDayDate 星期$changedDayWeekday.");
          Navigator.pop(context);
        },
        child: const Text(
          "確定",
          style: TextStyle(
            color: Color(0xff0d3b66),
            fontWeight: FontWeight.bold,
          ),
        ));

    if (selectedDay.isBefore(today)) {
      btnList.add(confirmBtn);
    } else {
      if (!selectedDay.isAfter(today) && selectedDay.weekday == 6) {
        btnList.add(confirmBtn);
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
          ] else ...[
            Text("你要將 ${widget.arguments['selectedDay'].month}/"
                "${widget.arguments['selectedDay'].day} 的運動計畫移到哪天呢？"),
            const SizedBox(height: 20),
            Container(
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
