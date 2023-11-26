import 'package:flutter/material.dart';
import 'package:datepicker_cupertino/datepicker_cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'dart:async';

import 'package:g12/services/database.dart';
import 'package:g12/services/page_data.dart';
import 'package:g12/screens/page_material.dart';

//////////////////////////////  Data Type  /////////////////////////////////////

// Map of the user's information based on their answers
Map userInfo = {
  "gender": "",
  "birthday": "",
  "height": "",
  "weight": "",
  "neuroticism": 0,
  "conscientiousness": 0,
  "openness": 0,
  "agreeableness": 0,
  "strengthLiking": 40,
  "cardioLiking": 40,
  "yogaLiking": 40,
  "mindfulnessLiking": 40,
  "workLiking": 40,
  "kindnessLiking": 40,
};

// List of questions in part two
final questions_2 = [
  [
    Question(
      text: "運動/冥想計畫時長",
      options: [
        Option(question: 0, text: "15分鐘", data: 15),
        Option(question: 0, text: "30分鐘", data: 30),
        Option(question: 0, text: "40分鐘", data: 45),
        Option(question: 0, text: "60分鐘", data: 60),
      ],
    ),
    Question(
      text: "運動/冥想計畫時間 (複選)",
      isMultiChoice: true,
      options: [
        Option(question: 1, text: "星期一", data: 1),
        Option(question: 1, text: "星期二", data: 2),
        Option(question: 1, text: "星期三", data: 3),
        Option(question: 1, text: "星期四", data: 4),
        Option(question: 1, text: "星期五", data: 5),
        Option(question: 1, text: "星期六", data: 6),
        Option(question: 1, text: "星期日", data: 0),
        Option(question: 1, text: "每天", data: "1111111"),
      ],
    ),
  ],
  [
    Question(
      text: "運動原因與目標 (複選)",
      isMultiChoice: true,
      options: [
        Option(question: 2, text: "減脂減重", data: "減脂減重"),
        Option(question: 2, text: "塑型增肌", data: "塑型增肌"),
        Option(question: 2, text: "紓解壓力", data: "紓解壓力"),
        Option(question: 2, text: "預防疾病", data: "預防疾病"),
        Option(question: 2, text: "改善膚況", data: "改善膚況"),
        Option(question: 2, text: "增強體力", data: "增強體力"),
        Option(question: 2, text: "激活大腦", data: "激活大腦"),
        Option(question: 2, text: "改善睡眠", data: "改善睡眠"),
      ],
    ),
    Question(
      text: "冥想原因與目標 (複選)",
      isMultiChoice: true,
      options: [
        Option(question: 3, text: "紓解壓力", data: "mindfulnessLiking"),
        Option(question: 3, text: "減緩憂慮", data: "mindfulnessLiking"),
        Option(question: 3, text: "增強動機", data: "workLiking"),
        Option(question: 3, text: "提升效率", data: "workLiking"),
        Option(question: 3, text: "提升自信", data: "kindnessLiking"),
        Option(question: 3, text: "情緒健康", data: "kindnessLiking"),
        Option(question: 3, text: "內心平靜", data: "mindfulnessLiking"),
        Option(question: 3, text: "高覺察力", data: "mindfulnessLiking"),
        Option(question: 3, text: "高專注力", data: "workLiking"),
        Option(question: 3, text: "高創造力", data: "workLiking"),
        Option(question: 3, text: "拓展人際", data: "kindnessLiking"),
        Option(question: 3, text: "練習感激", data: "kindnessLiking"),
      ],
    ),
  ],
  [
    Question(
      text: "運動偏好 (複選)",
      isMultiChoice: true,
      options: [
        Option(
            question: 4,
            text: "肌力訓練",
            data: "strengthLiking",
            description: "如：輕量舉重、伏地挺身"),
        Option(
            question: 4,
            text: "柔軟度訓練",
            data: "yogaLiking",
            description: "如：瑜珈、皮拉提斯"),
        Option(
            question: 4,
            text: "心肺耐力訓練",
            data: "cardioLiking",
            description: "如：慢跑、飛輪、跳繩、游泳"),
        Option(
            question: 4, text: "我沒有任何偏好", data: "", description: "想嘗試以上三種運動"),
      ],
    ),
    Question(
      text: "冥想偏好 (複選)",
      isMultiChoice: true,
      options: [
        Option(
            question: 5,
            text: "正念冥想",
            data: "mindfulnessLiking",
            description: "有意識地回到當下"),
        Option(
            question: 5,
            text: "工作冥想",
            data: "workLiking",
            description: "找到工作與生活的平衡"),
        Option(
            question: 5,
            text: "慈心冥想",
            data: "kindnessLiking",
            description: "適當地調節自己的情緒"),
        Option(
            question: 5, text: "我沒有任何偏好", data: "", description: "想嘗試以上三種冥想"),
      ],
    ),
  ],
  [
    Question(
      text: "自評肌力強度",
      options: [
        Option(
            question: 6,
            text: "LV.1 低強度",
            data: 40,
            description: "僅能完成 3 次左右的深蹲；能持續進行散步、輕量舉重"),
        Option(
            question: 6,
            text: "LV.2 中強度",
            data: 60,
            description: "一口氣完成 8-10 次的深蹲；能持續進行仰臥起坐"),
        Option(
            question: 6,
            text: "LV.3 高強度",
            data: 80,
            description: "一口氣完成 15 次以上的深蹲；能持續進行伏地挺身"),
      ],
    ),
    Question(
      text: "自評柔軟強度",
      options: [
        Option(
            question: 7,
            text: "LV.1 低強度",
            data: 40,
            description: "只能做簡單伸展動作，不一定保持姿勢正確性"),
        Option(
            question: 7,
            text: "LV.2 中強度",
            data: 60,
            description: "完成基本伸展動作，保持姿勢正確但未達高水平"),
        Option(
            question: 7,
            text: "LV.3 高強度",
            data: 80,
            description: "完成複雜伸展動作，並輕鬆保持每個姿勢正確"),
      ],
    ),
    Question(
      text: "自評心肺強度",
      options: [
        Option(
            question: 8,
            text: "LV.1 低強度",
            data: 40,
            description: "能持續快走 15-30 分鐘，結束後講話困難疲勞感強烈"),
        Option(
            question: 8,
            text: "LV.2 中強度",
            data: 60,
            description: "能持續慢跑 15-30 分鐘，結束能夠正常說話有疲勞感"),
        Option(
            question: 8,
            text: "LV.3 高強度",
            data: 80,
            description: "能持續跳繩 30 分鐘，結束能夠正常說話無疲勞感"),
      ],
    ),
  ]
];

