import 'package:flutter/material.dart';
import 'package:g12/screens/QuestionnairePage4.dart';

class QuestionnairePage3 extends StatefulWidget {
  @override
  _QuestionnairePage3 createState() => _QuestionnairePage3();
}

class _QuestionnairePage3 extends State<QuestionnairePage3> {
  String? radioValue_5 = "1";

  bool? monday = false;
  bool? tuesday = false;
  bool? wednesday = false;
  bool? thursday = false;
  bool? friday = false;
  bool? saturday = false;
  bool? sunday = false;
  bool? gym = false;
  bool? house = false;
  bool? outdoor = false;
  bool? other = false;
  bool? knee = false;
  bool? waist = false;
  bool? shoulder = false;
  bool? butt = false;
  bool? abd = false;
  bool? none = false;
  bool? strength = false;
  bool? cardio = false;
  bool? yoga = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part1：運動習慣偏好'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //第五題
              Text(
                '5.您希望一次運動安排多久時長？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("15分"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("30分"),
                  Radio<String>(
                    value: "3",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("45分"),
                  Radio<String>(
                    value: "4",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("60分"),
                ],
              ),
              SizedBox(height: 20),
              //第六題
              Text(
                '6. 未來的一個星期內有哪幾天有空運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Wrap(
                children: [
                  Checkbox(
                    value: monday,
                    onChanged: (bool? value) {
                      setState(() {
                        monday = value!;
                      });
                    },
                  ),
                  Text("星期一",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: tuesday,
                    onChanged: (bool? value) {
                      setState(() {
                        tuesday = value!;
                      });
                    },
                  ),
                  Text("星期二",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: wednesday,
                    onChanged: (bool? value) {
                      setState(() {
                        wednesday = value!;
                      });
                    },
                  ),
                  Text("星期三",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: thursday,
                    onChanged: (bool? value) {
                      setState(() {
                        thursday = value!;
                      });
                    },
                  ),
                  Text("星期四",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: friday,
                    onChanged: (bool? value) {
                      setState(() {
                        friday = value!;
                      });
                    },
                  ),
                  Text("星期五",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: saturday,
                    onChanged: (bool? value) {
                      setState(() {
                        saturday = value!;
                      });
                    },
                  ),
                  Text("星期六",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: sunday,
                    onChanged: (bool? value) {
                      setState(() {
                        sunday = value!;
                      });
                    },
                  ),
                  Text("星期日",
                      style: TextStyle(fontSize: 15)
                  ),
                ],
              ),
              SizedBox(height: 20),
              //第七題
              Text(
                '7. 您喜歡什麼樣類型的運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: strength,
                    onChanged: (bool? value) {
                      setState(() {strength = value!;
                      });
                    },
                  ),
                  Text("肌耐力訓練 (如重量訓練)"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: cardio,
                    onChanged: (bool? value) {
                      setState(() {
                        cardio = value!;
                      });
                    },
                  ),
                  Text("有氧訓練 (如有氧舞蹈、慢跑等)"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: yoga,
                    onChanged: (bool? value) {
                      setState(() {
                        yoga = value!;
                      });
                    },
                  ),
                  Text("伸展運動 (如瑜珈)"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: none,
                    onChanged: (bool? value) {
                      setState(() {
                        none = value!;
                      });
                    },
                  ),
                  Text("我沒有任何偏好"),
                ],
              ),
              SizedBox(height: 20),
              //第八題
              Text(
                '8.您喜歡在下列何情況進行運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(// 每行之間的間距
                children: [
                  Checkbox(
                    value: gym,
                    onChanged: (bool? value) {
                      setState(() {
                        gym = value!;
                      });
                    },
                  ),
                  Text("健身房",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: house,
                    onChanged: (bool? value) {
                      setState(() {
                        house = value!;
                      });
                    },
                  ),
                  Text("家裡",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: outdoor,
                    onChanged: (bool? value) {
                      setState(() {
                        outdoor = value!;
                      });
                    },
                  ),
                  Text("戶外",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: other,
                    onChanged: (bool? value) {
                      setState(() {
                        other = value!;
                      });
                    },
                  ),
                  Text("其他",
                      style: TextStyle(fontSize: 15)
                  ),
                ],
              ),
              SizedBox(height: 20),
              //第九題
              Text(
                '9. 您是否有任何身體部位受過傷害不適合太激烈的運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: knee,
                    onChanged: (bool? value) {
                      setState(() {
                        knee = value!;
                      });
                    },
                  ),
                  Text("膝蓋"),
                  Checkbox(
                    value: waist,
                    onChanged: (bool? value) {
                      setState(() {
                        waist = value!;
                      });
                    },
                  ),
                  Text("腰部"),
                  Checkbox(
                    value: shoulder,
                    onChanged: (bool? value) {
                      setState(() {
                        shoulder = value!;
                      });
                    },
                  ),
                  Text("肩膀"),
                ],
              ),
              Row(
                  children: [
                    Checkbox(
                      value: butt,
                      onChanged: (bool? value) {
                        setState(() {
                          butt = value!;
                        });
                      },
                    ),
                    Text("臀部"),
                    Checkbox(
                      value: abd,
                      onChanged: (bool? value) {
                        setState(() {
                          abd = value!;
                        });
                      },
                    ),
                    Text("腹肌"),
                    Checkbox(
                      value: none,
                      onChanged: (bool? value) {
                        setState(() {
                          none = value!;
                        });
                      },
                    ),
                    Text("均無"),
                  ]
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionnairePage4()));
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ]),
      ),
    );
  }
}
