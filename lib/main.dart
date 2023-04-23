import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:g12/screens/homepage.dart';
import 'package:g12/screens/statisticPage.dart';
import 'package:g12/screens/ContractPage.dart';
import 'package:g12/screens/CountdownPage.dart';
import 'package:g12/screens/ExercisePage.dart';

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'for_my_fat',
      initialRoute: '/', //加route
      routes: {
        '/': (context) => Homepage(title: "Homepage"),
        '/statistic': (context) => StatisticPage(title: "StatisticPage"),
        '/constract': (context) => ContractPage(title: "ContractPage"),
        '/countdown': (context) => CountdownPage(title: "CountdownPage"),
        '/exercise': (context) => ExercisePage(title: "ExercisePage"),
      },
      //home: const Homepage(title: "Homepage")
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configure firebase: https://stackoverflow.com/questions/70320263/the-term-flutterfire-is-not-recognized-as-the-name-of-a-cmdlet-function-scri
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(AppEntryPoint()));
}
