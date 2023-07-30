import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g12/services/Database.dart';

class FirstContractPage extends StatefulWidget {
  const FirstContractPage({super.key, required arguments});

  @override
  _FirstContractPage createState() => _FirstContractPage();
}

class _FirstContractPage extends State<FirstContractPage> {
  User? user = FirebaseAuth.instance.currentUser;
  int tapCount = 0;
  List<String> dialogs = [
    '承諾合約協助您養成習慣',
    '您可以在此於約定期間依照自身狀況選擇方案。'
        '一旦開始執行，契約內容將不能取消或進行更改直到方案完成'
        '若未達成設定目標，立契約人同意將投入金額全數捐出；'
        '若達成設定目標則由系統將全數金額退還。',
    '是否確認投入合約？',
    '請點選您想要投入類型：',
    '請點選您想要投入方案：',
    '您要投入多少金錢以督促自己：',
  ];

  late String inputAmount;
  late String type;
  late String plan;

  void updateDialog() {
    setState(() {
      if (tapCount < dialogs.length) {
        tapCount++;
      }
    });
  }

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
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: updateDialog,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(left: 25.0, right: 25.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF0CA),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dialogs[tapCount],
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                    if (tapCount != 1 &&
                        tapCount != 2 &&
                        tapCount != 3 &&
                        tapCount != 4 &&
                        tapCount != 5) ...[
                      const Text(
                        '➤ 點擊前往下一步',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF0D3B66),
                        ),
                      ),
                    ],
                    if (tapCount == 2) ...[
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tapCount++;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0D3B66),
                                backgroundColor: const Color(0xFFFDFDFD),
                              ),
                              child: const Text('確定！我要挑戰'),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0D3B66),
                                backgroundColor: const Color(0xFFFDFDFD),
                              ),
                              child: const Text('先不要...謝謝再連絡'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (tapCount == 3) ...[
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tapCount++;
                                  type = '運動'; // 賦值给type字段
                                  print('選擇的合約類型：$type');
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0D3B66),
                                backgroundColor: const Color(0xFFFDFDFD),
                              ),
                              child: const Text('運動'),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tapCount++;
                                  type = '冥想'; // 漢值给type字段
                                  print('選擇的合約類型：$type');
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0D3B66),
                                backgroundColor: const Color(0xFFFDFDFD),
                              ),
                              child: const Text('冥想'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (tapCount == 4) ...[
                      const SizedBox(height: 16.0),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                plan = '基礎';
                                print('選擇的合約方案：$plan');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D3B66),
                              backgroundColor: const Color(0xFFFDFDFD),
                            ),
                            child: const Text('基礎：一個月內至少達成3週目標'),
                          ),
                          const SizedBox(height: 4.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                plan = '進階';
                                print('選擇的合約方案：$plan');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D3B66),
                              backgroundColor: const Color(0xFFFDFDFD),
                            ),
                            child: const Text('進階：兩個月內至少達成7週目標'),
                          ),
                          const SizedBox(height: 4.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                plan = '困難';
                                print('選擇的合約方案：$plan');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF0D3B66),
                              backgroundColor: const Color(0xFFFDFDFD),
                            ),
                            child: const Text('困難：四個月內至少達成15週目標'),
                          ),
                        ],
                      ),
                    ],
                    if (tapCount == 5) ...[
                      SizedBox(
                        width: 230.0,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              inputAmount = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '輸入金額',
                            labelStyle: TextStyle(
                              color: Color(0xFF0D3B66),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            String value = inputAmount;
                            //print('投入金額：$value');
                            Map contractData = {
                              'user': user,
                              'type': type,
                              'plan': plan,
                              'amount': value,
                            };
                            print(contractData);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SecondContractPage(arguments: contractData),
                              ),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF0D3B66),
                          backgroundColor: const Color(0xFFFDFDFD),
                        ),
                        child: const Text('確定'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset(
                'assets/images/personality_SGF.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ],
        ),
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
  User? user = FirebaseAuth.instance.currentUser;
  String? type;
  String? plan;
  String? amount;

  @override
  void initState() {
    super.initState();
    // 取得要儲存的資料
    type = widget.arguments['type'];
    plan = widget.arguments['plan'];
    amount = widget.arguments['amount'];
  }

  void saveDataToMap() {}

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
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF0CA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('已簽約合約內容'),
                  Text(
                    '立契約人於約定期間積極養成  $type  習慣'
                    '\n選擇方案為  $plan'
                    '\n投入金額為  $amount  元'
                    '\n\n若未達成設定目標，立契約人同意將投入金額全數捐出；'
                    '若達成設定目標則由系統將全數金額退還。',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('確定要執行嗎？'),
                                  content: const Text('確認後將無法取消或進行修改'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // TODO: Connect to backend
                                        Navigator.pushNamed(context, '/pay',
                                            arguments: {
                                              'user': user,
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF0D3B66),
                                        backgroundColor:
                                            const Color(0xFFFDFDFD),
                                      ),
                                      child: const Text('確定'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF0D3B66),
                                        backgroundColor:
                                            const Color(0xFFFDFDFD),
                                      ),
                                      child: const Text('取消'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF0D3B66),
                            backgroundColor: const Color(0xFFFDFDFD),
                          ),
                          child: const Text('確定'),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/contract/initial',
                                arguments: {'user': user});
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF0D3B66),
                            backgroundColor: const Color(0xFFFDFDFD),
                          ),
                          child: const Text('取消/重新輸入'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Image.asset(
              'assets/images/personality_SGF.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

//已立過合約畫面
class AlreadyContractPage extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  final Map<String, String> contractData;
  AlreadyContractPage(
      {super.key, required this.contractData, required arguments, String? type, String? plan, String? amount});

  @override
  Widget build(BuildContext context) {
    print(contractData);
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
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF0CA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<Map<String, dynamic>?>(
                    future: ContractDB.getContractDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error fetching data');
                      } else if (snapshot.data != null) {
                        final type = snapshot.data!['type'];
                        final plan = snapshot.data!['plan'];
                        final amount = snapshot.data!['money'];
                        final startDay = snapshot.data!['startDay'];
                        final endDay = snapshot.data!['endDay'];

                        return Text(
                          '立契約人將依照選擇之方案來養成各項習慣，'
                              '若目標達成系統將投入金額全數退回，失敗則全數捐出。'
                              '\n您選擇養成的習慣：$type'
                              '\n您選擇的方案：$plan'
                              '\n您所投入的金額：$amount'
                              '\n合約開始日：$startDay'
                              '\n合約結束日：$endDay'
                              '\n距離成功已完成：', // TODO: Connect to backend
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF0D3B66),
                          ),
                        );
                      } else {
                        return const Text('No contract data found'); // If no data is found, show a message
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 180,
            child: Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _showOptionsDialog(context);
                    },
                    child: const Text(
                      '新增合約',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                  ),
                  const Text(
                    '/',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFF0D3B66),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      '回主頁',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Image.asset(
              'assets/images/personality_SGF.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.black.withOpacity(0.5), // Darkened background color
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: OptionsDialog(arguments: null),
        );
      },
    );
  }
}

