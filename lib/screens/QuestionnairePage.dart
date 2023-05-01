import 'package:g12/screens/ResultPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class QuestionnairePage extends StatefulWidget {
  @override
  _QuestionnairePage createState() => _QuestionnairePage();
}

class _QuestionnairePage extends State<QuestionnairePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Change Page',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('問卷介面'),
          ),
          body: _FirstPage(

          ),
        ),
        routes: <String, WidgetBuilder>{'/second': (_) => new SecondPage()});
  }
}

class _FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('第一部分共14道題，\n'
              '問題將分成「基本資訊」、「運動習慣偏好調查」\n'
              '與「現階段運動能力及未來目標」三大項。\n\n'
              '請依據個人狀況回來問題。\n',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            child: Text("開始作答"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? radioValue_1 = "1";
  DateTime? selectedDateTime;
  //TextEditingController heightController = TextEditingController();
  //TextEditingController weightController = TextEditingController();

  _saveData(String gender, double height, double weight) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('gender', gender);
    pref.setDouble('height', height);
    pref.setDouble('weight', weight);
  }

  @override
  Widget build(BuildContext context) {
    var selectedDateTime;
    return Scaffold(
        appBar: AppBar(
          title: Text('Part1：基本資訊'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //第一題
                SizedBox(height: 20),
                Text(
                  '1.您的性別?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<String>(
                      value: "1",
                      groupValue: radioValue_1,
                      onChanged: (value) {
                        setState(() {
                          radioValue_1 = value;
                        });
                      },
                    ),
                    Text("男"),
                    Radio<String>(
                      value: "2",
                      groupValue: radioValue_1,
                      onChanged: (value) {
                        setState(() {
                          radioValue_1 = value;
                        });
                      },
                    ),
                    Text("女"),
                  ],
                ),
                //第二題
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      '2.您的生日?',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        var result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900, 01),
                          lastDate: DateTime(2024, 01),
                        );
                        if (result != null) {
                          setState(() {
                            selectedDateTime = result;
                          });
                        }
                      },
                      child: const Text('選擇'),
                    ),
                    SizedBox(width: 10),
                    if (selectedDateTime != null)
                    //還在研究如何把日期印出來
                      Text(
                        '您的生日？ ${selectedDateTime?.toString()?.substring(0, 10) ?? ""}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                  ],
                ),
                //第三題
                SizedBox(height: 15),
                Text(
                  '3.您的身高?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '請輸入您的身高(cm)',
                      hintStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                //第四題
                SizedBox(height: 15),
                Text(
                  '4.您的體重?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Container(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '請輸入您的體重(kg)',
                      hintStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("返回"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(width: 20),
                    ElevatedButton(
                      child: Text("確定"),
                      onPressed: () async {
                        //呼叫存起來的東西
                        //但應該要是使用者存進去的值而不是我這邊輸入的？
                        String gender =  radioValue_1 = "";
                        double height = 0;
                        double weight = 0;
                        if (radioValue_1 == null ||
                            //selectedDateTime == null ||
                            height.isNaN ||
                            weight.isNaN) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("請填寫所有必填項目！",
                                style: TextStyle(
                                  fontSize: 20, // 字體大小
                                  color: Colors.white, // 字體顏色
                                ),
                              ),
                                backgroundColor: Colors.red,
                              )
                          );
                        }else {
                          _saveData(gender, height, weight);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ThirdPage()));
                        }
                      },
                    ),SizedBox(height: 20),
                  ],
                ),
              ]),
        )
    );
  }
}


class ThirdPage extends StatefulWidget {
  @override
  _ThirdPage createState() => _ThirdPage();
}

class _ThirdPage extends State<ThirdPage> {
  String? radioValue_5 = "1";
  bool? monday = false;
  bool? tuesday = false;
  bool? wednesday = false;
  bool? thursday = false;
  bool? friday = false;
  bool? saturday = false;
  bool? sunday = false;
  bool? gym = false;
  bool? house = false;
  bool? outdoor = false;
  bool? other = false;
  bool? knee = false;
  bool? waist = false;
  bool? shoulder = false;
  bool? butt = false;
  bool? abd = false;
  bool? none = false;
  bool? strength = false;
  bool? cardio = false;
  bool? yoga = false;

