import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:g12/services/Database.dart';

class FirstContractPage extends StatefulWidget {

  const FirstContractPage({super.key, required arguments});

  @override
  _FirstContractPage createState() => _FirstContractPage();
}

class _FirstContractPage extends State<FirstContractPage> {
  late Widget image;
  String plan = "5週4旗";
  String dropdownValue = '100';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '承諾合約',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color(0xFFFAF0CA),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 1000,
            width: 600,
            child: Image.asset(
              'assets/images/scroll.png',
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
                Text(
                  "5週4旗",
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
                Text(
                  "12週8旗",
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
                Text(
                  "18週12旗",
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
                const SizedBox(height: 8),
                // add some space between the text and the dropdown button
                DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    '100',
                    '125',
                    '150',
                    '175',
                    '200',
                    '215',
                    '250',
                    '275',
                    '300',
                    '350',
                    '400',
                    '450',
                    '500'
                  ].map<DropdownMenuItem<String>>((String value) {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA493),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("您確定要執行此動作嗎？",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                          )),
                      content: const Text("確認後將執行契約且不能反悔",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                          )),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA493),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("取消",
                              style: TextStyle(
                                color: Color(0xFF0D3B66),
                              )),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA493),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();

                            int duration = 0;
                            String flag = "";
                            switch (plan) {
                              case "5週4旗":
                                duration = 35;
                                flag = "0, 4";
                                break;
                              case "12週8旗":
                                duration = 84;
                                flag = "0, 8";
                                break;
                              case "18週12旗":
                                duration = 126;
                                flag = "0, 12";
                                break;
                            }
                            DateTime startDay =
                                Calendar.nextSunday(DateTime.now());
                            DateTime endDay =
                                startDay.add(Duration(days: duration));

                            var c = [
                              Calendar.toKey(startDay),
                              Calendar.toKey(endDay),
                              dropdownValue,
                              '1111111',
                              flag,
                              false,
                            ];

                            Map contract =
                                Map.fromIterables(ContractDB.getColumns(), c);
                            print(contract);
                            ContractDB.insert(contract);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                Future.delayed(const Duration(seconds: 3), () {
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(context, '/contract',
                                      arguments: {
                                        'contractData': contract,
                                      });
                                });
                                return const AlertDialog(
                                  title: Text("已確定契約並開始執行！",
                                      style: TextStyle(
                                        color: Color(0xFF0D3B66),
                                      )),
                                );
                              },
                            );
                          },
                          child: const Text("確定",
                              style: TextStyle(
                                color: Color(0xFF0D3B66),
                              )),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("確認",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                  )),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SecondContractPage extends StatefulWidget {
  final Map arguments;

  const SecondContractPage({super.key, required this.arguments});

  @override
  SecondContractPageState createState() => SecondContractPageState();
}

class SecondContractPageState extends State<SecondContractPage> {
  Map flagToPlan = {"4": "5 週 4 旗", "8": "12 週 8 旗", "12": "18 週 12 旗"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '承諾合約',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color(0xFFFAF0CA),
        automaticallyImplyLeading: false, // 將返回上一頁的按鈕移除
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 1000,
            width: 600,
            child: Image.asset(
              'assets/images/scroll.png',
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
              '您選擇的方案：${flagToPlan[widget.arguments['contractData']['flag'].split(", ")[1].toString()]}',
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
              '您所投入的金額(元)：${widget.arguments['contractData']['money']}',
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
              '距離成功已完成：', //${widget.arguments['contractData']['flag']}
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            top: 462,
            left: 205,
            child: StepProgressIndicator(
              totalSteps: int.parse(
                  widget.arguments['contractData']['flag'].split(",")[1]),
              currentStep: int.parse(
                  widget.arguments['contractData']['flag'].split(",")[0]), //
              selectedColor: const Color(0xFFFFA493),
              unselectedColor: Colors.white,
              customStep: (index, color, _) => Icon(
                Icons.flag_rounded,
                color: color,
              ),
            ),
          ),
          Positioned(
            top: 490,
            left: 65,
            child: Text(
              // endDay=ContractDB.getEndDay(widget.arguments['user'].uid);
              '承諾合約終止日：${widget.arguments['contractData']['endDay'].split(" ")[0]}',
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA493),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text("確認",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                  )),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
