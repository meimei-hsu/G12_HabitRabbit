import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/screens/register_page.dart';
import 'package:g12/services/database.dart';
import 'package:g12/services/page_data.dart';

// Define global variables for ContractPage
Map newContract = {
  "type": "",
  "content": "",
  "startDay": Calendar.dateToString(DateTime.now()),
  "endDay": "",
  "money": 0,
  "bankAccount": 85167880032579,
  "gem": "",
  "succeed": false,
};

class FirstContractPage extends StatefulWidget {
  const FirstContractPage({super.key, required arguments});

  @override
  FirstContractPageState createState() => FirstContractPageState();
}

class FirstContractPageState extends State<FirstContractPage> {
  GlobalKey<FormState> moneyFormKey = GlobalKey<FormState>();

  int tapCount = 0;
  final DateTime startDay = DateTime.now();
  final List<String> dialogs = [
    '承諾合約協助您養成習慣',
    '您可以在根據自己的情況選擇不同的條款。'
        '一旦契約開始執行，將無法取消或更改內容，直到完成您設定的目標。'
        '\n契約簽訂前，您需要先投入一筆保證金。'
        '如未能成功實現目標，該筆資金將全數捐至慈善機構；'
        '如您能成功實現目標，則將退還原款，並獎勵 3% 現金回饋。',
    '是否確認投入合約？',
    '請點選您想要投入類型：',
    '請點選您想要投入方案：',
    '您要投入多少金錢督促自己：',
  ];