  _saveData(String time) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('time', time);
    pref.setBool('monday', monday!);
    pref.setBool('tuesday', tuesday!);
    pref.setBool('wednesday', wednesday!);
    pref.setBool('thursday', thursday!);
    pref.setBool('friday', friday!);
    pref.setBool('gym', gym!);
    pref.setBool('house', house!);
    pref.setBool('outdoor', outdoor!);
    pref.setBool('other', other!);
    pref.setBool('knee', knee!);
    pref.setBool('waist', waist!);
    pref.setBool('shoulder', shoulder!);
    pref.setBool('butt', butt!);
    pref.setBool('abd!', abd!);
    pref.setBool('none', none!);
    pref.setBool('strength', strength!);
    pref.setBool('cardio', cardio!);
    pref.setBool('yoga', yoga!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part1：運動習慣偏好'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //第五題
              SizedBox(height: 20),
              Text(
                '5.您希望一次運動安排多久時長？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("15分"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("30分"),
                  Radio<String>(
                    value: "3",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("45分"),
                  Radio<String>(
                    value: "4",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("60分"),
                ],
              ),
              //第六題
              SizedBox(height: 15),
              Text(
                '6. 未來的一個星期內有哪幾天有空運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: monday,
                    onChanged: (bool? value) {
                      setState(() {
                        monday = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("星期一",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: tuesday,
                    onChanged: (bool? value) {
                      setState(() {
                        tuesday = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("星期二",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: wednesday,
                    onChanged: (bool? value) {
                      setState(() {
                        wednesday = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("星期三",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: thursday,
                    onChanged: (bool? value) {
                      setState(() {
                        thursday = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("星期四",
                      style: TextStyle(fontSize: 15)
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: friday,
                    onChanged: (bool? value) {
                      setState(() {
                        friday = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("星期五",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: saturday,
                    onChanged: (bool? value) {
                      setState(() {
                        saturday = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("星期六",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: sunday,
                    onChanged: (bool? value) {
                      setState(() {
                        sunday = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("星期日",
                      style: TextStyle(fontSize: 15)
                  ),
                ],
              ),
              //第七題
              SizedBox(height: 15),
              Text(
                '7. 您喜歡什麼樣類型的運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: strength,
                    onChanged: (bool? value) {
                      setState(() {strength = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: 3),
                  Text("肌耐力訓練 (如重量訓練)"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: cardio,
                    onChanged: (bool? value) {
                      setState(() {
                        cardio = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: 3),
                  Text("有氧訓練 (如有氧舞蹈、慢跑等)"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: yoga,
                    onChanged: (bool? value) {
                      setState(() {
                        yoga = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: 3),
                  Text("伸展運動 (如瑜珈)"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: none,
                    onChanged: (bool? value) {
                      setState(() {
                        none = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: 3),
                  Text("我沒有任何偏好"),
                ],
              ),
              //第八題
              SizedBox(height: 15),
              Text(
                '8.您喜歡在下列何情況進行運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(// 每行之間的間距
                children: [
                  Checkbox(
                    value: gym,
                    onChanged: (bool? value) {
                      setState(() {
                        gym = value!;
                      });
                    },
                  ),
                  Text("健身房",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: house,
                    onChanged: (bool? value) {
                      setState(() {
                        house = value!;
                      });
                    },
                  ),
                  Text("家裡",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: outdoor,
                    onChanged: (bool? value) {
                      setState(() {
                        outdoor = value!;
                      });
                    },
                  ),
                  Text("戶外",
                      style: TextStyle(fontSize: 15)
                  ),
                  Checkbox(
                    value: other,
                    onChanged: (bool? value) {
                      setState(() {
                        other = value!;
                      });
                    },
                  ),
                  Text("其他",
                      style: TextStyle(fontSize: 15)
                  ),
                ],
              ),
              //第九題
              SizedBox(height: 15),
              Text(
                '9. 您是否有任何身體部位受過傷害不適合太激烈的運動？',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: knee,
                    onChanged: (bool? value) {
                      setState(() {
                        knee = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("膝蓋"),
                  Checkbox(
                    value: waist,
                    onChanged: (bool? value) {
                      setState(() {
                        waist = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("腰部"),
                  Checkbox(
                    value: shoulder,
                    onChanged: (bool? value) {
                      setState(() {
                        shoulder = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text("肩膀"),
                ],
              ),
              Row(
                  children: [
                    Checkbox(
                      value: butt,
                      onChanged: (bool? value) {
                        setState(() {
                          butt = value!;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text("臀部"),
                    Checkbox(
                      value: abd,
                      onChanged: (bool? value) {
                        setState(() {
                          abd = value!;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text("腹肌"),
                    Checkbox(
                      value: none,
                      onChanged: (bool? value) {
                        setState(() {
                          none = value!;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text("均無"),
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text("返回"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(width: 20),
                  ElevatedButton(
                    child: Text("確定"),
                    onPressed: () async {
                      //呼叫存起來的東西
                      String time =  radioValue_5 = "";
                      if (radioValue_5 == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("尚有未作答題目！",
                              style: TextStyle(
                                fontSize: 15, // 字體大小
                                color: Colors.white, // 字體顏色
                              ),
                            ),
                              backgroundColor: Colors.red,)
                        );
                      }else {
                        _saveData(radioValue_5!);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ForthPage()));
                      }
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ]),
      ),
    );
  }
}

class ForthPage extends StatefulWidget {
  @override
  _ForthPage createState() => _ForthPage();
}

class _ForthPage extends State<ForthPage> {
  String? radioValue_10 = "1";
  bool? A = false;
  bool? B = false;
  bool? C = false;
  bool? D = false;
  bool? E = false;
  bool? F = false;
  bool? G = false;
  bool? H = false;
  String? radioValue_12 = "1";
  String? radioValue_13 = "1";
  String? radioValue_14 = "1";

  _saveData(String frequency, bool A, bool B, bool C, bool D, bool E, bool F, bool G, String ability) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('frequency', frequency);
    pref.setBool('A', A);
    pref.setBool('B', B);
    pref.setBool('C', C);
    pref.setBool('D', D);
    pref.setBool('E', E);
    pref.setBool('F', F);
    pref.setBool('G', G);
    pref.setString('ability', ability);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Part1：現階段運動能力與未來目標'),
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
                    Text(
                      '10.您目前的運動頻率(次數/週)？',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: "1",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("0"),
                        Radio<String>(
                          value: "2",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("1-2"),
                        Radio<String>(
                          value: "3",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("3-4"),
                        Radio<String>(
                          value: "4",
                          groupValue: radioValue_10,
                          onChanged: (value) {
                            setState(() {
                              radioValue_10 = value;
                            });
                          },
                        ),
                        Text("5(含以上)"),
                      ],
                    ),
                    //第十一題
                    SizedBox(height: 10),
                    Text(
                      '11.您運動的原因或預期目標？',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    //Column(
                    //children: [
                    Row(
                      children: [
                        Checkbox(
                          value: A,
                          onChanged: (bool? value) {
                            setState(() {
                              A = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("維持運動能力"),
                        Checkbox(
                          value: B,
                          onChanged: (bool? value) {
                            setState(() {
                              B = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("鍛鍊肌肉變更強壯"),
                        Checkbox(
                          value: C,
                          onChanged: (bool? value) {
                            setState(() {
                              C = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("減重"),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: D,
                          onChanged: (bool? value) {
                            setState(() {
                              D = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("提升心肺耐力"),
                        Checkbox(
                          value: E,
                          onChanged: (bool? value) {
                            setState(() {
                              E = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("提升身體的靈敏度"),
                        Checkbox(
                          value: F,
                          onChanged: (bool? value) {
                            setState(() {
                              F = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("抒解壓力"),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: G,
                          onChanged: (bool? value) {
                            setState(() {
                              G = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("促進身體健康"),
                        Checkbox(
                          value: H,
                          onChanged: (bool? value) {
                            setState(() {
                              H = value!;
                            });
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text("其他"),
                        SizedBox(width: 5),
                        Container(
                          width: 150,
                          height: 20,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '自行輸入',
                              hintStyle: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //第十二題
                    SizedBox(height: 10),
                    Text(
                      '12.請為您目前做肌耐力運動的能力評分',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "1",
                            groupValue: radioValue_12,
                            onChanged: (value) {
                              setState(() {
                                radioValue_12= value;
                              });
                            },
                          ),
                          Text('1.高水平：'
                              '一口氣完成20次深蹲、伏地挺身等重量訓練',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "2",
                            groupValue: radioValue_12,
                            onChanged: (value) {
                              setState(() {
                                radioValue_12= value;
                              });
                            },
                          ),
                          Text('2.中高水平：'
                              '一口氣完成15次深蹲、伏地挺身等重量訓練',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "3",
                            groupValue: radioValue_12,
                            onChanged: (value) {
                              setState(() {
                                radioValue_12= value;
                              });
                            },
                          ),
                          Text('3.中水平：'
                              '一口氣完成10次的深蹲、硬舉等重量訓練',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "4",
                            groupValue: radioValue_12,
                            onChanged: (value) {
                              setState(() {
                                radioValue_12= value;
                              });
                            },
                          ),
                          Text('4.中低水平：'
                              '一口氣完成3-6次深蹲、硬舉等重量訓練',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "5",
                            groupValue: radioValue_12,
                            onChanged: (value) {
                              setState(() {
                                radioValue_12= value;
                              });
                            },
                          ),
                          Text('5.低水平：'
                              '一次僅能完成1-3次深蹲、硬舉等重量訓練',
                          ),
                        ],
                      ),
                    ),
                    //第十三題
                    SizedBox(height: 10),
                    Text(
                      '13.請為您目前做有氧運動的能力評分',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "1",
                            groupValue: radioValue_13,
                            onChanged: (value) {
                              setState(() {
                                radioValue_13= value;
                              });
                            },
                          ),
                          Text('1.高水平：能持續30分鐘以上進行慢跑、飛輪'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "2",
                            groupValue: radioValue_13,
                            onChanged: (value) {
                              setState(() {
                                radioValue_13= value;
                              });
                            },
                          ),
                          Text('2.中水平：能持續15-30分鐘進行快走、跳繩'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Radio<String>(
                            value: "3",
                            groupValue: radioValue_13,
                            onChanged: (value) {
                              setState(() {
                                radioValue_13= value;
                              });
                            },
                          ),
                          Text('3.低水平：能持續15-30分鐘散步、爬樓梯'),
                        ],
                      ),
                    ),
                    //第十四題
                    SizedBox(width: 10),
                    SizedBox(height: 10),
                    Text(
                      '14.請為您目前做伸展運動的能力評分',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "1",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13 = value;
                            });
                          },
                        ),
                        Text('1.高水平\n'
                            '能夠完成多種複雜的伸展動作，\n'
                            '保持每個動作的正確姿勢並且能夠輕鬆地完成。',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "2",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13= value;
                            });
                          },
                        ),
                        Text('2.中水平\n'
                            '能夠完成基本的伸展運動，\n'
                            '保持正確姿勢完成伸展的動作，但未達高水平的要求。',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "3",
                          groupValue: radioValue_13,
                          onChanged: (value) {
                            setState(() {
                              radioValue_13 = value;
                            });
                          },
                        ),
                        Text('3.低水平\n'
                            '只能完成一些簡單的伸展動作，\n'
                            '難以保持正確的姿勢也無法完成複雜的伸展動作。',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text("返回"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(width: 20),
                        ElevatedButton(
                          child: Text("確定"),
                          onPressed: () async {
                            //呼叫存起來的東西
                            String frequency =  radioValue_10 = "";
                            //await _saveData(frequency);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FifthPage()));
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ]),
            )
        )
    );
  }
}

class FifthPage extends StatefulWidget {
  @override
  _FifthPage createState() => _FifthPage();
}

class _FifthPage extends State<FifthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part2：人格測驗'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('第二部分共有9道題，\n'
                  '請針對以下情況進行直覺式判斷，並在不花太多時間的條件下回答是或否。\n\n'
                  '請誠實且儘可能準確地回答。\n',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text("開始作答"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SixthPage()));
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
class SixthPage extends StatefulWidget {
  @override
  _SixthPage createState() => _SixthPage();
}

class _SixthPage extends State<SixthPage> {
  String? radioValue_1 = "";
  String? radioValue_2 = "";
  String? radioValue_3 = "";
  String? radioValue_4 = "";
  String? radioValue_5 = "";
  String? radioValue_6 = "";
  String? radioValue_7 = "";
  String? radioValue_8 = "";
  String? radioValue_9 = "";

  _saveData(String ans_1, ans_2, ans_3, ans_4, ans_5, ans_6, ans_7, ans_8, ans_9) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('ans_1', ans_1);
    pref.setString('ans_2', ans_2);
    pref.setString('ans_3', ans_3);
    pref.setString('ans_4', ans_4);
    pref.setString('ans_5', ans_5);
    pref.setString('ans_6', ans_6);
    pref.setString('ans_7', ans_7);
    pref.setString('ans_8', ans_8);
    pref.setString('ans_9', ans_9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Part2：人格測驗'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1.當處於極大壓力下時，我時常感到瀕臨崩潰。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_1,
                    onChanged: (value) {
                      setState(() {
                        radioValue_1 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_1,
                    onChanged: (value) {
                      setState(() {
                        radioValue_1 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '2.即使是一個很小的煩惱，也可能會讓我感到挫敗。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_2,
                    onChanged: (value) {
                      setState(() {
                        radioValue_2 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_2,
                    onChanged: (value) {
                      setState(() {
                        radioValue_2 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '3.看到別人的成功讓我產生壓力，並使我焦躁不安。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_3,
                    onChanged: (value) {
                      setState(() {
                        radioValue_3 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_3,
                    onChanged: (value) {
                      setState(() {
                        radioValue_3 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '4.我總是會按時完成計畫。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_4,
                    onChanged: (value) {
                      setState(() {
                        radioValue_4 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_4,
                    onChanged: (value) {
                      setState(() {
                        radioValue_4 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '5.我會依事情的輕重緩急安排時間。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_5,
                    onChanged: (value) {
                      setState(() {
                        radioValue_5 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '6.我的目標明確，能按部就班的朝目標努力。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_6,
                    onChanged: (value) {
                      setState(() {
                        radioValue_6 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_6,
                    onChanged: (value) {
                      setState(() {
                        radioValue_6 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '7.我喜歡實驗新的做事方法。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_7,
                    onChanged: (value) {
                      setState(() {
                        radioValue_7 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_7,
                    onChanged: (value) {
                      setState(() {
                        radioValue_7 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '8.在能發揮創意的環境下，我做事會最有效率。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_8,
                    onChanged: (value) {
                      setState(() {
                        radioValue_8 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_8,
                    onChanged: (value) {
                      setState(() {
                        radioValue_8 = value;
                      });
                    },
                  ),
                  Text("否"),
                ],
              ),
              Text(
                '9.我樂在學習新事物。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: "1",
                    groupValue: radioValue_9,
                    onChanged: (value) {
                      setState(() {
                        radioValue_9 = value;
                      });
                    },
                  ),
                  Text("是"),
                  Radio<String>(
                    value: "2",
                    groupValue: radioValue_9,
                    onChanged: (value) {
                      setState(() {
                        radioValue_9 = value;
                      }
                      );
                    },
                  ),
                  Text("否"),
                ],
              ),
              ElevatedButton(
                child: Text("確定送出"),
                onPressed: () async {
                  //呼叫存起來的東西
                  String ans_1 = radioValue_1 = "";
                  String ans_2 = radioValue_2 = "";
                  String ans_3 = radioValue_3 = "";
                  String ans_4 = radioValue_4 = "";
                  String ans_5 = radioValue_5 = "";
                  String ans_6 = radioValue_6 = "";
                  String ans_7 = radioValue_7 = "";
                  String ans_8 = radioValue_8 = "";
                  String ans_9 = radioValue_9 = "";
                  await _saveData(ans_1, ans_2, ans_3, ans_4, ans_5, ans_6, ans_7, ans_8, ans_9);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResultPage()));
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
