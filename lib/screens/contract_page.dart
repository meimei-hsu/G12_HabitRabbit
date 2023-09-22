import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/screens/register_page.dart';

import 'package:g12/services/database.dart';

// Define global variables for ContractPage
User? user = FirebaseAuth.instance.currentUser;
Map contractData = {
  "type": "",
  "plan": "",
  "startDay": Calendar.dateToString(DateTime.now()),
  "endDay": "",
  "money": 0,
  "bankAccount": 85167880032579,
  "flag": "",
  "result": false,
};

class FirstContractPage extends StatefulWidget {
  const FirstContractPage({super.key, required arguments});

  @override
  FirstContractPageState createState() => FirstContractPageState();
}

class FirstContractPageState extends State<FirstContractPage> {
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
    '您要投入多少金錢督促自己：',
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
      backgroundColor: ColorSet.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '承諾合約',
          style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 28,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        backgroundColor: ColorSet.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: ColorSet.iconColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: updateDialog,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ColorSet.bottomBarColor, ColorSet.bottomBarColor],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dialogs[tapCount],
                      style: TextStyle(
                          fontSize: 22.0,
                          color: ColorSet.textColor,
                          fontWeight: (tapCount != 1) ? FontWeight.bold : null),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (tapCount != 1 &&
                        tapCount != 2 &&
                        tapCount != 3 &&
                        tapCount != 4 &&
                        tapCount != 5) ...[
                      const Text(
                        '➤ 點擊前往下一步',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: ColorSet.textColor,
                        ),
                      ),
                    ],
                    if (tapCount == 2) ...[
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              backgroundColor: ColorSet.backgroundColor,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                            },
                            child: const Text(
                              '再考慮一下',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 17,
                              ),
                            ),
                          )),
                          const SizedBox(width: 10.0),
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              backgroundColor: ColorSet.backgroundColor,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                tapCount++;
                              });
                            },
                            child: const Text(
                              '確定挑戰！',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 17,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                    if (tapCount == 3) ...[
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                color: ColorSet.borderColor,
                              ),
                              backgroundColor: ColorSet.backgroundColor,
                            ),
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                contractData["type"] = '運動'; // 賦值给type字段
                              });
                            },
                            child: const Text(
                              '運動',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 17,
                              ),
                            ),
                          )),
                          const SizedBox(width: 10.0),
                          Expanded(
                              child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                color: ColorSet.borderColor,
                              ),
                              backgroundColor: ColorSet.backgroundColor,
                            ),
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                contractData["type"] = '冥想';
                              });
                            },
                            child: const Text(
                              '冥想',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 17,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                    if (tapCount == 4) ...[
                      const SizedBox(height: 10.0),
                      Column(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                color: ColorSet.borderColor,
                              ),
                              backgroundColor: ColorSet.backgroundColor,
                            ),
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                contractData["plan"] = "基礎 (1月內達成3週目標)";
                                contractData["endDay"] = Calendar.dateToString(
                                    DateTime(startDay.year, startDay.month + 1,
                                        startDay.day));
                                contractData["flag"] = "0, 3";
                              });
                            },
                            child: const Text(
                              '基礎：一個月內至少達成 3 週目標',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                color: ColorSet.borderColor,
                              ),
                              backgroundColor: ColorSet.backgroundColor,
                            ),
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                contractData["plan"] = "進階 (2月內達成7週目標)";
                                contractData["endDay"] = Calendar.dateToString(
                                    DateTime(startDay.year, startDay.month + 2,
                                        startDay.day));
                                contractData["flag"] = "0, 7";
                              });
                            },
                            child: const Text(
                              '進階：兩個月內至少達成 7 週目標',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                color: ColorSet.borderColor,
                              ),
                              backgroundColor: ColorSet.backgroundColor,
                            ),
                            onPressed: () {
                              setState(() {
                                tapCount++;
                                contractData["plan"] = "困難 (4月內達成15週目標)";
                                contractData["endDay"] = Calendar.dateToString(
                                    DateTime(startDay.year, startDay.month + 4,
                                        startDay.day));
                                contractData["flag"] = "0, 15";
                              });
                            },
                            child: const Text(
                              '困難：四個月內至少達成 15 週目標',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (tapCount == 5) ...[
                      const SizedBox(height: 15.0),
                      Container(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: TextFormField(
                          validator: (value) {
                            // TODO: validator context
                            if (value == null || value.isEmpty) {
                              return "請輸入金額！";
                            } else if (double.parse(value) == 0) {
                              return "金額不得為 0！";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: const Icon(
                              Icons.monetization_on_rounded,
                              color: ColorSet.iconColor,
                            ),
                            labelText: '輸入金額',
                            hintText: '單位為「新台幣」',
                            enabledBorder: enabledBorder,
                            errorBorder: focusedAndErrorBorder,
                            focusedBorder: focusedAndErrorBorder,
                            focusedErrorBorder: focusedAndErrorBorder,
                            labelStyle:
                                const TextStyle(color: ColorSet.textColor),
                            hintStyle: const TextStyle(color: Colors.grey),
                            errorStyle: const TextStyle(
                                height: 1,
                                color: ColorSet.backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            errorMaxLines: 1,
                            filled: true,
                            fillColor: ColorSet.backgroundColor,
                          ),
                          cursorColor: ColorSet.backgroundColor,
                          style: const TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 17,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              contractData["money"] = int.parse(value);
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            backgroundColor: ColorSet.backgroundColor,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                          child: const Text(
                            '確定',
                            style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
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
      backgroundColor: ColorSet.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '承諾合約',
          style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 28,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        backgroundColor: ColorSet.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: ColorSet.iconColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [ColorSet.bottomBarColor, ColorSet.bottomBarColor],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '已簽約合約內容',
                    style: TextStyle(
                        fontSize: 22.0,
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '立契約人於約定期間積極養成  ${contractData["type"]}  習慣'
                    '\n選擇方案為  ${contractData["plan"]}'
                    '\n投入金額為  ${contractData["money"]}  元'
                    '\n\n若未達成設定目標，立契約人同意將投入金額全數捐出；'
                    '若達成設定目標則由系統將全數金額退還。',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: ColorSet.textColor,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              backgroundColor: ColorSet.backgroundColor,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/contract/initial');
                            },
                            child: const Text(
                              '取消 / 重新輸入',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(right: 10, left: 10),
                              backgroundColor: ColorSet.backgroundColor,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              btnOkOnPress() async {
                                ContractDB.update(contractData);
                                Navigator.pushNamed(context, '/pay',
                                    arguments: {
                                      'user': user,
                                      'money': contractData["money"],
                                    });
                              }

                              ConfirmDialog()
                                  .get(
                                      context,
                                      '確定要執行嗎？',
                                      "一旦執行動作後就無法進行修改或刪除。您確定要繼續嗎？",
                                      btnOkOnPress)
                                  .show();
                            },
                            child: const Text(
                              '確定',
                              style: TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        )
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
  AlreadyContractPageState createState() => AlreadyContractPageState();
}

class AlreadyContractPageState extends State<AlreadyContractPage> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );

  @override
  Widget build(BuildContext context) {
    String type1 = "workout";
    String type2 = "meditation";

    return Scaffold(
      backgroundColor: ColorSet.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '承諾合約',
          style: TextStyle(
              color: ColorSet.textColor,
              fontSize: 28,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        backgroundColor: ColorSet.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: ColorSet.iconColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // FIXME: fix the position
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              Align(
                alignment: const Alignment(0.0, -0.3),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColorSet.bottomBarColor,
                        ColorSet.bottomBarColor
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder<Map<String, dynamic>?>(
                        future: ContractDB.getContract(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error fetching data');
                          } else if (snapshot.data!.containsKey(type1)) {
                            Map data = snapshot.data![type1];
                            return Text(
                              '立契約人將依照選擇之方案來養成各項習慣，'
                              '若目標達成系統將投入金額全數退回，失敗則全數捐出。\n'
                              '\n您選擇養成的習慣：${data["type"]}'
                              '\n您選擇的方案：${data["plan"]}'
                              '\n您所投入的金額：${data["money"]}\n'
                              '\n合約開始日：${data["startDay"]}'
                              '\n合約結束日：${data["endDay"]}'
                              '\n距離成功已完成：${Calculator.calcProgress(data["flag"])}%',
                              style: const TextStyle(
                                fontSize: 18.0,
                                letterSpacing: 1.2,
                                color: ColorSet.textColor,
                              ),
                            );
                          } else {
                            return const Text(
                                '尚未有運動合約資料'); // If no data is found, show a message
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.0, -0.3),
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColorSet.bottomBarColor,
                        ColorSet.bottomBarColor
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FutureBuilder<Map<String, dynamic>?>(
                        future: ContractDB.getContract(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Error fetching data');
                          } else if (snapshot.data!.containsKey(type2)) {
                            Map data = snapshot.data![type2];
                            return Text(
                              '立契約人將依照選擇之方案來養成各項習慣，'
                              '若目標達成系統將投入金額全數退回，失敗則全數捐出。\n'
                              '\n您選擇養成的習慣：${data["type"]}'
                              '\n您選擇的方案：${data["plan"]}'
                              '\n您所投入的金額：${data["money"]}\n'
                              '\n合約開始日：${data["startDay"]}'
                              '\n合約結束日：${data["endDay"]}'
                              '\n距離成功已完成：${Calculator.calcProgress(data["flag"])}%',
                              style: const TextStyle(
                                fontSize: 18.0,
                                letterSpacing: 1.2,
                                color: ColorSet.textColor,
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
            bottom: 235,
            child: Container(
              margin: const EdgeInsets.only(right: 5.0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Future<Map<String, dynamic>?> futureContract =
                          ContractDB.getContract();
                      futureContract.then((data) {
                        bool workoutContractExists =
                            data!.containsKey("workout");
                        bool meditationContractExists =
                            data.containsKey("meditation");

                        if (workoutContractExists && meditationContractExists) {
                          // Show the dialog message for one second and then hide it
                          InformDialog()
                              .get(context, "無法新增:(", "每種類型合約僅能建立一次！")
                              .show();
                        } else {
                          _showOptionsBottomSheet(context);
                        }
                      });
                    },
                    child: const Text(
                      '新增合約',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: ColorSet.textColor,
                          fontWeight: FontWeight.bold),
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

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      backgroundColor: ColorSet.backgroundColor,
      // Darkened background color
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const OptionsBottomSheet();
      },
    );
  }
}

class OptionsBottomSheet extends StatefulWidget {
  const OptionsBottomSheet({super.key});

  @override
  OptionsBottomSheetState createState() => OptionsBottomSheetState();
}

class OptionsBottomSheetState extends State<OptionsBottomSheet> {
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 0.0),
            title: const Text(
              "建立新的承諾合約",
              style: TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                border: Border.all(color: ColorSet.textColor, width: 2),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: ColorSet.textColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "你要新增什麼類型的合約呢？",
            style: TextStyle(
                color: ColorSet.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: const BorderSide(
                  color: ColorSet.textColor,
                ),
                backgroundColor: (_type == "運動")
                    ? ColorSet.backgroundColor
                    : ColorSet.backgroundColor,
              ),
              onPressed: () async {
                //檢查是否有運動合約
                bool hasWorkoutContract = await ContractDB.getWorkout() != null;
                if (hasWorkoutContract) {
                  if (!mounted) return;
                  InformDialog().get(context, "警告！", "已建立過運動合約，不允許二次投入").show();
                } else {
                  _selectType("運動");
                }
              },
              child: const Text(
                "運動",
                style: TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: const BorderSide(
                  color: ColorSet.textColor,
                ),
                backgroundColor: (_type == "冥想")
                    ? ColorSet.backgroundColor
                    : ColorSet.backgroundColor,
              ),
              onPressed: () async {
                //檢查是否有冥想合約
                bool hasMeditationContract =
                    await ContractDB.getMeditation() != null;
                if (hasMeditationContract) {
                  if (!mounted) return;
                  InformDialog().get(context, "警告！", "已建立過冥想合約，不允許二次投入").show();
                } else {
                  _selectType("冥想");
                }
              },
              child: const Text(
                "冥想",
                style: TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 16,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 15.0),
          const Text(
            "你想選擇哪種方案？",
            style: TextStyle(
                color: ColorSet.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _getPlanBtnList(),
          ),
          const SizedBox(height: 15.0),
          const Text(
            "你想投入多少金額呢？",
            style: TextStyle(
                color: ColorSet.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: ListView(
                scrollDirection: Axis.horizontal, children: _getMoneyBtnList()),
          ),
          const SizedBox(
            height: 20,
          ),
          processing
              ? const CircularProgressIndicator()
              : Container(
                  padding: const EdgeInsets.only(left: 20, right: 18),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      backgroundColor: ColorSet.backgroundColor,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _startContract();
                    },
                    child: const Text(
                      "確定",
                      style: TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  List<Widget> _getPlanBtnList() {
    List programList = ["基礎", "進階", "困難"];
    List<Widget> btnList = [];

    for (final program in programList) {
      String choice = program;
      btnList.add(OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(
            color: ColorSet.textColor,
          ),
          backgroundColor: (_plan == choice)
              ? ColorSet.backgroundColor
              : ColorSet.backgroundColor,
        ),
        onPressed: () {
          _selectPlan(choice);
        },
        child: Text(
          choice,
          style: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 16,
          ),
        ),
      ));
      btnList.add(const SizedBox(
        width: 10,
      ));
    }
    return btnList;
  }

  List<Widget> _getMoneyBtnList() {
    List moneyList = [100, 150, 200, 250, 300];
    List<Widget> btnList = [];

    for (final money in moneyList) {
      int choice = money;
      btnList.add(OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: const BorderSide(
            color: ColorSet.textColor,
          ),
          backgroundColor: (_money == choice)
              ? ColorSet.backgroundColor
              : ColorSet.backgroundColor,
        ),
        onPressed: () {
          _selectAmount(choice);
        },
        child: Text(
          "$choice",
          style: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 16,
          ),
        ),
      ));
      btnList.add(const SizedBox(
        width: 10,
      ));
    }
    return btnList;
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
          contractData["endDay"] = Calendar.dateToString(
              DateTime(startDay.year, startDay.month + 1, startDay.day));
          contractData["flag"] = "0, 3";
          break;
        case "進階":
          contractData["plan"] = "進階 (2月內達成7週目標)";
          contractData["endDay"] = Calendar.dateToString(
              DateTime(startDay.year, startDay.month + 2, startDay.day));
          contractData["flag"] = "0, 7";
          break;
        case "困難":
          contractData["plan"] = "困難 (4月內達成15週目標)";
          contractData["endDay"] = Calendar.dateToString(
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
    btnOkOnPress() async {
      ContractDB.update(contractData);
      Navigator.of(context).pop(true);
      setState(() {
        processing = true;
      });
      if (!mounted) return;
      Navigator.pushNamed(context, '/pay', arguments: {
        'user': user,
        'money': _money,
      });
    }

    ConfirmDialog()
        .get(context, "確認執行動作", "一旦執行動作後就無法進行修改或刪除。您確定要繼續嗎？", btnOkOnPress)
        .show();
  }
}
