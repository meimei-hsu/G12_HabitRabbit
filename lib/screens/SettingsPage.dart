import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';

import 'package:g12/services/Database.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class SettingsPage extends StatefulWidget {
  final Map arguments;

  const SettingsPage({super.key, required this.arguments});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  User user = FirebaseAuth.instance.currentUser!;

  //運動初始值
  num timeSpan = 0;
  List workoutDays = [];
  Map likings = {};

  void getPlanData() async {
    var planVariables = await UserDB.getPlanVariables();
    timeSpan = planVariables![1]["timeSpan"];
    workoutDays = planVariables[1]["workoutDays"];
    likings = planVariables[2];
  }

  @override
  void initState() {
    super.initState();
    getPlanData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "個人設定",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 32,
              letterSpacing: 0,
              //percentages not used in flutter
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // user card
            SimpleUserCard(
              userName: user.displayName!,
              userProfilePic: const NetworkImage(
                  "https://pokoloruj.com.pl/static/gallery/gwiazdy-pop/yr3ylitu.png"),
            ),
            SettingsGroup(
              settingsGroupTitle: "計畫",
              items: [
                SettingsItem(
                  onTap: () => showDialog<double>(
                          context: context,
                          builder: (context) => ChangeTimeDialog(
                              arguments: {"timeSpan": timeSpan}))
                      .then((_) => getPlanData()),
                  icons: CupertinoIcons.timer,
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xff0d3b66),
                    withBackground: true,
                    backgroundColor: const Color(0xfffaf0ca),
                  ),
                  title: '運動時長',
                  subtitle: "更改每次運動計畫的長度",
                ),
                SettingsItem(
                  onTap: () => showDialog<double>(
                          context: context,
                          builder: (context) => ChangeDayDialog(
                              arguments: {"workoutDays": workoutDays}))
                      .then((_) => getPlanData()),
                  icons: Icons.calendar_today_outlined,
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xff0d3b66),
                    withBackground: true,
                    backgroundColor: const Color(0xfffaf0ca),
                  ),
                  title: '周運動日',
                  subtitle: "更改每周可以運動的日子",
                ),
                SettingsItem(
                  onTap: () => showDialog<double>(
                          context: context,
                          builder: (context) => ChangeLikingDialog(
                              arguments: {"likings": likings}))
                      .then((_) => getPlanData()),
                  icons: CupertinoIcons.heart_circle,
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xff0d3b66),
                    withBackground: true,
                    backgroundColor: const Color(0xfffaf0ca),
                  ),
                  title: '運動偏好',
                  subtitle: "更改每類運動的喜愛程度",
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "個人",
              items: [
                SettingsItem(
                  onTap: () => {},
                  icons: CupertinoIcons.textformat_alt,
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xff0d3b66),
                    withBackground: true,
                    backgroundColor: const Color(0xfffaf0ca),
                  ),
                  title: '更改暱稱',
                ),
                SettingsItem(
                    onTap: () => {},
                    icons: Icons.email_outlined,
                    iconStyle: IconStyle(
                      iconsColor: const Color(0xff0d3b66),
                      withBackground: true,
                      backgroundColor: const Color(0xfffaf0ca),
                    ),
                    title: '更改信箱'),
                SettingsItem(
                  onTap: () => {},
                  icons: CupertinoIcons.photo_on_rectangle,
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xff0d3b66),
                    withBackground: true,
                    backgroundColor: const Color(0xfffaf0ca),
                  ),
                  title: '更改照片',
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "其他",
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xff0d3b66),
                    withBackground: true,
                    backgroundColor: const Color(0xfffaf0ca),
                  ),
                  title: '夜間模式',
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "帳號",
              items: [
                SettingsItem(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.popAndPushNamed(context, '/register');
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "登出帳號",
                ),
                SettingsItem(
                  onTap: () {},
                  icons: CupertinoIcons.delete_solid,
                  title: "刪除帳號",
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class ChangeTimeDialog extends StatefulWidget {
  final Map arguments;

  const ChangeTimeDialog({super.key, required this.arguments});

  @override
  ChangeTimeDialogState createState() => ChangeTimeDialogState();
}

class ChangeTimeDialogState extends State<ChangeTimeDialog> {
  int exerciseTime = 0;

  @override
  initState() {
    super.initState();
    exerciseTime = widget.arguments['timeSpan'];
  }

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
        "運動時長(分鐘)",
        style: TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
              num original = widget.arguments['timeSpan'];
              num modified = exerciseTime;
              if (original != modified) {
                await UserDB.update({"timeSpan": modified});
              }
              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: const Text(
                  "運動時長已更新",
                  style: TextStyle(
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

class ChangeDayDialog extends StatefulWidget {
  final Map arguments;

  const ChangeDayDialog({super.key, required this.arguments});

  @override
  ChangeDayDialogState createState() => ChangeDayDialogState();
}

class ChangeDayDialogState extends State<ChangeDayDialog> {
  List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];
  List selectedDays = [];
  List selectedNames = [];

  @override
  initState() {
    super.initState();
    selectedDays = List.from(widget.arguments['workoutDays']);
    selectedNames = [
      for (int i = 0; i < 7; i++)
        if (widget.arguments['workoutDays'][i] == 1) weekdayNameList[i]
    ];
  }

  List<Widget> _getDayBtnList() {
    List<OutlinedButton> btnList = [];

    for (int i = 0; i < 7; i++) {
      btnList.add(OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: const BorderSide(
            color: Color(0xff0d3b66),
          ),
          backgroundColor: (selectedNames.contains(weekdayNameList[i]))
              ? const Color(0xffffa493)
              : Colors.white70,
        ),
        onPressed: () {
          String choice = weekdayNameList[i];
          if (selectedNames.contains(choice)) {
            setState(() {
              selectedNames.remove(choice);
              selectedDays[i] = 0;
            });
          } else {
            setState(() {
              selectedNames.add(choice);
              selectedDays[i] = 1;
            });
          }
        },
        child: Text(
          weekdayNameList[i],
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
        "每周運動日",
        style: TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
            width: double.maxFinite,
            child: ListView(
                scrollDirection: Axis.horizontal, children: _getDayBtnList()),
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
              String original = widget.arguments['workoutDays'].join("");
              String modified = selectedDays.join("");
              if (original != modified) {
                await UserDB.update({"workoutDays": modified});
              }
              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: const Text(
                  "周運動日已更新",
                  style: TextStyle(
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

class ChangeLikingDialog extends StatefulWidget {
  final Map arguments;

  const ChangeLikingDialog({super.key, required this.arguments});

  @override
  ChangeLikingDialogState createState() => ChangeLikingDialogState();
}

class ChangeLikingDialogState extends State<ChangeLikingDialog> {
  Map<String, num> likings = {};
  List<String> category = ["肌力運動", "有氧運動", "瑜珈運動"];
  Map<String, IconData> icons = {
    "肌力運動": Icons.fitness_center,
    "有氧運動": Icons.directions_run,
    "瑜珈運動": Icons.self_improvement
  };
  List<String> key = ["strengthLiking", "cardioLiking", "yogaLiking"];
  String dropdownValue = "";

  @override
  initState() {
    super.initState();
    likings = Map.from(widget.arguments['likings']);
    dropdownValue = category.first;
  }

  Widget _getSlider(int i) {
    var currentValue = likings[key[i]]! / 20;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Slider(
        value: currentValue,
        min: 0,
        max: 5,
        divisions: 50,
        onChanged: (value) {
          setState(() {
            likings[key[i]] = value * 20;
          });
        },
      ),
      Text(
        currentValue.toStringAsFixed(1),
        textAlign: TextAlign.right,
        style: const TextStyle(
            color: Color(0xff0d3b66),
            fontSize: 15,
            fontWeight: FontWeight.normal,
            height: 1),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "運動偏好(0~5分)",
        style: TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down_outlined),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: category.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Icon(icons[value]),
                    const SizedBox(width: 5),
                    Text(value),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
            width: double.maxFinite,
            child: _getSlider(category.indexOf(dropdownValue)),
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
              Map original = widget.arguments['likings'];
              Map<String, Object> modified = likings;
              if (original != modified) {
                await UserDB.update(modified);
              }
              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: const Text(
                  "運動偏好已更新",
                  style: TextStyle(
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
