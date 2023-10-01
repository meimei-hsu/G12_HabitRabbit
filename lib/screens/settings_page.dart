import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:g12/screens/page_material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import 'package:g12/services/database.dart';

import '../services/authentication.dart';
import '../services/page_data.dart';

IconStyle iconStyle = IconStyle(
  iconsColor: ColorSet.iconColor,
  withBackground: true,
  backgroundColor: ColorSet.bottomBarColor,
);

// UI Layout
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Future<void> refresh() async {
    if (Data.updated) await SettingsData.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return MaterialApp(
        home: Scaffold(
      backgroundColor: ColorSet.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "個人設定",
          textAlign: TextAlign.left,
          style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 32,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        backgroundColor: ColorSet.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // user card
            SimpleUserCard(
              userName: Data.user!.displayName!,
              userProfilePic: AssetImage(Data.characterImageURL),
            ),
            SettingsGroup(
              settingsGroupTitle: "運動",
              items: [
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingWorkout();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeDurationDialog());
                  },
                  icons: CupertinoIcons.timer,
                  iconStyle: iconStyle,
                  title: '運動時長',
                  subtitle: "更改每次運動計畫的長度",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingWorkout();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeDayDialog());
                  },
                  icons: Icons.calendar_today_outlined,
                  iconStyle: iconStyle,
                  title: '週運動日',
                  subtitle: "更改每週可以運動的日子",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingWorkout();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeStartTimeDialog());
                  },
                  icons: Icons.notifications_none,
                  iconStyle: iconStyle,
                  title: '運動通知',
                  subtitle: "更改每天開始運動的時間",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingWorkout();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeLikingDialog());
                  },
                  icons: CupertinoIcons.heart_circle,
                  iconStyle: iconStyle,
                  title: '運動偏好',
                  subtitle: "更改每類運動的喜愛程度",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingWorkout();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeGoalDialog());
                  },
                  icons: Icons.gps_fixed,
                  iconStyle: iconStyle,
                  title: '運動目標',
                  subtitle: "更改運動的目標與動機",
                ),
              ],
            ),
            // TODO: Combine to habits group
            SettingsGroup(
              settingsGroupTitle: "冥想",
              items: [
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingMeditation();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeDurationDialog());
                  },
                  icons: CupertinoIcons.timer,
                  iconStyle: iconStyle,
                  title: '冥想時長',
                  subtitle: "更改每次冥想計畫的長度",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingMeditation();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeDayDialog());
                  },
                  icons: Icons.calendar_today_outlined,
                  iconStyle: iconStyle,
                  title: '週冥想日',
                  subtitle: "更改每週可以冥想的日子",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingMeditation();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeStartTimeDialog());
                  },
                  icons: Icons.notifications_none,
                  iconStyle: iconStyle,
                  title: '冥想通知',
                  subtitle: "更改每天開始冥想的時間",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingMeditation();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeLikingDialog());
                  },
                  icons: CupertinoIcons.heart_circle,
                  iconStyle: iconStyle,
                  title: '冥想偏好',
                  subtitle: "更改每類冥想的喜愛程度",
                ),
                SettingsItem(
                  onTap: () {
                    SettingsData.isSettingMeditation();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeGoalDialog());
                  },
                  icons: Icons.gps_fixed,
                  iconStyle: iconStyle,
                  title: '冥想目標',
                  subtitle: "更改冥想的目標與動機",
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "個人",
              items: [
                SettingsItem(
                  onTap: () async {
                    SettingsData.isSettingDisplayName();
                    await showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeProfileDialog());
                    setState(() {
                      Data.user = FirebaseAuth.instance.currentUser!;
                    });
                  },
                  icons: CupertinoIcons.textformat_alt,
                  iconStyle: iconStyle,
                  title: '更改暱稱',
                ),
                SettingsItem(
                    onTap: () {
                      SettingsData.isSettingPassword();
                      showDialog<double>(
                          context: context,
                          builder: (context) => const ChangeProfileDialog());
                      setState(() {
                        Data.user = FirebaseAuth.instance.currentUser!;
                      });
                    },
                    icons: Icons.password_outlined,
                    iconStyle: iconStyle,
                    title: '更改密碼'),
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

