import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

class StatisticPage extends StatefulWidget {

  const StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  List<List<double>> res = [[0.0]];
  List<double> list1 = [0.0];
  List<Map<String, double>> weightDataList = [];
  late double weight;
  late String date;
  late DateTime? selectedDate;
  late double minY = 0.0;
  late double maxY = 0.0;

  final Map<DateTime, int> datasets = {
    DateTime(2023, 5, 1): 1,
    DateTime(2023, 5, 7): 2,
    DateTime(2023, 5, 13): 2,
    DateTime(2023, 5, 18): 1,
    DateTime(2023, 5, 20): 2,

    DateTime(2023, 6, 6): 1,
    DateTime(2023, 6, 7): 2,
    DateTime(2023, 6, 12): 1,
    DateTime(2023, 6, 14): 1,
  };

  final Map<int, Color> colorsets = {
    1: Colors.red.shade200,
    2: Colors.green.shade200,
  };

  get icon => null;

  @override
  void initState() {
    super.initState();
    updateYAxisRange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [],
          backgroundColor: Colors.white,
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
          child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //FIXME: 統計頁面待美化
                    Text(
                      '體重表',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
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
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Colors.black, fontSize: 10),
                              getTitles: (value) {
                                int index = value.toInt();
                                if (index >= 0 && index < res.length) {
                                  int timestamp = res[index][0].toInt();
                                  DateTime dateTime = DateTime
                                      .fromMillisecondsSinceEpoch(timestamp);
                                  return '${dateTime.year}-${dateTime.month
                                      .toString().padLeft(2, '0')}-${dateTime
                                      .day.toString().padLeft(2, '0')}';
                                }
                                return '';
                              },
                              margin: 8,
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                              const TextStyle(
                                  color: Colors.black, fontSize: 10),
                              getTitles: (value) {
                                double weight = list1.isNotEmpty ? list1[list1
                                    .length - 1] : 0.0;
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
                                getDotPainter: (spot, percent, barData,
                                    index) =>
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
                      padding: EdgeInsets.only(right: 80, left: 20, top: 40),
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
                      height: 550,
                      padding: EdgeInsets.only(top: 20),
                      child: HeatMapCalendar(
                        defaultColor: Colors.white,
                        flexible: true,
                        colorMode: ColorMode.color,
                        datasets: datasets,
                        colorsets: colorsets,
                        onClick: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(value.toString())),
                          );
                        },

                      ),
                    )
                  ],
                ),
              ]
          ),
        )
    );
  }

  _showAddWeightDialog() async {
    TextEditingController weightController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('新增體重'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: '體重數值(kg)',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 1),
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
                    //dateController.text = selectedDate.toString()
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate!);
                  }
                },

                child: IgnorePointer(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: '日期',
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
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                double weight = double.tryParse(weightController.text) ?? 0;
                if (weight > 0 && selectedDate != null) {
                  setState(() {
                    // Remove 0.0 values from list1
                    list1.removeWhere((value) => value == 0.0);
                    // Add the weight data to the chart
                    list1.add(weight);
                    // Add the date to the chart
                    res.add([selectedDate!.millisecondsSinceEpoch.toDouble()]);
                    weightDataList.add({selectedDate!.toString(): weight});
                    // Update the y-axis range
                    updateYAxisRange();
                  });
                  // 更新圖表數據
                  updateChart();
                }
                print(weightDataList); //TODO List
                print(res);
                print(list1);
                weightController.clear(); // Clear weight text field
                dateController.clear(); // Clear date text field
                Navigator.of(context).pop();
              },
              child: Text('新增'),
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

  void updateChart() {
    // 更新後，按照日期排序體重數據
    weightDataList.sort((a, b) {
      final DateTime aDate = DateTime.parse(a.keys.first);
      final DateTime bDate = DateTime.parse(b.keys.first);
      return aDate.compareTo(bDate);
    });

    // 清空之前的圖表數據
    res.clear();
    // 根據 weightDataList 的日期順序重新排列 list1
    list1 = weightDataList.map((entry) => entry.values.first).toList();

    // 遍歷排序後的 weightDataList，將日期格式化並添加到圖表中
    for (var entry in weightDataList) {
      final String dateString = entry.keys.first;
      final double weight = entry.values.first;

      final DateTime date = DateTime.parse(dateString);
      //String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      // 將格式化後的日期和體重添加到圖表數據中
      res.add([date.millisecondsSinceEpoch.toDouble(), weight]);
      //res.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), list1[0]) as List<double>);

    }
  }

}

