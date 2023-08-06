import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g12/services/Database.dart';
import 'dart:async';

// Define global variables for ContractPage
User? user = FirebaseAuth.instance.currentUser;
Map contractData = {
  "type": "",
  "plan": "",
  "startDay": Calendar.toKey(DateTime.now()),
  "endDay": "",
  "money": 0,
  "bankAccount": 85167880032579,
  "flag": "",
  "result": false,
};

class FirstContractPage extends StatefulWidget {
  const FirstContractPage({super.key, required arguments});

  @override
  _FirstContractPage createState() => _FirstContractPage();
}

class _FirstContractPage extends State<FirstContractPage> {
  int tapCount = 0;
  final DateTime startDay = DateTime.now();
  final List<String> dialogs = [
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
                                  contractData["type"] = '運動'; // 賦值给type字段
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
                                  contractData["type"] = '冥想';
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
                                contractData["plan"] = "基礎 (1月內達成3週目標)";
                                contractData["endDay"] = Calendar.toKey(
                                    DateTime(startDay.year, startDay.month + 1,
                                        startDay.day));
                                contractData["flag"] = "0, 3";
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
                                contractData["plan"] = "進階 (2月內達成7週目標)";
                                contractData["endDay"] = Calendar.toKey(
                                    DateTime(startDay.year, startDay.month + 2,
                                        startDay.day));
                                contractData["flag"] = "0, 7";
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
                                contractData["plan"] = "困難 (4月內達成15週目標)";
                                contractData["endDay"] = Calendar.toKey(
                                    DateTime(startDay.year, startDay.month + 4,
                                        startDay.day));
                                contractData["flag"] = "0, 15";
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
                              contractData["money"] = int.parse(value);
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SecondContractPage(),
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
  const SecondContractPage({super.key});

  @override
  SecondContractPageState createState() => SecondContractPageState();
}

class SecondContractPageState extends State<SecondContractPage> {
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
                    '立契約人於約定期間積極養成  ${contractData["type"]}  習慣'
                    '\n選擇方案為  ${contractData["plan"]}'
                    '\n投入金額為  ${contractData["money"]}  元'
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
                                        ContractDB.update(contractData);
                                        Navigator.pushNamed(context, '/pay',
                                            arguments: {
                                              'user': user,
                                              'money': contractData["money"],
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
                            Navigator.pushNamed(context, '/contract/initial');
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
class AlreadyContractPage extends StatefulWidget {
  const AlreadyContractPage({super.key});

  @override
  _AlreadyContractPageState createState() => _AlreadyContractPageState();
}

class _AlreadyContractPageState extends State<AlreadyContractPage> {

  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );

  @override
  Widget build(BuildContext context) {
    String type1 = "workout";
    String type2 = "meditation";

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
          PageView(
            controller: _pageController,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF0CA),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder<Map<String, dynamic>?>(
                        future: ContractDB.getContract(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error fetching data');
                          } else if (snapshot.data!.containsKey(type1)) {
                            Map data = snapshot.data![type1];
                            return Text(
                              '立契約人將依照選擇之方案來養成各項習慣，'
                                  '若目標達成系統將投入金額全數退回，失敗則全數捐出。'
                                  '\n您選擇養成的習慣：${data["type"]}'
                                  '\n您選擇的方案：${data["plan"]}'
                                  '\n您所投入的金額：${data["money"]}'
                                  '\n合約開始日：${data["startDay"]}'
                                  '\n合約結束日：${data["endDay"]}'
                                  '\n距離成功已完成：${Tool.calcProgress(data["flag"])}%',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFF0D3B66),
                              ),
                            );
                          } else {
                            return const Text('尚未有運動合約資料'); // If no data is found, show a message
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF0CA),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder<Map<String, dynamic>?>(
                        future: ContractDB.getContract(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error fetching data');
                          } else if (snapshot.data!.containsKey(type2)) {
                            Map data = snapshot.data![type2];
                            return Text(
                              '立契約人將依照選擇之方案來養成各項習慣，'
                                  '若目標達成系統將投入金額全數退回，失敗則全數捐出。'
                                  '\n您選擇養成的習慣：${data["type"]}'
                                  '\n您選擇的方案：${data["plan"]}'
                                  '\n您所投入的金額：${data["money"]}'
                                  '\n合約開始日：${data["startDay"]}'
                                  '\n合約結束日：${data["endDay"]}'
                                  '\n距離成功已完成：${Tool.calcProgress(data["flag"])}%',
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFF0D3B66),
                              ),
                            );
                          } else {
                            return const Text('尚未有冥想合約資料');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                      Future<Map<String, dynamic>?> futureContract = ContractDB.getContract();
                      futureContract.then((data) {
                        bool workoutContractExists = data!.containsKey("workout");
                        bool meditationContractExists = data.containsKey("meditation");

                        if (workoutContractExists && meditationContractExists) {
                          // Show the dialog message for one second and then hide it
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: Text(
                                    '每種類型合約僅能建立一次',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Color(0xFF0D3B66),
                                  ),
                                ),
                              );
                            },
                          );
                          Timer(const Duration(seconds: 1), () {
                            Navigator.of(context).pop(); // Close the dialog after one second
                          });
                        } else {
                          _showOptionsDialog(context);
                        }
                      });
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
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: OptionsDialog(),
        );
      },
    );
  }
}

