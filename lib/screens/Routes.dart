import 'package:flutter/material.dart';

import 'package:g12/screens/ContractPage.dart';
import 'package:g12/screens/CountdownPage.dart';
import 'package:g12/screens/ExercisePage.dart';
import 'package:g12/screens/HomePage.dart';
import 'package:g12/screens/MilestonePage.dart';
import 'package:g12/screens/LinePayPage.dart';
import 'package:g12/screens/QuestionnairePage.dart';
import 'package:g12/screens/RegisterPage.dart';
import 'package:g12/screens/StatisticPage.dart';
import 'package:g12/screens/SettingsPage.dart';

//配置路由規則
final routes = {
  '/': (context) => const Homepage(),
  '/register': (context) => const RegisterPage(isLoginPage: true),
  '/statistic': (context) => const StatisticPage(),
  '/countdown': (context, {arguments}) => CountdownPage(arguments: arguments),
  '/exercise': (context, {arguments}) => ExercisePage(arguments: arguments),
  '/settings': (context, {arguments}) => const SettingsPage(),
  '/milestone': (context, {arguments}) => const MilestonePage(),
  /* ContractPage */
  '/contract/initial': (context, {arguments}) =>
      FirstContractPage(arguments: arguments),
  '/contract': (context, {arguments}) =>
      SecondContractPage(arguments: arguments),
  '/pay': (context, {arguments}) => PayPage(arguments: arguments),
  '/pay/password': (context, {arguments}) => PasswordPage(arguments: arguments),
  '/pay/checkout': (context, {arguments}) => ConfirmPage(arguments: arguments),
  /* QuestionnairePage */
  '/questionnaire/1': (context, {arguments}) => FirstPage(arguments: arguments),
  '/questionnaire/2': (context, {arguments}) =>
      SecondPage(arguments: arguments),
  '/questionnaire/3': (context, {arguments}) => ThirdPage(arguments: arguments),
  '/questionnaire/4': (context, {arguments}) => ForthPage(arguments: arguments),
  '/questionnaire/5': (context, {arguments}) => FifthPage(arguments: arguments),
  '/questionnaire/6': (context, {arguments}) => SixthPage(arguments: arguments),
  '/questionnaire/result': (context, {arguments}) => ResultPage(
        arguments: arguments,
      ),
};

var onGenerateRoute = (RouteSettings settings) {
  // 統一處理
  final String? name = settings.name;
  final Function pageContentBuilder = routes[name] as Function;
  if (settings.arguments != null) {
    final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments));
    return route;
  } else {
    final Route route =
        MaterialPageRoute(builder: (context) => pageContentBuilder(context));
    return route;
  }
};
