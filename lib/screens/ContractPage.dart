import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  @override
  _ContractPage createState() => new _ContractPage();
}

class _ContractPage extends State<ContractPage> {
  late Widget image;
  String plan = "5週4旗";
  String dropdownValue = '100';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('承諾合約',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: 1000,
              width: 600,
              child: Image.asset('assets/images/scroll.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 200,
              left: 180,
              child: Text(
                '契約書',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 22,
                ),
              ),
            ),
            Positioned(
              top: 240,
              left: 65,
              child: Text(
                '使用者立定契約時，已瞭解並同意本'
                    '\n契約內容。依照自身狀況選擇契約方'
                    '\n案及金額後，將會遵守自己設定的運'
                    '\n動模式來養成運動習慣，一旦開始契'
                    '\n約內容，將不能取消或修改。目標達'
                    '\n成時投入金額將全數退回；目標失敗'
                    '\n將由管理員將費用全數捐出。',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 430,
              left: 65,
              child: Text(
                '請選擇方案：',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 450,
              left: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "5週4旗",
                    groupValue: plan,
                    onChanged: (value) {
                      setState(() {
                        plan = value!;
                      });
                    },
                    activeColor: Colors.grey[700],
                  ),
                  Text("5週4旗",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),
                  Radio<String>(
                    value: "12週8旗",
                    groupValue: plan,
                    onChanged: (value) {
                      setState(() {
                        plan = value!;
                      });
                    },
                    activeColor: Colors.grey[700],
                  ),
                  Text("12週8旗",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),
                  Radio<String>(
                    value: "18週12旗",
                    groupValue: plan,
                    onChanged: (value) {
                      setState(() {
                        plan = value!;
                      });
                    },
                    activeColor: Colors.grey[700],
                  ),
                  Text("18週12旗",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 490,
              left: 65,
              child: Row(
                children: [
                  Text(
                    '請選擇投入金額(元)：',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8), // add some space between the text and the dropdown button
                  DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['100', '125', '150', '175', '200', '215', '250', '275', '300', '350', '400', '450', '500']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 180,
              child: ElevatedButton(
                child: Text("確認",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA493),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("您確定要執行此動作嗎？",
                            style: TextStyle(
                              color: Color(0xFF0D3B66),
                            )
                        ),
                        content: Text("確認後將執行契約且不能反悔",
                            style: TextStyle(
                              color: Color(0xFF0D3B66),
                            )
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Text("取消",
                                style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                )
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFA493),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: Text("確定",
                                style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                )
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFA493),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Map<String, String> contractData = {
                                'plan': plan,
                                '投入金額': dropdownValue,
                              };
                              print(contractData);
                              // do something with the contract data, such as sending it to a server or storing it locally
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>  SecondContractPage(contractData: contractData)
                                        ));
                                  });
                                  return AlertDialog(
                                    title: Text("已確定契約並開始執行！",
                                        style: TextStyle(
                                          color: Color(0xFF0D3B66),
                                        )
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SecondContractPage extends StatefulWidget {
  final Map<String, String> contractData;
  SecondContractPage({required this.contractData});

  @override
  _SecondContractPageState createState() => _SecondContractPageState();
}

class _SecondContractPageState extends State<SecondContractPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('承諾合約',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
        automaticallyImplyLeading: false, // 將返回上一頁的按鈕移除
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: 1000,
              width: 600,
              child: Image.asset('assets/images/scroll.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 200,
              left: 180,
              child: Text(
                '契約書',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 22,
                ),
              ),
            ),
            Positioned(
              top: 240,
              left: 65,
              child: Text(
                '使用者立定契約將遵守自己設定的運'
                    '\n動模式來養成運動習慣，目標達成時'
                    '\n投入金額將全數退回；目標失敗將由'
                    '\n管理員將費用全數捐出。',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 400,
              left: 65,
              child: Text(
                '您選擇的方案：${widget.contractData['plan']}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 430,
              left: 65,
              child: Text(
                '您所投入的金額(元)：${widget.contractData['投入金額']}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 460,
              left: 65,
              child: Text(
                '距離成功已完成：',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 490,
              left: 65,
              child: Text(
                '承諾合約終止日：',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 180,
              child: ElevatedButton(
                child: Text("確認",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA493),
                ),
                onPressed: () {
                  //這裡應該要回到 HomePage
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContractPage()));
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
