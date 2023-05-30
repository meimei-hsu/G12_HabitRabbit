import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatisticPage extends StatefulWidget {
  final Map arguments;

  const StatisticPage({Key? key, required this.arguments}) : super(key: key);

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
    DateTime(2023, 5, 6): 1,
    DateTime(2023, 5, 7): 2,
    DateTime(2023, 5, 12): 2,
    DateTime(2023, 5, 24): 1,
  };

  final Map<int, Color> colorsets = {
    1: Colors.red.shade300,
    2: Colors.green.shade300,
  };

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
          child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //FIXME: 統計頁面待美化
                    Text(
                      'Statistics:',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 300,
                      padding: EdgeInsets.only(right: 405, top: 20),
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
          title: Text('Add Weight'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight',
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
                    dateController.text = selectedDate.toString();
                  }
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date (YYYY-MM-DD)',
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double weight = double.tryParse(weightController.text) ?? 0;
                if (weight > 0 && selectedDate != null) {
                  setState(() {
                    // Add the weight data to the chart
                    list1.add(weight);
                    // Add the date to the chart
                    res.add([selectedDate!.millisecondsSinceEpoch.toDouble()]);
                    weightDataList.add({selectedDate!.toString(): weight});
                    // Update the y-axis range
                    updateYAxisRange();
                  });
                }
                print(weightDataList); //to-do list 嘉嘉
                weightController.clear(); // Clear weight text field
                dateController.clear(); // Clear date text field
                Navigator.of(context).pop();
              },
              child: Text('Add'),
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
