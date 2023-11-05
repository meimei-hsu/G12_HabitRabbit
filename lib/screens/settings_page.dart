import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:g12/screens/page_material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:g12/services/database.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../services/authentication.dart';
import '../services/page_data.dart';

IconStyle iconStyle = IconStyle(
  iconsColor: ColorSet.iconColor,
  withBackground: true,
  backgroundColor: ColorSet.bottomBarColor,
);

TextStyle titleStyle = const TextStyle(
  color: ColorSet.textColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

TextStyle subtitleStyle = const TextStyle(
  color: ColorSet.textColor,
  fontSize: 16,
);

// UI Layout
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Future<void> refresh() async {
    if (Data.updatingDB || Data.updatingUI[4]) await SettingsData.fetch();
    setState(() {});
  }

  double getImageWidthPercentage(){
    String character = Data.characterName;
    double percentage = 0;
    if(character == "Mouse" || character == "Cat"){
      percentage = 0.4;
    }else if(character == "Pig"){
      percentage = 0.45;
    }else if(character == "Sheep"){
      percentage = 0.65;
    }else if(character == "Dog"){
      percentage = 0.5;
    }else if(character == "Lion" || character == "Fox"){
      percentage = 0.55;
    }else if(character == "Sloth"){
      percentage = 0.6;
    }
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorSet.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '個人設定',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 28,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        backgroundColor: ColorSet.backgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: ListView(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
              decoration: const BoxDecoration(
                color: ColorSet.bottomBarColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                      Data.characterImageURL,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * getImageWidthPercentage(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    Data.user!.displayName!,
                    style: const TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            SettingsGroup(
              settingsGroupTitle: "計畫",
              settingsGroupTitleStyle: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 24,
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
              ),
              items: [
                SettingsItem(
                  onTap: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isSettingWorkout();
                          return const ChangeDurationBottomSheet();
                        });
                  },
                  icons: CupertinoIcons.timer,
                  iconStyle: iconStyle,
                  title: '更改時長',
                  titleStyle: titleStyle,
                  //subtitle: "更改每次運動計畫的長度",
                  //subtitleStyle: subtitleStyle,
                ),
                SettingsItem(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isSettingWorkout();
                          return const ChangeDayAndNotificationTimeBottomSheet();
                        });
                  },
                  icons: Icons.calendar_today_outlined,
                  iconStyle: iconStyle,
                  title: '更改計畫日與通知時間',
                  titleStyle: titleStyle,
                  //subtitle: "更改每天開始運動的時間",
                  //subtitleStyle: subtitleStyle,
                ),
                SettingsItem(
                  onTap: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isSettingWorkout();
                          return const ChangeLikingBottomSheet();
                        });
                  },
                  icons: CupertinoIcons.heart_circle,
                  iconStyle: iconStyle,
                  title: '更改類型喜愛程度',
                  titleStyle: titleStyle,
                  //subtitle: "更改每類運動的喜愛程度",
                  //subtitleStyle: subtitleStyle,
                ),
                SettingsItem(
                  onTap: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isSettingWorkout();
                          return const ChangeGoalBottomSheet();
                        });
                  },
                  icons: Icons.gps_fixed,
                  iconStyle: iconStyle,
                  title: '更改目標與動機',
                  titleStyle: titleStyle,
                  //subtitle: "更改運動的目標與動機",
                  //subtitleStyle: subtitleStyle,
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "個人",
              settingsGroupTitleStyle: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 24,
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
              ),
              items: [
                SettingsItem(
                  onTap: () async {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isSettingDisplayName();
                          return const ChangeProfileBottomSheet();
                        });
                  },
                  icons: CupertinoIcons.textformat_alt,
                  iconStyle: iconStyle,
                  title: '更改暱稱',
                  titleStyle: titleStyle,
                ),
                SettingsItem(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isSettingPassword();
                          return const ChangeProfileBottomSheet();
                        });
                    setState(() {});
                  },
                  icons: Icons.password_outlined,
                  iconStyle: iconStyle,
                  title: '更改密碼',
                  titleStyle: titleStyle,
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "帳號",
              settingsGroupTitleStyle: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 24,
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
              ),
              items: [
                SettingsItem(
                  onTap: () async {
                    btnOkOnPress() async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.popAndPushNamed(context, '/register');
                    }

                    ConfirmDialog()
                        .get(context, ':)警告', "確定登出嗎？", btnOkOnPress)
                        .show();
                  },
                  icons: Icons.exit_to_app_rounded,
                  iconStyle: iconStyle,
                  title: "登出帳號",
                  titleStyle: titleStyle,
                ),
                SettingsItem(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isDeletingAccount();
                          return const ChangeProfileBottomSheet();
                        });
                  },
                  icons: CupertinoIcons.delete_solid,
                  iconStyle: iconStyle,
                  title: "刪除帳號",
                  titleStyle: const TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 18,
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
class ChangeDurationBottomSheet extends StatefulWidget {
  const ChangeDurationBottomSheet({super.key});

