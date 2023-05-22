import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatisticPage extends StatefulWidget {
  final Map arguments;
  final String title;

  const StatisticPage({Key? key, required this.arguments, required this.title}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  List<List<double>> res = [[0.0]];
  List<double> list1 = [0.0];

  final Map<DateTime, int> datasets = {
    DateTime(2023, 5, 6): 1,
    DateTime(2023, 5, 7): 2,
    DateTime(2023, 5, 12): 2,
    DateTime(2023, 5, 24): 3,
  };

  final Map<int, Color> colorsets = {
    1: Colors.red.shade300,
    2: Colors.yellow.shade400,
    3: Colors.green.shade300,
  };

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
              children:[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics:',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 380,
                      child: LineChart(
                        LineChartData(

                          lineTouchData: LineTouchData(
                            touchCallback: (LineTouchResponse touchResponse) {},
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              getTextStyles: (value) =>
                              const TextStyle(color: Colors.black, fontSize: 10),
                              getTitles: (value) {
                                int index = value.toInt();
                                if (index >= 0 && index < res.length) {
                                  int timestamp = res[index][0].toInt();
                                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
                                  return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
                                }
                                return '';
                              },
                              margin: 8,
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              getTextStyles: (value) =>
                              const TextStyle(color: Colors.black, fontSize: 10),
                              getTitles: (value) {
                                return '${value.toInt()}';
                              },
                              margin: 8,
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _getWeightData(),
                              isCurved: true,
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
                      padding: EdgeInsets.only(right: 80, left: 80, top: 20),
                      child :Text(
                        '熱圖介面',
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
                      height:200,
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

  void _showAddWeightDialog() {
    TextEditingController weightController = TextEditingController();
    TextEditingController dateController = TextEditingController();

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
              SizedBox(height: 8),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                ),
                keyboardType: TextInputType.datetime,
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
                String date = dateController.text;
                if (weight > 0 && date.isNotEmpty) {
                  setState(() {
                    // Add the weight data to the chart
                    list1.add(weight);
                    // Add the date to the chart
                    // You can handle the conversion and formatting of the date here if needed
                    // For simplicity, I'm assuming the date input is in the format 'YYYY-MM-DD'
                    // and directly adding it as a label to the bottom axis of the chart
                    res.add([DateTime.parse(date).millisecondsSinceEpoch.toDouble()]);
                  });
                }
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
    print('res length: ${res.length}');
    print('list1 length: ${list1.length}');

    if (res.isEmpty || list1.isEmpty) {
      return [];
    }
    return List.generate(
        list1.length,
            (index) => FlSpot(index.toDouble(), list1[index])
    );
  }
}

