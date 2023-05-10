import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:g12/screens/RegisterPage.dart';
import 'package:g12/screens/QuestionnairePage.dart';
import 'package:g12/screens/Homepage.dart';
import 'package:g12/screens/StatisticPage.dart';
import 'package:g12/screens/ContractPage.dart';
import 'package:g12/screens/CountdownPage.dart';
import 'package:g12/screens/ExercisePage.dart';
import 'package:g12/screens/CustomizedPage.dart';

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'for_my_fat',
      initialRoute: '/register', //加route
      routes: {
        '/': (context) => Homepage(title: "Homepage"),
        '/statistic': (context) => StatisticPage(title: "StatisticPage"),
        '/constract': (context) => ContractPage(title: "ContractPage"),
        '/countdown': (context) => CountdownPage(title: "CountdownPage"),
        '/exercise': (context) => ExercisePage(title: "ExercisePage"),
        '/register': (context) => RegisterPage(title: "RegisterPage", isLoginPage: true),
        '/questionnaire': (context) => QuestionnairePage(),
        '/customized': (context) => CustomizedPage(),
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
