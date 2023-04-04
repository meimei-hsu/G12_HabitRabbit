import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key, required this.title});

  final String title;

  @override
  _StatisticPageState createState() => new _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '統計資料',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 32,
              letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [],
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
          backgroundColor: Color(0xffffa493),
          child: Container(
            child: Ink(
              decoration: const ShapeDecoration(
                //color: Color(0xffffa493),
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 80,
                color: Color(0xff0d3b66),
                tooltip: "返回",
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
