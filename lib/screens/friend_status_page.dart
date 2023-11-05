import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:g12/screens/page_material.dart';

import '../services/page_data.dart';

class FriendStatusPage extends StatefulWidget {
  const FriendStatusPage({super.key});

  @override
  FriendStatusPageState createState() => FriendStatusPageState();
}

class FriendStatusPageState extends State<FriendStatusPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorSet.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: ColorSet.iconColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '${FriendData.userName} 的資訊',
            style: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          //automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding:
                    const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                          'assets/images/${FriendData.character}.png'),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "${FriendData.userName}"
                      "\n社交碼：${FriendData.socialCode}",
                      style: const TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: ColorSet.backgroundColor,
                              border: Border.all(
                                  color: ColorSet.borderColor, width: 4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              const ListTile(
                                title: Text(
                                  "等級資訊",
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                              ),
                              SizedBox(
                                height: 200.0,
                                child: SfCircularChart(
                                  legend: Legend(
                                      isVisible: true,
                                      textStyle: const TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    color: ColorSet.bottomBarColor,
                                    builder: (dynamic data,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) {
                                      return Text(
                                        "${point.x} ${("${point.x}" == "個人等級") ? "Lv" : "×"} ${point.y}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: ColorSet.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                  series: <CircularSeries<ChartData, String>>[
                                    RadialBarSeries<ChartData, String>(
                                      maximumValue: 1.0 +
                                          [
                                            FriendData.level,
                                            FriendData.workoutGem,
                                            FriendData.meditationGem
                                          ].reduce(max),
                                      dataSource: [
                                        ChartData('個人等級', FriendData.level),
                                        ChartData(
                                            '運動寶物', FriendData.workoutGem),
                                        ChartData(
                                            '冥想寶物', FriendData.meditationGem),
                                      ],
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      /*dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              labelPosition:
                                                  ChartDataLabelPosition.inside,
                                              textStyle: TextStyle(
                                                  color: ColorSet.textColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),*/
                                      cornerStyle: CornerStyle.bothCurve,
                                      pointColorMapper: (ChartData data, _) {
                                        if (data.x == "個人等級") {
                                          return const Color(0xff5661FC);
                                        } else if (data.x == "運動寶物") {
                                          return const Color(0xffA1A7FC);
                                        } else if (data.x == "冥想寶物") {
                                          return const Color(0xffd4d6fc);
                                        } else {
                                          return Colors.grey;
                                        }
                                      },
                                      useSeriesColor: true,
                                      trackOpacity: 0.3,
                                      radius: '100%',
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: ColorSet.backgroundColor,
                              border: Border.all(
                                  color: ColorSet.borderColor, width: 4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              const ListTile(
                                title: Text(
                                  "累計總時長",
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                              ),
                              Container(
                                height: 200.0,
                                padding:
                                    const EdgeInsets.only(right: 30, left: 30),
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(
                                    axisLine: const AxisLine(
                                      color: ColorSet.textColor,
                                      width: 0.6,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    majorGridLines: const MajorGridLines(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    labelFormat: '{value} 分',
                                    minimum: 500,
                                    interval: 50,
                                    axisLine: const AxisLine(width: 0),
                                    labelStyle: const TextStyle(
                                        fontSize: 10,
                                        color: ColorSet.textColor),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                  ),
                                  series: <ColumnSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: [
                                        // TODO: get cumulativeTime data from database
                                        ChartData(
                                            '運動', Random().nextInt(170) + 580),
                                        ChartData(
                                            '冥想', Random().nextInt(170) + 580),
                                      ],
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              labelAlignment:
                                                  ChartDataLabelAlignment.top,
                                              textStyle: TextStyle(
                                                  color: ColorSet.textColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                      width: 0.3,
                                      color: ColorSet.meditationColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: ColorSet.backgroundColor,
                              border: Border.all(
                                  color: ColorSet.borderColor, width: 4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              const ListTile(
                                title: Text(
                                  "最高連續天數",
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                              ),
                              Container(
                                height: 200.0,
                                padding:
                                    const EdgeInsets.only(right: 30, left: 30),
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(
                                    axisLine: const AxisLine(
                                      color: ColorSet.textColor,
                                      width: 0.6,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    majorGridLines: const MajorGridLines(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    labelFormat: '{value} 天',
                                    interval: 5,
                                    axisLine: const AxisLine(width: 0),
                                    labelStyle: const TextStyle(
                                        fontSize: 10,
                                        color: ColorSet.textColor),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                  ),
                                  series: <ColumnSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: [
                                        // TODO: get maximumConsecutiveDays data from database
                                        ChartData(
                                            '運動', Random().nextInt(15) + 5),
                                        ChartData(
                                            '冥想', Random().nextInt(15) + 5),
                                      ],
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              labelAlignment:
                                                  ChartDataLabelAlignment.top,
                                              textStyle: TextStyle(
                                                  color: ColorSet.textColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                      width: 0.3,
                                      color: ColorSet.meditationColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ])
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class ChartData {
  final String x;
  final int y;

  ChartData(this.x, this.y);
}
