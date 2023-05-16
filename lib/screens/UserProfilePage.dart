import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  final Map arguments;
  //final User user;

  const UserProfilePage({super.key, required this.arguments});
  @override
  _UserProfilePage createState() => _UserProfilePage();
}

// TODO: 抓使用者的原設定帶入預設值
class _UserProfilePage extends State<UserProfilePage> {
  //暱稱
  TextEditingController nicknameController = TextEditingController();
  String nickName = "";
  //運動時間
  String timeSpan = "";
  //運動日
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;
  //運動偏好
  bool strengthLiking = false;
  bool cardioLiking = false;
  bool yogaLiking = false;
  bool none = false;

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('客製計畫',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFFFAF0CA),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.arguments['user'].displayName}'),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Text(
                  '修改暱稱：',
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Container(
                  width: 200,
                  child: TextField(
                    controller: nicknameController,
                    decoration: InputDecoration(
                      //hintText: '修改暱稱',
                      hintStyle: TextStyle(
                        color: Color(0xFF0D3B66),
                        fontSize: 15,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      nickName = value;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Text(
                  '更改運動時長：',
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
                    Text("15分鐘",
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
                    Text("30分鐘",
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
                    Text("45分鐘",
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
                    Text("60分鐘",
                        style: TextStyle(
                          color: Color(0xFF0D3B66),
                          fontSize: 15,
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Text(
                  '更改每週運動日：',
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left:20),
                child: Text(
                  '更改個人運動偏好：',
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
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text("肌耐力訓練 (如重量訓練)",
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
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text("有氧訓練 (如有氧舞蹈、慢跑等)",
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
                        });
                      },
                      activeColor: Color(0xFFFFA493),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text("伸展運動 (如瑜珈)",
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
                      value: none,
                      onChanged: (value) {
                        setState(() {
                          none = value!;
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
              SizedBox(height: 20),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  child: Text("確認",
                      style: TextStyle(
                        color: Color(0xFF0D3B66),
                      )
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFA493),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('修改確認',
                              style: TextStyle(
                                color: Color(0xFF0D3B66),
                              )
                          ),
                          content: Text('你確定要執行此操作嗎?',
                              style: TextStyle(
                                color: Color(0xFF0D3B66),
                              )
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('取消',
                                  style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                  )
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFFA493),
                                onPrimary: Color(0xFF0D3B66),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('確認',
                                  style: TextStyle(
                                    color: Color(0xFF0D3B66),
                                  )
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFFFA493),
                                onPrimary: Color(0xFF0D3B66),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                              ),
                              onPressed: () {
                                print('nickName:$nickName');
                                print('timeSpan:$timeSpan');
                                String workoutDays = (monday ? "1" : "0") +
                                    (tuesday ? "1" : "0") +
                                    (wednesday ? "1" : "0") +
                                    (thursday ? "1" : "0") +
                                    (friday ? "1" : "0") +
                                    (saturday ? "1" : "0") +
                                    (sunday ? "1" : "0");
                                print('workoutDays:' + workoutDays);
                                Map<String, int> liking = {
                                  'strengthLiking': strengthLiking ? 60 : 40,
                                  'cardioLiking': cardioLiking ? 60 : 40,
                                  'yogaLiking': yogaLiking ? 60 : 40,
                                };
                                print(liking);
                                Navigator.of(context).pop();
                              },
                            ), SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ]),
      ),
    );
  }
}