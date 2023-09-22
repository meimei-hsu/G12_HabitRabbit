import 'package:flutter/material.dart';
import 'package:g12/screens/community_page.dart';
import 'package:g12/screens/contract_page.dart';
import 'package:g12/screens/countdown_page.dart';
import 'package:g12/screens/exercise_page.dart';
import 'package:g12/screens/habit_detail_page.dart';
import 'package:g12/screens/home_page.dart';
import 'package:g12/screens/milestone_page.dart';
import 'package:g12/screens/line_pay_page.dart';
import 'package:g12/screens/survey_page.dart';
import 'package:g12/screens/register_page.dart';
import 'package:g12/screens/statistic_page.dart';
import 'package:g12/screens/settings_page.dart';
import 'package:g12/screens/video_page.dart';

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
