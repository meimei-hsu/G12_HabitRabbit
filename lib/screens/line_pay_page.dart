import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';

import '../services/database.dart';
import '../services/page_data.dart';

// Define global variables for LinePayPage
Map contract = {};
String userName = "", money = "";

class PayPage extends StatefulWidget {
  final Map arguments;

  const PayPage({super.key, required this.arguments});

  @override
  PayPageState createState() => PayPageState();
}

enum Card { ctbc, cube }

// #23B91A: green
class PayPageState extends State<PayPage> {
  @override
  void initState() {
    super.initState();
    contract = widget.arguments['contract'];
    userName = Data.profile!["userName"];
    money = contract['money'].toString();
  }

  String getPayTime() {
    DateTime now = DateTime.now();
    String hour = now.hour < 12 ? "上午${now.hour}" : "下午${now.hour - 12}";
    String minute =
        now.minute + 5 < 10 ? "0${now.minute + 5}" : "${now.minute + 5}";
    return "$hour:$minute";
  }

  Card _card = Card.ctbc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Text(
          "LINE Pay",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xff343434),
              fontSize: 26,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xff343434),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: const Color(0xfffdfdfd),
        automaticallyImplyLeading: false, //關掉返回鍵
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    radius: 48, // Image radius
                    backgroundColor: Colors.transparent,
                    // TODO: 頭貼上有個藍色認證勾勾?
                    backgroundImage: AssetImage(Data.characterImageURL
                        .replaceAll(RegExp(r'.png'), "_head.png")),
                  ),
                  trailing: const Icon(Icons.info_outline_rounded),
                  title: Text("$userName 正在付款。"),
                  subtitle: Text('請在${getPayTime()}前完成付款。'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CompanyDescriptionItem(value: money),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                PayByPointItem(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: Column(
              children: const <Widget>[
                ListTile(
                  title: Text(
                    "付款方法",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                  visualDensity: VisualDensity(vertical: -3),
                ),
                Divider(
                  height: 1,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PayMethodItem(
                  label: '8529 中信',
                  value: Card.ctbc,
                  groupValue: _card,
                  onChanged: (Card? newValue) {
                    setState(() {
                      _card = newValue!;
                    });
                  },
                ),
                const Divider(
                  height: 1,
                ),
                PayMethodItem(
                  label: '8726 國泰',
                  value: Card.cube,
                  groupValue: _card,
                  onChanged: (Card? newValue) {
                    setState(() {
                      _card = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "可使用的卡片",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Image.asset('assets/images/visa.png'),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0)),
                      Image.asset('assets/images/mastercard.png'),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0)),
                      Image.asset('assets/images/jcb.png')
                    ],
                  ),
                  // TODO: 調整圖片大小
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                  visualDensity: const VisualDensity(vertical: -3),
                  trailing: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text(
                      "新增信用卡",
                      style: TextStyle(
                        color: Color(0xFFA0A9B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF23B91A),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF23B91A),
            minimumSize: const Size.fromHeight(55), // NEW
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/pay/password');
          },
          child: Text(
            '支付NT\$ $money',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ));
  }
}

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  PasswordPageState createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  String pinCode = "";
  final pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  onKeyboardTap(String value) {
    setState(() {
      pinCode = pinCode + value;
      pinCodeController.text = pinCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xff343434),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: Colors.grey[50],
        automaticallyImplyLeading: false, //關掉返回鍵
      ),
      body: SafeArea(
          child: Center(
              child: Column(children: [
        const Spacer(),
        const Text(
          "Line Pay 密碼",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 10),
        const Text("請輸入您的 Line Pay 密碼。", style: TextStyle(color: Colors.grey)),
        const Spacer(),
        Container(
          color: Colors.white,
          margin: const EdgeInsets.only(left: 20, right: 20),
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                PinCodeFields(
                  length: 6,
                  obscureText: true,
                  obscureCharacter: "🔴",
                  textStyle: const TextStyle(color: Color(0xFF23B91A)),
                  // FIXME: didn't change color, but it's enable when setting obscureText==false
                  borderColor: const Color(0xFFA0A9B8),
                  keyboardType: TextInputType.number,
                  controller: pinCodeController,
                  onComplete: (text) {
                    pinCodeController.clear();
                    Navigator.popAndPushNamed(context, '/pay/checkout');
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "忘記密碼？",
          style: TextStyle(color: Colors.grey),
        ),
        const Spacer(),
        Container(
          color: Colors.white,
          child: NumericKeyboard(
              onKeyboardTap: onKeyboardTap,
              textStyle: const TextStyle(
                  color: Color(0xFFA0A9B8),
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
              rightButtonFn: () {
                if (pinCode.isEmpty) return;
                setState(() {
                  pinCode = pinCode.substring(0, pinCode.length - 1);
                  pinCodeController.text = pinCode;
                });
              },
              rightButtonLongPressFn: () {
                if (pinCode.isEmpty) return;
                setState(() {
                  pinCode = '';
                  pinCodeController.text = pinCode;
                });
              },
              rightIcon: const Icon(
                Icons.backspace_outlined,
                color: Colors.blueGrey,
              ),
              mainAxisAlignment: MainAxisAlignment.spaceBetween),
        ),
      ]))),
    ));
  }
}

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  ConfirmPageState createState() => ConfirmPageState();
}

class ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: const Text(
          "LINE Pay",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xff343434),
              fontSize: 26,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Color(0xff343434),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: Colors.grey[50],
        automaticallyImplyLeading: false, //關掉返回鍵
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    "商家",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "習慣兔科技公司",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  visualDensity: VisualDensity(vertical: -4),
                ),
                const ListTile(
                  title: Text(
                    "商品",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "習慣兔，你的專屬習慣Tool！",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  visualDensity: VisualDensity(vertical: -4),
                ),
                ListTile(
                  title: const Text(
                    "付款方法",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                text:
                                    " • • • •  • • • •  • • • • 8529(熊大黑卡/中國\n信託)",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            WidgetSpan(
                              child: Image.asset('assets/images/visa.png'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  visualDensity: const VisualDensity(vertical: 2),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 18.0, end: 18.0),
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "商品價格",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "NT\$ $money",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(
                          start: 18.0, end: 18.0),
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text(
                    "實際支付金額",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "NT\$ $money",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  visualDensity: const VisualDensity(vertical: -4),
                ),
                const SizedBox(height: 15),
                Container(
                  margin:
                      const EdgeInsetsDirectional.only(start: 18.0, end: 18.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA0A9B8),
                            shadowColor: Colors.white,
                            minimumSize: const Size(0, 45)),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "取消",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF23B91A),
                              shadowColor: Colors.white,
                              minimumSize: const Size(0, 45)),
                          onPressed: () async {
                            await ContractDB.update(contract);
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/contract/already', ModalRoute.withName('/'));
                          },
                          child: const Text(
                            "付款",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text("點選按鍵開始進行。", style: TextStyle(color: Colors.grey)),
          const Text("請在訂單頁面中確認結果。", style: TextStyle(color: Colors.grey)),
        ],
      ),
    ));
  }
}

// Company Description List Item
class CompanyDescriptionItem extends StatelessWidget {
  const CompanyDescriptionItem({
    super.key,
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(48), // Image radius
                child: Image.asset('assets/images/Logo.png'),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "習慣兔科技公司",
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  const Text(
                    "習慣兔，你的專屬習慣Tool！",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  const Text(
                    "使用中信LINE Pay卡付款，最多可累積 1% 的 LINE Points點數！",
                    style: TextStyle(fontSize: 10.0, color: Colors.red),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  Text(
                    "NT\$ $value",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Point List Item
class PayByPointItem extends StatelessWidget {
  const PayByPointItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: "以點數支付 ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      WidgetSpan(
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: Color(0xFFA0A9B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text("0", style: TextStyle(fontSize: 16))
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: TextEditingController(text: "NT\$ 0"),
                  decoration: const InputDecoration(
                    isDense: true,
                    // Added this
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x19A0A9B8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFA0A9B8),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  cursorColor: const Color(0xFF23B91A),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF23B91A),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA0A9B8),
                      shadowColor: Colors.white),
                  onPressed: () {},
                  child: const Text(
                    "全部使用",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

// Pay Method Item
class PayMethodItem extends StatelessWidget {
  const PayMethodItem({
    super.key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final Card groupValue;
  final Card value;
  final ValueChanged<Card> onChanged;

  //final Card _card = Card.ctbc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (value != groupValue) {
            onChanged(value);
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 15.0, 0.0, 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Radio<Card>(
                value: value,
                groupValue: groupValue,
                onChanged: (Card? newValue) {
                  onChanged(newValue!);
                },
                activeColor: const Color(0xFF23B91A),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "信用卡",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                    Row(children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0)),
                      Container(
                        height: 16,
                        width: 20,
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black12),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                        child: Image.asset('assets/images/visa.png'),
                      ),
                    ])
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
