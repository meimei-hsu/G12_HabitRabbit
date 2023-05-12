import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  List<List<double>> res = [];
  List<double> list1= [ ];
  List<double> list2= [ ];
  List<double> list3= [ ];

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
              letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [],
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
        backgroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
          backgroundColor: Color(0xffffa493),
          child: Container(
            child: Ink(
              decoration: const ShapeDecoration(
                //color: Color(0xffffa493),
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 80,
                color: Color(0xff0d3b66),
                tooltip: "返回",
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
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
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTextStyles: (value) =>
                        const TextStyle(color: Colors.black, fontSize: 10),
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 1:
                              return 'JAN';
                            case 2:
                              return 'FEB';
                            case 3:
                              return 'MAR';
                            case 4:
                              return 'APR';
                            case 5:
                              return 'MAY';
                            case 6:
                              return 'JUN';
                            case 7:
                              return 'JUL';
                            case 8:
                              return 'AUG';
                            case 9:
                              return 'SEP';
                            case 10:
                              return 'OCT';
                            case 11:
                              return 'NOV';
                            case 12:
                              return 'DEC';
                            default:
                              return '';
                          }
                        },
                        margin: 8,
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) =>
                        const TextStyle(color: Colors.black, fontSize: 10),
                        getTitles: (value) {
                          return '${value.toInt()}';
                          //return '${value.toInt()}00';
                        },
                        margin: 8,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _mockData1()[0],
                        isCurved: true,
                        colors: [
                          Colors.blue,
                        ],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            color: Colors.black,
                            radius: 3,
                          ),
                        ),
                      ),
                      /*LineChartBarData(
                      spots: _mockData1()[1],
                      isCurved: true,
                      colors: [
                        Colors.red,
                      ],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        //color: Colors.red,
                      ),
                    ),*/
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

List<LineChartBarData> statistics() {
  List<List<double>> res = [];
  //List<double> list1 =[];
  //List<double> list2 =[];
  //List<double> list3 =[];

  return [
    LineChartBarData(
      spots: [        for (int i = 0; i < res[0].length; i++)
        FlSpot(i.toDouble(), res[0][i]),
      ],
      isCurved: true,
      colors: [Colors.greenAccent],
      barWidth: 2,
      belowBarData: FlBarBelowData(
        show: true,
        colors: [Colors.greenAccent.withOpacity(0.3)],
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          color: Colors.black,
          radius: 3,
        ),
      ),
    ),
    LineChartBarData(
      spots: [
        for (int i = 0; i < res[1].length; i++)
          FlSpot(i.toDouble(), res[1][i]),
      ],
      isCurved: true,
      colors: [Colors.orangeAccent],
      barWidth: 2,
      belowBarData: FlBarBelowData(
        show: true,
        colors: [Colors.orangeAccent.withOpacity(0.3)],
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          color: Colors.black,
          radius: 3,
        ),
      ),
    ),
    LineChartBarData(
      spots: [
        for (int i = 0; i < res[2].length; i++)
          FlSpot(i.toDouble(), res[2][i]),
      ],
      isCurved: true,
      colors: [Colors.blueAccent],
      barWidth: 2,
      belowBarData: FlBarBelowData(
        show: true,
        colors: [Colors.blueAccent.withOpacity(0.3)],
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          color: Colors.black,
          radius: 3,
        ),
      ),
    ),
  ];
}

FlBarBelowData({required bool show, required List<Color> colors}) {
}

List _mockData1() {
  var list1 = <FlSpot>[];
  var res = [];
  list1.add(FlSpot(1, 50));
  list1.add(FlSpot(2, 55));
  list1.add(FlSpot(3, 45));
  list1.add(FlSpot(4, 57));
  list1.add(FlSpot(5, 54));
  list1.add(FlSpot(6, 50));

  res.add(list1);

  //var list2 = <FlSpot>[];
  //list2.add(FlSpot(1, 80));
  //list2.add(FlSpot(2, 100));
  //list2.add(FlSpot(3, 120));
  //list2.add(FlSpot(4, 130));
  //list2.add(FlSpot(5, 140));
  //list2.add(FlSpot(6, 155));
  //res.add(list2);

  //var list3 = <FlSpot>[];
  //list3.add(FlSpot(1, 90));
  //list3.add(FlSpot(2, 110));
  //list3.add(FlSpot(3, 130));
  //list3.add(FlSpot(4, 140));
  //list3.add(FlSpot(5, 150));
  //list3.add(FlSpot(6, 170));
  //res.add(list3);

  return res;
}