// UI elements
class ChangeDurationDialog extends StatefulWidget {
  const ChangeDurationDialog({super.key});

  @override
  ChangeDurationDialogState createState() => ChangeDurationDialogState();
}

class ChangeDurationDialogState extends State<ChangeDurationDialog> {
  int exerciseTime = 0;
  String key = "${SettingsData.habitType}Time";

  @override
  initState() {
    super.initState();
    exerciseTime = SettingsData.userData[key];
  }

  List<Widget> _getDurationBtnList() {
    List<OutlinedButton> btnList = [];

    for (int i = 1; i <= 4; i++) {
      int choice = 15 * i;
      btnList.add(
        OutlinedButton(
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
        ),
      );
    }
    return btnList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "${SettingsData.habitTypeZH}時長(分鐘)",
        style: const TextStyle(
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
                scrollDirection: Axis.horizontal,
                children: _getDurationBtnList()),
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
              num original = SettingsData.userData[key];
              num modified = exerciseTime;
              if (modified != original) {
                SettingsData.userData[key] = modified;
                await UserDB.update({key: modified});
              }

              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: Text(
                  "${SettingsData.habitTypeZH}時長已更新",
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
  const ChangeDayDialog({super.key});

  @override
  ChangeDayDialogState createState() => ChangeDayDialogState();
}

class ChangeDayDialogState extends State<ChangeDayDialog> {
  List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];
  List selectedDays = [];
  List selectedNames = [];
  String key = "${SettingsData.habitType}Days";

  @override
  initState() {
    super.initState();
    selectedDays = SettingsData.userData[key];
    selectedNames = [
      for (int i = 0; i < 7; i++)
        if (selectedDays[i] == 1) weekdayNameList[i]
    ];
  }

  List<Widget> _getDayBtnList() {
    List<OutlinedButton> btnList = [];

    for (int i = 0; i < 7; i++) {
      btnList.add(
        OutlinedButton(
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
        ),
      );
    }
    return btnList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "每週${SettingsData.habitTypeZH}日",
        style: const TextStyle(
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
              List original = SettingsData.userData[key];
              List modified = selectedDays;
              if (modified != original) {
                SettingsData.userData[key] = modified;
                await UserDB.update({key: modified.join("")});
              }

              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: Text(
                  "週${SettingsData.habitTypeZH}日已更新",
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

class ChangeStartTimeDialog extends StatefulWidget {
  const ChangeStartTimeDialog({super.key});

  @override
  ChangeStartTimeDialogState createState() => ChangeStartTimeDialogState();
}

class ChangeStartTimeDialogState extends State<ChangeStartTimeDialog> {
  List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];
  List selectedDays = []; // the index of the weekdays
  Map forecast = {};
  String key = "${SettingsData.habitType}Clock";

  @override
  initState() {
    super.initState();
    selectedDays = [
      for (int i = 0; i < 7; i++)
        if (SettingsData.userData["${SettingsData.habitType}Days"][i] == 1) i
    ];
    forecast = SettingsData.timeForecast[key];
  }

  List<Widget> _getTimeBtnList() {
    List<OutlinedButton> btnList = [];

    for (int index in selectedDays) {
      String weekday = "星期${weekdayNameList[index]}";
      String selectedTime =
          forecast["forecast_$index"] ?? Calendar.timeToString(TimeOfDay.now());
      btnList.add(
        OutlinedButton(
          onPressed: () async {
            final TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: Calendar.stringToTime(selectedTime),
              initialEntryMode: TimePickerEntryMode.dial,
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat: true,
                      ),
                      child: child!,
                    ),
                  ),
                );
              },
            );
            setState(() {
              if (time != null) selectedTime = Calendar.timeToString(time);
              forecast["forecast_$index"] = selectedTime;
            });
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xff0d3b66),
            side: const BorderSide(color: Colors.white),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 20),
              Text(weekday),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(selectedTime)],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      );
    }
    return btnList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "${SettingsData.habitTypeZH}通知時間",
        style: const TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.maxFinite,
            child: ListView(
                scrollDirection: Axis.vertical, children: _getTimeBtnList()),
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
              SettingsData.timeForecast[key] = forecast;
              ClockDB.update(
                  SettingsData.habitType, Map<String, String>.from(forecast));

              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: Text(
                  "${SettingsData.habitTypeZH}通知時間已更新",
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
  const ChangeLikingDialog({super.key});

  @override
  ChangeLikingDialogState createState() => ChangeLikingDialogState();
}

