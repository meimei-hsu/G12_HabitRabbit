import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:g12/services/Database.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class FirstContractPage extends StatefulWidget {
  const FirstContractPage({super.key, required arguments});

  @override
  _FirstContractPage createState() => _FirstContractPage();
}

final BorderRadius _borderRadius = const BorderRadius.only(
  topLeft: Radius.circular(25),
  topRight: Radius.circular(25),
);

ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
  topLeft: Radius.circular(25),
  topRight: Radius.circular(25),
));
SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.pinned;
EdgeInsets padding = EdgeInsets.zero;

int _selectedItemPosition = 2;
SnakeShape snakeShape = SnakeShape.circle;

bool showSelectedLabels = false;
bool showUnselectedLabels = false;

Color selectedColor = Colors.black;
Color unselectedColor = Colors.blueGrey;

Gradient selectedGradient =
    const LinearGradient(colors: [Colors.red, Colors.amber]);
Gradient unselectedGradient =
    const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

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
          child: Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(left: 25.0, right: 25.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF98D98E),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dialogs[tapCount],
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFFFDFDFD),
                          ),
                        ),
                        if (tapCount == 2) ...[
                          SizedBox(height: 16.0),
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
                                    primary: Color(0xFFFDFDFD),
                                    onPrimary: Color(0xFF98D98E),
                                  ),
                                  child: Text('確定！我要挑戰'),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: 回到主頁
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFDFDFD),
                                    onPrimary: Color(0xFF98D98E),
                                  ),
                                  child: Text('先不要...謝謝再連絡'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (tapCount == 3) ...[
                          SizedBox(height: 16.0),
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
                                    primary: Color(0xFFFDFDFD),
                                    onPrimary: Color(0xFF98D98E),
                                  ),
                                  child: Text('運動'),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    tapCount++;
                                    type = '冥想';
                                    print('選擇的合約類型：$type');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFFDFDFD),
                                    onPrimary: Color(0xFF98D98E),
                                  ),
                                  child: Text('冥想'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (tapCount == 4) ...[
                          SizedBox(height: 16.0),
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
                                  primary: Color(0xFFFDFDFD),
                                  onPrimary: Color(0xFF98D98E),
                                ),
                                child: Text('基礎：一個月內至少達成3週目標'),
                              ),
                              SizedBox(height: 4.0),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    tapCount++;
                                    plan = '進階';
                                    print('選擇的合約方案：$plan');
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFDFDFD),
                                  onPrimary: Color(0xFF98D98E),
                                ),
                                child: Text('進階：兩個月內至少達成7週目標'),
                              ),
                              SizedBox(height: 4.0),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    tapCount++;
                                    plan = '困難';
                                    print('選擇的合約方案：$plan');
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFDFDFD),
                                  onPrimary: Color(0xFF98D98E),
                                ),
                                child: Text('困難：四個月內至少達成15週目標'),
                              ),
                            ],
                          ),
                        ],
                        if (tapCount == 5) ...[
                          Container(
                            width: 230.0,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  inputAmount = value;
                                });
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '輸入金額',
                                labelStyle: TextStyle(
                                  color: Color(0xFFFDFDFD), // 设置标签文本的颜色为特定颜色
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                String value = inputAmount;
                                print('投入金額：$value');
                                Map<String, String> contractData = {
                                  'type': type,
                                  'plan': plan,
                                  'amount': value
                                };
                                print(contractData);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SecondContractPage(contractData: contractData),
                                  ),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFDFDFD),
                              onPrimary: Color(0xFF98D98E),
                            ),
                            child: Text('確定'),
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
                    'assets/images/personality_S₁GS₂.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: snakeBarStyle,
          snakeShape: snakeShape,
          shape: bottomBarShape,
          padding: padding,
          height: 80,
          //backgroundColor: const Color(0xfffdeed9),
          backgroundColor: const Color(0xffd4d6fc),
          snakeViewColor: const Color(0xfffdfdf5),
          selectedItemColor: const Color(0xff4b3d70),
          unselectedItemColor: const Color(0xff4b3d70),

          ///configuration for SnakeNavigationBar.color
          // snakeViewColor: selectedColor,
          // selectedItemColor:
          //  snakeShape == SnakeShape.indicator ? selectedColor : null,
          //unselectedItemColor: Colors.blueGrey,

          ///configuration for SnakeNavigationBar.gradient
          //snakeViewGradient: selectedGradient,
          //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
          //unselectedItemGradient: unselectedGradient,

          showUnselectedLabels: showUnselectedLabels,
          showSelectedLabels: showSelectedLabels,

          currentIndex: _selectedItemPosition,
          //onTap: (index) => setState(() => _selectedItemPosition = index),
          onTap: (index) {
            _selectedItemPosition = index;
            if (index == 0) {
              Navigator.pushNamed(context, '/statistic',
                  arguments: {'user': user});
            }
            if (index == 1) {
              Navigator.pushNamed(context, '/milestone',
                  arguments: {'user': user});
            }
            if (index == 2) {
              Navigator.pushNamed(context, '/', arguments: {'user': user});
            }
            if (index == 3) {
              Navigator.pushNamed(context, '/contract/initial',
                  arguments: {'user': user});
            }
            //3
            if (index == 4) {
              Navigator.pushNamed(context, '/settings',
                  arguments: {'user': user});
            }
            print(index);
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.insights,
                  size: 40,
                ),
                label: 'tickets'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.workspace_premium_outlined,
                  size: 40,
                ),
                label: 'calendar'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 40,
                ),
                label: 'home'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.request_quote_outlined,
                  size: 40,
                ),
                label: 'microphone'),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.manage_accounts_outlined,
                  size: 40,
                ),
                label: 'search')
          ],
        ));
  }
}

class SecondContractPage extends StatefulWidget {
  //final Map arguments;
  final Map<String, String> contractData;
  SecondContractPage({required this.contractData});

  //const SecondContractPage({super.key, required this.arguments});

  @override
  SecondContractPageState createState() => SecondContractPageState();
}

class SecondContractPageState extends State<SecondContractPage> {
  Map flagToPlan = {"4": "5 週 4 旗", "8": "12 週 8 旗", "12": "18 週 12 旗"};

  @override
  Widget build(BuildContext context) {
    String? type = widget.contractData['type'];
    String? plan = widget.contractData['plan'];
    String? amount = widget.contractData['amount'];

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
      body: Container(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 25.0, right: 25.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Color(0xFF98D98E),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '立契約人  ' //TODO: 使用者名稱
                          '\n於約定期間積極養成  $type  習慣'
                          '\n選擇方案為  $plan'
                          '\n投入金額為  $amount  元'
                          '\n\n若未達成設定目標，立契約人同意將投入金額全數捐出；'
                          '若達成設定目標則由系統將全數金額退還。',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFFFDFDFD),
                      ),
                    ),
                    SizedBox(height: 16.0),
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
                                    title: Text('確定要執行嗎？'),
                                    content: Text('確認後將無法取消或進行修改'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // TODO: 跳到 LINEPay
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFFDFDFD),
                                          onPrimary: Color(0xFF98D98E),
                                        ),
                                        child: Text('確定'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFFDFDFD),
                                          onPrimary: Color(0xFF98D98E),
                                        ),
                                        child: Text('取消'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFDFDFD),
                              onPrimary: Color(0xFF98D98E),
                            ),
                            child: Text('確定'),
                          ),
                          SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FirstContractPage(),
                                  ),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFDFDFD),
                              onPrimary: Color(0xFF98D98E),
                            ),
                            child: Text('取消/重新輸入'),
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
                'assets/images/personality_S₁GS₂.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