// List of questions in part three
final questions_3 = [
  '當我處於極大壓力時，我常覺得自己快要崩潰',
  '我總是會按時完成計畫',
  '我在能發揮創意的環境下，做事最有效率',
  '我能和朋友建立和諧的關係',
  '看到別人的成功會使我感到壓力，讓我變得焦躁不安',
  '我會依事情的輕重緩急妥善安排時間',
  '我喜歡實驗新的做事方法',
  '我很能理解別人的感受',
  '即使是一個很小的煩惱也可能讓我感到挫敗',
  '我的目標明確，能按部就班地朝目標努力',
  '我樂在學習新事物',
  '我想要盡最大的能力幫助別人',
]; // 題目依照 "N,C,O,A" 順序循環排列
// (e.g. neuroticism ≡ 0, conscientiousness ≡ 1, openness ≡ 2, agreeableness ≡ 3)

// Define data type (Question & Option) for part two
class Option {
  final int question;
  final String text;
  final dynamic data;
  String description;

  Option({
    required this.question,
    required this.data,
    required this.text,
    this.description = "",
  });
}

class Question {
  final String text;
  final List<Option> options;
  final bool isMultiChoice;
  List<Option> selectedOptions;

  Question({
    required this.text,
    this.isMultiChoice = false,
    required this.options,
    List<Option>? selectedOptions,
  }) : selectedOptions = selectedOptions ?? [];
}

///////////////////////////////  Widget  ///////////////////////////////////////

