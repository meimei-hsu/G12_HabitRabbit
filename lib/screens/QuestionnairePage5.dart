import 'package:flutter/material.dart';
import 'package:g12/screens/QuestionnairePage6.dart';

class QuestionnairePage5 extends StatefulWidget {
  @override
  _QuestionnairePage5 createState() => _QuestionnairePage5();
}

class _QuestionnairePage5 extends State<QuestionnairePage5> {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('第二部分共有9道題，\n'
                  '請針對以下情況進行直覺式判斷，並在不花太多時間的條件下回答是或否。\n'
                  '請誠實且儘可能準確地回答。\n\n',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text("開始作答"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionnairePage6()));
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