  @override
  void initState() {
    super.initState();
    if (GameData.contracts.isNotEmpty) {
      tapCount = 4;
      newContract["type"] = GameData.lastContractZH;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.backgroundColor,
      resizeToAvoidBottomInset: false,
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
        onTap: () {
          setState(() {
            // 除了說明頁(p.0~1)，其他都需要選擇選項才能跳下一頁
            if (tapCount < 2) {
              tapCount++;
            }
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpeechBalloon(
                  color: ColorSet.backgroundColor,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.4,
                  nipLocation: NipLocation.bottom,
                  nipHeight: 30,
                  borderColor: ColorSet.borderColor,
                  borderRadius: 20,
                  borderWidth: 8,
                  child: Center(
                      child: Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dialogs[tapCount],
                          style: TextStyle(
                              fontSize: 21.0,
                              color: ColorSet.textColor,
                              fontWeight:
                                  (tapCount != 1) ? FontWeight.bold : null),
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
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  backgroundColor: ColorSet.bottomBarColor,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                                  padding: const EdgeInsets.only(left: 10),
                                  backgroundColor: ColorSet.buttonColor,
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
                                    newContract["type"] = '運動'; // 賦值给type字段
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
                                    newContract["type"] = '冥想';
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
                                    newContract["content"] = "基礎 (1月內達成3週目標)";
                                    newContract["endDay"] =
                                        Calendar.dateToString(DateTime(
                                            startDay.year,
                                            startDay.month + 1,
                                            startDay.day));
                                    newContract["gem"] = "0, 3";
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
                                    newContract["content"] = "進階 (2月內達成7週目標)";
                                    newContract["endDay"] =
                                        Calendar.dateToString(DateTime(
                                            startDay.year,
                                            startDay.month + 2,
                                            startDay.day));
                                    newContract["gem"] = "0, 7";
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
                                    newContract["content"] = "困難 (4月內達成15週目標)";
                                    newContract["endDay"] =
                                        Calendar.dateToString(DateTime(
                                            startDay.year,
                                            startDay.month + 4,
                                            startDay.day));
                                    newContract["gem"] = "0, 15";
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
                          Form(
                              key: moneyFormKey,
                              child: Column(children: [
                                const SizedBox(height: 15.0),
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      // TODO: validator context
                                      if (value == null || value.isEmpty) {
                                        return "請輸入金額！";
                                      } else if (double.parse(value) == 0) {
                                        return "金額不得為 0！";
                                      } else if (double.parse(value) < 100) {
                                        return "金額最低需為 100！";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
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
                                      labelStyle: const TextStyle(
                                          color: ColorSet.textColor),
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      errorStyle: const TextStyle(
                                          height: 1,
                                          color: ColorSet.errorColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      errorMaxLines: 1,
                                      filled: true,
                                      fillColor: ColorSet.backgroundColor,
                                    ),
                                    cursorColor: ColorSet.errorColor,
                                    style: const TextStyle(
                                      color: ColorSet.textColor,
                                      fontSize: 17,
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        newContract["money"] = int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 50, right: 50),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      backgroundColor: ColorSet.bottomBarColor,
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      minimumSize: const Size.fromHeight(40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      moneyFormKey.currentState?.save();

                                      if (moneyFormKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SecondContractPage()),
                                              ModalRoute.withName('/'));
                                        });
                                      }
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
                              ]))
                        ],
                      ],
                    ),
                  ))),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Contract.gif',
                      width: MediaQuery.of(context).size.width * 0.85,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        resizeToAvoidBottomInset: false,
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpeechBalloon(
                color: ColorSet.backgroundColor,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                nipLocation: NipLocation.bottom,
                nipHeight: 30,
                borderColor: ColorSet.borderColor,
                borderRadius: 20,
                borderWidth: 8,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          '立契約人於約定期間積極養成  ${newContract["type"]}  習慣'
                          '\n選擇方案為  ${newContract["content"]}'
                          '\n投入金額為  ${newContract["money"]}  元'
                          '\n\n若未達成設定目標，立契約人同意將投入金額全數捐至慈善機構；'
                          '若達成設定目標，本公司同意以 103% 的比例退還立契約人之款項。',
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: ColorSet.textColor,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  backgroundColor: ColorSet.bottomBarColor,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/contract/initial',
                                      ModalRoute.withName('/'));
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
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  backgroundColor: ColorSet.buttonColor,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  btnOkOnPress() async {
                                    Navigator.pushNamed(context, '/pay',
                                        arguments: {
                                          'contract': newContract,
                                        });
                                  }

                                  ConfirmDialog()
                                      .get(context, '提示:)',
                                          "確定後無法進行修改或刪除，請深思熟慮", btnOkOnPress)
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
                        //),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/Rabbit_2.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
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
    viewportFraction: 0.85,
  );

  void refresh() async {
    if (Data.updatingDB || Data.updatingUI[1]) await GameData.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    refresh();
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    for (Map data in GameData.contracts)
                      Container(
                        padding:
                            const EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: ColorSet.backgroundColor,
                            border: Border.all(
                                color: ColorSet.borderColor, width: 4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '立契約人將依照選擇之方案來養成各項習慣，'
                                '如未能成功實現目標，Habit Rabbit 將把投入的資金全部捐出；'
                                '如您成功實現了目標，Habit Rabbit 將退還原款，並獎勵 3% 現金回饋。\n'
                                '\n您選擇養成的習慣：${data["type"]}'
                                '\n您選擇的方案：${data["content"]}'
                                '\n您所投入的金額：${data["money"]}\n'
                                '\n合約開始日：${data["startDay"]}'
                                '\n合約結束日：${data["endDay"]}'
                                '\n距離成功已完成：${Calculator.calcProgress(data["gem"]).round()}%',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  letterSpacing: 1.2,
                                  color: ColorSet.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    /*Container(
                      //padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
                      padding: const EdgeInsets.only(
                        top: 20,
                        //bottom: 250,
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: ColorSet.backgroundColor,
                          border:
                              Border.all(color: ColorSet.borderColor, width: 4),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
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
                                    '\n您選擇的方案：${data["content"]}'
                                    '\n您所投入的金額：${data["money"]}\n'
                                    '\n合約開始日：${data["startDay"]}'
                                    '\n合約結束日：${data["endDay"]}'
                                    '\n距離成功已完成：${Calculator.calcProgress(data["gem"])}%',
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
                    ),*/
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                        backgroundColor: ColorSet.buttonColor,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        /*Future<Map<String, dynamic>?> futureContract =
                            ContractDB.getContract();
                        futureContract.then((data) {
                          bool workoutContractExists =
                              data!.containsKey("workout");
                          bool meditationContractExists =
                              data.containsKey("meditation");

                          if (workoutContractExists &&
                              meditationContractExists) {
                            // Show the dialog message for one second and then hide it
                            ErrorDialog()
                                .get(context, "無法新增:(", "每種類型合約僅能建立一次！")
                                .show();
                          } else {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                ),
                                backgroundColor: ColorSet.bottomBarColor,
                                context: context,
                                builder: (context) {
                                  return const OptionsBottomSheet();
                                });
                          }*/
                        if (GameData.contracts.length == 2) {
                          // Show the dialog message for one second and then hide it
                          ErrorDialog()
                              .get(context, "無法新增:(", "每種類型合約僅能建立一次！")
                              .show();
                        } else {
                          ConfirmDialog()
                              .get(
                                  context,
                                  "新增合約",
                                  "是否確認新增${GameData.lastContractZH}合約？",
                                  () => Navigator.pushNamed(
                                      context, '/contract/initial'))
                              .show();
                        }
                      },
                      child: const Text(
                        '新增合約！',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: ColorSet.textColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Image.asset(
                      'assets/images/Rabbit_2.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ],
                ),
              ),
              /*Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Image.asset(
              'assets/images/Rabbit_2.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),*/
            ],
          ),
        ));
  }
}

