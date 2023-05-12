import 'package:flutter/material.dart';

import 'package:g12/screens/RegisterPage.dart';
import 'package:g12/screens/QuestionnairePage.dart';
import 'package:g12/screens/Homepage.dart';
import 'package:g12/screens/StatisticPage.dart';
import 'package:g12/screens/ContractPage.dart';
import 'package:g12/screens/CountdownPage.dart';
import 'package:g12/screens/ExercisePage.dart';
import 'package:g12/screens/UserProfilePage.dart';
import 'package:path/path.dart';

//配置路由規則
final routes = {
  '/': (context, {user}) => Homepage(user: user),
  '/statistic': (context) => StatisticPage(),
  '/constract': (context) => ContractPage(),
  '/countdown': (context) => CountdownPage(),
  '/exercise': (context) => ExercisePage(),
  '/register': (context) =>
      RegisterPage(title: "RegisterPage", isLoginPage: true),
  '/questionnaire': (context, {user}) => QuestionnairePage(user: user),
  '/customized': (context, {arguments}) => UserProfilePage(arguments: arguments),
};

// 如果你要把路由抽離出去，必須寫下面這一堆的程式碼，不用理解什麼意思
var onGenerateRoute = (RouteSettings settings) {
  // 統一處理
  final String? name = settings.name; // diff
  final Function pageContentBuilder = routes[name] as Function; // diff
  if (pageContentBuilder != null) {
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
  }
};
