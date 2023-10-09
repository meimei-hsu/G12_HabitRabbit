import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:g12/screens/page_material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

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
            // user card
            SimpleUserCard(
              userName: Data.user!.displayName!,
              userProfilePic: AssetImage(Data.characterImageURL),
              textStyle: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
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
                // FIXME: cannot change background color of SettingsItem
                SettingsItem(
                  onTap: () {
                    //SettingsData.isSettingWorkout();
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
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        backgroundColor: ColorSet.bottomBarColor,
                        context: context,
                        builder: (context) {
                          SettingsData.isSettingWorkout();
                          return const ChangeDayBottomSheet();
                        });
                  },
                  icons: Icons.calendar_today_outlined,
                  iconStyle: iconStyle,
                  title: '更改計畫日',
                  titleStyle: titleStyle,
                  //subtitle: "更改每週可以運動的日子",
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
                          return const ChangeStartTimeBottomSheet();
                        });
                    /*SettingsData.isSettingWorkout();
                    showDialog<double>(
                        context: context,
                        builder: (context) => const ChangeStartTimeDialog());*/
                  },
                  icons: Icons.notifications_none,
                  iconStyle: iconStyle,
                  title: '更改通知時間',
                  titleStyle: titleStyle,
                  //subtitle: "更改每天開始運動的時間",
                  //subtitleStyle: subtitleStyle,
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
                  title: '更改類型喜愛程度',
                  titleStyle: titleStyle,
                  //subtitle: "更改每類運動的喜愛程度",
                  //subtitleStyle: subtitleStyle,
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
                  title: '更改目標與動機',
                  titleStyle: titleStyle,
                  //subtitle: "更改運動的目標與動機",
                  //subtitleStyle: subtitleStyle,
                ),
              ],
            ),
            // TODO: Combine to habits group
           /*SettingsGroup(
              settingsGroupTitle: "冥想",
              settingsGroupTitleStyle: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 24,
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
              ),
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
                  titleStyle: titleStyle,
                  subtitle: "更改每次冥想計畫的長度",
                  subtitleStyle: subtitleStyle,
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
                  titleStyle: titleStyle,
                  subtitle: "更改每週可以冥想的日子",
                  subtitleStyle: subtitleStyle,
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
                  titleStyle: titleStyle,
                  subtitle: "更改每天開始冥想的時間",
                  subtitleStyle: subtitleStyle,
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
                  titleStyle: titleStyle,
                  subtitle: "更改每類冥想的喜愛程度",
                  subtitleStyle: subtitleStyle,
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
                  titleStyle: titleStyle,
                  subtitle: "更改冥想的目標與動機",
                  subtitleStyle: subtitleStyle,
                ),
              ],
            ),*/
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
                  titleStyle: titleStyle,
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
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.popAndPushNamed(context, '/register');
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "登出帳號",
                  titleStyle: titleStyle,
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
            "你要將${SettingsData.habitTypeZH}時長更改為幾分鐘呢呢？",
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

class ChangeDayBottomSheet extends StatefulWidget {
  const ChangeDayBottomSheet({super.key});

  @override
  ChangeDayBottomSheetState createState() => ChangeDayBottomSheetState();
}

class ChangeDayBottomSheetState extends State<ChangeDayBottomSheet> {
  List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];
  List selectedDays = [];
  List selectedNames = [];

  int planToChange = 0; // 0 = 運動, 1 = 冥想

  String key = "${SettingsData.habitType}Days";

  final ScrollController _controller = ScrollController();

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
            backgroundColor: (selectedNames.contains(weekdayNameList[i]))
                ? (planToChange == 0)
                    ? ColorSet.exerciseColor
                    : ColorSet.meditationColor
                : ColorSet.backgroundColor,
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
              "更改每週${SettingsData.habitTypeZH}日",
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

              key = "${SettingsData.habitType}Days";
              selectedDays = SettingsData.userData[key];
              selectedNames = [
                for (int i = 0; i < 7; i++)
                  if (selectedDays[i] == 1) weekdayNameList[i]
              ];
              setState(() {});
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "你要將每週${SettingsData.habitTypeZH}日更改為哪幾天呢？",
            style: const TextStyle(color: ColorSet.textColor, fontSize: 18),
          ),
          const SizedBox(height: 10),
          SizedBox(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                child: ListView(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    children: _getDayBtnList()),
              )),
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
                List original = SettingsData.userData[key];
                List modified = selectedDays;
                if (modified != original) {
                  SettingsData.userData[key] = modified;
                  await UserDB.update({key: modified.join("")});
                }

                if (!mounted) return;
                InformDialog()
                    .get(context, "完成更改:)", "週${SettingsData.habitTypeZH}日已更新！")
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

class ChangeStartTimeBottomSheet extends StatefulWidget {
  const ChangeStartTimeBottomSheet({super.key});

  @override
  ChangeStartTimeBottomSheetState createState() =>
      ChangeStartTimeBottomSheetState();
}

class ChangeStartTimeBottomSheetState
    extends State<ChangeStartTimeBottomSheet> {
  List weekdayNameList = ["日", "一", "二", "三", "四", "五", "六"];
  List selectedDays = []; // the index of the weekdays
  Map forecast = {};

  int planToChange = 0; // 0 = 運動, 1 = 冥想

  String key = "${SettingsData.habitType}Clock";

  final ScrollController _controller = ScrollController();

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
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: Text(
              "更改${SettingsData.habitTypeZH}通知時間",
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

              key = "${SettingsData.habitType}Clock";
              selectedDays = [
                for (int i = 0; i < 7; i++)
                  if (SettingsData.userData["${SettingsData.habitType}Days"]
                          [i] ==
                      1)
                    i
              ];
              forecast = SettingsData.timeForecast[key];
              setState(() {});
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.maxFinite,
              child: Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                child: ListView(
                    controller: _controller,
                    scrollDirection: Axis.vertical,
                    children: _getTimeBtnList()),
              )),
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
                SettingsData.timeForecast[key] = forecast;
                ClockDB.update(
                    SettingsData.habitType, Map<String, String>.from(forecast));

                if (!mounted) return;
                InformDialog()
                    .get(context, "完成更改:)",
                        "${SettingsData.habitTypeZH}通知時間已更新！")
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
      backgroundColor: ColorSet.backgroundColor,
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
              backgroundColor: ColorSet.exerciseColor,
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
                    color: ColorSet.textColor,
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
                color: ColorSet.textColor,
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
          color: ColorSet.textColor,
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
                color: ColorSet.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSet.exerciseColor,
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
                    color: ColorSet.textColor,
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
                color: ColorSet.textColor,
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
              color: ColorSet.textColor,
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
          color: ColorSet.textColor,
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
                color: ColorSet.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSet.exerciseColor,
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
                    color: ColorSet.textColor,
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
                color: ColorSet.textColor,
                fontWeight: FontWeight.bold,
              ),
            )),
      ],
    );
  }
}