// Build options for part two
class OptionsWidget extends StatelessWidget {
  final int index;
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    super.key,
    required this.index,
    required this.question,
    required this.onClickedOption,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> options =
        question.options.map((option) => buildOption(context, option)).toList();

    if (index < 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < options.length ~/ 2; i++) ...[
            Flexible(
              child: Row(children: [
                options[2 * i],
                const SizedBox(height: 10), // crossAxisSpacing
                options[2 * i + 1]
              ]),
            ),
            const SizedBox(height: 10), // mainAxisSpacing
          ]
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < options.length; i++) ...[
            options[i],
            const SizedBox(height: 8), // mainAxisSpacing
          ]
        ],
      );
    }
  }

  Widget buildOption(BuildContext context, Option option) {
    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: getBackground(option),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(2, 4), // changes position of shadow
            ),
          ],
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * (index < 2 ? 0.3 : 1),
          height: getHeight(option),
          child: ListTile(
            title: buildSelection(option),
            subtitle:
                (option.description != "") ? buildDescription(option) : null,
          ),
        ),
      ),
    );
  }

  Widget buildSelection(Option option) {
    return SizedBox(
      height: 50,
      child: (index < 2)
          ? Center(
              child: Text(
                option.text,
                style: const TextStyle(color: ColorSet.textColor, fontSize: 20),
                softWrap: true,
              ),
            )
          : Row(children: [
              const SizedBox(width: 12),
              Text(
                option.text,
                style: const TextStyle(color: ColorSet.textColor, fontSize: 20),
              )
            ]),
    );
  }

  Widget buildDescription(Option option) {
    return (question.selectedOptions.contains(option))
        ? Column(children: [
            Row(children: [
              const SizedBox(width: 12),
              Expanded(
                  child: SizedBox(
                width: 200,
                child: Text(
                  option.description,
                  style: const TextStyle(
                      color: ColorSet.textColor,
                      fontSize: 16,
                      fontStyle: FontStyle.italic),
                ),
              )),
            ]),
            const SizedBox(
              height: 15,
            )
          ])
        : Container();
  }

  Color getBackground(Option option) {
    if (question.selectedOptions.contains(option)) {
      return ColorSet.exerciseColor;
    } else {
      return ColorSet.backgroundColor;
    }
  }

  double getHeight(Option option) {
    if (question.selectedOptions.contains(option)) {
      if (index == 2) {
        return 90;
      } else if (index == 3) {
        return 120;
      }
    }
    return 60;
  }
}

// Build questions and options for part two
class QuestionsWidget extends StatelessWidget {
  final PageController pageController;
  final ScrollController scrollController;
  final ValueChanged<Option> onClickedOption;

  const QuestionsWidget({
    super.key,
    required this.pageController,
    required this.scrollController,
    required this.onClickedOption,
  });

  @override
  Widget build(BuildContext context) => PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        itemCount: questions_2.length,
        itemBuilder: (context, index) {
          final questions = questions_2[index];

          return buildPage(index: index, questions: questions);
        },
      );

  Widget buildPage({required int index, required List<Question> questions}) =>
      Container(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            for (int i = 0; i < (index == 3 ? 3 : 2); i++) ...[
              // 第四頁有三小題
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      questions[i].text,
                      style: const TextStyle(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 24),
                    OptionsWidget(
                        index: index,
                        question: questions[i],
                        onClickedOption: onClickedOption),
                    (i + 1 == (index == 3 ? 3 : 2)) // last item of this list
                        ? Container()
                        : const SizedBox(height: 32),
                  ],
                ),
              )
            ],
          ],
        ),
      );
}

////////////////////////////////  Page  ////////////////////////////////////////
class TitlePage extends StatefulWidget {
  final Map arguments;

  const TitlePage({super.key, required this.arguments});

  @override
  TitlePageState createState() => TitlePageState();
}

