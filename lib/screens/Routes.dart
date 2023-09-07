import 'package:flutter/material.dart';
import 'package:g12/screens/CommunityPage.dart';
import 'package:g12/screens/ContractPage.dart';
import 'package:g12/screens/CountdownPage.dart';
import 'package:g12/screens/ExercisePage.dart';
import 'package:g12/screens/HabitDetailPage.dart';
import 'package:g12/screens/HomePage.dart';
import 'package:g12/screens/MilestonePage.dart';
import 'package:g12/screens/LinePayPage.dart';
import 'package:g12/screens/QuestionnairePage.dart';
import 'package:g12/screens/RegisterPage.dart';
import 'package:g12/screens/StatisticPage.dart';
import 'package:g12/screens/SettingsPage.dart';
import 'package:g12/screens/VideoPage.dart';

//配置路由規則
final routes = {
  '/': (context) => const Homepage(),
  '/register': (context) => const RegisterPage(),
  '/statistic': (context, {arguments}) => StatisticPage(arguments: arguments),
  '/countdown': (context, {arguments}) => CountdownPage(arguments: arguments),
  '/settings': (context, {arguments}) => const SettingsPage(),
  '/milestone': (context, {arguments}) => MilestonePage(arguments: arguments),
  '/community': (context, {arguments}) => CommunityPage(arguments: arguments),
  '/video': (context, {arguments}) => VideoPage(arguments: arguments),
  /* ExercisePage */
  '/exercise': (context, {arguments}) => DoExercisePage(arguments: arguments),
  '/meditation': (context, {arguments}) =>
      DoMeditationPage(arguments: arguments),
  /* HabitDetailPage */
  '/detail/exercise': (context, {arguments}) =>
      ExerciseDetailPage(arguments: arguments),
  '/detail/meditation': (context, {arguments}) =>
      MeditationDetailPage(arguments: arguments),
  /* ContractPage */
  '/contract/initial': (context, {arguments}) =>
      FirstContractPage(arguments: arguments),
  '/contract': (context, {arguments}) => const SecondContractPage(),
  '/contract/already': (context, {arguments}) => const AlreadyContractPage(),
  /* LinePayPage */
  '/pay': (context, {arguments}) => PayPage(arguments: arguments),
  '/pay/password': (context, {arguments}) => const PasswordPage(),
  '/pay/checkout': (context, {arguments}) => const ConfirmPage(),
  /* QuestionnairePage */
  '/questionnaire': (context, {arguments}) => TitlePage(arguments: arguments),
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
