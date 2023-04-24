import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FeedbackPageState createState() => new _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _currentValue1 = 1;
  double _selectedValue1 = 1;
  double _currentValue2 = 1;
  double _selectedValue2 = 1;

  void _showAlertDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: Text(
          '每週運動回饋',
          style: TextStyle(
            backgroundColor: Colors.yellow,
            color: Color(0xff0d3b66),
          )
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Container(
              padding: EdgeInsets.only(top:1),
              child: Text(
                '運動項目是否滿意?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  //backgroundColor: Colors.yellow,
                    color: Color(0xff0d3b66),
                    fontSize: 25,
                    letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.bold,
                    height: 1),
              ),
            ),
            Container(
                child: Slider(
                  value: _currentValue1,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _currentValue1.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentValue1 = value;
                      _selectedValue1 = value;
                    });
                  },
                )
            ),
            Text(
              '1                                    5',
              textAlign: TextAlign.left,
              style: TextStyle(
                //backgroundColor: Colors.yellow,
                  color: Color(0xff0d3b66),
                  fontSize: 20,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
            Container(
              padding: EdgeInsets.only(top:25),
              child: Text(
                '運動過程是否滿意?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  //backgroundColor: Colors.yellow,
                    color: Color(0xff0d3b66),
                    fontSize: 25,
                    letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.bold,
                    height: 1),
              ),
            ),
            Container(
                child: Slider(
                  value: _currentValue2,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _currentValue2.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentValue2 = value;
                      _selectedValue2 = value;
                    });
                  },
                )
            ),
            Text(
              '1                                    5',
              textAlign: TextAlign.left,
              style: TextStyle(
                //backgroundColor: Colors.yellow,
                  color: Color(0xff0d3b66),
                  fontSize: 20,
                  letterSpacing:
                  0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ]
      ),

      actions: [
        ElevatedButton(
            child: Text("Submit"),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        ElevatedButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ],
    );

    // Show the dialog (showDialog() => showGeneralDialog())
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {return Wrap();},
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            (1.0-Curves.easeInOut.transform(anim1.value))*400,
            0.0,
          ),
          child: dialog,
        );
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FeedbackTest"),

      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Feedback"),
          onPressed: () {
            _showAlertDialog(context);
          },
        ),
      ),
    );
  }
}

