import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:g12/services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/PlanAlgo.dart';

class Homepage extends StatefulWidget {
  //final Map arguments;
  final User user;
  const Homepage({super.key, required this.user});

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
            style: TextStyle(
                color: Color(0xff0d3b66),
                fontSize: 22,
                letterSpacing: 0, //percentages not used in flutter
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          children: itemList,
        ),
      );
    }

    return expansionTitleList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Today',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 32,
              letterSpacing: 0, //percentages not used in flutter
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [],
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
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
          Container(
              padding: const EdgeInsets.only(right: 10),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*
                  Container(
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Color(0xfffaf0ca),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: 40,
                        color: const Color(0xff0d3b66),
                        tooltip: "新增",
                        onPressed: () {},
                      ),
                    ),
                  ),*/
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
                          Algorithm.regenerate("Mary", _selectedDay!);
                        },
                      ),
                    ),
                  )
                ],
              )),
          const SizedBox(height: 10),
          FutureBuilder<String?>(
              // Exercise plan
              future: PlanDB.getPlanFromDate("Mary", _selectedDay!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // If snapshot has no error, return plan
                    String plan = snapshot.data ?? "";
                    if (plan.isNotEmpty) {
                      // Convert the String of plan into a List of workouts
                      List content = PlanDB.toList(plan);
                      int length = content.length;
                      // Generate the titles
                      List title = [
                        for (int i = 1; i <= length - 2; i++) "Round $i"
                      ];
                      title.insert(0, "Warm up");
                      title.insert(length - 1, "Cool down");

                      int umcompletedPercentage = 50;
                      // Return the plan information
                      return Expanded(
                          child: Column(
                        children: [
                          Text(
                            "今天還有 $umcompletedPercentage% 的運動還沒完成噢~加油加油！",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color(0xffffa493),
                                fontSize: 18,
                                letterSpacing:
                                    0, //percentages not used in flutter
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              child: ListView(
                                children: _getSportList(content, title),
                              ),
                            ),
                          ),
                        ],
                      ));
                    } else {
                      return const Text("Rest Day");
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
                  Navigator.pushNamed(context, '/countdown');
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
                        Navigator.pushNamed(context, '/statistic');
                      },
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      iconSize: 60,
                      color: Color(0xff0d3b66),
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
                decoration: BoxDecoration(
                  //to be better
                  color: Color(0x193598f5),
                ),
                accountName: Text(
                  "${widget.user.displayName}",
                  style: TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 24,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                accountEmail: Text(
                  "${widget.user.email}",
                  style: TextStyle(
                    color: Color(0xff0d3b66),
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    height: 1,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  //backgroundImage: NetworkImage(
                  //"https://avatars2.githubusercontent.com/u/18156421?s=400&u=1f91dcf74134827fde071751f95522845223ed6a&v=4",
                  //),
                  child: Icon(
                    Icons.face,
                    color: Color(0xffCCCCCC),
                  ),
                ),
                onDetailsPressed: () {
                  Navigator.popAndPushNamed(context, '/customized', arguments: {'user': widget.user});
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
                  Navigator.popAndPushNamed(context, '/constract');
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
