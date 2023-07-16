import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../services/Database.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class StatisticPage extends StatefulWidget {
  final Map arguments;

  const StatisticPage({super.key, required this.arguments});

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

final BorderRadius _borderRadius = const BorderRadius.only(
  topLeft: Radius.circular(25),
  topRight: Radius.circular(25),
);

ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
  topLeft: Radius.circular(25),
  topRight: Radius.circular(25),
));
SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.pinned;
EdgeInsets padding = EdgeInsets.zero;

int _selectedItemPosition = 2;
SnakeShape snakeShape = SnakeShape.circle;
bool showSelectedLabels = false;
bool showUnselectedLabels = false;

Color selectedColor = Colors.black;
Color unselectedColor = Colors.blueGrey;

Gradient selectedGradient =
    const LinearGradient(colors: [Colors.red, Colors.amber]);
Gradient unselectedGradient =
    const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

class _StatisticPageState extends State<StatisticPage> {
  User? user = FirebaseAuth.instance.currentUser;
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
          child: ListView(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  height: 400,
                  child: Stack(
                    children: [
                      HeatMapCalendar(
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
                      Positioned(
                        right: 0,
                        bottom: 20,
                        child: Container(
                          width: 150,
                          height: 50,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade200,
                                    size: 25,
                                  ),
                                  Text(
                                    '成功',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.red.shade200,
                                    size: 25,
                                  ),
                                  Text(
                                    '失败',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: snakeBarStyle,
          snakeShape: snakeShape,
          shape: bottomBarShape,
          padding: padding,
          height: 80,
          //backgroundColor: const Color(0xfffdeed9),
          backgroundColor: const Color(0xffd4d6fc),
          snakeViewColor: const Color(0xfffdfdf5),
          selectedItemColor: const Color(0xff4b3d70),
          unselectedItemColor: const Color(0xff4b3d70),

          ///configuration for SnakeNavigationBar.color
          // snakeViewColor: selectedColor,
          // selectedItemColor:
          //  snakeShape == SnakeShape.indicator ? selectedColor : null,
          //unselectedItemColor: Colors.blueGrey,

          ///configuration for SnakeNavigationBar.gradient
          //snakeViewGradient: selectedGradient,
          //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
          //unselectedItemGradient: unselectedGradient,

          showUnselectedLabels: showUnselectedLabels,
          showSelectedLabels: showSelectedLabels,

          currentIndex: _selectedItemPosition,
          //onTap: (index) => setState(() => _selectedItemPosition = index),
          onTap: (index) {
            _selectedItemPosition = index;
            if (index == 0) {
              Navigator.pushNamed(context, '/statistic',
                  arguments: {'user': user});
            }
            if (index == 1) {
              Navigator.pushNamed(context, '/milestone',
                  arguments: {'user': user});
            }
            if (index == 2) {
              Navigator.pushNamed(context, '/');
            }
            if (index == 3) {
              Navigator.pushNamed(context, '/contract/initial',
                  arguments: {'user': user});
            }
            //3
            if (index == 4) {
              Navigator.pushNamed(context, '/settings',
                  arguments: {'user': user});
            }
            print(index);
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.insights,
                  size: 40,
                ),
                label: 'tickets'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.workspace_premium_outlined,
                  size: 40,
                ),
                label: 'calendar'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 40,
                ),
                label: 'home'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.request_quote_outlined,
                  size: 40,
                ),
                label: 'microphone'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.manage_accounts_outlined,
                  size: 40,
                ),
                label: 'search')
          ],
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
                    // Add the date to the chart
                    res.add([selectedDate!.millisecondsSinceEpoch.toDouble()]);
                    Map<String, double> addedData = {
                      Calendar.toKey(selectedDate!): weight
                    };
                    weightDataList.addAll(addedData);
                    // Add the weight data to the chart
                    list1 = Map.fromEntries(weightDataList.entries.toList()
                          ..sort((e1, e2) => e1.key.compareTo(e2.key)))
                        .values
                        .toList();
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
