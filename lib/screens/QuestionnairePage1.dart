import 'package:flutter/material.dart';
import 'package:g12/screens/QuestionnairePage2.dart';

class QuestionnairePage1 extends StatefulWidget {
  @override
  _QuestionnairePage1 createState() => _QuestionnairePage1();
}


class _QuestionnairePage1 extends State<QuestionnairePage1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Change Page',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('問卷介面'),
          ),
          body: _QuestionnairePage(

          ),
        ),
        routes: <String, WidgetBuilder>{'/second': (_) => QuestionnairePage2()});
  }
}

class _QuestionnairePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('第一部分共14道題，\n'
              '問題將分成「基本資訊」、「運動習慣偏好調查」\n'
              '與「現階段運動能力及未來目標」三大項。\n\n'
              '請依據個人狀況回來問題。\n',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            child: Text("開始作答"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionnairePage2()));
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
