import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../services/Database.dart';

class StatisticPage extends StatefulWidget {
  final Map arguments;

  const StatisticPage({super.key, required this.arguments});

  @override
  StatisticPageState createState() => StatisticPageState();
}

class StatisticPageState extends State<StatisticPage> {
  bool isInit = true;
  bool isAddingWeight = false;

  User? user = FirebaseAuth.instance.currentUser;

  // 體重
  List<double> weightDataList = [0.0];
  Map<String, double> weightDataMap = {};
  late double weight;
  late double avgWeight = 0.0;
  late DateTime? selectedDate;
  late double minY = 0.0;
  late double maxY = 0.0;

  // 計畫進度
  Map<DateTime, int> exerciseCompletionRateMap = {};
  Map<DateTime, int> meditationCompletionRateMap = {};

  //late String exerciseDate;
  //late String meditationDate;

  // 每月成功天數
  List exerciseMonthDaysList = [];
  List meditationMonthDaysList = [];
  late double maxExerciseDays = 0;
  late double maxMeditationDays = 0;
  late TooltipBehavior _tooltipBehavior;

  // toggle switch control (0 = 運動, 1 = 冥想)
  int planProgress = 0;
  int consecutiveDays = 0;
  int accumulatedTime = 0;
  int monthDays = 0;

  final Map<int, Color> colorSet = {
    1: const Color(0xfff6cdb7),
    2: const Color(0xffd4d6fc),
  };

  final ScrollController _scrollController = ScrollController();