class TitlePageState extends State<TitlePage> {
  List title = ['第一部分\n基本資料', '第二部分\n習慣養成', '第三部分\n個人性格'];

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () {
      switch (widget.arguments['part']) {
        case 0:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PartOnePage()));
          break;
        case 1:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PartTwoPage()));
          break;
        case 2:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PartThreePage()));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.backgroundColor,
        body: WillPopScope(
          onWillPop: () async => false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 80, 35, 80),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                children: [
                  /*BubbleSpecialTwo(
                  text: 'bubble special tow with tail',
                  isSender: true,
                  color: Color(0xFFE8E8EE),
                  sent: true,
                ),*/
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 100, left: 50, right: 50),
                    child: Text(
                      title[widget.arguments['part']],
                      style: const TextStyle(
                        color: ColorSet.textColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 150),
                    child: Image.asset(
                      "assets/images/Rabbit_2.png",
                      width: 180,
                      height: 200,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Part I 基本資料
class PartOnePage extends StatefulWidget {
  const PartOnePage({super.key});

  @override
  PartOnePageState createState() => PartOnePageState();
}

class PartOnePageState extends State<PartOnePage> {
  final List keys = ["gender", "birthday", "height", "weight"];
  bool isComplete = false;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  bool checkCompletion() {
    for (String key in keys) {
      if (userInfo[key] == "") return false;
    }
    return true;
  }

  Color getForegroundColor(String key, String value) {
    return userInfo[key] == value ? ColorSet.textColor : ColorSet.textColor;
  }

  Color getBackgroundColor(String key, String value) {
    return userInfo[key] == value
        ? ColorSet.exerciseColor
        : ColorSet.backgroundColor;
  }

  TextStyle getQuestionStyle() {
    return const TextStyle(
      color: ColorSet.textColor,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    userInfo["gender"] = ""; // reset to default value
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorSet.backgroundColor,
        body: WillPopScope(
          onWillPop: () async => (Data.isFirstTime)
              ? ConfirmDialog()
                  .get(context, "確認退出", "此時離開頁面則視為註冊失敗，是否仍要退出？",
                      () => Navigator.pop(context, true),
                      btnCancelOnPress: () => false)
                  .show() as bool
              : true,
          child: ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(35, 75, 35, 0),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorSet.borderColor, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(5, 18, 5, 18),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            '生理性別',
                            style: getQuestionStyle(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: getBackgroundColor(
                                      "gender", "男"), // 按鈕顏色設定
                                ),
                                onPressed: () {
                                  setState(() {
                                    userInfo['gender'] = "男";
                                    isComplete = checkCompletion();
                                  });
                                },
                                child: Text(
                                  "男",
                                  style: TextStyle(
                                    color: getForegroundColor("gender", "男"),
                                    // 字體顏色設定
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 25),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      getBackgroundColor("gender", "女"),
                                ),
                                onPressed: () {
                                  setState(() {
                                    userInfo['gender'] = "女";
                                    isComplete = checkCompletion();
                                  });
                                },
                                child: Text(
                                  "女",
                                  style: TextStyle(
                                    color: getForegroundColor("gender", "女"),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            '生日',
                            style: getQuestionStyle(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                              color: ColorSet.backgroundColor,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DatePickerCupertino(
                              hintText: '請選擇日期',
                              style: const TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 15,
                              ),
                              onDateTimeChanged: (date) {
                                setState(() {
                                  userInfo['birthday'] =
                                      Calendar.dateToString(date);
                                  isComplete = checkCompletion();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            '身高',
                            style: getQuestionStyle(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            width: 250,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: ColorSet.backgroundColor),
                            child: TextField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                border: InputBorder.none,
                                hintText: '請輸入您的身高(cm)',
                                hintStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 15,
                                ),
                              ),
                              style: const TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 15,
                              ),
                              cursorColor: ColorSet.borderColor,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  userInfo['height'] = int.parse(value);
                                  isComplete = checkCompletion();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            '體重',
                            style: getQuestionStyle(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Container(
                            width: 250,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: ColorSet.backgroundColor),
                            child: TextField(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 9),
                                border: InputBorder.none,
                                hintText: '請輸入您的體重(kg)',
                                hintStyle: TextStyle(
                                  color: ColorSet.textColor,
                                  fontSize: 15,
                                ),
                              ),
                              style: const TextStyle(
                                color: ColorSet.textColor,
                                fontSize: 15,
                              ),
                              cursorColor: ColorSet.borderColor,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOut);
                                });

                                setState(() {
                                  userInfo["weight"] = double.parse(value);
                                  isComplete = checkCompletion();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 50),
                child: IconButton(
                  onPressed: () {
                    if (isComplete) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TitlePage(arguments: {"part": 1})));
                    } else {
                      ErrorDialog()
                          .get(
                            context,
                            "警告！",
                            "題目尚未填寫完畢喔~",
                          )
                          .show();
                    }
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 50,
                    color: (isComplete)
                        ? ColorSet.iconColor
                        : ColorSet.chartLineColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Part II 習慣養成
class PartTwoPage extends StatefulWidget {
  const PartTwoPage({super.key});

  @override
  PartTwoPageState createState() => PartTwoPageState();
}

class PartTwoPageState extends State<PartTwoPage> {
  final PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorSet.backgroundColor,
        body: WillPopScope(
          onWillPop: () async => (Data.isFirstTime)
              ? ConfirmDialog()
                  .get(context, "確認退出", "此時離開頁面則視為註冊失敗，是否仍要退出？",
                      () => Navigator.pop(context, true),
                      btnCancelOnPress: () => false)
                  .show() as bool
              : true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(35, 75, 35, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorSet.borderColor, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.fromLTRB(5, 18, 5, 18),
                  child: QuestionsWidget(
                    pageController: pageController,
                    scrollController: scrollController,
                    onClickedOption: selectOption,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 20, 50, 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (pageController.page == 0) {
                          ErrorDialog()
                              .get(context, "警告！", "無法返回\n您已經在第一頁嘍")
                              .show();
                        } else {
                          nextQuestion(goBack: true);
                        }
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_left_outlined,
                        size: 50,
                        color: ColorSet.iconColor,
                      ),
                    ),
                    const SizedBox(width: 200),
                    IconButton(
                      onPressed: () async {
                        if (isComplete) {
                          if (pageController.page == 3) {
                            // update the data into userInfo
                            processInput();
                            // clear the answers
                            for (int i = 0; i < 4; i++) {
                              for (Question q in questions_2[i]) {
                                q.selectedOptions.clear();
                              }
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TitlePage(arguments: {"part": 2})),
                            );
                          } else {
                            nextQuestion(goBack: false);
                          }
                        } else {
                          ErrorDialog()
                              .get(
                                context,
                                "警告！",
                                "題目尚未填寫完畢喔~",
                              )
                              .show();
                        }
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_right_outlined,
                        size: 50,
                        color: ColorSet.iconColor,
                      ),
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

  void selectOption(Option option) {
    bool isThreeQ = option.question > 5;
    int i = (isThreeQ) ? 3 : option.question ~/ 2;
    int j = option.question % (isThreeQ ? 3 : 2);
    Question question = questions_2[i][j];

    setState(() {
      if (question.selectedOptions.isEmpty) {
        question.selectedOptions.add(option);
      } else {
        if (question.selectedOptions.contains(option)) {
          question.selectedOptions.remove(option);
        } else {
          if (question.isMultiChoice == true) {
            // 若已選/改選 "我沒有任何偏好"或"每天"，則需先清空選項清單
            if (question.selectedOptions.first.text == "我沒有任何偏好" ||
                option.text == "我沒有任何偏好" ||
                question.selectedOptions.first.text == "每天" ||
                option.text == "每天") question.selectedOptions.clear();
            // 新增現在點選的選項
            question.selectedOptions.add(option);
          } else {
            question.selectedOptions[0] = option;
          }
        }
      }

      isComplete = checkCompletion(index: (pageController.page!).toInt());

      final position = scrollController.position;
      // P.0~P.2: scroll to position 0/1 when answering Q.0/Q.1
      // P.3: scroll to position 0/0.5/1 when answering Q.0/Q.1/Q.2
      final destination = position.maxScrollExtent * j * (i == 3 ? 0.5 : 1);
      final distance = (position.pixels - destination).round().abs();
      scrollController.animateTo(destination,
          duration: Duration(milliseconds: distance * 2),
          curve: (i == 1) ? Curves.fastOutSlowIn : Curves.easeInOut);
    });
  }

  void nextQuestion({required bool goBack}) {
    final indexPage = (pageController.page! + (goBack ? -1 : 1)).toInt();
    pageController.jumpToPage(indexPage);

    setState(() {
      isComplete = checkCompletion(index: indexPage);
    });
  }

  bool checkCompletion({required int index}) {
    for (int i = (index == 3) ? 0 : index; i <= index; i++) {
      // check if all questions are completed at the fourth page
      // else, check the given page only
      for (Question q in questions_2[i]) {
        if (q.selectedOptions.isEmpty) return false;
      }
    }
    return true;
  }

  // Process the user's input into pre-defined database format
  void processInput() {
    final List keys = [
      [
        "workoutTime",
        "workoutDays",
        "meditationTime",
        "meditationDays",
      ],
      [
        "workoutGoals",
        "meditationGoals",
      ],
      "",
      [
        "strengthAbility",
        "yogaAbility",
        "cardioAbility",
      ],
    ];

    userInfo["userName"] = Data.user?.displayName;
    for (int i = 0; i < questions_2.length; i++) {
      List questionGroup = questions_2[i];
      for (int j = 0; j < questionGroup.length; j++) {
        List answers = questionGroup[j].selectedOptions;

        if (i == 0) {
          dynamic result;
          if (j == 0) {
            // Get (0-0)workoutTime || Get (0-0)meditationTime
            result = answers.first.data;
          } else if (j == 1) {
            // Get (0-1)workoutDays || Get (0-1)meditationDays
            if (answers.first.text == "每天") {
              result = answers.first.data;
            } else {
              List days = [for (int k = 0; k < 7; k++) 0];
              for (Option option in answers) {
                // Set the day to 1 if is selected, else 0
                days[option.data] = 1;
              }
              result = days.join('');
            }
          }
          userInfo[keys[i][j]] = result;
          userInfo[keys[i][j + 2]] = result;
        } else if (i == 1 || i == 2) {
          // Get (1-0)workoutGoals || Get (1-1)meditationGoals
          List reasons =
              List.generate(answers.length, (index) => answers[index].text);
          // Joint all the answers into a string with ", "
          if (i == 1) userInfo[keys[1][j]] = reasons.join(", ");

          // Get (2-0)workoutLikings || Get (1-1)meditationLikings
          for (Option option in answers) {
            if (i == 2 && j == 0) {
              // Set the workoutLiking to 60 if is selected, else 40
              if (option.data.isNotEmpty) userInfo[option.data] += 20;
            } else if (i == 1 && j == 1) {
              // Count the occurrences for each meditation type (liking score)
              userInfo[option.data] += 5;
            }
          }
        } else if (i == 3) {
          // Get (3-0)strengthAbility, (3-1)yogaAbility, (3-2)cardioAbility
          userInfo[keys[i][j]] = answers.first.data;
        }
      }
    }
    debugPrint("Survey part 2: $userInfo");
  }
}

// Part III 個人性格
class PartThreePage extends StatefulWidget {
  const PartThreePage({super.key});

  @override
  PartThreePageState createState() => PartThreePageState();
}

class PartThreePageState extends State<PartThreePage>
    with SingleTickerProviderStateMixin {
  late final List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  final List keys = [
    "neuroticism",
    "conscientiousness",
    "openness",
    "agreeableness"
  ];

  @override
  void initState() {
    for (int i = 0; i < questions_3.length; i++) {
      _swipeItems.add(SwipeItem(
        content: questions_3[i],
        likeAction: () {
          processInput(i, 1);
        },
        nopeAction: () {
          processInput(i, -1);
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  // Process the user's input into pre-defined database format
  void processInput(int index, int score) {
    // neuroticism ≡ 0, conscientiousness ≡ 1, openness ≡ 2, agreeableness ≡ 3
    String key = keys[index % 4];
    int added = userInfo[key] += score;
    if (added == 3 || added == -3) {
      // the valid score of "N,C,O,A" is 1, -1
      userInfo[key] ~/= 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the animation controller
    AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create a curved animation for the repeating effect
    Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    // Add a status listener to reset the animation when it completes
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 250), () {
          controller.repeat();
        });
      }
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        body: WillPopScope(
          onWillPop: () async => (Data.isFirstTime)
              ? ConfirmDialog()
                  .get(context, "確認退出", "此時離開頁面則視為註冊失敗，是否仍要退出？",
                      () => Navigator.pop(context, true),
                      btnCancelOnPress: () => false)
                  .show() as bool
              : true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 80, 35, 80),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                // TODO: width fits the container of height narrow down
                width: 400.0,
                child: SwipeCards(
                  matchEngine: _matchEngine,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: ColorSet.backgroundColor,
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.all(30),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _swipeItems[index].content,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: ColorSet.textColor),
                              ),
                            ],
                          ),
                          Positioned(
                            left: 15,
                            top: 400,
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                controller.forward(); // 啟動動畫
                                return Transform.translate(
                                  offset: Offset(
                                      -10 + controller.value * -50, 0), // X軸位移
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.angleDoubleLeft,
                                        color: ColorSet.textColor,
                                        size: 40,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '否 Nope',
                                        style: TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: 15,
                            top: 400,
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                controller.forward(); // 啟動動畫
                                return Transform.translate(
                                  offset: Offset(
                                      10 + controller.value * 50, 0), // X軸位移
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        '是 Yes',
                                        style: TextStyle(
                                          color: ColorSet.textColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        FontAwesomeIcons.angleDoubleRight,
                                        color: ColorSet.textColor,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onStackFinished: () {
                    controller.dispose();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResultPage()));
                  },
                  itemChanged: (SwipeItem item, int index) {
                    debugPrint("$index. ${item.content}");
                  },
                  upSwipeAllowed: false,
                  fillSpace: true,
                  likeTag: Container(
                    margin: const EdgeInsets.all(24.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: const Text(
                      'YES',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  nopeTag: Container(
                    margin: const EdgeInsets.all(24.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: const Text(
                      'NOPE',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  bool isUpdating = false;
  String character = "";
  late Widget imageWidget;

  @override
  void initState() {
    super.initState();
    getCharacterImage();
  }

  void getCharacterImage() {
    String personalityType = "";
    personalityType += userInfo["neuroticism"] > 0 ? "N" : "S";
    personalityType += userInfo["openness"] > 0 ? "O" : "G";
    personalityType += userInfo["conscientiousness"] > 0 ? "C" : "F";

    // translate personality to character
    List personalities = [
      "NOC",
      "NOF",
      "NGC",
      "NGF",
      "SOC",
      "SOF",
      "SGC",
      "SGF"
    ];
    List characters = [
      "Fox_1",
      "Cat_1",
      "Pig_1",
      "Mouse_1",
      "Lion_1",
      "Sheep_1",
      "Dog_1",
      "Sloth_1"
    ];
    character = characters[personalities.indexOf(personalityType)];

    imageWidget = Image.asset("assets/images/$character.png", height: 250);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(35, 80, 35, 80),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              border: Border.all(color: ColorSet.textColor, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '以下為您所對應的人格角色：\n',
                  style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                imageWidget,
                const SizedBox(height: 20),
                isUpdating
                    ? Center(
                        child: LoadingAnimationWidget.horizontalRotatingDots(
                          color: ColorSet.bottomBarColor,
                          size: 100,
                        ),
                      )
                    : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorSet.textColor,
                          side: const BorderSide(
                            color: ColorSet.borderColor,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            isUpdating = true;
                          });

                          if (Data.isFirstTime) {
                            await UserDB.insert(userInfo);
                            await WeightDB.update({
                              Calendar.dateToString(DateTime.now()):
                                  (userInfo["weight"]).toDouble()
                            });
                            for (String habit in Data.habitTypes) {
                              await ClockDB.update(habit, {
                                for (int i = 0; i < 7; i++)
                                  "forecast_$i": "09:00"
                              });
                            }
                            await GamificationDB.insert(userInfo, character);
                            await Data.init();
                          }

                          if (!mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (Route<dynamic> route) => false);

                          setState(() {
                            isUpdating = false;
                          });
                        },
                        child: const Text("確認"),
                      ),
                isUpdating
                    ? const Text("個人化中",
                        style: TextStyle(color: ColorSet.hintColor))
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
