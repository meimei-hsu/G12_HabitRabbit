import 'package:flutter/material.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/services/database.dart';
import 'package:g12/services/page_data.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  StatisticPageState createState() => StatisticPageState();
}

class StatisticPageState extends State<StatisticPage> {
  // toggle switch control (0 = 運動, 1 = 冥想)
  final Map<int, Color> colorSet = {
    1: ColorSet.failColor,
    2: ColorSet.successColor,
  };

  final ScrollController _scrollController = ScrollController();

  void refresh() async {
    if (Data.updatingDB || Data.updatingUI[0]) await StatData.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '${Data.profile?["userName"]} 的統計資料',
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          backgroundColor: ColorSet.backgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: (StatData.isFetchingData)
            ? Center(
                child: Container(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    decoration: BoxDecoration(
                        color: ColorSet.bottomBarColor,
                        border: Border.all(color: ColorSet.bottomBarColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingAnimationWidget.horizontalRotatingDots(
                          color: ColorSet.textColor,
                          size: 100,
                        ),
                        const Text(
                          "重新整理中...",
                          style: TextStyle(
                            color: ColorSet.textColor,
                          ),
                        )
                      ],
                    )))
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
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            decoration: BoxDecoration(
                              color: ColorSet.backgroundColor,
                              border: Border.all(
                                  color: ColorSet.borderColor, width: 4),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "BMI",
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                Text(
                                  StatData.bmiStandard,
                                  style: TextStyle(
                                      color: (StatData.bmiStandard == "消瘦")
                                          ? Colors.blueAccent.shade100
                                          : (StatData.bmiStandard == "標準")
                                              ? Colors.green
                                              : (StatData.bmiStandard == "微胖")
                                                  ? Colors.amber
                                                  : Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                Text(
                                  StatData.bmi.toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 5.0),
                                  margin:
                                      const EdgeInsets.only(right: 5, left: 10),
                                  decoration: BoxDecoration(
                                    color: ColorSet.backgroundColor,
                                    border: Border.all(
                                        color: ColorSet.borderColor, width: 4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "運動最大\n連續天數",
                                        style: TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        StatData.maxWorkoutConsecutiveDays
                                            .toStringAsFixed(0),
                                        style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0),
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 5.0),
                                  margin:
                                      const EdgeInsets.only(right: 10, left: 5),
                                  decoration: BoxDecoration(
                                    color: ColorSet.backgroundColor,
                                    border: Border.all(
                                        color: ColorSet.borderColor, width: 4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "冥想最大\n連續天數",
                                        style: TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        StatData.maxMeditationConsecutiveDays
                                            .toStringAsFixed(0),
                                        style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 5.0),
                                  margin:
                                      const EdgeInsets.only(right: 5, left: 10),
                                  decoration: BoxDecoration(
                                    color: ColorSet.backgroundColor,
                                    border: Border.all(
                                        color: ColorSet.borderColor, width: 4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "    運動\n累積時間",
                                        style: TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      Text(
                                        StatData.workoutAccumulatedTime
                                            .toStringAsFixed(0),
                                        style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 5.0, 0.0, 5.0),
                                  margin:
                                      const EdgeInsets.only(right: 10, left: 5),
                                  decoration: BoxDecoration(
                                    color: ColorSet.backgroundColor,
                                    border: Border.all(
                                        color: ColorSet.borderColor, width: 4),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "    冥想\n累積時間",
                                        style: TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      const SizedBox(
                                        width: 0,
                                      ),
                                      Text(
                                        StatData.meditationAccumulatedTime
                                            .toStringAsFixed(0),
                                        style: const TextStyle(
                                            color: ColorSet.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: ColorSet.backgroundColor,
                            border: Border.all(
                                color: ColorSet.borderColor, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  "體重紀錄",
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                trailing: IconButton(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 20),
                                  icon: const Icon(Icons.add_box_rounded),
                                  iconSize: 28,
                                  color: ColorSet.iconColor,
                                  tooltip: "新增體重",
                                  onPressed: () async {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20)),
                                        ),
                                        backgroundColor:
                                            ColorSet.bottomBarColor,
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setModalState) {
                                            return AnimatedPadding(
                                                padding: MediaQuery.of(context)
                                                    .viewInsets,
                                                duration: const Duration(
                                                    milliseconds: 10),
                                                child: SingleChildScrollView(
                                                    child:
                                                        getAddWeightBottomSheet(
                                                            setModalState)));
                                          });
                                        });
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              Container(
                                height: 300,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 20, top: 15, bottom: 15),
                                child: LineChart(
                                  LineChartData(
                                    // lineTouchData: 觸摸交互詳細訊息
                                    lineTouchData: LineTouchData(
                                      handleBuiltInTouches: true,
                                      touchTooltipData: LineTouchTooltipData(
                                        fitInsideHorizontally: true,
                                        fitInsideVertically: true,
                                        tooltipBgColor: ColorSet.bottomBarColor
                                            .withOpacity(0.8),
                                        getTooltipItems: (List<LineBarSpot>
                                            touchedBarSpots) {
                                          return touchedBarSpots.map((barSpot) {
                                            final flSpot = barSpot;

                                            return LineTooltipItem(
                                              '${StatData.weightDataMap.keys.toList()[flSpot.x.toInt()]}\n',
                                              const TextStyle(
                                                color: ColorSet.textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${flSpot.y.toString()} 公斤',
                                                  style: const TextStyle(
                                                    color: ColorSet.textColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w900,
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
                                          y: StatData.avgWeight,
                                          label: HorizontalLineLabel(
                                              show: true,
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              labelResolver: (line) =>
                                                  '平均：${StatData.avgWeight.round()}',
                                              alignment: Alignment.topRight,
                                              style: TextStyle(
                                                  color: ColorSet.textColor
                                                      .withOpacity(0.7),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          color: ColorSet.textColor
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
                                          color: ColorSet.hintColor.withOpacity(0.6),
                                          strokeWidth: 0.8,
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
                                                color: ColorSet.textColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                        getTitles: (value) {
                                          return StatData.weightDataMap.keys
                                              .toList()[value.toInt()];
                                        },
                                        margin: 8,
                                      ),
                                      leftTitles: SideTitles(
                                        showTitles: true,
                                        getTextStyles: (value) =>
                                            const TextStyle(
                                                color: ColorSet.textColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                        getTitles: (value) {
                                          // Customize the display for values within the range
                                          // FIXME(?): 好像沒有一定會間隔為 5?
                                          if (value >= StatData.minY &&
                                              value <= StatData.maxY) {
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
                                        border: Border(
                                            bottom: BorderSide(
                                          color: ColorSet.hintColor.withOpacity(0.6),
                                          width: 0.8,
                                        ))),
                                    // lineBarsData: 數線資料
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: _getWeightData(),
                                        isCurved: false,
                                        colors: [ColorSet.chartLineColor],
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter:
                                              (spot, percent, barData, index) =>
                                                  FlDotCirclePainter(
                                            color: ColorSet.textColor,
                                            radius: 3,
                                          ),
                                        ),
                                      ),
                                    ],
                                    minY: StatData.minY,
                                    // y軸最小值
                                    maxY: StatData.maxY, // y軸最大值
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
                            color: ColorSet.backgroundColor,
                            border: Border.all(
                                color: ColorSet.borderColor, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  '計畫進度表',
                                  //(planProgress == 0) ? '運動計畫進度表' : '冥想計畫進度表',
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                trailing: ToggleSwitch(
                                  minHeight: 35,
                                  initialLabelIndex: StatData.planProgress,
                                  cornerRadius: 10.0,
                                  radiusStyle: true,
                                  labels: const ['運動', '冥想'],
                                  icons: const [
                                    Icons.fitness_center_outlined,
                                    Icons.self_improvement_outlined
                                  ],
                                  iconSize: 16,
                                  activeBgColors: const [
                                    [ColorSet.exerciseColor],
                                    [ColorSet.meditationColor]
                                  ],
                                  activeFgColor: ColorSet.textColor,
                                  inactiveBgColor: ColorSet.bottomBarColor,
                                  inactiveFgColor: ColorSet.textColor,
                                  totalSwitches: 2,
                                  //animate: true,
                                  //animationDuration: 300,
                                  onToggle: (index) {
                                    StatData.planProgress = index!;
                                    setState(() {});
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 0),
                                child: HeatMapCalendar(
                                  defaultColor: ColorSet.bottomBarColor,
                                  textColor: ColorSet.textColor,
                                  weekTextColor: ColorSet.textColor,
                                  colorMode: ColorMode.color,
                                  fontSize: 18,
                                  weekFontSize: 14,
                                  monthFontSize: 16,
                                  flexible: true,
                                  margin: const EdgeInsets.all(2.5),
                                  datasets: (StatData.planProgress == 0)
                                      ? StatData.exerciseCompletionRateMap
                                      : StatData.meditationCompletionRateMap,
                                  colorsets: colorSet,
                                  colorTipCount: 2,
                                  colorTipSize: 20,
                                  colorTipHelper: const [
                                    Text(
                                      "失敗 ",
                                      style: TextStyle(
                                          color: ColorSet.textColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      " 成功",
                                      style: TextStyle(
                                          color: ColorSet.textColor,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                  /*onClick: (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value.toString())),
                                  );
                                },*/
                                ),
                              )
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
                            color: ColorSet.backgroundColor,
                            border:
                                Border.all(color: ColorSet.textColor, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  '連續完成天數',
                                  //(consecutiveDays == 0) ? '連續完成運動天數' : '連續完成冥想天數',
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                trailing: ToggleSwitch(
                                  minHeight: 35,
                                  initialLabelIndex: StatData.consecutiveDays,
                                  cornerRadius: 10.0,
                                  radiusStyle: true,
                                  labels: const ['運動', '冥想'],
                                  icons: const [
                                    Icons.fitness_center_outlined,
                                    Icons.self_improvement_outlined
                                  ],
                                  iconSize: 16,
                                  activeBgColors: const [
                                    [ColorSet.exerciseColor],
                                    [ColorSet.meditationColor]
                                  ],
                                  activeFgColor: ColorSet.textColor,
                                  inactiveBgColor: ColorSet.bottomBarColor,
                                  inactiveFgColor: ColorSet.textColor,
                                  totalSwitches: 2,
                                  onToggle: (index) {
                                    StatData.consecutiveDays = index!;
                                    setState(() {});
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePanning: true,
                                ),
                                primaryXAxis: CategoryAxis(
                                  autoScrollingDelta: 7,
                                  autoScrollingMode: AutoScrollingMode.end,
                                  axisLine: const AxisLine(
                                    color: ColorSet.borderColor,
                                    width: 0.6,
                                  ),
                                  labelStyle: const TextStyle(
                                      color: ColorSet.textColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  majorTickLines: const MajorTickLines(size: 0),
                                  majorGridLines: const MajorGridLines(
                                    color: Colors.transparent,
                                  ),
                                ),
                                primaryYAxis: NumericAxis(
                                  axisLine: const AxisLine(width: 0),
                                  interval: 2,
                                  labelStyle: const TextStyle(fontSize: 0),
                                  numberFormat: NumberFormat('#,##0 天'),
                                  majorTickLines: const MajorTickLines(size: 0),
                                ),
                                series: <BarSeries<ChartData, String>>[
                                  BarSeries<ChartData, String>(
                                    dataSource: (StatData.consecutiveDays == 0)
                                        ? getExerciseConsecutiveDaysChartData()
                                        : getMeditationConsecutiveDaysChartData(),
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        textStyle: TextStyle(
                                            color: ColorSet.textColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    color: (StatData.consecutiveDays == 0)
                                        ? ColorSet.exerciseColor
                                        : ColorSet.meditationColor,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // TODO: 橫向 "連續完成天數"
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: ColorSet.backgroundColor,
                            border: Border.all(
                                color: ColorSet.borderColor, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  '每週成功天數',
                                  //(weekDays == 0) ? '每週成功運動天數' : '每週成功冥想天數',
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                trailing: ToggleSwitch(
                                  minHeight: 35,
                                  initialLabelIndex: StatData.weekDays,
                                  cornerRadius: 10.0,
                                  radiusStyle: true,
                                  labels: const ['運動', '冥想'],
                                  icons: const [
                                    Icons.fitness_center_outlined,
                                    Icons.self_improvement_outlined
                                  ],
                                  iconSize: 16,
                                  activeBgColors: const [
                                    [ColorSet.exerciseColor],
                                    [ColorSet.meditationColor]
                                  ],
                                  activeFgColor: ColorSet.textColor,
                                  inactiveBgColor: ColorSet.bottomBarColor,
                                  inactiveFgColor: ColorSet.textColor,
                                  totalSwitches: 2,
                                  //animate: true,
                                  //animationDuration: 300,
                                  onToggle: (index) {
                                    StatData.weekDays = index!;
                                    setState(() {});
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: SfCartesianChart(
                                  // hide the border
                                  plotAreaBorderWidth: 0,
                                  zoomPanBehavior: ZoomPanBehavior(
                                    enablePanning: true,
                                    zoomMode: ZoomMode.x,
                                  ),
                                  primaryXAxis: CategoryAxis(
                                    autoScrollingDelta: 7,
                                    autoScrollingMode: AutoScrollingMode.end,
                                    interval: 1,
                                    axisLine: const AxisLine(
                                      color: ColorSet.textColor,
                                      width: 0.6,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    // set 0 or transparent color to hide grid lines and tick lines
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    majorGridLines: const MajorGridLines(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    // must set for data label (above the column)
                                    labelFormat: '{value} 天',
                                    minimum: 0,
                                    maximum: (StatData.weekDays == 0)
                                        ? StatData.maxExerciseWeekDays
                                        : StatData.maxMeditationWeekDays,
                                    interval: 2,
                                    // set 0 to hide grid lines and tick lines
                                    axisLine: const AxisLine(width: 0),
                                    labelStyle: const TextStyle(
                                        fontSize: 10,
                                        color: ColorSet.textColor),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                  ),
                                  series: <ChartSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: (StatData.weekDays == 0)
                                          ? getExerciseWeekDaysData()
                                          : getMeditationWeekDaysData(),
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              textStyle: TextStyle(
                                                  color: ColorSet.textColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                      color: (StatData.weekDays == 0)
                                          ? ColorSet.exerciseColor
                                          : ColorSet.meditationColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                    ),
                                  ],
                                ),
                              )
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
                            color: ColorSet.backgroundColor,
                            border: Border.all(
                                color: ColorSet.borderColor, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  '每月成功天數',
                                  //(monthDays == 0) ? '每月成功運動天數' : '每月成功冥想天數',
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                trailing: ToggleSwitch(
                                  minHeight: 35,
                                  initialLabelIndex: StatData.monthDays,
                                  cornerRadius: 10.0,
                                  radiusStyle: true,
                                  labels: const ['運動', '冥想'],
                                  icons: const [
                                    Icons.fitness_center_outlined,
                                    Icons.self_improvement_outlined
                                  ],
                                  iconSize: 16,
                                  activeBgColors: const [
                                    [ColorSet.exerciseColor],
                                    [ColorSet.meditationColor]
                                  ],
                                  activeFgColor: ColorSet.textColor,
                                  inactiveBgColor: ColorSet.bottomBarColor,
                                  inactiveFgColor: ColorSet.textColor,
                                  totalSwitches: 2,
                                  //animate: true,
                                  //animationDuration: 300,
                                  onToggle: (index) {
                                    StatData.monthDays = index!;
                                    setState(() {});
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: SfCartesianChart(
                                  // hide the border
                                  plotAreaBorderWidth: 0,
                                  zoomPanBehavior: ZoomPanBehavior(
                                    enablePanning: true,
                                    zoomMode: ZoomMode.x,
                                  ),
                                  primaryXAxis: CategoryAxis(
                                    autoScrollingDelta: 7,
                                    autoScrollingMode: AutoScrollingMode.end,
                                    axisLine: const AxisLine(
                                      color: ColorSet.textColor,
                                      width: 0.6,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    // set 0 or transparent color to hide grid lines and tick lines
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    majorGridLines: const MajorGridLines(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    // must set for data label (above the column)
                                    labelFormat: '{value} 天',
                                    minimum: 0,
                                    maximum: (StatData.monthDays == 0)
                                        ? StatData.maxExerciseMonthDays
                                        : StatData.maxMeditationMonthDays,
                                    interval: 3,
                                    // set 0 to hide grid lines and tick lines
                                    axisLine: const AxisLine(width: 0),
                                    labelStyle: const TextStyle(
                                        fontSize: 10,
                                        color: ColorSet.textColor),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                  ),
                                  //tooltipBehavior: _tooltipBehavior,
                                  series: <ChartSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataSource: (StatData.monthDays == 0)
                                          ? getExerciseMonthDaysData()
                                          : getMeditationMonthDaysData(),
                                      xValueMapper: (ChartData data, _) =>
                                          data.x,
                                      yValueMapper: (ChartData data, _) =>
                                          data.y,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              textStyle: TextStyle(
                                                  color: ColorSet.textColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                      color: (StatData.monthDays == 0)
                                          ? ColorSet.exerciseColor
                                          : ColorSet.meditationColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                    ),
                                  ],
                                ),
                              )
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
                            color: ColorSet.backgroundColor,
                            border: Border.all(
                                color: ColorSet.borderColor, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text(
                                  '累積比例',
                                  //(accumulatedTime == 0) ? '累積運動時長' : '累積冥想時長',
                                  style: TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                trailing: ToggleSwitch(
                                  minHeight: 35,
                                  initialLabelIndex: StatData.accumulatedTime,
                                  cornerRadius: 10.0,
                                  radiusStyle: true,
                                  labels: const ['運動', '冥想'],
                                  icons: const [
                                    Icons.fitness_center_outlined,
                                    Icons.self_improvement_outlined
                                  ],
                                  iconSize: 16,
                                  activeBgColors: const [
                                    [ColorSet.exerciseColor],
                                    [ColorSet.meditationColor]
                                  ],
                                  activeFgColor: ColorSet.textColor,
                                  inactiveBgColor: ColorSet.bottomBarColor,
                                  inactiveFgColor: ColorSet.textColor,
                                  totalSwitches: 2,
                                  onToggle: (index) {
                                    StatData.accumulatedTime = index!;
                                    setState(() {});

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.easeOut);
                                    });
                                  },
                                ),
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                              ),
                              SfCircularChart(
                                legend: Legend(
                                    isVisible: true,
                                    textStyle: const TextStyle(
                                        color: ColorSet.textColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                series: <CircularSeries<ChartData, String>>[
                                  DoughnutSeries<ChartData, String>(
                                    dataSource: (StatData.accumulatedTime == 0)
                                        ? getExerciseTypePercentageChartData()
                                        : getMeditationTypePercentageChartData(),
                                    innerRadius: '40%',
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    pointColorMapper: (ChartData data, _) {
                                      if (StatData.accumulatedTime == 0) {
                                        if (data.x == "有氧") {
                                          return const Color(0xfffbd9c6);
                                        } else if (data.x == "重訓") {
                                          return const Color(0xfffae5da);
                                        } else if (data.x == "瑜珈") {
                                          return const Color(0xfffcf1ec);
                                        } else {
                                          return const Color(0xfffdfdfd);
                                        }
                                      } else {
                                        if (data.x == "正念") {
                                          return const Color(0xffe9eafd);
                                        } else if (data.x == "工作") {
                                          return const Color(0xffd6d8fa);
                                        } else if (data.x == "慈心") {
                                          return const Color(0xffc2c5f7);
                                        } else {
                                          return const Color(0xfffdfdfd);
                                        }
                                      }
                                    },
                                    //顯示數字(趴數)
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      textStyle: TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  List<FlSpot> _getWeightData() {
    if (StatData.weightDataList.isEmpty) {
      return [];
    }

    return List.generate(
      StatData.weightDataList.length,
      (index) => FlSpot(index.toDouble(), StatData.weightDataList[index]),
    );
  }

  Map month = {
    "01": "Jan",
    "02": "Feb",
    "03": "Mar",
    "04": "Apr",
    "05": "May",
    "06": "Jun",
    "07": "Jul",
    "08": "Aug",
    "09": "Sep",
    "10": "Oct",
    "11": "Nov",
    "12": "Dec"
  };

  // TODO: 顯示年份
  List<ChartData> getExerciseMonthDaysData() {
    List<ChartData> chartData = [];

    if (StatData.exerciseMonthDaysList.isEmpty) {
      return [];
    }
    debugPrint("exerciseMonthDaysList: ${StatData.exerciseMonthDaysList}");
    // [[2023-04-01, 2023-04-30, 1], [2023-05-01, 2023-05-31, 7], [2023-06-01, 2023-06-30, 3], [2023-07-01, 2023-07-31, 0]]

    for (int i = 0; i < StatData.exerciseMonthDaysList.length; i++) {
      List startDay = StatData.exerciseMonthDaysList[i][0].split("-");
      String monthEng = month[startDay[1]];
      chartData.add(ChartData(monthEng, StatData.exerciseMonthDaysList[i][1]));
    }

    return chartData;
  }

  List<ChartData> getMeditationMonthDaysData() {
    List<ChartData> chartData = [];

    if (StatData.meditationMonthDaysList.isEmpty) {
      return [];
    }
    debugPrint("meditationMonthDaysList: ${StatData.meditationMonthDaysList}");

    for (int i = 0; i < StatData.meditationMonthDaysList.length; i++) {
      List startDay = StatData.meditationMonthDaysList[i][0].split("-");
      String monthEng = month[startDay[1]];
      chartData
          .add(ChartData(monthEng, StatData.meditationMonthDaysList[i][1]));
    }

    return chartData;
  }

  List<ChartData> getExerciseWeekDaysData() {
    List<ChartData> chartData = [];

    if (StatData.exerciseWeekDaysList.isEmpty) {
      return [];
    }
    debugPrint("exerciseWeekDaysList: ${StatData.exerciseWeekDaysList}");
    // [[2023-04-01, 2023-04-08, 3], ...]

    List<String> addedMonths = [];
    for (int i = 0; i < StatData.exerciseWeekDaysList.length; i++) {
      List startDay = StatData.exerciseWeekDaysList[i][0].split("-");
      String monthEng = month[startDay[1]];
      String label = (addedMonths.contains(monthEng)) ? startDay[2] : monthEng;
      chartData.add(ChartData(label, StatData.exerciseWeekDaysList[i][1]));

      if (!addedMonths.contains(monthEng)) addedMonths.add(monthEng);
      if (addedMonths.length == 12) addedMonths.clear();
    }

    return chartData;
  }

  List<ChartData> getMeditationWeekDaysData() {
    List<ChartData> chartData = [];

    if (StatData.meditationWeekDaysList.isEmpty) {
      return [];
    }
    debugPrint("meditationWeekDaysList: ${StatData.meditationWeekDaysList}");
    // [[2023-04-01, 2023-04-08, 3], ...]

    List<String> addedMonths = [];
    for (int i = 0; i < StatData.meditationWeekDaysList.length; i++) {
      List startDay = StatData.meditationWeekDaysList[i][0].split("-");
      String monthEng = month[startDay[1]];
      String label = (addedMonths.contains(monthEng)) ? startDay[2] : monthEng;
      chartData.add(ChartData(label, StatData.meditationWeekDaysList[i][1]));

      if (!addedMonths.contains(monthEng)) addedMonths.add(monthEng);
      if (addedMonths.length == 12) addedMonths.clear();
    }

    return chartData;
  }

  List<ChartData> getExerciseConsecutiveDaysChartData() {
    List<ChartData> chartData = [];
    DateFormat dateFormat = DateFormat('MM/dd');

    debugPrint(
        "exerciseConsecutiveDaysList: ${StatData.consecutiveExerciseDaysList}");

    for (int i = 0; i < StatData.consecutiveExerciseDaysList.length; i++) {
      DateTime startDate = StatData.consecutiveExerciseDaysList[i][0];
      DateTime endDate = StatData.consecutiveExerciseDaysList[i][1];
      double consecutiveDays = StatData.consecutiveExerciseDaysList[i][2];

      String startLabel = dateFormat.format(startDate);
      String endLabel = dateFormat.format(endDate);
      String label = "$startLabel - $endLabel";

      chartData.add(ChartData(label, consecutiveDays.toInt()));
    }
    return chartData;
  }

  List<ChartData> getMeditationConsecutiveDaysChartData() {
    List<ChartData> chartData = [];

    debugPrint(
        "meditationConsecutiveDaysList: ${StatData.consecutiveMeditationDaysList}");

    for (int i = 0; i < StatData.consecutiveMeditationDaysList.length; i++) {
      DateTime startDate = StatData.consecutiveMeditationDaysList[i][0];
      DateTime endDate = StatData.consecutiveMeditationDaysList[i][1];
      double consecutiveDays = StatData.consecutiveMeditationDaysList[i][2];

      DateFormat dateFormat = DateFormat('MM/dd');
      String startLabel = dateFormat.format(startDate);
      String endLabel = dateFormat.format(endDate);
      String label = "$startLabel - $endLabel";

      chartData.add(ChartData(label, consecutiveDays.toInt()));
    }
    return chartData;
  }

  Map<String, String> typeTranslationMap = {
    "cardio": "有氧",
    "yoga": "瑜珈",
    "strength": "重訓",
    "mindfulness": "正念",
    "work": "工作",
    "kindness": "慈心",
  };

  String translateTypeToChinese(String englishType) {
    return typeTranslationMap[englishType] ?? englishType;
  }

  List<ChartData> getExerciseTypePercentageChartData() {
    List<ChartData> chartData = [];

    debugPrint("exercisePercentageList: ${StatData.exerciseTypePercentageMap}");

    for (var entry in StatData.exerciseTypePercentageMap.entries) {
      String chineseType = translateTypeToChinese(entry.key);
      chartData.add(ChartData(chineseType, entry.value.toInt()));
    }
    return chartData;
  }

  List<ChartData> getMeditationTypePercentageChartData() {
    List<ChartData> chartData = [];

    debugPrint(
        "meditationPercentageList: ${StatData.meditationTypePercentageMap}");

    for (var entry in StatData.meditationTypePercentageMap.entries) {
      String chineseType = translateTypeToChinese(entry.key);
      chartData.add(ChartData(chineseType, entry.value.toInt()));
    }
    return chartData;
  }

////////////////////// Parameter of AddWeightBottomSheet //////////////////////
  TextEditingController weightController = TextEditingController();

  GlobalKey<FormState> checkFormKey = GlobalKey<FormState>();

  OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: ColorSet.textColor,
      width: 3,
    ),
  );

  OutlineInputBorder focusedAndErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Color(0xfff6cdb7),
      width: 3,
    ),
  );

  DateTime selectedDate = DateTime.now();

////////////////////// Parameter of AddWeightBottomSheet //////////////////////

  // 新增20 bottom sheet
  Widget getAddWeightBottomSheet(StateSetter setModalState) {
    String showingDate =
        "${selectedDate.year} / ${selectedDate.month} / ${selectedDate.day}";

    return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: const Text(
              "新增體重",
              style: TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              /*decoration: BoxDecoration(
                border: Border.all(color: ColorSet.textColor, width: 2),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),*/
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorSet.textColor,
                ),
                tooltip: "關閉",
                onPressed: () {
                  weightController.clear();
                  setState(() {
                    selectedDate = DateTime.now();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Form(
                key: checkFormKey,
                child: TextFormField(
                  controller: weightController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "請輸入體重！";
                    } else if (double.parse(value) == 0) {
                      return "體重不得為 0！";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(
                      Icons.monitor_weight_outlined,
                      color: ColorSet.iconColor,
                    ),
                    labelText: '體重',
                    hintText: '單位為「公斤」',
                    enabledBorder: enabledBorder,
                    errorBorder: focusedAndErrorBorder,
                    focusedBorder: focusedAndErrorBorder,
                    focusedErrorBorder: focusedAndErrorBorder,
                    labelStyle: const TextStyle(color: ColorSet.textColor),
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorStyle: const TextStyle(
                        height: 1,
                        color: Color(0xfff6cdb7),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorMaxLines: 1,
                    filled: true,
                    fillColor: ColorSet.backgroundColor,
                  ),
                  cursorColor: const Color(0xfff6cdb7),
                  style: const TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              )),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(
                  Icons.accessibility_outlined,
                  color: ColorSet.iconColor,
                ),
                labelText: "日期：$showingDate",
                disabledBorder: const NonUniformOutlineInputBorder(
                  hideBottomSide: true,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  borderSide: BorderSide(
                    color: ColorSet.textColor,
                    width: 3,
                  ),
                ),
                labelStyle: const TextStyle(color: ColorSet.textColor),
                filled: true,
                fillColor: ColorSet.backgroundColor,
              ),
              style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Container(
                height: 200,
                padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                decoration: const ShapeDecoration(
                    color: ColorSet.backgroundColor,
                    shape: NonUniformOutlineInputBorder(
                        hideTopSide: true,
                        borderSide:
                            BorderSide(color: ColorSet.borderColor, width: 3),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ScrollDatePicker(
                        selectedDate: selectedDate,
                        maximumDate: DateTime.now(),
                        options: const DatePickerOptions(
                            isLoop: false,
                            backgroundColor: ColorSet.backgroundColor),
                        scrollViewOptions: const DatePickerScrollViewOptions(
                            year: ScrollViewDetailOptions(
                              textStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              selectedTextStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              margin: EdgeInsets.only(right: 20, left: 20),
                            ),
                            month: ScrollViewDetailOptions(
                              textStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              selectedTextStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              margin: EdgeInsets.only(right: 20, left: 20),
                            ),
                            day: ScrollViewDetailOptions(
                              textStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              selectedTextStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              margin: EdgeInsets.only(right: 20, left: 20),
                            )),
                        onDateTimeChanged: (DateTime value) {
                          setModalState(() {
                            selectedDate = value;
                            showingDate =
                                "${selectedDate.year} / ${selectedDate.month} / ${selectedDate.day}";
                          });
                        },
                      ),
                    )
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(right: 10, left: 10),
                backgroundColor: ColorSet.backgroundColor,
                shadowColor: ColorSet.borderColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                checkFormKey.currentState?.save();

                if (checkFormKey.currentState!.validate()) {
                  Navigator.pop(context);

                  double weight = double.tryParse(weightController.text) ?? 0;
                  if (weight > 0) {
                    Map<String, double> addedData = {
                      Calendar.dateToString(selectedDate): weight
                    };
                    await WeightDB.update(addedData);
                  }
                  selectedDate = DateTime.now();
                  weightController.clear();
                  setState(() {
                    refresh();
                  });
                }
              },
              child: const Text(
                "確定",
                style: TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ]));
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final int y;
}
