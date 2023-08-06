import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
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
  List<List<double>> res = [
    [0.0]
  ];
  List<double> list1 = [0.0];

  Map<String, double> weightDataList = {};
  Map<DateTime, int> completionRateList = {};

  late double weight;
  late double avgWeight = 0.0;
  late String date;
  late DateTime? selectedDate;
  late double minY = 0.0;
  late double maxY = 0.0;

  int planProgress = 0; // 0 = 運動, 1 = 冥想

  final Map<int, Color> colorSet = {
    1: const Color(0xfff6cdb7),
    2: const Color(0xffd4d6fc),
  };

  final ScrollController _scrollController = ScrollController();

  void getUserData() async {
    var weight = await WeightDB.getTable();
    if (weight != null) {
      weightDataList =
          weight.map((key, value) => MapEntry(key as String, value.toDouble()));
      // 照時間順序排
      weightDataList = Map.fromEntries(weightDataList.entries.toList()
        ..sort((e1, e2) => e1.key.compareTo(e2.key)));
      list1 = weightDataList.values.toList();
    }
    minY = list1.reduce(min);
    maxY = list1.reduce(max);
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
    avgWeight = list1.average;

    var duration = await DurationDB.getTable();
    if (duration != null) {
      for (MapEntry entry in duration.entries) {
        var date = DateTime.parse(entry.key);
        completionRateList[date] =
            (await DurationDB.calcProgress(date) == 100) ? 2 : 1;
      }
    }

    isInit = false;
    isAddingWeight = false;

    setState(() {});
    EasyLoading.dismiss();
  }

  // Loading mask 屬性
  void configLoading() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.threeBounce
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 50.0
      ..radius = 20.0
      ..backgroundColor = const Color(0xffd4d6fc)
      ..indicatorColor = const Color(0xff4b3d70)
      ..textColor = const Color(0xff4b3d70)
      ..textPadding = const EdgeInsets.all(20)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  void initState() {
    super.initState();

    configLoading();
    EasyLoading.show(
      status: '載入數據中...',
      maskType: EasyLoadingMaskType.clear,
    );

    getUserData();
  }

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
          ? Container()
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
                                                    '${weightDataList.keys.toList()[flSpot.x.toInt()]}\n',
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
                                                strokeWidth: 0.5,
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
                                                return weightDataList.keys
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
                                                width: 0.5,
                                              ))),
                                          // lineBarsData: 數線資料
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: _getWeightData(),
                                              isCurved: false,
                                              // 曲線 or 折線?
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
                            (planProgress == 0)
                                ? Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: HeatMapCalendar(
                                      defaultColor: const Color(0xfffdfdf5),
                                      textColor: const Color(0xff4b4370),
                                      weekTextColor: const Color(0xff4b4370)
                                          .withOpacity(0.7),
                                      colorMode: ColorMode.color,
                                      fontSize: 18,
                                      weekFontSize: 14,
                                      monthFontSize: 16,
                                      flexible: true,
                                      margin: const EdgeInsets.all(2.5),
                                      datasets: completionRateList,
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(value.toString())),
                                        );
                                      },
                                      onMonthChange: (value) {
                                        // TODO: remove "scrolling automatically function" after adding more chart
                                        // to scroll the listview to bottom automatically when the size of calendar's container change
                                        // if set container's height, there will be a big, blank space -> ugly
                                        // so choose to scroll automatically temporarily to maximize UX (?)
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              curve: Curves.easeOut);
                                        });
                                      },
                                    ),
                                  )
                                : const Text("Coming Soon!!!"),
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
    if (list1.isEmpty) {
      return [];
    }

    return List.generate(
      list1.length,
      (index) => FlSpot(index.toDouble(), list1[index]),
    );
  }
}
