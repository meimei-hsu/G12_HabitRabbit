import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:g12/screens/homepage.dart';
import 'package:g12/screens/statisticPage.dart';
import 'package:g12/screens/ContractPage.dart';

class AppEntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'for_my_fat',
      initialRoute: '/', //加route
      routes: {
        '/': (context) => Homepage(title: "Homepage"),
        '/statistic': (context) => StatisticPage(title: "Statisticpage"),
        '/constract': (context) => ContractPage(title: "Contractpage"),
      },
      //home: const Homepage(title: "Homepage")
    );
  }
}

void main() {
  initializeDateFormatting().then((_) => runApp(AppEntryPoint()));
  //runApp(AppEntryPoint());
}