/*class OptionsBottomSheet extends StatefulWidget {
  const OptionsBottomSheet({super.key});

  @override
  OptionsBottomSheetState createState() => OptionsBottomSheetState();
}

class OptionsBottomSheetState extends State<OptionsBottomSheet> {
  GlobalKey<FormState> moneyFormKey = GlobalKey<FormState>();

  String? _type;
  String? _content;
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
        _content = contractData["content"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: moneyFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: ColorSet.iconColor,
                    ),
                    tooltip: "關閉",
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
                        ? ColorSet.exerciseColor
                        : ColorSet.backgroundColor,
                  ),
                  onPressed: () async {
                    //檢查是否有運動合約
                    bool hasWorkoutContract =
                        await ContractDB.getWorkout() != null;
                    if (hasWorkoutContract) {
                      if (!mounted) return;
                      ErrorDialog()
                          .get(context, "警告！", "已建立過運動合約，不允許二次投入")
                          .show();
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
                        ? ColorSet.meditationColor
                        : ColorSet.backgroundColor,
                  ),
                  onPressed: () async {
                    //檢查是否有冥想合約
                    bool hasMeditationContract =
                        await ContractDB.getMeditation() != null;
                    if (hasMeditationContract) {
                      if (!mounted) return;
                      ErrorDialog()
                          .get(context, "警告！", "已建立過冥想合約，不允許二次投入")
                          .show();
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
              const SizedBox(height: 10.0),
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
              const SizedBox(height: 10.0),
              const Text(
                "你想投入多少金額呢？",
                style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: TextFormField(
                  validator: (value) {
                    // TODO: validator context
                    if (value == null || value.isEmpty) {
                      return "請輸入金額！";
                    } else if (double.parse(value) == 0) {
                      return "金額不得為 0！";
                    } else if (double.parse(value) < 100) {
                      return "金額最低需為 100！";
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
                    labelStyle: const TextStyle(color: ColorSet.textColor),
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorStyle: const TextStyle(
                        height: 1,
                        color: ColorSet.errorColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    errorMaxLines: 1,
                    filled: true,
                    fillColor: ColorSet.backgroundColor,
                  ),
                  cursorColor: ColorSet.errorColor,
                  style: const TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 17,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      newContract["money"] = int.parse(value);
                    });
                  },
                ),
              ),
              /*SizedBox(
            height: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: ListView(
                scrollDirection: Axis.horizontal, children: _getMoneyBtnList()),
          ),*/
              const SizedBox(
                height: 10,
              ),
              processing
                  ? const CircularProgressIndicator()
                  : Container(
                      padding: const EdgeInsets.only(left: 20, right: 18),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          backgroundColor: ColorSet.backgroundColor,
                          shadowColor: ColorSet.borderColor,
                          //elevation: 0,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          moneyFormKey.currentState?.save();

                          if (moneyFormKey.currentState!.validate()) {
                            _startContract();
                          }
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
                height: 20,
              ),
            ],
          ),
        ));
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
          backgroundColor: (_content == choice)
              ? (_type == "運動")
                  ? ColorSet.exerciseColor
                  : ColorSet.meditationColor
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

  _selectType(String t) {
    setState(() {
      _type = t;
      newContract["type"] = t;
    });
  }

  _selectPlan(String p) {
    setState(() {
      _content = p;
      DateTime startDay = DateTime.now();
      switch (p) {
        case "基礎":
          newContract["content"] = "基礎 (1月內達成3週目標)";
          newContract["endDay"] = Calendar.dateToString(
              DateTime(startDay.year, startDay.month + 1, startDay.day));
          newContract["gem"] = "0, 3";
          break;
        case "進階":
          newContract["content"] = "進階 (2月內達成7週目標)";
          newContract["endDay"] = Calendar.dateToString(
              DateTime(startDay.year, startDay.month + 2, startDay.day));
          newContract["gem"] = "0, 7";
          break;
        case "困難":
          newContract["content"] = "困難 (4月內達成15週目標)";
          newContract["endDay"] = Calendar.dateToString(
              DateTime(startDay.year, startDay.month + 4, startDay.day));
          newContract["gem"] = "0, 15";
          break;
      }
    });
  }

  void _startContract() async {
    btnOkOnPress() async {
      // ContractDB.update(contractData);
      Navigator.of(context).pop(true);
      setState(() {
        processing = true;
      });
      if (!mounted) return;
      Navigator.pushNamed(context, '/pay', arguments: {
        'user': Data.profile!["userName"],
        'money': newContract["money"],
      });
    }

    ConfirmDialog()
        .get(context, "提示", "確定後無法進行修改或刪除，請深思熟慮", btnOkOnPress)
        .show();
  }
}*/
