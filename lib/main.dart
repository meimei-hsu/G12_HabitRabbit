import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import 'package:g12/screens/Routes.dart';
import 'package:g12/screens/ContractPage.dart';
import 'package:g12/screens/HomePage.dart';
import 'package:g12/screens/MilestonePage.dart';
import 'package:g12/screens/StatisticPage.dart';
import 'package:g12/screens/SettingsPage.dart';

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    String initialRoute = "";
    if (currentUser == null) {
      initialRoute = "/register";
    } else {
      initialRoute = "/";
    }

    // TODO: 確認若登出後重新登入，頁面顯示有無問題
    return MaterialApp(
      title: 'for_my_fat',
      initialRoute: initialRoute, // 加 route
      onGenerateRoute: onGenerateRoute, // route 抽離
      home: const Scaffold(
        body: BottomNavigationController(),
      ),
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
  var user = FirebaseAuth.instance.currentUser;

  // 目前選擇頁索引值
  int _currentIndex = 2; // 預設值 = homepage
  // TODO: 確認 arguments 會不會有問題
  final pages = [
    const StatisticPage(arguments: {}),
    const MilestonePage(arguments: {}),
    const Homepage(),
    const FirstContractPage(arguments: {}), // TODO: 判斷有無立合約決定要跳頁面
    const SettingsPage(arguments: {})
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
          backgroundColor: const Color(0xffd4d6fc),
          snakeViewColor: const Color(0xfffdfdf5),
          selectedItemColor: const Color(0xff4b3d70),
          unselectedItemColor: const Color(0xff4b3d70),
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.insights,
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
                  Icons.request_quote_outlined,
                  size: 40,
                ),
                label: 'microphone'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.manage_accounts_outlined,
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
  initializeDateFormatting().then((_) => runApp(const AppEntryPoint()));
}