  void getUserData() async {
    // 體重
    var weight = await WeightDB.getTable();
    if (weight != null) {
      weightDataMap =
          weight.map((key, value) => MapEntry(key as String, value.toDouble()));
      // 照時間順序排
      weightDataMap = Map.fromEntries(weightDataMap.entries.toList()
        ..sort((e1, e2) => e1.key.compareTo(e2.key)));

      weightDataList = weightDataMap.values.toList();
    }
    minY = weightDataList.reduce(min);
    maxY = weightDataList.reduce(max);
    for (int i = 1; i <= 5; i++) {
      if ((minY - i) % 5 == 0) {
        minY = minY - i;
        break;
      }
    }
    for (int i = 1; i <= 5; i++) {
      if ((maxY + i) % 5 == 0) {
        maxY = maxY + i;
        break;
      }
    }
    avgWeight = weightDataList.average;

    // 計畫進度
    var exerciseDuration = await DurationDB.getTable();
    if (exerciseDuration != null) {
      for (MapEntry entry in exerciseDuration.entries) {
        var exerciseDate = DateTime.parse(entry.key);
        exerciseCompletionRateMap[exerciseDate] =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;
      }
    }

    var meditationDuration = await MeditationDurationDB.getTable();
    if (meditationDuration != null) {
      for (MapEntry entry in meditationDuration.entries) {
        var meditationDate = DateTime.parse(entry.key);
        meditationCompletionRateMap[meditationDate] =
            (Calculator.calcProgress(entry.value).round() == 100) ? 2 : 1;
      }
    }

    // 每月成功天數
    var exerciseMonthDays = await DurationDB.getMonthTotalDays();
    var meditationMonthDays = await MeditationDurationDB.getMonthTotalDays();
    setState(() {
      exerciseMonthDaysList = exerciseMonthDays ?? [];
      meditationMonthDaysList = meditationMonthDays ?? [];
    });

    List<double> exerciseDays = [];
    for (int i = 0; i < exerciseMonthDaysList.length; i++) {
      exerciseDays.add(exerciseMonthDaysList[i][2].toDouble());
    }
    maxExerciseDays = exerciseDays.reduce(max) + 10;

    List<double> meditationDays = [];
    for (int i = 0; i < meditationMonthDaysList.length; i++) {
      meditationDays.add(meditationMonthDaysList[i][2].toDouble());
    }
    if (meditationDays.isNotEmpty) {
      // TODO: 這個判斷之後應該可以刪掉？
      maxMeditationDays = meditationDays.reduce(max) + 10;
    }

    // After getting user's data, hide the loading mask
    isInit = false;
    isAddingWeight = false;

    setState(() {});
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      shouldAlwaysShow: true,
      activationMode: ActivationMode.longPress,
      opacity: 0,
      // 隱藏預設的框框（有個對話框角角）
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xfffdfdf5).withOpacity(0.6),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  point.x,
                  style: const TextStyle(
                    color: Color(0xff4b3d70),
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${point.y} 天",
                  style: const TextStyle(
                    color: Color(0xff4b3d70),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ));
      },
    );
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xfffdfdf5),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${user?.displayName!} 的統計資料',
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Color(0xff4b3d70),
              fontSize: 28,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        backgroundColor: const Color(0xfffdfdf5),
        automaticallyImplyLeading: false,
      ),
      body: (isInit)
          ? Center(
              child: Container(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: const Color(0xffd4d6fc),
                      border: Border.all(color: const Color(0xffd4d6fc)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingAnimationWidget.horizontalRotatingDots(
                        color: const Color(0xff4b3d70),
                        size: 100,
                      ),
                      const Text(
                        "載入數據中...",
                        style: TextStyle(
                          color: Color(0xff4b3d70),
                        ),
                      )
                    ],
                  )))
          : Padding(
              padding: const EdgeInsets.all(10),
              //ListView可各分配空間給兩張圖
              child: ListView(
                controller: _scrollController,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xfffdeed9),
                            border: Border.all(color: const Color(0xffffeed9)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                /*leading: const Icon(
                            Icons.monitor_weight_outlined,
                            color: Color(0xff4b4370),
                            size: 28,
                          ),*/
                                title: const Text(
                                  "體重紀錄",
                                  style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_box_rounded),
                                  iconSize: 28,
                                  color: const Color(0xff4b4370),
                                  tooltip: "新增體重",
                                  onPressed: () async {
                                    _showAddWeightDialog();
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              Container(
                                height: 300,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 20, top: 15, bottom: 15),
                                child: (isAddingWeight)
                                    ? Center(
                                        child: LoadingAnimationWidget
                                            .horizontalRotatingDots(
                                        color: const Color(0xfffdfdf5),
                                        size: 100,
                                      ))
                                    : LineChart(
                                        LineChartData(
                                          // lineTouchData: 觸摸交互詳細訊息
                                          lineTouchData: LineTouchData(
                                            handleBuiltInTouches: true,
                                            touchTooltipData:
                                                LineTouchTooltipData(
                                              fitInsideHorizontally: true,
                                              fitInsideVertically: true,
                                              tooltipBgColor:
                                                  const Color(0xfffdfdf5)
                                                      .withOpacity(0.6),
                                              getTooltipItems:
                                                  (List<LineBarSpot>
                                                      touchedBarSpots) {
                                                return touchedBarSpots
                                                    .map((barSpot) {
                                                  final flSpot = barSpot;

                                                  return LineTooltipItem(
                                                    '${weightDataMap.keys.toList()[flSpot.x.toInt()]}\n',
                                                    const TextStyle(
                                                      color: Color(0xff4b3d70),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            '${flSpot.y.toString()} 公斤',
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xff4b3d70),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                    textAlign: TextAlign.center,
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ),
                                          extraLinesData: ExtraLinesData(
                                            horizontalLines: [
                                              HorizontalLine(
                                                y: avgWeight,
                                                label: HorizontalLineLabel(
                                                    show: true,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    labelResolver: (line) =>
                                                        '平均：${avgWeight.round()}',
                                                    alignment:
                                                        Alignment.topRight,
                                                    style: TextStyle(
                                                        color: const Color(
                                                                0xff4b3d70)
                                                            .withOpacity(0.7),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                color: const Color(0xff4b3d70)
                                                    .withOpacity(0.7),
                                                dashArray: [5, 5],
                                              ),
                                            ],
                                          ),
                                          // gridData: 網格數據
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            // Disable vertical grid lines
                                            drawHorizontalLine: true,
                                            getDrawingHorizontalLine: (value) {
                                              return FlLine(
                                                color: const Color(0xff4b3d70),
                                                strokeWidth: 0.6,
                                              );
                                            },
                                            checkToShowHorizontalLine: (value) {
                                              return value % 5 ==
                                                  0; // Show horizontal grid lines at intervals of 5
                                            },
                                          ),
                                          // titlesData: 四個方向的標題
                                          titlesData: FlTitlesData(
                                            bottomTitles: SideTitles(
                                              showTitles: false,
                                              reservedSize: 28,
                                              getTextStyles: (value) =>
                                                  const TextStyle(
                                                      color: Color(0xff4b3d70),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              getTitles: (value) {
                                                return weightDataMap.keys
                                                    .toList()[value.toInt()];
                                              },
                                              margin: 8,
                                            ),
                                            leftTitles: SideTitles(
                                              showTitles: true,
                                              getTextStyles: (value) =>
                                                  const TextStyle(
                                                      color: Color(0xff4b3d70),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                              getTitles: (value) {
                                                // Customize the display for values within the range
                                                // FIXME(?): 好像沒有一定會間隔為 5?
                                                if (value >= minY &&
                                                    value <= maxY) {
                                                  int intValue = value.toInt();
                                                  if (intValue % 5 == 0) {
                                                    return '$intValue';
                                                  }
                                                }
                                                return '';
                                              },
                                              margin: 10,
                                              reservedSize: 28,
                                            ),
                                          ),
                                          // borderData: 邊框數據
                                          borderData: FlBorderData(
                                              show: true,
                                              border: const Border(
                                                  bottom: BorderSide(
                                                color: Color(0xff4e4965),
                                                width: 0.6,
                                              ))),
                                          // lineBarsData: 數線資料
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: _getWeightData(),
                                              isCurved: false,
                                              colors: [const Color(0xffd4d6fc)],
                                              barWidth: 3,
                                              isStrokeCapRound: true,
                                              dotData: FlDotData(
                                                show: true,
                                                getDotPainter: (spot, percent,
                                                        barData, index) =>
                                                    FlDotCirclePainter(
                                                  color:
                                                      const Color(0xff4b3d70),
                                                  radius: 3,
                                                ),
                                              ),
                                            ),
                                          ],
                                          minY: minY,
                                          // y軸最小值
                                          maxY: maxY, // y軸最大值
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xfffdeed9),
                            border: Border.all(color: const Color(0xffffeed9)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(children: [
                            ListTile(
                              title: const Text(
                                '計畫進度表',
                                //(planProgress == 0) ? '運動計畫進度表' : '冥想計畫進度表',
                                style: TextStyle(
                                    color: Color(0xff4b4370),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0),
                              ),
                              trailing: ToggleSwitch(
                                minHeight: 35,
                                initialLabelIndex: planProgress,
                                cornerRadius: 10.0,
                                radiusStyle: true,
                                labels: const ['運動', '冥想'],
                                icons: const [
                                  Icons.fitness_center_outlined,
                                  Icons.self_improvement_outlined
                                ],
                                iconSize: 16,
                                activeBgColors: const [
                                  [Color(0xfff6cdb7)],
                                  [Color(0xffd4d6fc)]
                                ],
                                activeFgColor: const Color(0xff4b4370),
                                inactiveBgColor: const Color(0xfffdfdf5),
                                inactiveFgColor: const Color(0xff4b4370),
                                totalSwitches: 2,
                                //animate: true,
                                //animationDuration: 300,
                                onToggle: (index) {
                                  planProgress = index!;
                                  setState(() {});
                                },
                              ),
                              visualDensity: const VisualDensity(vertical: -4),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: HeatMapCalendar(
                                defaultColor: const Color(0xfffdfdf5),
                                textColor: const Color(0xff4b4370),
                                weekTextColor:
                                    const Color(0xff4b4370).withOpacity(0.7),
                                colorMode: ColorMode.color,
                                fontSize: 18,
                                weekFontSize: 14,
                                monthFontSize: 16,
                                flexible: true,
                                margin: const EdgeInsets.all(2.5),
                                datasets: (planProgress == 0)
                                    ? exerciseCompletionRateMap
                                    : meditationCompletionRateMap,
                                colorsets: colorSet,
                                colorTipCount: 2,
                                colorTipSize: 20,
                                colorTipHelper: const [
                                  Text(
                                    "失敗 ",
                                    style: TextStyle(
                                        color: Color(0xff4b4370),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    " 成功",
                                    style: TextStyle(
                                        color: Color(0xff4b4370),
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                                onClick: (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value.toString())),
                                  );
                                },
                              ),
                            )
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xfffdeed9),
                              border:
                                  Border.all(color: const Color(0xffffeed9)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              ListTile(
                                title: const Text(
                                  '連續完成天數',
                                  //(consecutiveDays == 0) ? '連續完成運動天數' : '連續完成冥想天數',
                                  style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                                trailing: ToggleSwitch(
                                  minHeight: 35,
                                  initialLabelIndex: consecutiveDays,
                                  cornerRadius: 10.0,
                                  radiusStyle: true,
                                  labels: const ['運動', '冥想'],
                                  icons: const [
                                    Icons.fitness_center_outlined,
                                    Icons.self_improvement_outlined
                                  ],
                                  iconSize: 16,
                                  activeBgColors: const [
                                    [Color(0xfff6cdb7)],
                                    [Color(0xffd4d6fc)]
                                  ],
                                  activeFgColor: const Color(0xff4b4370),
                                  inactiveBgColor: const Color(0xfffdfdf5),
                                  inactiveFgColor: const Color(0xff4b4370),
                                  totalSwitches: 2,
                                  onToggle: (index) {
                                    consecutiveDays = index!;
                                    setState(() {});
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              (consecutiveDays == 0)
                                  ? const Text("連續完成運動天數 coming soon")
                                  : const Text("連續完成冥想天數 coming soon")
                            ])),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xfffdeed9),
                              border:
                                  Border.all(color: const Color(0xffffeed9)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              ListTile(
                                title: const Text(
                                  '累積時長',
                                  //(accumulatedTime == 0) ? '累積運動時長' : '累積冥想時長',
                                  style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                                trailing: ToggleSwitch(
                                  minHeight: 35,
                                  initialLabelIndex: accumulatedTime,
                                  cornerRadius: 10.0,
                                  radiusStyle: true,
                                  labels: const ['運動', '冥想'],
                                  icons: const [
                                    Icons.fitness_center_outlined,
                                    Icons.self_improvement_outlined
                                  ],
                                  iconSize: 16,
                                  activeBgColors: const [
                                    [Color(0xfff6cdb7)],
                                    [Color(0xffd4d6fc)]
                                  ],
                                  activeFgColor: const Color(0xff4b4370),
                                  inactiveBgColor: const Color(0xfffdfdf5),
                                  inactiveFgColor: const Color(0xff4b4370),
                                  totalSwitches: 2,
                                  onToggle: (index) {
                                    accumulatedTime = index!;
                                    setState(() {});
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              (accumulatedTime == 0)
                                  ? const Text("運動累積時長 coming soon")
                                  : const Text("冥想累積時長 coming soon")
                            ])),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xfffdeed9),
                            border: Border.all(color: const Color(0xffffeed9)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(children: [
                            ListTile(
                              title: const Text(
                                '每月成功天數',
                                //(monthDays == 0) ? '每月成功運動天數' : '每月成功冥想天數',
                                style: TextStyle(
                                    color: Color(0xff4b4370),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0),
                              ),
                              trailing: ToggleSwitch(
                                minHeight: 35,
                                initialLabelIndex: monthDays,
                                cornerRadius: 10.0,
                                radiusStyle: true,
                                labels: const ['運動', '冥想'],
                                icons: const [
                                  Icons.fitness_center_outlined,
                                  Icons.self_improvement_outlined
                                ],
                                iconSize: 16,
                                activeBgColors: const [
                                  [Color(0xfff6cdb7)],
                                  [Color(0xffd4d6fc)]
                                ],
                                activeFgColor: const Color(0xff4b4370),
                                inactiveBgColor: const Color(0xfffdfdf5),
                                inactiveFgColor: const Color(0xff4b4370),
                                totalSwitches: 2,
                                //animate: true,
                                //animationDuration: 300,
                                onToggle: (index) {
                                  monthDays = index!;
                                  setState(() {});

                                  // TODO: 可能可以刪，或是確認要加在哪些地方（完成統計頁後)
                                  // add "scrolling automatically function" in the last container
                                  // to scroll the listview to bottom automatically
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeOut);
                                  });
                                },
                              ),
                              visualDensity: const VisualDensity(vertical: -4),
                            ),
                            (monthDays == 0)
                                ? Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: SfCartesianChart(
                                        // hide the border
                                        plotAreaBorderWidth: 0,
                                        primaryXAxis: CategoryAxis(
                                          axisLine: const AxisLine(
                                            color: Color(0xff4b4370),
                                            width: 0.6,
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Color(0xff4b4370),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          // set 0 or transparent color to hide grid lines and tick lines
                                          majorTickLines:
                                              const MajorTickLines(size: 0),
                                          majorGridLines: const MajorGridLines(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        primaryYAxis: NumericAxis(
                                          // must set for data label (above the column)
                                          labelFormat: '{value} 天',
                                          minimum: 0,
                                          maximum: maxExerciseDays,
                                          interval: 3,
                                          // set 0 to hide grid lines and tick lines
                                          axisLine: const AxisLine(width: 0),
                                          labelStyle: const TextStyle(
                                            fontSize: 0,
                                          ),
                                          majorTickLines:
                                              const MajorTickLines(size: 0),
                                          majorGridLines: const MajorGridLines(
                                            color: Color(0xff4b4370),
                                          ),
                                        ),
                                        // TODO: need tooltip? or just show days above columns like now
                                        tooltipBehavior: _tooltipBehavior,
                                        series: <
                                            ChartSeries<ChartData, String>>[
                                          ColumnSeries<ChartData, String>(
                                            dataSource:
                                                getExerciseMonthDaysData(),
                                            xValueMapper: (ChartData data, _) =>
                                                data.x,
                                            yValueMapper: (ChartData data, _) =>
                                                data.y,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                                    isVisible: true,
                                                    textStyle: TextStyle(
                                                        color:
                                                            Color(0xff4b4370),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            color: const Color(0xffd4d6fc),
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10)),
                                          )
                                        ]))
                                : (meditationMonthDaysList.isNotEmpty)
                                    // TODO: 這個判斷之後應該可以刪掉?
                                    ? Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child: SfCartesianChart(
                                            // hide the border
                                            plotAreaBorderWidth: 0,
                                            primaryXAxis: CategoryAxis(
                                              axisLine: const AxisLine(
                                                color: Color(0xff4b4370),
                                                width: 0.6,
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Color(0xff4b4370),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              // set 0 or transparent color to hide grid lines and tick lines
                                              majorTickLines:
                                                  const MajorTickLines(size: 0),
                                              majorGridLines:
                                                  const MajorGridLines(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            primaryYAxis: NumericAxis(
                                              // must set for data label (above the column)
                                              labelFormat: '{value} 天',
                                              minimum: 0,
                                              maximum: maxMeditationDays,
                                              interval: 7,
                                              // set 0 to hide grid lines and tick lines
                                              axisLine:
                                                  const AxisLine(width: 0),
                                              labelStyle: const TextStyle(
                                                fontSize: 0,
                                              ),
                                              majorTickLines:
                                                  const MajorTickLines(size: 0),
                                              majorGridLines:
                                                  const MajorGridLines(
                                                color: Color(0xff4b4370),
                                              ),
                                            ),
                                            // TODO: need tooltip? or just show days above columns like now
                                            tooltipBehavior: _tooltipBehavior,
                                            series: <
                                                ChartSeries<ChartData, String>>[
                                              ColumnSeries<ChartData, String>(
                                                dataSource:
                                                    getMeditationMonthDaysData(),
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y,
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        isVisible: true,
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xff4b4370),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                color: const Color(0xffd4d6fc),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(
                                                                10)),
                                              )
                                            ]))
                                    : const Text("冥想沒成功過，加油好嗎:(((("),
                          ]),
                        ),
                      ]),
                ],
              ),
            ),
    ));
  }

  _showAddWeightDialog() async {
    TextEditingController weightController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Weight'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 1),
              InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                    dateController.text = Calendar.toKey(selectedDate!);
                  }
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isAddingWeight = true;
                });

                double weight = double.tryParse(weightController.text) ?? 0;
                if (weight > 0 && selectedDate != null) {
                  Map<String, double> addedData = {
                    Calendar.toKey(selectedDate!): weight
                  };
                  await WeightDB.update(addedData);
                  getUserData();
                }
                weightController.clear(); // Clear weight text field
                dateController.clear(); // Clear date text field

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  List<FlSpot> _getWeightData() {
    if (weightDataList.isEmpty) {
      return [];
    }

    return List.generate(
      weightDataList.length,
      (index) => FlSpot(index.toDouble(), weightDataList[index]),
    );
  }

  Map month = {
    "01": "Jan",
    "02": "Feb",
    "03": "Mar",
    "04": "Apr",
    "05": "May",
    "06": "Jun",
    "07": "Jul",
    "08": "Aug",
    "09": "Sep",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec"
  };

  // FIXME: 顯示年份（但這應該可以放不重要TODO）
  List<ChartData> getExerciseMonthDaysData() {
    List<ChartData> chartData = [];

    if (exerciseMonthDaysList.isEmpty) {
      return [];
    }

    print("exerciseMonthDaysList: $exerciseMonthDaysList");
    // [[2023-04-01, 2023-04-30, 1], [2023-05-01, 2023-05-31, 7], [2023-06-01, 2023-06-30, 3], [2023-07-01, 2023-07-31, 0]]

    for (int i = 0; i < exerciseMonthDaysList.length; i++) {
      String monthEng = month[exerciseMonthDaysList[i][0].split("-")[1]];
      chartData.add(ChartData(monthEng, exerciseMonthDaysList[i][2]));
    }

    return chartData;
  }

  List<ChartData> getMeditationMonthDaysData() {
    List<ChartData> chartData = [];

    if (meditationMonthDaysList.isEmpty) {
      print("meditationMonthDaysList is empty!");
      return [];
    }

    print("meditationMonthDaysList: $meditationMonthDaysList");

    for (int i = 0; i < meditationMonthDaysList.length; i++) {
      String monthEng = month[meditationMonthDaysList[i][0].split("-")[1]];
      chartData.add(ChartData(monthEng, meditationMonthDaysList[i][2]));
    }

    return chartData;
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final int y;
}
