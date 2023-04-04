import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key, required this.title});

  final String title;

  @override
  _ContractPageState createState() => new _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '承諾合約',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(0xff0d3b66),
              fontSize: 32,
              letterSpacing:
              0 /*percentages not used in flutter. defaulting to zero*/,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        //Text(widget.title, style: TextStyle(color: Color(0xff0d3b66))),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'LINE暱稱',
                hintText: '請輸入LINE暱稱',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
              onChanged: (value) {
                print(value);
              },
              onSubmitted: (value) {
                print('Submitted: $value');
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'LINEID',
                hintText: '請輸入LINEID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              obscureText: false,
              //controller: _controller,
              onChanged: (value) {
                //print(value);
              },
              onSubmitted: (value) {
                //print('Submitted: $value');
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: IconButton(
              icon: const Icon(Icons.send),
              iconSize: 40,
              color: Color(0xff0d3b66),
              tooltip: "送出",
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