class OptionsDialog extends StatefulWidget {
  const OptionsDialog({super.key});

  @override
  _OptionsDialogState createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  String? _type;
  String? _plan;
  int? _money;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _fetchExistingContractData();
    processing = false;
  }

  Future<void> _fetchExistingContractData() async {
    Map<String, dynamic>? contractData = await ContractDB.getContract();
    if (contractData != null) {
      setState(() {
        _type = contractData["type"];
        _plan = contractData["plan"];
        _money = contractData["money"];
      });
    }
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
                    onPressed: () async {
                      //檢查是否有運動合約
                      bool hasWorkoutContract =
                          await ContractDB.getWorkout() != null;
                      if (hasWorkoutContract) {
                        _showDialog("已建立過運動合約，不允許二次投入");
                      } else {
                        _selectType("運動");
                      }
                    },
                  ),
                  ActionChip(
                    label: const Text("冥想"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _type == "冥想"
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () async {
                      //檢查是否有冥想合約
                      bool hasMeditationContract =
                          await ContractDB.getMeditation() != null;
                      if (hasMeditationContract) {
                        _showDialog("已建立過冥想合約，不允許二次投入");
                      } else {
                        _selectType("冥想");
                      }
                    },
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
                    backgroundColor: _money == 100
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(100),
                  ),
                  ActionChip(
                    label: const Text("150"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _money == 150
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(150),
                  ),
                  ActionChip(
                    label: const Text("200"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _money == 200
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(200),
                  ),
                  ActionChip(
                    label: const Text("250"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _money == 250
                        ? const Color(0xFFFAF0CA)
                        : Colors.black26,
                    onPressed: () => _selectAmount(250),
                  ),
                  ActionChip(
                    label: const Text("300"),
                    labelStyle: const TextStyle(color: Color(0xFF0D3B66)),
                    backgroundColor: _money == 300
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

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop(); // Close the dialog after 3 seconds
        });
        return AlertDialog(
          title: const Text("警告"),
          content: Text(message),
        );
      },
    );
  }

  _selectType(String t) {
    setState(() {
      _type = t;
      contractData["type"] = t;
    });
  }

  _selectPlan(String p) {
    setState(() {
      _plan = p;
      DateTime startDay = DateTime.now();
      switch (p) {
        case "基礎":
          contractData["plan"] = "基礎 (1月內達成3週目標)";
          contractData["endDay"] = Calendar.toKey(
              DateTime(startDay.year, startDay.month + 1, startDay.day));
          contractData["flag"] = "0, 3";
          break;
        case "進階":
          contractData["plan"] = "進階 (2月內達成7週目標)";
          contractData["endDay"] = Calendar.toKey(
              DateTime(startDay.year, startDay.month + 2, startDay.day));
          contractData["flag"] = "0, 7";
          break;
        case "困難":
          contractData["plan"] = "困難 (4月內達成15週目標)";
          contractData["endDay"] = Calendar.toKey(
              DateTime(startDay.year, startDay.month + 4, startDay.day));
          contractData["flag"] = "0, 15";
          break;
      }
    });
  }

  _selectAmount(int a) {
    setState(() {
      _money = a;
      contractData["money"] = a;
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
                ContractDB.update(contractData);
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
      if (!mounted) return;
      Navigator.pushNamed(context, '/pay', arguments: {
        'user': user,
        'money': _money,
      });
    }
  }
}