import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:g12/services/page_data.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:g12/screens/community_page.dart';
import 'package:g12/screens/home_page.dart';
import 'package:g12/screens/gamification_page.dart';
import 'package:g12/screens/routes.dart';
import 'package:g12/screens/statistic_page.dart';
import 'package:g12/screens/settings_page.dart';

import 'package:g12/screens/page_material.dart';

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    String initialRoute = "";
    if (FirebaseAuth.instance.currentUser == null) {
      initialRoute = "/register";
    } else {
      initialRoute = "/";
    }

    // TODO: 確認若登出後重新登入，頁面顯示有無問題
    return MaterialApp(
      title: 'for_my_fat',
      initialRoute: initialRoute,
      // 加 route
      onGenerateRoute: onGenerateRoute,
      // route 抽離
      home: const Scaffold(
        body: BottomNavigationController(),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class BottomNavigationController extends StatefulWidget {
  const BottomNavigationController({super.key});

  @override
  BottomNavigationControllerState createState() =>
      BottomNavigationControllerState();
}

class BottomNavigationControllerState
    extends State<BottomNavigationController> {
  // 目前選擇頁索引值
  int _currentIndex = 2; // 預設值 = homepage
  // TODO: 確認 arguments 會不會有問題
  // 先初始一個 list 才不會出現 RangeError (index): Invalid value: Valid value range is empty: 2
  List<Widget> pages = [
    const StatisticPage(),
    const GamificationPage(),
    const Homepage(),
    const CommunityPage(arguments: {}),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.pinned,
          snakeShape: SnakeShape.circle,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
          padding: EdgeInsets.zero,
          height: 80,
          backgroundColor: ColorSet.bottomBarColor,
          snakeViewColor: const Color(0xFFFDFDFD),
          selectedItemColor: const Color(0xFF2F4F4F),
          unselectedItemColor: const Color(0xFF2F4F4F),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (Data.updated) {
              switch (_currentIndex) {
                case 0:
                  StatData.fetch();
                  break;
                case 1:
                  GameData.fetch();
                  break;
                case 2:
                  HomeData.fetch();
                  break;
                case 4:
                  SettingsData.fetch();
                  break;
              }
            }

            setState(() {
              _currentIndex = index;
              EasyLoading.dismiss();
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.bar_chart_outlined,
                  size: 40,
                ),
                label: 'tickets'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.workspace_premium_outlined,
                  size: 40,
                ),
                label: 'calendar'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 40,
                ),
                label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.groups,
                  size: 40,
                ),
                label: 'microphone'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_outlined,
                  size: 40,
                ),
                label: 'search')
          ],
        ));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configure firebase: https://stackoverflow.com/questions/70320263/the-term-flutterfire-is-not-recognized-as-the-name-of-a-cmdlet-function-scri
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) await Data.init();
  initializeDateFormatting().then((_) => runApp(const AppEntryPoint()));
}