class OptionsDialog extends StatefulWidget {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> contractData = {};

  OptionsDialog({super.key, required arguments});

  @override
  _OptionsDialogState createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  String? _type;
  String? _plan;
  int? _amount;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _type = "運動";
    _plan = "基礎";
    _amount = 100;
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade200,
              child: Text(
                "建立新的承諾合約",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text("選擇類型"),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 16.0,
                spacing: 16.0,
                children: <Widget>[
                  const SizedBox(width: 0.0),
                  ActionChip(
                    label: const Text("運動"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _type == "運動"
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectType("運動"),
                  ),
                  ActionChip(
                    label: const Text("冥想"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _type == "冥想"
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectType("冥想"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text("選擇方案"),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 16.0,
                spacing: 16.0,
                children: <Widget>[
                  const SizedBox(width: 0.0),
                  ActionChip(
                    label: const Text("基礎"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _plan == "基礎"
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectPlan("基礎"),
                  ),
                  ActionChip(
                    label: const Text("進階"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _plan == "進階"
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectPlan("進階"),
                  ),
                  ActionChip(
                    label: const Text("困難"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _plan == "困難"
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectPlan("困難"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text("選擇投入金額"),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                runSpacing: 16.0,
                spacing: 16.0,
                children: <Widget>[
                  const SizedBox(width: 0.0),
                  ActionChip(
                    label: const Text("100"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _amount == 100
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(100),
                  ),
                  ActionChip(
                    label: const Text("150"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _amount == 150
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(150),
                  ),
                  ActionChip(
                    label: const Text("200"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _amount == 200
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(200),
                  ),
                  ActionChip(
                    label: const Text("250"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _amount == 250
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(250),
                  ),
                  ActionChip(
                    label: const Text("300"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _amount == 300
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(300),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            processing
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _startContract,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D3B66),
                      backgroundColor: const Color(0xFFFDFDFD),
                    ),
                    child: const Text("確認執行"),
                  ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  _selectType(String t) {
    setState(() {
      _type = t;
      widget.contractData['type'] = _type;
    });
  }

  _selectPlan(String p) {
    setState(() {
      _plan = p;
      widget.contractData['plan'] = _plan;
    });
  }

  _selectAmount(int a) {
    setState(() {
      _amount = a;
      widget.contractData['amount'] = _amount;
    });
  }

  void _startContract() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("確認執行動作"),
          content: const Text("一旦執行動作後就無法進行修改或刪除。您確定要繼續嗎？"),
          actions: <Widget>[
            TextButton(
              child: const Text("確認"),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
            ),
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        processing = true;
      });

      //DateTime 處理和資料庫更新
      /*int duration = 0;
      DateTime startDay = Calendar.nextSunday(DateTime.now());
      DateTime endDay = startDay.add(Duration(days: duration));

      var c = [
        Calendar.toKey(startDay),
        Calendar.toKey(endDay),
        '1111111',
        false,
      ];

      Map contract = Map.fromIterables(ContractDB.getColumns(), c);
      ContractDB.update(contract);
      print(contract);*/

      Navigator.pushNamed(context, '/pay', arguments: {
        'user': widget.user,
        'contractData': widget.contractData,
      });
    }
  }
}

//TODO: 判斷式判斷使用者目前投入哪個合約
//1. if (type != exercise)：Navigator.pushNamed(context, '/contract/exercise', arguments: {'user': user});
//2. if (type != meditation)：Navigator.pushNamed(context, '/contract/meditation', arguments: {'user': user});
//3. if (type == exercise && type == meditation):showDialog(兩種習慣養成合約都已建立)