  @override
  ChangeDurationBottomSheetState createState() =>
      ChangeDurationBottomSheetState();
}

class ChangeDurationBottomSheetState extends State<ChangeDurationBottomSheet> {
  int exerciseTime = 0;
  int planToChange = 0; // 0 = 運動, 1 = 冥想

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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(
              color: ColorSet.borderColor,
            ),
            backgroundColor: (exerciseTime == choice)
                ? (planToChange == 0)
                    ? ColorSet.exerciseColor
                    : ColorSet.meditationColor
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
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "更改${SettingsData.habitTypeZH}時長（分鐘）",
              style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
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
          ToggleSwitch(
            minWidth: MediaQuery.of(context).size.width,
            //minHeight: 35,
            initialLabelIndex: planToChange,
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
              planToChange = index!;
              (index == 0)
                  ? SettingsData.isSettingWorkout()
                  : SettingsData.isSettingMeditation();
              key = "${SettingsData.habitType}Time";
              exerciseTime = SettingsData.userData[key];
              setState(() {});
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "你要將${SettingsData.habitTypeZH}時長更改為幾分鐘呢？",
            style: const TextStyle(color: ColorSet.textColor, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getDurationBtnList(),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: (planToChange == 0)
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
                num original = SettingsData.userData[key];
                num modified = exerciseTime;
                if (modified != original) {
                  SettingsData.userData[key] = modified;
                  await UserDB.update({key: modified});
                }

                if (!mounted) return;
                InformDialog()
                    .get(context, "完成更改:)", "${SettingsData.habitTypeZH}時長已更新！")
                    .show();
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

class ChangeDayAndNotificationTimeBottomSheet extends StatefulWidget {
  const ChangeDayAndNotificationTimeBottomSheet({super.key});

  @override
  ChangeDayAndNotificationTimeBottomSheetState createState() =>
      ChangeDayAndNotificationTimeBottomSheetState();
}

class ChangeDayAndNotificationTimeBottomSheetState
    extends State<ChangeDayAndNotificationTimeBottomSheet> {
  int planToChange = 0; // 0 = 運動, 1 = 冥想

  // Day
  List dayWeekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];
  List daySelectedDays = [];
  List daySelectedNames = [];

  String dayKey = "${SettingsData.habitType}Days";

  // Notification
  List notificationWeekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];
  List notificationSelectedDays = []; // the index of the weekdays
  Map forecast = {};

  String notificationKey = "${SettingsData.habitType}Clock";

  final ScrollController _dayController = ScrollController();
  final ScrollController _notificationController = ScrollController();

  @override
  initState() {
    super.initState();
    daySelectedDays = List.from(SettingsData.userData[dayKey]);
    daySelectedNames = [
      for (int i = 0; i < 7; i++)
        if (daySelectedDays[i] == 1) dayWeekdayNameList[i]
    ];

    notificationSelectedDays = [
      for (int i = 0; i < 7; i++)
        if (SettingsData.userData[dayKey][i] == 1) i
    ];
    forecast = Map.from(SettingsData.timeForecast[notificationKey]);
  }

  List<Widget> _getDayBtnList() {
    List<Widget> btnList = [];

    for (int i = 0; i < 7; i++) {
      btnList.add(
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: const BorderSide(
              color: ColorSet.borderColor,
            ),
            backgroundColor: (daySelectedNames.contains(dayWeekdayNameList[i]))
                ? (planToChange == 0)
                    ? ColorSet.exerciseColor
                    : ColorSet.meditationColor
                : ColorSet.backgroundColor,
          ),
          onPressed: () {
            String choice = dayWeekdayNameList[i];
            if (daySelectedNames.contains(choice)) {
              setState(() {
                daySelectedNames.remove(choice);
                daySelectedDays[i] = 0;
              });
            } else {
              setState(() {
                daySelectedNames.add(choice);
                daySelectedDays[i] = 1;
              });
            }

            notificationKey = "${SettingsData.habitType}Clock";
            notificationSelectedDays = [
              for (int i = 0; i < 7; i++)
                if (daySelectedDays[i] == 1) i
            ];
            forecast = SettingsData.timeForecast[notificationKey];
          },
          child: Text(
            dayWeekdayNameList[i],
            style: const TextStyle(
              color: ColorSet.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      if (i != 6) {
        btnList.add(const SizedBox(
          width: 10,
        ));
      }
    }
    return btnList;
  }

  List<Widget> _getTimeBtnList() {
    List<OutlinedButton> btnList = [];

    for (int index in notificationSelectedDays) {
      String weekday = "星期${notificationWeekdayNameList[index]}";
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
            backgroundColor: ColorSet.backgroundColor,
            foregroundColor: ColorSet.textColor,
            side: const BorderSide(color: ColorSet.borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 20),
              Text(
                weekday,
                style: const TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      selectedTime,
                      style: const TextStyle(
                          color: ColorSet.textColor, fontSize: 16),
                    )
                  ],
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
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "更改每週${SettingsData.habitTypeZH}日與通知時間",
              style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
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
          ToggleSwitch(
            minWidth: MediaQuery.of(context).size.width,
            //minHeight: 35,
            initialLabelIndex: planToChange,
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
              planToChange = index!;
              (index == 0)
                  ? SettingsData.isSettingWorkout()
                  : SettingsData.isSettingMeditation();

              dayKey = "${SettingsData.habitType}Days";
              daySelectedDays = SettingsData.userData[dayKey];
              daySelectedNames = [
                for (int i = 0; i < 7; i++)
                  if (daySelectedDays[i] == 1) dayWeekdayNameList[i]
              ];

              notificationKey = "${SettingsData.habitType}Clock";
              notificationSelectedDays = [
                for (int i = 0; i < 7; i++)
                  if (daySelectedDays[i] == 1) i
              ];
              forecast = SettingsData.timeForecast[notificationKey];

              setState(() {});
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              margin: const EdgeInsets.only(right: 15, left: 15),
              decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                    "你要將每週${SettingsData.habitTypeZH}日更改為哪幾天呢？",
                    style: const TextStyle(
                        color: ColorSet.textColor, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Scrollbar(
                        controller: _dayController,
                        thumbVisibility: true,
                        child: ListView(
                            controller: _dayController,
                            scrollDirection: Axis.horizontal,
                            children: _getDayBtnList()),
                      )),
                ],
              )),
          const SizedBox(height: 10),
          Container(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              margin: const EdgeInsets.only(right: 15, left: 15),
              decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(children: [
                Text(
                  "${SettingsData.habitTypeZH}日的通知時間？",
                  style:
                      const TextStyle(color: ColorSet.textColor, fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Scrollbar(
                      controller: _notificationController,
                      thumbVisibility: true,
                      child: ListView(
                          controller: _notificationController,
                          scrollDirection: Axis.vertical,
                          children: _getTimeBtnList()),
                    )),
              ])),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: (planToChange == 0)
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
                List originalList = SettingsData.userData[dayKey];
                List modifiedList = daySelectedDays;
                if (modifiedList != originalList) {
                  SettingsData.userData[dayKey] = modifiedList;
                  await UserDB.update({dayKey: modifiedList.join("")});
                  // TODO: update to GamificationDB
                }

                Map originalMap = SettingsData.timeForecast[notificationKey];
                Map modifiedMap = forecast;
                if (SettingsData.timeForecast[notificationKey] != originalMap) {
                  SettingsData.timeForecast[notificationKey] = modifiedMap;
                  ClockDB.update(SettingsData.habitType,
                      Map<String, String>.from(modifiedMap));
                }

                if (!mounted) return;
                InformDialog()
                    .get(context, "提示:)",
                        "週${SettingsData.habitTypeZH}日與通知時間已更新！")
                    .show();
                // FIXME: should close the bottom sheet after pressing "確定"
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

class ChangeLikingBottomSheet extends StatefulWidget {
  const ChangeLikingBottomSheet({super.key});

  @override
  ChangeLikingBottomSheetState createState() => ChangeLikingBottomSheetState();
}

class ChangeLikingBottomSheetState extends State<ChangeLikingBottomSheet> {
  Map<String, num> likings = {};
  List<String> categories = [];
  List<String> keys = [];
  Map<String, IconData> icons = {};
  String dropdownValue = "";

  int planToChange = 0; // 0 = 運動, 1 = 冥想

  @override
  initState() {
    super.initState();

    setKeysList();
    likings = {for (var item in keys) item: SettingsData.userData[item]};
    dropdownValue = categories.first;
  }

  void setKeysList() {
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
  }

  Widget _getSlider(int i) {
    var currentValue = likings[keys[i]]! / 20;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Slider(
          value: currentValue,
          min: 0,
          max: 5,
          divisions: 50,
          activeColor: (planToChange == 0)
              ? ColorSet.exerciseColor
              : ColorSet.meditationColor,
          inactiveColor: (planToChange == 0)
              ? ColorSet.backgroundColor
              : ColorSet.backgroundColor,
          onChanged: (value) {
            setState(() {
              likings[keys[i]] = value * 20;
            });
          },
        ),
      ),
      Text(
        currentValue.toStringAsFixed(1),
        style: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1),
      ),
    ]);
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
              "更改${SettingsData.habitTypeZH}偏好",
              style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
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
          ToggleSwitch(
            minWidth: MediaQuery.of(context).size.width,
            //minHeight: 35,
            initialLabelIndex: planToChange,
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
              planToChange = index!;
              (index == 0)
                  ? SettingsData.isSettingWorkout()
                  : SettingsData.isSettingMeditation();

              setKeysList();
              likings = {
                for (var item in keys) item: SettingsData.userData[item]
              };
              dropdownValue = categories.first;
              setState(() {});
            },
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(
              Icons.arrow_drop_down_outlined,
              color: ColorSet.iconColor,
            ),
            iconSize: 28,
            elevation: 16,
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
                    Icon(
                      icons[value],
                      color: ColorSet.iconColor,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      value,
                      style: const TextStyle(
                          color: ColorSet.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.8,
            child: _getSlider(categories.indexOf(dropdownValue)),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: (planToChange == 0)
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
                Map original = {
                  for (var item in keys) item: SettingsData.userData[item]
                };
                Map<String, Object> modified = likings;
                if (modified != original) {
                  for (var key in keys) {
                    SettingsData.userData[key] = modified[key];
                  }
                  await UserDB.update(modified);
                }

                if (!mounted) return;
                InformDialog()
                    .get(context, "提示:)", "${SettingsData.habitTypeZH}偏好已更新！")
                    .show();
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

class ChangeGoalBottomSheet extends StatefulWidget {
  const ChangeGoalBottomSheet({super.key});

  @override
  ChangeGoalBottomSheetState createState() => ChangeGoalBottomSheetState();
}

class ChangeGoalBottomSheetState extends State<ChangeGoalBottomSheet> {
  List selectableItems = [];
  List goal = [];
  String key = "${SettingsData.habitType}Goals";

  int planToChange = 0; // 0 = 運動, 1 = 冥想

  @override
  initState() {
    super.initState();
    goal = SettingsData.userData[key];
    setSelectableItem();
  }

  void setSelectableItem() {
    if (SettingsData.habitType == "workout") {
      selectableItems = [
        "減脂減重",
        "塑型增肌",
        "紓解壓力",
        "預防疾病",
        "改善膚況",
        "增強體力",
        "提升大腦",
        "改善睡眠"
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
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "更改${SettingsData.habitTypeZH}目標",
              style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
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
          ToggleSwitch(
            minWidth: MediaQuery.of(context).size.width,
            //minHeight: 35,
            initialLabelIndex: planToChange,
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
              planToChange = index!;
              (index == 0)
                  ? SettingsData.isSettingWorkout()
                  : SettingsData.isSettingMeditation();

              key = "${SettingsData.habitType}Goals";
              goal = SettingsData.userData[key];
              setSelectableItem();

              setState(() {});
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: MultiSelectChipField(
              showHeader: false,
              decoration: const BoxDecoration(),
              chipShape: RoundedRectangleBorder(
                side: const BorderSide(color: ColorSet.borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              chipColor: ColorSet.backgroundColor,
              textStyle: const TextStyle(color: ColorSet.textColor),
              selectedChipColor: (planToChange == 0)
                  ? ColorSet.exerciseColor
                  : ColorSet.meditationColor,
              selectedTextStyle: const TextStyle(color: ColorSet.textColor),
              // icon: const Icon(Icons.check),
              items: selectableItems.map((e) => MultiSelectItem(e, e)).toList(),
              scroll: false,
              initialValue: goal,
              onTap: (values) {
                goal = values;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: (planToChange == 0)
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
                List original = SettingsData.userData[key];
                List modified = goal;
                if (modified != original) {
                  SettingsData.userData[key] = modified;
                  await UserDB.update({key: modified.join(", ")});
                }

                if (!mounted) return;
                InformDialog()
                    .get(context, "提示:)", "${SettingsData.habitTypeZH}目標已更新！")
                    .show();
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

class ChangeProfileBottomSheet extends StatefulWidget {
  const ChangeProfileBottomSheet({super.key});

  @override
  ChangeProfileBottomSheetState createState() =>
      ChangeProfileBottomSheetState();
}

class ChangeProfileBottomSheetState extends State<ChangeProfileBottomSheet> {
  TextEditingController controller = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool isPasswordVisible = false;

  Widget _getTextFormField({required controller, hintText = ""}) =>
      TextFormField(
        controller: controller,
        validator: (SettingsData.functionCode == "更改暱稱")
            ? null
            : Validator.validatePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: const Icon(
            Icons.abc_rounded,
            color: ColorSet.iconColor,
          ),
          suffixIcon: (SettingsData.functionCode == "更改暱稱")
              ? null
              : IconButton(
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
                ),
          labelText: (SettingsData.functionCode == "更改暱稱") ? "暱稱" : hintText,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: ColorSet.borderColor,
              width: 3,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: ColorSet.errorColor,
              width: 3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: ColorSet.errorColor,
              width: 3,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: ColorSet.errorColor,
              width: 3,
            ),
          ),
          labelStyle: const TextStyle(color: ColorSet.textColor),
          hintStyle: const TextStyle(color: ColorSet.hintColor),
          errorStyle: const TextStyle(
              height: 1,
              color: ColorSet.errorColor,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          errorMaxLines: 1,
          filled: true,
          fillColor: ColorSet.backgroundColor,
        ),
        cursorColor: ColorSet.errorColor,
        style: const TextStyle(fontSize: 18, color: ColorSet.textColor),
        keyboardType: TextInputType.text,
        obscureText:
            (SettingsData.functionCode == "更改暱稱") ? false : !isPasswordVisible,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
                title: Text(
                  SettingsData.functionCode,
                  style: const TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  padding: const EdgeInsets.only(right: 20, left: 20),
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
              const SizedBox(
                height: 10,
              ),
              (SettingsData.functionCode == "更改密碼")
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.2,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _getTextFormField(
                              controller: controller, hintText: "目前密碼"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.2,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _getTextFormField(
                              controller: newPasswordController,
                              hintText: "新密碼"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.width * 0.2,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: _getTextFormField(
                          controller: controller,
                          hintText: (SettingsData.functionCode == "更改暱稱")
                              ? Data.user?.displayName
                              : "密碼驗證"),
                    ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 18),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    backgroundColor: ColorSet.backgroundColor,
                    shadowColor: ColorSet.borderColor,
                    //elevation: 0,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (SettingsData.functionCode == "更改暱稱") {
                      String userName = controller.text;
                      await Data.user!.updateDisplayName(userName);
                      await UserDB.update({"userName": userName});
                      await GamificationDB.update({"userName": userName});
                      Data.user = FirebaseAuth.instance.currentUser;
                      if (!mounted) return;
                      // FIXME: Navigator.pop(context) -> Null check operator used on a null value
                      // Navigator.pushNamed(context, "/settings");
                      // 如果用push而不是pop，則按返回見的時候，會回到這個更改密碼bottomSheet，不合理
                      InformDialog()
                          .get(context, "提示:)",
                              "${SettingsData.functionCode}已完成！")
                          .show();
                    } else {
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: Data.user!.email!,
                        password: controller.text,
                      );
                      try {
                        Data.user!.reauthenticateWithCredential(credential);
                        if (SettingsData.functionCode == "更改密碼") {
                          await Data.user!
                              .updatePassword(newPasswordController.text);
                          if (!mounted) return;
                          InformDialog()
                              .get(context, "提示:)",
                                  "${SettingsData.functionCode}已完成！")
                              .show();
                        } else {
                          await UserDB.delete();
                          await ContractDB.delete();
                          await GamificationDB.delete();
                          await PlanDB.deleteAll();
                          await Data.user?.delete();
                          if (!mounted) return;
                          Navigator.popAndPushNamed(context, '/register');
                        }
                      } catch (e) {
                        if (!mounted) return;
                        debugPrint(e.toString());
                        InformDialog().get(context, "警告:(", "密碼錯誤QQ").show();
                      }
                    }
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
        ));
  }
}