class ChangeLikingDialogState extends State<ChangeLikingDialog> {
  Map<String, num> likings = {};
  List<String> categories = [];
  List<String> keys = [];
  Map<String, IconData> icons = {};
  String dropdownValue = "";

  @override
  initState() {
    super.initState();
    if (SettingsData.habitType == "workout") {
      categories = ["肌力運動", "有氧運動", "瑜珈運動"];
      keys = ["strengthLiking", "cardioLiking", "yogaLiking"];
      icons = {
        "肌力運動": Icons.fitness_center,
        "有氧運動": Icons.directions_run,
        "瑜珈運動": Icons.self_improvement
      };
    } else if (SettingsData.habitType == "meditation") {
      categories = ["正念冥想", "工作冥想", "慈心冥想"];
      keys = ["mindfulnessLiking", "workLiking", "kindnessLiking"];
      icons = {
        "正念冥想": Icons.spa_outlined,
        "工作冥想": Icons.business_center_outlined,
        "慈心冥想": Icons.volunteer_activism_outlined
      };
    }
    likings = {for (var item in keys) item: SettingsData.userData[item]};
    dropdownValue = categories.first;
  }

  Widget _getSlider(int i) {
    var currentValue = likings[keys[i]]! / 20;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Slider(
        value: currentValue,
        min: 0,
        max: 5,
        divisions: 50,
        onChanged: (value) {
          setState(() {
            likings[keys[i]] = value * 20;
          });
        },
      ),
      Text(
        currentValue.toStringAsFixed(1),
        textAlign: TextAlign.right,
        style: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 15,
            fontWeight: FontWeight.normal,
            height: 1),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "${SettingsData.habitTypeZH}偏好(0~5分)",
        style: const TextStyle(
          color: ColorSet.textColor,
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
            style: const TextStyle(color: ColorSet.iconColor),
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
            items: categories.map<DropdownMenuItem<String>>((String value) {
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
            child: _getSlider(categories.indexOf(dropdownValue)),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
            child: const Text(
              "取消",
              style: TextStyle(
                color: ColorSet.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSet.backgroundColor,
            ),
            onPressed: () async {
              Map original = {
                for (var item in keys) item: SettingsData.userData[item]
              };
              Map<String, Object> modified = likings;
              if (modified != original) {
                SettingsData.userData.update(keys, (value) => modified[value]);
                await UserDB.update(modified);
              }

              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: Text(
                  "${SettingsData.habitTypeZH}偏好已更新",
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

class ChangeGoalDialog extends StatefulWidget {
  const ChangeGoalDialog({super.key});

  @override
  ChangeGoalDialogState createState() => ChangeGoalDialogState();
}

class ChangeGoalDialogState extends State<ChangeGoalDialog> {
  List selectableItems = [];
  List goal = [];
  String key = "${SettingsData.habitType}Goals";

  @override
  initState() {
    super.initState();
    goal = SettingsData.userData[key];
    if (SettingsData.habitType == "workout") {
      selectableItems = [
        "減脂減重",
        "塑型增肌",
        "紓解壓力",
        "預防疾病",
        "改善膚況",
        "增強體力",
        "提升大腦功能",
        "提升睡眠品質"
      ];
    } else if (SettingsData.habitType == "meditation") {
      selectableItems = [
        "壓力",
        "憂慮",
        "效率",
        "動機",
        "平靜",
        "自愛",
        "感激",
        "人際",
        "專注力",
        "創造力",
        "情緒健康"
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "${SettingsData.habitTypeZH}目標",
        style: const TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MultiSelectChipField(
            showHeader: false,
            decoration: const BoxDecoration(),
            // icon: const Icon(Icons.check),
            items: selectableItems.map((e) => MultiSelectItem(e, e)).toList(),
            scroll: false,
            initialValue: goal,
            onTap: (values) {
              goal = values;
            },
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
              List original = SettingsData.userData[key];
              List modified = goal;
              if (modified != original) {
                SettingsData.userData[key] = modified;
                await UserDB.update({key: modified.join(", ")});
              }

              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: Text(
                  "${SettingsData.habitTypeZH}時長已更新",
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

class ChangeProfileDialog extends StatefulWidget {
  const ChangeProfileDialog({super.key});

  @override
  ChangeProfileDialogState createState() => ChangeProfileDialogState();
}

class ChangeProfileDialogState extends State<ChangeProfileDialog> {
  TextEditingController controller = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  Widget _getTextFormField({required controller, hintText = ""}) =>
      TextFormField(
        controller: controller,
        validator: (SettingsData.profileType == "密碼")
            ? Validator.validatePassword
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Icon(
            Icons.abc_rounded,
            color: ColorSet.iconColor,
          ),
          suffixIcon: (SettingsData.profileType == "密碼")
              ? IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    isPasswordVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: ColorSet.iconColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                )
              : null,
          labelText: (SettingsData.profileType == "密碼")
              ? hintText
              : SettingsData.profileType,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xff4b4370),
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xfff6cdb7),
              width: 3,
            ),
          ),
          labelStyle: const TextStyle(color: ColorSet.textColor),
          hintStyle: const TextStyle(color: Colors.grey),
          errorStyle: const TextStyle(
              height: 1,
              color: Color(0xfff6cdb7),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          errorMaxLines: 1,
          filled: true,
          fillColor: ColorSet.backgroundColor,
        ),
        cursorColor: const Color(0xfff6cdb7),
        style: const TextStyle(fontSize: 18, color: ColorSet.textColor),
        keyboardType: TextInputType.text,
        obscureText:
            (SettingsData.profileType == "密碼") ? !isPasswordVisible : false,
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        SettingsData.profileType,
        style: const TextStyle(
          color: Color(0xff0d3b66),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (SettingsData.profileType == "密碼")
              ? SizedBox(
                  height: MediaQuery.of(context).size.width * 0.4,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                        width: double.maxFinite,
                        child: _getTextFormField(
                            controller: controller, hintText: "目前密碼"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.2,
                        width: double.maxFinite,
                        child: _getTextFormField(
                            controller: newPasswordController, hintText: "新密碼"),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: double.maxFinite,
                  child: _getTextFormField(controller: controller),
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
              if (SettingsData.profileType == "密碼") {
                AuthCredential credential = EmailAuthProvider.credential(
                  email: Data.user!.email!,
                  password: controller.text,
                );
                Data.user!
                    .reauthenticateWithCredential(credential)
                    .then((userCredential) {
                  return Data.user!.updatePassword(newPasswordController.text);
                });
              } else if (SettingsData.profileType == "暱稱") {
                await Data.user!.updateDisplayName(controller.text);
                await UserDB.update({"userName": controller.text});
              }

              if (!mounted) return;
              Navigator.pop(context);
              MotionToast(
                icon: Icons.done_all_rounded,
                primaryColor: const Color(0xffffa493),
                description: Text(
                  "${SettingsData.profileType}已更新",
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
