import 'package:flutter/material.dart';

import 'package:g12/services/Database.dart';
import 'package:g12/services/PlanAlgo.dart';

class FirstPage extends StatefulWidget {
  final Map arguments;

  const FirstPage({super.key, required this.arguments});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '問卷介面',
          style: TextStyle(
              color: Color(0xFF0D3B66),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        backgroundColor: Color(0xFFFAF0CA),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 200),
              child: Text(
                '第一部分共14道題，問題將分成：\n\n'
                '1.基本資訊\n2.運動習慣偏好調查\n3.現階段運動能力及未來目標\n\n'
                '共三個部分，\n每道題目均為必填，\n請依據個人狀況回來問題。\n',
                style: TextStyle(
                  color: Color(0xFF0D3B66),
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    child: Text(
                      "開始作答",
                      style: TextStyle(
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFA493),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/questionnaire/2",
                          arguments: {'user': widget.arguments['user']});
                      },
                  ),
                )
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  final Map arguments;

  const SecondPage({super.key, required this.arguments});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String gender = "";
  DateTime? selectedDateTime;
  TextEditingController heightController = TextEditingController();
  String height = "";
  TextEditingController weightController = TextEditingController();
  String weight = "";

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Part1：基本資訊',
            style: TextStyle(
              color: Color(0xFF0D3B66),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Color(0xFFFAF0CA),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //第一題
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(left:20),
                  child: Text(
                    '1. 您的性別',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: "男",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("男",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                      ),
                      Radio<String>(
                        value: "女",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("女",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                      ),
                      Radio<String>(
                        value: "其他",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("其他",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 380,
                    child: Divider(
                      color: Colors.black26,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //第二題
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        '2. 您的生日',
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 15),
                      ElevatedButton(
                        onPressed: () async {
                          var result = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900, 01),
                            lastDate: DateTime(2024, 01),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFFFFA493), // showDatePicker的主要顏色
                                    onPrimary: Colors.white, // showDatePicker主要顏色的文本顏色
                                  ),
                                ),
                                child: child ?? Container(),
                              );
                            },
                          );
                          if (result != null) {
                            setState(() {
                              selectedDateTime = result;
                            });
                          }
                        },
                        child: const Text('選擇',
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFA493),
                        ),
                      ),
                      SizedBox(width: 15),
                      if (selectedDateTime != null)
                        Text(
                          '\n ${selectedDateTime?.toString()?.substring(0, 10) ?? ""}',
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 18,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 380,
                    child: Divider(
                      color: Colors.black26,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //第三題
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '3. 您的身高',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Container(
                    width: 200,
                    child: TextField(
                      controller: heightController,
                      decoration: InputDecoration(
                        hintText: '請輸入您的身高(cm)',
                        hintStyle: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        height = value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 380,
                    child: Divider(
                      color: Colors.black26,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //第四題
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '4. 您的體重',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(left: 20),
                  child: Container(
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '請輸入您的體重(kg)',
                        hintStyle: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        weight = value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text(
                        "返回",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFA493),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(width: 20),
                    ElevatedButton(
                        child: Text(
                          "確定",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFA493),
                        ),
                        onPressed: () {
                          if (gender.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("性別選項未填"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("確定"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFA493),
                                        onPrimary: Color(0xFF0D3B66),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }else if(selectedDateTime == null){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("生日選項未填"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("確定"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFA493),
                                        onPrimary: Color(0xFF0D3B66),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }else if(height.isEmpty){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("身高選項未填"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("確定"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFA493),
                                        onPrimary: Color(0xFF0D3B66),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if(weight.isEmpty){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("體重選項未填"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("確定"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFA493),
                                        onPrimary: Color(0xFF0D3B66),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Map<String, dynamic> answers = {
                              'gender': gender,
                              'birthday': selectedDateTime.toString(),
                              'height': double.parse(height),
                              'weight': double.parse(weight),
                            };
                            print(answers);
                            Navigator.pushNamed(context, "/questionnaire/3",
                                arguments: {
                                  'user': widget.arguments['user'],
                                  'answers': answers
                                });
                          }
                        }),
                    SizedBox(height: 20),
                  ],
                ),
              ]),
        ));
  }
}

class ThirdPage extends StatefulWidget {
  final Map arguments;

  const ThirdPage({super.key, required this.arguments});

  @override
  _ThirdPage createState() => _ThirdPage();
}

class _ThirdPage extends State<ThirdPage> {
  String timeSpan = "";

  //設定沒有一天被選中
  bool anyDaySelected = false;
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;

  //設定沒有一種運動類型被選中
  bool LikingSelected = false;
  bool strengthLiking = false;
  bool cardioLiking = false;
  bool yogaLiking = false;
  bool noneLiking = false;

  bool? gym = false;
  bool? house = false;
  bool? outdoor = false;
  bool? other = false;
  bool? knee = false;
  bool? waist = false;
  bool? shoulder = false;
  bool? butt = false;
  bool? abd = false;
  bool none = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Part1：運動習慣偏好',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //第五題
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '5. 您希望一次運動安排多久時長',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: "15分鐘",
                        groupValue: timeSpan,
                        onChanged: (value) {
                          setState(() {
                            timeSpan = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("15分",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                      Radio<String>(
                        value: "30分鐘",
                        groupValue: timeSpan,
                        onChanged: (value) {
                          setState(() {
                            timeSpan = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("30分",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                      Radio<String>(
                        value: "45分鐘",
                        groupValue: timeSpan,
                        onChanged: (value) {
                          setState(() {
                            timeSpan = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("45分",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                      Radio<String>(
                        value: "60分鐘",
                        groupValue: timeSpan,
                        onChanged: (value) {
                          setState(() {
                            timeSpan = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("60分",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 380,
                    child: Divider(
                      color: Colors.black26,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //第六題
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '6. 未來的一個星期內有哪幾天有空運動',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        value: monday,
                        onChanged: (value) {
                          setState(() {
                            monday = value!;
                            anyDaySelected = monday || tuesday || wednesday || thursday || friday || saturday || sunday;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("星期一",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                      Checkbox(
                        value: tuesday,
                        onChanged: (value) {
                          setState(() {
                            tuesday = value!;
                            anyDaySelected = monday || tuesday || wednesday || thursday || friday || saturday || sunday;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("星期二",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                      Checkbox(
                        value: wednesday,
                        onChanged: (value) {
                          setState(() {
                            wednesday = value!;
                            anyDaySelected = monday || tuesday || wednesday || thursday || friday || saturday || sunday;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("星期三",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        ),
                      ),
                      Checkbox(
                        value: thursday,
                        onChanged: (value) {
                          setState(() {
                            thursday = value!;
                            anyDaySelected = monday || tuesday || wednesday || thursday || friday || saturday || sunday;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("星期四",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        value: friday,
                        onChanged: (value) {
                          setState(() {
                            friday = value!;
                            anyDaySelected = monday || tuesday || wednesday || thursday || friday || saturday || sunday;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("星期五",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                      Checkbox(
                        value: saturday,
                        onChanged: (value) {
                          setState(() {
                            saturday = value!;
                            anyDaySelected = monday || tuesday || wednesday || thursday || friday || saturday || sunday;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("星期六",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                      Checkbox(
                        value: sunday,
                        onChanged: (value) {
                          setState(() {
                            sunday = value!;
                            anyDaySelected = monday || tuesday || wednesday || thursday || friday || saturday || sunday;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("星期日",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                            fontSize: 15,
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 380,
                    child: Divider(
                      color: Colors.black26,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //第七題
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '7. 您喜歡什麼樣類型的運動',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child:
                  Row(
                    children: [
                      Checkbox(
                        value: strengthLiking,
                        onChanged: (value) {
                          setState(() {
                            strengthLiking = value!;
                            LikingSelected = strengthLiking || cardioLiking || yogaLiking || noneLiking;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("肌耐力訓練 ex.重量訓練",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        value: cardioLiking,
                        onChanged: (value) {
                          setState(() {
                            cardioLiking = value!;
                            LikingSelected = strengthLiking || cardioLiking || yogaLiking || noneLiking;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("有氧訓練 ex.有氧舞蹈、慢跑等",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child:
                  Row(
                    children: [
                      Checkbox(
                        value: yogaLiking,
                        onChanged: (value) {
                          setState(() {
                            yogaLiking = value!;
                            LikingSelected = strengthLiking || cardioLiking || yogaLiking || noneLiking;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("伸展運動 ex.瑜珈",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        value: noneLiking,
                        onChanged: (value) {
                          setState(() {
                            noneLiking = value!;
                            LikingSelected = strengthLiking || cardioLiking || yogaLiking || noneLiking;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("我沒有任何偏好",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 380,
                    child: Divider(
                      color: Colors.black26,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //第八題
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '8. 您喜歡在下列何情況進行運動',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(// 每行之間的間距
                    children: [
                      Checkbox(
                        value: gym,
                        onChanged: (bool? value) {
                          setState(() {
                            gym = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("健身房",
                          style: TextStyle(
                              color: Color(0xFF0D3B66),
                              fontSize: 15)
                      ),
                      Checkbox(
                        value: house,
                        onChanged: (bool? value) {
                          setState(() {
                            house = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("家裡",
                          style: TextStyle(
                              color: Color(0xFF0D3B66),
                              fontSize: 15
                          )
                      ),
                      Checkbox(
                        value: outdoor,
                        onChanged: (bool? value) {
                          setState(() {
                            outdoor = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("戶外",
                          style: TextStyle(
                              color: Color(0xFF0D3B66),
                              fontSize: 15
                          )
                      ),
                      Checkbox(
                        value: other,
                        onChanged: (bool? value) {
                          setState(() {
                            other = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                      ),
                      Text("無偏好",
                          style: TextStyle(
                              color: Color(0xFF0D3B66),
                              fontSize: 15
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(padding: EdgeInsets.only(left: 10),
                  child: Container(
                    width: 380,
                    child: Divider(
                      color: Colors.black26,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //第九題
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '9. 您是否有任何身體部位受過傷害,\n'
                        '    不適合太激烈的運動',
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Checkbox(
                        value: knee,
                        onChanged: (bool? value) {
                          setState(() {
                            knee = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("膝蓋",
                          style: TextStyle(
                              color: Color(0xFF0D3B66),
                              fontSize: 15
                          )
                      ),
                      Checkbox(
                        value: waist,
                        onChanged: (bool? value) {
                          setState(() {
                            waist = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("腰部",
                          style: TextStyle(
                              color: Color(0xFF0D3B66),
                              fontSize: 15
                          )
                      ),
                      Checkbox(
                        value: shoulder,
                        onChanged: (bool? value) {
                          setState(() {
                            shoulder = value!;
                          });
                        },
                        activeColor: Color(0xFFFFA493),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text("肩膀",
                          style: TextStyle(
                              color: Color(0xFF0D3B66),
                              fontSize: 15
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                      children: [
                        Checkbox(
                          value: butt,
                          onChanged: (bool? value) {
                            setState(() {
                              butt = value!;
                            });
                          },
                          activeColor: Color(0xFFFFA493),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("臀部",
                            style: TextStyle(
                                color: Color(0xFF0D3B66),
                                fontSize: 15
                            )
                        ),
                        Checkbox(
                          value: abd,
                          onChanged: (bool? value) {
                            setState(() {
                              abd = value!;
                            });
                          },
                          activeColor: Color(0xFFFFA493),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("腹肌",
                            style: TextStyle(
                                color: Color(0xFF0D3B66),
                                fontSize: 15
                            )
                        ),
                        Checkbox(
                          value: none,
                          onChanged: (bool? value) {
                            setState(() {
                              none = value!;
                            });
                          },
                          activeColor: Color(0xFFFFA493),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("均無",
                            style: TextStyle(
                                color: Color(0xFF0D3B66),
                                fontSize: 15
                            )
                        ),
                      ]
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("返回",
                          style: TextStyle(
                            color: Color(0xFF0D3B66),
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFA493),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(width: 20),
                    ElevatedButton(
                        child: Text("確定",
                            style: TextStyle(
                              color: Color(0xFF0D3B66),
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFA493),
                        ),
                        onPressed: () {
                          if (timeSpan.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("運動時長不得為空"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("確定"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFA493),
                                        onPrimary: Color(0xFF0D3B66),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if(!anyDaySelected){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("第六題：至少選擇一天運動日"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("確定"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFA493),
                                        onPrimary: Color(0xFF0D3B66),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if(!LikingSelected){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("第七題：至少選擇一個選項"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text("確定"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFFFA493),
                                        onPrimary: Color(0xFF0D3B66),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            String workoutDays = (monday ? "1" : "0") +
                                (tuesday ? "1" : "0") +
                                (wednesday ? "1" : "0") +
                                (thursday ? "1" : "0") +
                                (friday ? "1" : "0") +
                                (saturday ? "1" : "0") +
                                (sunday ? "1" : "0");
                            Map<String, dynamic> data = {
                              'timeSpan': int.parse(timeSpan.substring(0, 2)),
                              'workoutDays': workoutDays,
                              'strengthLiking': strengthLiking ? 60 : 40,
                              'cardioLiking': cardioLiking ? 60 : 40,
                              'yogaLiking': yogaLiking ? 60 : 40,
                            };
                            Map<String, dynamic> combinedData_1 = {};
                            combinedData_1.addAll(widget.arguments['answers']);
                            combinedData_1.addAll(data);
                            print('combinedData_1: $combinedData_1');
                            Navigator.pushNamed(context, "/questionnaire/4",
                                arguments: {
                                  'user': widget.arguments['user'],
                                  'combinedData_1': combinedData_1
                                });
                            /*Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ForthPage(combinedData_1: combinedData_1, user: widget.user)
                              ));*/
                          }
                        }),
                    SizedBox(height: 20),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

class ForthPage extends StatefulWidget {
  final Map arguments;

  const ForthPage({super.key, required this.arguments});

  @override
  _ForthPage createState() => _ForthPage();
}

class _ForthPage extends State<ForthPage> {
  String? frequency = "";
  bool? A = false;
  bool? B = false;
  bool? C = false;
  bool? D = false;
  bool? E = false;
  bool? F = false;
  bool? G = false;
  bool? H = false;
  String strengthAbility = "";
  String cardioAbility = "";
  String yogaAbility = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Part1：現階段運動能力與未來目標',
            style: TextStyle(
              color: Color(0xFF0D3B66),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Color(0xFFFAF0CA),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //第十題
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '10. 您目前的運動頻率(次數/週)',
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<String>(
                            value: "1",
                            groupValue: frequency,
                            onChanged: (value) {
                              setState(() {
                                frequency = value;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                          ),
                          Text("0",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Radio<String>(
                            value: "2",
                            groupValue: frequency,
                            onChanged: (value) {
                              setState(() {
                                frequency = value;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                          ),
                          Text("1-2",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Radio<String>(
                            value: "3",
                            groupValue: frequency,
                            onChanged: (value) {
                              setState(() {
                                frequency = value;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                          ),
                          Text("3-4",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Radio<String>(
                            value: "4",
                            groupValue: frequency,
                            onChanged: (value) {
                              setState(() {
                                frequency = value;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                          ),
                          Text("5(含以上)",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(padding: EdgeInsets.only(left: 10),
                      child: Container(
                        width: 380,
                        child: Divider(
                          color: Colors.black26,
                          height: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //第十一題
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '11. 您運動的原因及預期目標',
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Checkbox(
                            value: A,
                            onChanged: (bool? value) {
                              setState(() {
                                A = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("維持運動能力",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Checkbox(
                            value: B,
                            onChanged: (bool? value) {
                              setState(() {
                                B = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("鍛鍊肌肉",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Checkbox(
                            value: C,
                            onChanged: (bool? value) {
                              setState(() {
                                C = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("減重",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Checkbox(
                            value: D,
                            onChanged: (bool? value) {
                              setState(() {
                                D = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("提升心肺耐力",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Checkbox(
                            value: E,
                            onChanged: (bool? value) {
                              setState(() {
                                E = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("提升身體靈敏度",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Checkbox(
                            value: F,
                            onChanged: (bool? value) {
                              setState(() {
                                F = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("抒解壓力",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Checkbox(
                            value: G,
                            onChanged: (bool? value) {
                              setState(() {
                                G = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("減重",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          Checkbox(
                            value: H,
                            onChanged: (bool? value) {
                              setState(() {
                                H = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text("其他",
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                          SizedBox(width: 5),
                          Container(
                            width: 80,
                            height: 20,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '自行輸入',
                                hintStyle: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(padding: EdgeInsets.only(left: 10),
                      child: Container(
                        width: 380,
                        child: Divider(
                          color: Colors.black26,
                          height: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //第十二題
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '12. 請為您目前做肌耐力運動的能力評分',
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "80",
                              groupValue: strengthAbility,
                              onChanged: (value) {
                                setState(() {
                                  strengthAbility = value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('高水平：'
                                '一次完成20次深蹲及伏地挺身',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "70",
                              groupValue: strengthAbility,
                              onChanged: (value) {
                                setState(() {
                                  strengthAbility = value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('中高水平：'
                                '一次完成15次深蹲及伏地挺身',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "60",
                              groupValue: strengthAbility,
                              onChanged: (value) {
                                setState(() {
                                  strengthAbility = value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('中水平：'
                                '一次完成10次的深蹲及硬舉',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "50",
                              groupValue: strengthAbility,
                              onChanged: (value) {
                                setState(() {
                                  strengthAbility = value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('中低水平：'
                                '一次完成3-6次深蹲及硬舉',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "40",
                              groupValue: strengthAbility,
                              onChanged: (value) {
                                setState(() {
                                  strengthAbility = value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('低水平：'
                                '一次僅能完成1-3次深蹲及硬舉',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(padding: EdgeInsets.only(left: 10),
                      child: Container(
                        width: 380,
                        child: Divider(
                          color: Colors.black26,
                          height: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //第十三題
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '13. 請為您目前做有氧運動的能力評分',
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "80",
                              groupValue: cardioAbility,
                              onChanged: (value) {
                                setState(() {
                                  cardioAbility = value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('高水平：能持續30分鐘以上慢跑或飛輪',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "60",
                              groupValue: cardioAbility,
                              onChanged: (value) {
                                setState(() {
                                  cardioAbility = value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('中水平：能持續15-30分鐘快走或跳繩',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SizedBox(
                        height: 28,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: "40",
                              groupValue: cardioAbility,
                              onChanged: (value) {
                                setState(() {
                                  cardioAbility= value!;
                                });
                              },
                              activeColor: Color(0xFFFFA493),
                            ),
                            Text('低水平：能持續15-30分鐘散步或爬樓梯',
                                style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                    fontSize: 15
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(padding: EdgeInsets.only(left: 10),
                      child: Container(
                        width: 380,
                        child: Divider(
                          color: Colors.black26,
                          height: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //第十四題
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '14. 請為您目前做伸展運動的能力評分',
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "80",
                            groupValue: yogaAbility,
                            onChanged: (value) {
                              setState(() {
                                yogaAbility = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                          ),
                          Text('高水平：能完成多種複雜的伸展動作\n'
                              '                保持每個姿勢正確且輕鬆地完成',
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "60",
                            groupValue: yogaAbility,
                            onChanged: (value) {
                              setState(() {
                                yogaAbility= value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                          ),
                          Text('中水平：能完成基本的伸展運動\n'
                              '                保持姿勢正確但未達高水平要求',
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "40",
                            groupValue: yogaAbility,
                            onChanged: (value) {
                              setState(() {
                                yogaAbility = value!;
                              });
                            },
                            activeColor: Color(0xFFFFA493),
                          ),
                          Text('低水平：只能完成簡單的伸展動作\n'
                              '                無法做複雜動作及保持姿勢正確',
                              style: TextStyle(
                                  color: Color(0xFF0D3B66),
                                  fontSize: 15
                              )
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text(
                            "返回",
                            style: TextStyle(
                              color: Color(0xFF0D3B66),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFA493),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            },
                        ),
                        SizedBox(height: 20),
                        SizedBox(width: 20),
                        ElevatedButton(
                          child: Text(
                            "確定",
                            style: TextStyle(
                              color: Color(0xFF0D3B66),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFA493),
                          ),
                          onPressed: () {
                            if (strengthAbility.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("肌耐力運動能力不得空白"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text("確定"),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFFFA493),
                                          onPrimary: Color(0xFF0D3B66),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (cardioAbility.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("有氧運動能力不得空白"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text("確定"),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFFFA493),
                                          onPrimary: Color(0xFF0D3B66),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (yogaAbility.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("伸展運動能力不得空白"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text("確定"),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFFFA493),
                                          onPrimary: Color(0xFF0D3B66),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              Map<String, dynamic> Data = {
                                'strengthAbility': int.parse(strengthAbility),
                                'cardioAbility': int.parse(cardioAbility),
                                'yogaAbility': int.parse(yogaAbility),
                              };
                              Map<String, dynamic> combinedData_2 = {};
                              combinedData_2.addAll(widget.arguments['combinedData_1']);
                              combinedData_2.addAll(Data);
                              print('combinedData_2: $combinedData_2');
                              Navigator.pushNamed(context, "/questionnaire/5",
                                  arguments: {
                                'user': widget.arguments['user'],
                                'combinedData_2': combinedData_2
                              });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ]),
        )));
  }
}

class FifthPage extends StatefulWidget {
  final Map arguments;

  const FifthPage({super.key, required this.arguments});

  @override
  _FifthPage createState() => _FifthPage();
}

class _FifthPage extends State<FifthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Part2：人格測驗',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 200),
              child: Text(
                '第二部分共有9道題，\n'
                '請針對以下情況進行直覺式判斷，\n並在不花太多時間的條件下回答是或否。\n\n'
                '請誠實且儘可能準確地回答。\n',
                style: TextStyle(
                  color: Color(0xFF0D3B66),
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                child: Text(
                  "開始作答",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFA493),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/questionnaire/6", arguments: {
                    'user': widget.arguments['user'],
                    'combinedData_2': widget.arguments['combinedData_2']
                  });
                },
              ),
            )),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class SixthPage extends StatefulWidget {
  final Map arguments;

  const SixthPage({super.key, required this.arguments});

  @override
  _SixthPage createState() => _SixthPage();
}

class _SixthPage extends State<SixthPage> {
  String neuroticism_1 = "";
  String neuroticism_2 = "";
  String neuroticism_3 = "";
  String conscientiousness_1 = "";
  String conscientiousness_2 = "";
  String conscientiousness_3 = "";
  String openness_1 = "";
  String openness_2 = "";
  String openness_3 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Part2：人格測驗',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '1.當處於極大壓力下時，我時常感到瀕臨崩潰。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: neuroticism_1,
                      onChanged: (value) {
                        setState(() {
                          neuroticism_1 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: neuroticism_1,
                      onChanged: (value) {
                        setState(() {
                          neuroticism_1 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '2.即使是很小的煩惱，也可能會讓我感到挫敗。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: neuroticism_2,
                      onChanged: (value) {
                        setState(() {
                          neuroticism_2 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: neuroticism_2,
                      onChanged: (value) {
                        setState(() {
                          neuroticism_2 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '3.看到別人成功讓我產生壓力，使我焦躁不安。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: neuroticism_3,
                      onChanged: (value) {
                        setState(() {
                          neuroticism_3 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: neuroticism_3,
                      onChanged: (value) {
                        setState(() {
                          neuroticism_3 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '4.我總是會按時完成計畫。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: conscientiousness_1,
                      onChanged: (value) {
                        setState(() {
                          conscientiousness_1 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: conscientiousness_1,
                      onChanged: (value) {
                        setState(() {
                          conscientiousness_1 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '5.我會依事情的輕重緩急安排時間。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: conscientiousness_2,
                      onChanged: (value) {
                        setState(() {
                          conscientiousness_2 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: conscientiousness_2,
                      onChanged: (value) {
                        setState(() {
                          conscientiousness_2 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '6.我的目標明確，能按部就班的朝目標努力。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: conscientiousness_3,
                      onChanged: (value) {
                        setState(() {
                          conscientiousness_3 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: conscientiousness_3,
                      onChanged: (value) {
                        setState(() {
                          conscientiousness_3 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '7.我喜歡實驗新的做事方法。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: openness_1,
                      onChanged: (value) {
                        setState(() {
                          openness_1 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: openness_1,
                      onChanged: (value) {
                        setState(() {
                          openness_1 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '8.在能發揮創意的環境下，我做事會最有效率。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: openness_2,
                      onChanged: (value) {
                        setState(() {
                          openness_2 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: openness_2,
                      onChanged: (value) {
                        setState(() {
                          openness_2 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '9.我樂在學習新事物。',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: openness_3,
                      onChanged: (value) {
                        setState(() {
                          openness_3 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("是",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                    Radio<String>(
                      value: "2",
                      groupValue: openness_3,
                      onChanged: (value) {
                        setState(() {
                          openness_3 = value!;
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                    ),
                    Text("否",
                        style:
                            TextStyle(color: Color(0xFF0D3B66), fontSize: 15)),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  child: Text(
                    "確定送出",
                    style: TextStyle(
                      color: Color(0xFF0D3B66),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFA493),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () async {
                    if (neuroticism_1.isEmpty ||
                        neuroticism_2.isEmpty ||
                        neuroticism_3.isEmpty ||
                        conscientiousness_1.isEmpty ||
                        conscientiousness_2.isEmpty ||
                        conscientiousness_3.isEmpty ||
                        openness_1.isEmpty ||
                        openness_2.isEmpty ||
                        openness_3.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("尚有未作答題目"),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("確定"),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFFA493),
                                  onPrimary: Color(0xFF0D3B66),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Map<String, int> personality = {};
                      int neuroticismSum = 0;
                      if (neuroticism_1 == "1") {
                        neuroticismSum += 1;
                      }
                      if (neuroticism_2 == "1") {
                        neuroticismSum += 1;
                      }
                      if (neuroticism_3 == "1") {
                        neuroticismSum += 1;
                      }
                      if (neuroticismSum == 2 || neuroticismSum == 3) {
                        personality['neuroticism'] = 1;
                      } else {
                        personality['neuroticism'] = -1;
                      }
                      int conscientiousnessSum = 0;
                      if (conscientiousness_1 == "1") {
                        conscientiousnessSum += 1;
                      }
                      if (conscientiousness_2 == "1") {
                        conscientiousnessSum += 1;
                      }
                      if (conscientiousness_3 == "1") {
                        conscientiousnessSum += 1;
                      }
                      if (conscientiousnessSum == 2 ||
                          conscientiousnessSum == 3) {
                        personality['conscientiousness'] = 1;
                      } else {
                        personality['conscientiousness'] = -1;
                      }
                      int opennessSum = 0;
                      if (openness_1 == "1") {
                        opennessSum += 1;
                      }
                      if (openness_2 == "1") {
                        opennessSum += 1;
                      }
                      if (openness_3 == "1") {
                        opennessSum += 1;
                      }
                      if (opennessSum == 2 || opennessSum == 3) {
                        personality['openness'] = 3;
                      } else {
                        personality['openness'] = 2;
                      }
                      Map<String, dynamic> combinedData = {};
                      combinedData.addAll(widget.arguments['combinedData_2']);
                      combinedData.addAll(personality);
                      combinedData["userName"] =
                          widget.arguments['user'].displayName;
                      print('combinedData: $combinedData');

                      String uid = widget.arguments['user'].uid;
                      await UserDB.insert(uid, combinedData);
                      await PlanAlgo.execute(uid);
                      Navigator.pushNamed(context, "/questionnaire/result",
                          arguments: {
                            'user': widget.arguments['user'],
                            'neuroticismSum': neuroticismSum,
                            'conscientiousnessSum': conscientiousnessSum,
                            'opennessSum': opennessSum,
                            'resultMap': combinedData,
                          });
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  final Map arguments;

  const ResultPage({
    super.key,
    required this.arguments,
  });

  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  String getPersonalityType() {
    if ((widget.arguments['neuroticismSum'] == 2 ||
            widget.arguments['neuroticismSum'] == 3) &&
        (widget.arguments['conscientiousnessSum'] == 2 ||
            widget.arguments['conscientiousnessSum'] == 3) &&
        (widget.arguments['opennessSum'] == 2 ||
            widget.arguments['opennessSum'] == 3)) {
      return "NOC";
    } else if ((widget.arguments['neuroticismSum'] == 0 ||
            widget.arguments['neuroticismSum'] == 1) &&
        (widget.arguments['conscientiousnessSum'] == 2 ||
            widget.arguments['conscientiousnessSum'] == 3) &&
        (widget.arguments['opennessSum'] == 2 ||
            widget.arguments['opennessSum'] == 3)) {
      return "S₁OC";
    } else if ((widget.arguments['neuroticismSum'] == 2 ||
            widget.arguments['neuroticismSum'] == 3) &&
        (widget.arguments['conscientiousnessSum'] == 0 ||
            widget.arguments['conscientiousnessSum'] == 1) &&
        (widget.arguments['opennessSum'] == 2 ||
            widget.arguments['opennessSum'] == 3)) {
      return "NGC";
    } else if ((widget.arguments['neuroticismSum'] == 0 ||
            widget.arguments['neuroticismSum'] == 1) &&
        (widget.arguments['conscientiousnessSum'] == 0 ||
            widget.arguments['conscientiousnessSum'] == 1) &&
        (widget.arguments['opennessSum'] == 2 ||
            widget.arguments['opennessSum'] == 3)) {
      return "S₁GC";
    } else if ((widget.arguments['neuroticismSum'] == 2 ||
            widget.arguments['neuroticismSum'] == 3) &&
        (widget.arguments['conscientiousnessSum'] == 2 ||
            widget.arguments['conscientiousnessSum'] == 3) &&
        (widget.arguments['opennessSum'] == 0 ||
            widget.arguments['opennessSum'] == 1)) {
      return "NOS₂";
    } else if ((widget.arguments['neuroticismSum'] == 0 ||
            widget.arguments['neuroticismSum'] == 1) &&
        (widget.arguments['conscientiousnessSum'] == 2 ||
            widget.arguments['conscientiousnessSum'] == 3) &&
        (widget.arguments['opennessSum'] == 0 ||
            widget.arguments['opennessSum'] == 1)) {
      return "S₁OS₂";
    } else if ((widget.arguments['neuroticismSum'] == 2 ||
            widget.arguments['neuroticismSum'] == 3) &&
        (widget.arguments['conscientiousnessSum'] == 0 ||
            widget.arguments['conscientiousnessSum'] == 1) &&
        (widget.arguments['opennessSum'] == 0 || widget.arguments['opennessSum'] == 1)) {
      return "NGS₂";
    } else {
      return "S₁GS₂";
    }
  }

  String personalityType = ''; //回傳一個人格類型字串
  late Widget imageWidget;

  @override
  void initState() {
    super.initState();
    personalityType = getPersonalityType();
  }

  @override
  Widget build(BuildContext context) {
    switch (personalityType) {
      case 'NOC':
        imageWidget = Image.asset(
          'assets/images/personality_NOC.png',
          height: 250,
        );
        break;
      case 'S₁OC':
        imageWidget = Image.asset('assets/images/personality_S₁OC.png');
        break;
      case 'NGC':
        imageWidget = Image.asset('assets/images/personality_NGC.png');
        break;
      case 'S₁GC':
        imageWidget = Image.asset('assets/images/personality_S₁GC.png');
        break;
      case 'NOS₂':
        imageWidget = Image.asset('assets/images/personality_NOS₂.png');
        break;
      case 'S₁OS₂':
        imageWidget = Image.asset('assets/images/personality_S₁OS₂.png');
        break;
      case 'NGS₂':
        imageWidget = Image.asset('assets/images/personality_NGS₂.png');
        break;
      case 'S₁GS₂':
        imageWidget = Image.asset('assets/images/personality_S₁GS₂.png');
        break;
    }
    print(personalityType);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '測驗結果',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              '以下為您所對應的人格角色：\n',
              style: TextStyle(
                color: Color(0xFF0D3B66),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            imageWidget,
            ElevatedButton(
              child: Text("確認",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                  )),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFA493),
              ),
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => false,
                    arguments: {'user': widget.arguments['user']});
              },
            ),
            Text("Map: ${widget.arguments['resultMap']}"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
