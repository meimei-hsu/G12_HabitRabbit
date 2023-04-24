import 'package:flutter/material.dart';
import 'package:g12/screens/QuestionnairePage5.dart';

class QuestionnairePage4 extends StatefulWidget {
  @override
  _QuestionnairePage4 createState() => _QuestionnairePage4();
}

class _QuestionnairePage4 extends State<QuestionnairePage4> {
  String? radioValue_10 = "1";
  String? radioValue_12 = "1";
  String? radioValue_13 = "1";
  String? radioValue_14 = "1";
  bool? A = false;
  bool? B = false;
  bool? C = false;
  bool? D = false;
  bool? E = false;
  bool? F = false;
  bool? G = false;
  bool? H = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Part1：現階段運動能力與未來目標'),
        ),
        body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //第五題
                    Text(
                      '\n10.您目前的運動頻率(次數/週)？',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: "1",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("0"),
                        Radio<String>(
                          value: "2",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("1-2"),
                        Radio<String>(
                          value: "3",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("3-4"),
                        Radio<String>(
                          value: "4",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("5(含以上)"),
                      ],
                    ),
                    //第十一題
                    Text(
                      '\n11.您運動的原因或預期目標？',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    //Column(
                    //children: [
                    Wrap(
                      children: [
                        Checkbox(
                          value: A,
                          onChanged: (bool? value) {
                            setState(() {
                              A = value!;
                            });
                          },
                        ),
                        Text("減重",
                            style: TextStyle(fontSize: 15)
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Checkbox(
                          value: B,
                          onChanged: (bool? value) {
                            setState(() {
                              B = value!;
                            });
                          },
                        ),
                        Text("鍛鍊肌肉，變得更強壯",
                            style: TextStyle(fontSize: 15)
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Checkbox(
                          value: C,
                          onChanged: (bool? value) {
                            setState(() {
                              C = value!;
                            });
                          },
                        ),
                        Text("維持個人運動能力",
                            style: TextStyle(fontSize: 15)
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Checkbox(
                          value: D,
                          onChanged: (bool? value) {
                            setState(() {
                              D = value!;
                            });
                          },
                        ),
                        Text("提升心肺耐力",
                            style: TextStyle(fontSize: 15)
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Checkbox(
                          value: E,
                          onChanged: (bool? value) {
                            setState(() {
                              E = value!;
                            });
                          },
                        ),
                        Text("促進身體的靈敏度與機動性",
                            style: TextStyle(fontSize: 15)
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Checkbox(
                          value: F,
                          onChanged: (bool? value) {
                            setState(() {
                              F = value!;
                            });
                          },
                        ),
                        Text("抒解壓力",
                            style: TextStyle(fontSize: 15)
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Checkbox(
                          value: G,
                          onChanged: (bool? value) {
                            setState(() {
                              G = value!;
                            });
                          },
                        ),
                        Text("促進身體健康",
                            style: TextStyle(fontSize: 15)
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        Checkbox(
                          value: H,
                          onChanged: (bool? value) {
                            setState(() {
                              H = value!;
                            });
                          },
                        ),
                        Text("其他",
                            style: TextStyle(fontSize: 15)
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '自行輸入',
                              hintStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //],
                    //),
                    //第十二題
                    Text(
                      '\n12.請為您目前做肌耐力運動的能力評分',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "1",
                          groupValue: radioValue_12,
                          onChanged: (value) {
                            setState(() {
                              radioValue_12 = value;
                            });
                          },
                        ),
                        Text('1.高水平\n'
                            '能完成超過15次深蹲、硬舉等重量訓練\n'
                            '每個動作重量為自身體重1.5倍以上\n'
                            '能續進行高強度的肌耐力運動(如引體向上、交替式深蹲)',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "2",
                          groupValue: radioValue_12,
                          onChanged: (value) {
                            setState(() {
                              radioValue_12 = value;
                            });
                          },
                        ),
                        Text('2.中高水平\n'
                            '能完成10-15次深蹲、硬舉等重量訓練\n'
                            '每個動作重量為自身體重1.2-1.5倍\n'
                            '能持續進行中高強度的肌耐力運動(如俯身划船、跳繩)',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "3",
                          groupValue: radioValue_12,
                          onChanged: (value) {
                            setState(() {
                              radioValue_12 = value;
                            });
                          },
                        ),
                        Text('3.中水平\n'
                            '能完成6-10次的深蹲、硬舉等重量訓練\n'
                            '每個動作重量為自身體重1-1.2倍\n'
                            '能持續進行中強度的肌耐力運動(如仰臥起坐、腹肌滾筒)',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "4",
                          groupValue: radioValue_12,
                          onChanged: (value) {
                            setState(() {
                              radioValue_12 = value;
                            });
                          },
                        ),
                        Text('4.中低水平\n'
                            '能完成3-6次深蹲、硬舉等重量訓練\n'
                            '每個動作重量為自身體重0.8-1倍\n'
                            '能持續進行輕度的肌耐力運動(如伏地挺身、平板支撐)',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "5",
                          groupValue: radioValue_12,
                          onChanged: (value) {
                            setState(() {
                              radioValue_12 = value;
                            });
                          },
                        ),
                        Text('5.低水平\n'
                            '能完成1-3次深蹲、硬舉等重量訓練\n'
                            '每個動作重量為自身體重0.8倍以下\n'
                            '只能進行輕度的肌耐力運動(如散步、輕量舉重)',
                        ),
                      ],
                    ),
                    //第十三題
                    Text(
                      '\n13.請為您目前做有氧運動的能力評分',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "1",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13 = value;
                            });
                          },
                        ),
                        Text('1.高水平\n'
                            '能夠進行高強度心肺耐力運動(如慢跑、游泳、飛輪)\n'
                            '持續超過30分鐘，\n'
                            '結束時能夠正常說話，且無特別明顯疲勞感。',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "2",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13= value;
                            });
                          },
                        ),
                        Text('2.中水平\n'
                            '能夠進行中等強度心肺耐力運動(如快走、跳繩)\n'
                            '持續時間15-30分鐘，\n'
                            '結束時能夠正常說話但有些許疲勞感。',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "3",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13 = value;
                            });
                          },
                        ),
                        Text('3.低水平\n'
                            '能夠進行輕度心肺耐力運動(如散步、爬樓梯)\n'
                            '持續時間15-30分鐘，\n'
                            '運動時呼吸急促、難以說話並有明顯疲勞感。',
                        ),
                      ],
                    ),
                    //第十四題
                    Text(
                      '\n14.請為您目前做伸展運動的能力評分',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "1",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13 = value;
                            });
                          },
                        ),
                        Text('1.高水平\n'
                            '能夠完成多種複雜的伸展動作，\n'
                            '保持每個動作的正確姿勢並且能夠輕鬆地完成。',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "2",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13= value;
                            });
                          },
                        ),
                        Text('2.中水平\n'
                            '能夠完成基本的伸展運動，\n'
                            '保持正確的姿勢且完成伸展的動作，\n'
                            '但尚未達到高水平的要求。',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "3",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13 = value;
                            });
                          },
                        ),
                        Text('3.低水平\n'
                            '只能完成一些簡單的伸展動作，\n'
                            '難以保持正確的姿勢也無法完成複雜的伸展動作。',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text("返回"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(width: 20),
                        ElevatedButton(
                          child: Text("確定"),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionnairePage5()));
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ]),
            )
        )
    );
  }
}
