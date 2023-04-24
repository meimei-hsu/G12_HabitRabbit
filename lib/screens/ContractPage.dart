import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({Key? key, required this.title}) : super(key: key);

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
          /* Container(

            padding: EdgeInsets.only(right: 280,top:50),
            child: Text(
              'Line暱稱 ：',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xff0d3b66),
                  fontSize: 25,
                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
*/
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
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: '設立目標',
                hintText: '請輸入設立目標',
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
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: '投注金額',
                hintText: '請輸入投注金額',
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
            padding: EdgeInsets.only(left:20,right:20,top:15),
            child: Text(
              '1.本系統與LINE官方進行合作',
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
            padding: EdgeInsets.only(left:45,right:20,top:10),
            child: Text(
              '2.請掃描該QRCODE，再進行後續動作',
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
            child:
            Image.asset(
              'assets/images/LINE.jpg', // 相對路徑
              width: 300,
              height: 100,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 280, right: 10),
            child: IconButton(
              icon: const Icon(Icons.send),
              iconSize: 40,
              color: Color(0xff0d3b66),
              tooltip: "送出",
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
