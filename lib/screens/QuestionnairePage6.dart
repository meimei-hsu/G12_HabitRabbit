import 'package:flutter/material.dart';

class QuestionnairePage6 extends StatefulWidget {
  @override
  _QuestionnairePage6 createState() => _QuestionnairePage6();
}

class _QuestionnairePage6 extends State<QuestionnairePage6> {
  String? radioValue_1 = "";
  String? radioValue_2 = "";
  String? radioValue_3 = "";
  String? radioValue_4 = "";
  String? radioValue_5 = "";
  String? radioValue_6 = "";
  String? radioValue_7 = "";
  String? radioValue_8 = "";
  String? radioValue_9 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part2：人格測驗'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1.當處於極大壓力下時，我時常感到瀕臨崩潰。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_1,
                    onChanged: (value) {
                      setState(() {
                        radioValue_1 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_1,
                    onChanged: (value) {
                      setState(() {
                        radioValue_1 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '2.即使是一個很小的煩惱，也可能會讓我感到挫敗。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_2,
                    onChanged: (value) {
                      setState(() {
                        radioValue_2 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_2,
                    onChanged: (value) {
                      setState(() {
                        radioValue_2 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '3.看到別人的成功讓我產生壓力，並使我焦躁不安。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_3,
                    onChanged: (value) {
                      setState(() {
                        radioValue_3 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_3,
                    onChanged: (value) {
                      setState(() {
                        radioValue_3 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '4.我總是會按時完成計畫。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_4,
                    onChanged: (value) {
                      setState(() {
                        radioValue_4 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_4,
                    onChanged: (value) {
                      setState(() {
                        radioValue_4 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '5.我會依事情的輕重緩急安排時間。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '6.我的目標明確，能按部就班的朝目標努力。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_6,
                    onChanged: (value) {
                      setState(() {
                        radioValue_6 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_6,
                    onChanged: (value) {
                      setState(() {
                        radioValue_6 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '7.我喜歡實驗新的做事方法。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_7,
                    onChanged: (value) {
                      setState(() {
                        radioValue_7 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_7,
                    onChanged: (value) {
                      setState(() {
                        radioValue_7 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '8.在能發揮創意的環境下，我做事會最有效率。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_8,
                    onChanged: (value) {
                      setState(() {
                        radioValue_8 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_8,
                    onChanged: (value) {
                      setState(() {
                        radioValue_8 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '9.我樂在學習新事物。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_9,
                    onChanged: (value) {
                      setState(() {
                        radioValue_9 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_9,
                    onChanged: (value) {
                      setState(() {
                        radioValue_9 = value;
                      }
                      );
                    },
                  ),
                  Text("否"),
                ],
              ),
              ElevatedButton(
                child: Text("確定送出"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QuestionnairePage6()));
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
