import 'package:flutter/material.dart';

class PayPage extends StatefulWidget {
  final Map arguments;

  const PayPage({super.key, required this.arguments});

  @override
  PayPageState createState() => PayPageState();
}

enum Card { ctbc, cube }

// #23B91A: green
class PayPageState extends State<PayPage> {
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
    return Scaffold(
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
            onPressed: () {},
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
                  leading: const CircleAvatar(
                    radius: 48, // Image radius
                    // TODO: 頭貼上有個藍色認證勾勾?
                    backgroundImage: NetworkImage(
                        "https://pokoloruj.com.pl/static/gallery/gwiazdy-pop/yr3ylitu.png"),
                  ),
                  trailing: const Icon(Icons.info_outline_rounded),
                  title: Text("${widget.arguments['user'].displayName} 正在付款。"),
                  subtitle: Text('請在${getPayTime()}前完成付款。'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CompanyDescriptionItem(value: "150"),
                // TODO: get contract value
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PayByPointItem(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: const Column(
              children: <Widget>[
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
        color: Color(0xFF23B91A),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF23B91A),
            minimumSize: const Size.fromHeight(55), // NEW
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/pay/password');
          },
          child: const Text(
            '支付NT\$ 150', // TODO: get contract value
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class PasswordPage extends StatefulWidget {
  final Map arguments;

  const PasswordPage({super.key, required this.arguments});

  @override
  PasswordPageState createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class ConfirmPage extends StatefulWidget {
  final Map arguments;

  const ConfirmPage({super.key, required this.arguments});

  @override
  ConfirmPageState createState() => ConfirmPageState();
}

class ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
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
                child: Image.asset('assets/images/Logo.jpg'),
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
                    "懶蟲運動科技公司",
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  const Text(
                    "懶蟲們，一起運動吧！",
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
                // TODO: 和輸入的點數數字同步更新
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

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    super.key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final Card groupValue;
  final Card value;
  final ValueChanged<Card> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<Card>(
              groupValue: groupValue,
              value: value,
              onChanged: (Card? newValue) {
                onChanged(newValue!);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

// Point List Item
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
