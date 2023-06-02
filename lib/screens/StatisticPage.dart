import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../services/Database.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  List<List<double>> res = [
    [0.0]
  ];
  List<double> list1 = [0.0];
  Map<String, double> weightDataList = {};
  Map<DateTime, int> completionRateList = {};
  late double weight;
  late String date;
  late DateTime? selectedDate;
  late double minY = 0.0;
  late double maxY = 0.0;

  final Map<int, Color> colorSet = {
    1: Colors.red.shade300,
    2: Colors.green.shade300,
  };

  void getUserData() async {
    var weight = await WeightDB.getTable();
    if (weight != null) {
      weightDataList =
          weight.map((key, value) => MapEntry(key as String, value.toDouble()));
      list1 = weightDataList.values.toList();
    }

    var duration = await DurationDB.getTable();
    if (duration != null) {
      for (MapEntry entry in duration.entries) {
        var date = DateTime.parse(entry.key);
        completionRateList[date] =
            (await DurationDB.calcProgress(date) == 100) ? 2 : 1;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    updateYAxisRange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            '統計資料',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 32,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          actions: [],
          backgroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddWeightDialog(); // Show dialog to add weight
          },
          backgroundColor: Color(0xffffa493),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Padding(
          padding: EdgeInsets.all(16),
          //ListView可各分配空間給兩張圖
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //FIXME: 統計頁面待美化
                Text(
                  'Statistics:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // FIXME: 體重圖表初次無法顯示折線圖，需要加入體重後才會顯示
                Container(
                  height: 300,
                  padding: EdgeInsets.only(right: 40, top: 20),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchCallback: (LineTouchResponse touchResponse) {},
                        handleBuiltInTouches: true,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        // Disable vertical grid lines
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey,
                            strokeWidth: 0.5,
                          );
                        },
                        checkToShowHorizontalLine: (value) {
                          return value % 5 ==
                              0; // Show horizontal grid lines at intervals of 5
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTextStyles: (value) => const TextStyle(
                              color: Colors.black, fontSize: 10),
                          getTitles: (value) {
                            int index = value.toInt();
                            if (index >= 0 && index < res.length) {
                              int timestamp = res[index][0].toInt();
                              DateTime dateTime =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      timestamp);
                              return Calendar.toKey(dateTime);
                            }
                            return '';
                          },
                          margin: 8,
                        ),
                        // FIXME: 體重圖表的最大值應該是體重的最大值加 10(or 5)，反之亦然
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Colors.black, fontSize: 10),
                          getTitles: (value) {
                            double weight = list1.isNotEmpty
                                ? list1[list1.length - 1]
                                : 0.0;
                            double minValue = weight - 10;
                            double maxValue = weight + 10;

                            // Customize the display for values within the range
                            if (value >= minValue && value <= maxValue) {
                              int intValue = value.toInt();
                              if (intValue % 5 == 0) {
                                return '$intValue';
                              }
                            }
                            return '';
                          },
                          margin: 8,
                          reservedSize: 28,
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getWeightData(),
                          isCurved: false,
                          colors: [Colors.blue],
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              color: Colors.black,
                              radius: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 80, left: 20, top: 20),
                  child: Text(
                    '當月進度表',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        backgroundColor: Colors.yellow,
                        color: Color(0xff0d3b66),
                        fontSize: 32,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.bold,
                        height: 1),
                  ),
                ),
                Container(
                  height: 500,
                  child: HeatMapCalendar(
                    defaultColor: Colors.white,
                    flexible: true,
                    colorMode: ColorMode.color,
                    datasets: completionRateList,
                    colorsets: colorSet,
                    onClick: (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value.toString())),
                      );
                    },
                  ),
                )
              ],
            ),
          ]),
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
              onPressed: () {
                double weight = double.tryParse(weightController.text) ?? 0;
                if (weight > 0 && selectedDate != null) {
                  setState(() async {
                    // Add the weight data to the chart
                    list1.add(weight);
                    // Add the date to the chart
                    res.add([selectedDate!.millisecondsSinceEpoch.toDouble()]);
                    Map<String, double> addedData = {
                      Calendar.toKey(selectedDate!): weight
                    };
                    weightDataList.addAll(addedData);
                    // Update to database
                    await WeightDB.update(addedData);
                    // Update the y-axis range
                    updateYAxisRange();
                  });
                }
                weightController.clear(); // Clear weight text field
                dateController.clear(); // Clear date text field
                Navigator.of(context).pop();
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

  // Update the updateYAxisRange() method
  void updateYAxisRange() {
    if (list1.isEmpty) {
      return;
    }

    double minValue = list1.reduce(min) - 10;
    double maxValue = list1.reduce(max) + 10;

    if (minValue < minY) {
      minY = minValue;
    }

    if (maxValue > maxY) {
      maxY = maxValue;
    }

    setState(() {});
  }
}
