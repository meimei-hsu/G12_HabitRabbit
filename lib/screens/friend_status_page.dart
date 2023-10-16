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
                      child: Image.asset('assets/images/${FriendData.character}.png'),
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
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  series: <CircularSeries<ChartData, String>>[
                                    RadialBarSeries<ChartData, String>(
                                      dataSource: [
                                        ChartData('個人等級', FriendData.level),
                                        ChartData('角色等級', FriendData.characterLevel),
                                        ChartData('運動寶物', FriendData.workoutGem),
                                        ChartData('冥想寶物', FriendData.meditationGem),
                                      ],
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      cornerStyle: CornerStyle.bothCurve,
                                      pointColorMapper: (ChartData data, _) {
                                        if (data.x == "個人等級") {
                                          return const Color(0xff5661FC);
                                        } else if (data.x == "角色等級") {
                                          return const Color(0xffA1A7FC);
                                        } else if (data.x == "運動寶物") {
                                          return const Color(0xffd4d6fc);
                                        } else if (data.x == "冥想寶物") {
                                          return const Color(0xffEDEEFC);
                                        } else {
                                          return Colors.grey;
                                        }
                                      },
                                      useSeriesColor: true,
                                      trackOpacity: 0.3,
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
                                    ),
                                    labelStyle: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    majorGridLines: const MajorGridLines(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(width: 0),
                                    labelStyle: const TextStyle(fontSize: 0),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                  ),
                                  series: <ColumnSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: [
                                        ChartData('運動', 20),
                                        ChartData('冥想', 40),
                                      ],
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
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
                                    ),
                                    labelStyle: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    majorGridLines: const MajorGridLines(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(width: 0),
                                    labelStyle: const TextStyle(fontSize: 0),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                  ),
                                  series: <ColumnSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: [
                                        ChartData('運動', 12),
                                        ChartData('冥想', 33),
                                      ],
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
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
