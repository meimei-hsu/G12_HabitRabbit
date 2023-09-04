import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FriendStatusPage extends StatefulWidget {
  const FriendStatusPage({super.key});

  //const CommunityPage({super.key, required arguments});

  @override
  _FriendStatusPageState createState() => _FriendStatusPageState();
}

class _FriendStatusPageState extends State<FriendStatusPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfffdfdf5),
        appBar: AppBar(
          backgroundColor: const Color(0xfffdfdf5),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Color(0xff4b4370)),
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
                      child: Image.asset('assets/images/Friend_B.png'),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'Andy'
                          '\n社交碼：AUG23LR6U1',
                      // TODO:讀取使用者的真實情況
                      style: TextStyle(
                        color: Color(0xff4b3d70),
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
                            padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xfffdeed9),
                              border: Border.all(color: const Color(0xffffeed9)),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              const ListTile(
                                title: Text(
                                  "等級資訊",
                                  style: TextStyle(
                                      color: Color(0xff4b4370),
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
                                          color: Color(0xff4b4370),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)
                                  ),
                                  series: <CircularSeries<ChartData, String>>[
                                    RadialBarSeries<ChartData, String>(
                                      dataSource: [
                                        ChartData('個人等級', 20),
                                        ChartData('角色等級', 40),
                                        ChartData('寶物數量', 14),
                                      ],
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      cornerStyle: CornerStyle.bothCurve,
                                      pointColorMapper: (ChartData data, _) {
                                        if (data.x == "個人等級") {
                                          return const Color(0xffEDEEFC);
                                        } else if (data.x == "角色等級") {
                                          return const Color(0xffd4d6fc);
                                        } else if (data.x == "寶物數量") {
                                          return const Color(0xffA1A7FC);
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
                            padding: const EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 20.0),
                            margin: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xfffdeed9),
                              border: Border.all(color: const Color(0xffffeed9)),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              const ListTile(
                                title: Text(
                                  "累計總時長",
                                  style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                              ),
                              Container(
                                height: 200.0,
                                padding: const EdgeInsets.only(right: 30, left: 30),
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(
                                    axisLine: const AxisLine(
                                      color: Color(0xff4b4370),
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Color(0xff4b4370),
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
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      width: 0.3,
                                      color: const Color(0xffd4d6fc),
                                      borderRadius:
                                      const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)
                                      ),
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
                              color: const Color(0xfffdeed9),
                              border:
                              Border.all(color: const Color(0xffffeed9)),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(children: [
                              const ListTile(
                                title: Text(
                                  "最高連續天數",
                                  style: TextStyle(
                                      color: Color(0xff4b4370),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                              ),
                              Container(
                                height: 200.0,
                                padding: const EdgeInsets.only(right: 30, left: 30),
                                child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(
                                    axisLine: const AxisLine(
                                      color: Color(0xff4b4370),
                                    ),
                                    labelStyle: const TextStyle(
                                        color: Color(0xff4b4370),
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
                                      xValueMapper: (ChartData data, _) => data.x,
                                      yValueMapper: (ChartData data, _) => data.y,
                                      width: 0.3,
                                      color: const Color(0xffd4d6fc),
                                      borderRadius:
                                      const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)
                                      ),
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
