import 'package:flutter/material.dart';
import 'package:g12/screens/QuestionnairePage3.dart';

class QuestionnairePage2 extends StatefulWidget {
  @override
  _QuestionnairePage2 createState() => _QuestionnairePage2();
}

class _QuestionnairePage2 extends State<QuestionnairePage2> {
  String? radioValue_1 = "1";
  DateTime? selectedDate;

  set selectedDateTime(DateTime selectedDateTime) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Part1：基本資訊'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //第一題
                Text(
                  '1.您的性別?',
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
                    Text("男"),
                    Radio<String>(
                      value: "2",
                      groupValue: radioValue_1,
                      onChanged: (value) {
                        setState(() {
                          radioValue_1 = value;
                        });
                      },
                    ),
                    Text("女"),
                  ],
                ),
                SizedBox(height: 20),
                //第二題
                Text(
                  '2.您的生日?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900, 01),
                      lastDate: DateTime(2024, 01),
                    );
                    if (result != null) {
                      setState(() {
                        selectedDateTime = result;
                        print(result);
                      });
                    }
                  },
                  child: const Text('選擇'),
                ),
                SizedBox(height: 20),
                //第三題
                Text(
                  '3.您的身高?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '請輸入您的身高(cm)',
                      hintStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //第四題
                Text(
                  '4.您的體重?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '請輸入您的體重(kg)',
                      hintStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionnairePage3()));
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ]),
        )
    );
  }
}