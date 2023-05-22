import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:g12/CalendarPage.dart';
import 'package:g12/screens/Routes.dart';

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'for_my_fat',
      initialRoute: '/register', // 加 route
      onGenerateRoute:onGenerateRoute, // route 抽離
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configure firebase: https://stackoverflow.com/questions/70320263/the-term-flutterfire-is-not-recognized-as-the-name-of-a-cmdlet-function-scri
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(const AppEntryPoint()));
}
