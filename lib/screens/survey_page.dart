import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:datepicker_cupertino/datepicker_cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'dart:async';

import 'package:g12/services/database.dart';

import '../services/page_data.dart';
import '../services/plan_algo.dart';
import 'page_material.dart';

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
  "mindfulnessLiking": 0,
  "workLiking": 0,
  "kindnessLiking": 0,
};

// List of questions in part two
final questions_2 = [
  Question(
    text: "運動時間 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "星期一", data: 1),
      Option(text: "星期二", data: 2),
      Option(text: "星期三", data: 3),
      Option(text: "星期四", data: 4),
      Option(text: "星期五", data: 5),
      Option(text: "星期六", data: 6),
      Option(text: "星期日", data: 0),
    ],
  ),
  Question(
    text: "運動時長",
    options: [
      Option(text: "15分鐘", data: 15),
      Option(text: "30分鐘", data: 30),
      Option(text: "40分鐘", data: 45),
      Option(text: "60分鐘", data: 60),
    ],
  ),
  Question(
    text: "運動原因與目標 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "減脂減重", data: "減脂減重"),
      Option(text: "塑型增肌", data: "塑型增肌"),
      Option(text: "紓解壓力", data: "紓解壓力"),
      Option(text: "預防疾病", data: "預防疾病"),
      Option(text: "改善膚況", data: "改善膚況"),
      Option(text: "增強體力", data: "增強體力"),
      Option(text: "提升大腦功能", data: "提升大腦功能"),
      Option(text: "提升睡眠品質", data: "提升睡眠品質"),
    ],
  ),
  Question(
    text: "運動偏好 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "肌耐力訓練", data: "strengthLiking", description: "輕量舉重、伏地挺身"),
      Option(text: "心肺耐力訓練", data: "cardioLiking", description: "慢跑、飛輪、跳繩、游泳"),
      Option(text: "柔軟度訓練", data: "yogaLiking", description: "瑜珈、皮拉提斯"),
      Option(text: "我沒有任何偏好", data: "", description: "想嘗試以上三種運動"),
    ],
  ),
  Question(
    text: "肌耐力能力",
    options: [
      Option(
          text: "LV.1 低強度",
          data: 40,
          description: "僅能完成 3 次左右的深蹲；能持續進行散步、輕量舉重"),
      Option(
          text: "LV.2 中強度", data: 60, description: "一口氣完成 8-10 次的深蹲；能持續進行仰臥起坐"),
      Option(
          text: "LV.3 高強度", data: 80, description: "一口氣完成 15 次以上的深蹲；能持續進行伏地挺身"),
    ],
  ),
  Question(
    text: "心肺耐力能力",
    options: [
      Option(
          text: "LV.1 低強度",
          data: 40,
          description: "能持續快走 15-30 分鐘，結束後講話困難疲勞感強烈"),
      Option(
          text: "LV.2 中強度",
          data: 60,
          description: "能持續慢跑 15-30 分鐘，結束能夠正常說話有疲勞感"),
      Option(
          text: "LV.3 高強度", data: 80, description: "能持續跳繩 30 分鐘，結束能夠正常說話無疲勞感"),
    ],
  ),
  Question(
    text: "柔軟度能力",
    options: [
      Option(text: "LV.1 低強度", data: 40, description: "只能做簡單伸展動作，不一定保持姿勢正確性"),
      Option(text: "LV.2 中強度", data: 60, description: "完成基本伸展動作，保持姿勢正確但未達高水平"),
      Option(text: "LV.3 高強度", data: 80, description: "完成複雜伸展動作，並輕鬆保持每個姿勢正確"),
    ],
  ),
  Question(
    text: "冥想時間 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "星期一", data: 1),
      Option(text: "星期二", data: 2),
      Option(text: "星期三", data: 3),
      Option(text: "星期四", data: 4),
      Option(text: "星期五", data: 5),
      Option(text: "星期六", data: 6),
      Option(text: "星期日", data: 0),
    ],
  ),
  Question(
    text: "冥想時長",
    options: [
      Option(text: "15分鐘", data: 15),
      Option(text: "30分鐘", data: 30),
      Option(text: "40分鐘", data: 45),
      Option(text: "60分鐘", data: 60),
    ],
  ),
  Question(
    text: "想提升或改善的面向\n(複選)",
    isMultiChoice: true,
    options: [
      Option(text: "壓力", data: "mindfulnessLiking"),
      Option(text: "憂慮", data: "mindfulnessLiking"),
      Option(text: "效率", data: "workLiking"),
      Option(text: "動機", data: "workLiking"),
      Option(text: "平靜", data: "mindfulnessLiking"),
      Option(text: "自愛", data: "kindnessLiking"),
      Option(text: "感激", data: "kindnessLiking"),
      Option(text: "人際", data: "kindnessLiking"),
      Option(text: "專注力", data: "workLiking"),
      Option(text: "創造力", data: "workLiking"),
      Option(text: "覺察力", data: "mindfulnessLiking"),
      Option(text: "情緒健康", data: "kindnessLiking"),
    ],
  ),
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
  final String text;
  final dynamic data;
  String description;

  Option({
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

    if (index != 9) {
      // Q1 ~ Q9
      List<Widget> optionList = [options.first, const SizedBox(height: 8)];
      for (int i = 1; i < options.length - 1; i++) {
        final child = options[i];
        optionList.add(child);
        optionList.add(const SizedBox(height: 8));
      }
      optionList.add(options.last);
      return ListView(
          physics: const BouncingScrollPhysics(), children: optionList);
    } else {
      // Q10
      return GridView.count(
        crossAxisCount: 2,
        // number of columns
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.7,
        physics: const BouncingScrollPhysics(),
        children: options,
      );
    }
  }

  Widget buildOption(BuildContext context, Option option) {
    final color = getBackground(option);

    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(2, 4), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            title: buildSelection(option),
            subtitle:
                (option.description != "") ? buildDescription(option) : null,
          )),
    );
  }

  Widget buildSelection(Option option) {
    final color = getForeground(option);

    if (index != 9) {
      // Q1 ~ Q9
      return SizedBox(
        height: 50,
        child: Row(children: [
          const SizedBox(width: 12),
          Text(
            option.text,
            style: TextStyle(color: color, fontSize: 20),
          )
        ]),
      );
    } else {
      // Q10
      return SizedBox(
        height: 50,
        child: Center(
          child: Text(
            option.text,
            style: TextStyle(color: color, fontSize: 20),
          ),
        ),
      );
    }
  }

  Widget buildDescription(Option option) {
    final color = getForeground(option);

    if (question.selectedOptions.contains(option)) {
      return Column(children: [
        Row(children: [
          const SizedBox(width: 12),
          Expanded(
              child: SizedBox(
            width: 200,
            child: Text(
              option.description,
              style: TextStyle(
                  color: color, fontSize: 16, fontStyle: FontStyle.italic),
            ),
          )),
        ]),
        const SizedBox(
          height: 15,
        )
      ]);
    } else {
      return Container();
    }
  }

  Color getBackground(Option option) {
    if (question.selectedOptions.contains(option)) {
      return ColorSet.exerciseColor;
    } else {
      return ColorSet.backgroundColor;
    }
  }

  Color getForeground(Option option) {
    if (question.selectedOptions.contains(option)) {
      return ColorSet.textColor;
    } else {
      return ColorSet.textColor;
    }
  }
}

// Build navigation bar for questions in part two
class QuestionNumbersWidget extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final List<Question> questions;
  final Question question;
  final ValueChanged<int> onClickedNumber;

  QuestionNumbersWidget({
    super.key,
    required this.questions,
    required this.question,
    required this.onClickedNumber,
  });

  @override
  Widget build(BuildContext context) {
    const double padding = 16;

    return SizedBox(
      height: 50,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: padding),
        controller: _controller,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => Container(width: padding),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return buildNumber(index: index);
        },
      ),
    );
  }

  Widget buildNumber({required int index}) {
    final isSelected = question == questions[index];
    final isAnswered = questions[index].selectedOptions.isNotEmpty;

    Color color = isSelected
        ? ColorSet.exerciseColor
        : isAnswered
            ? ColorSet.bottomBarColor
            : ColorSet.backgroundColor;

    return GestureDetector(
      onTap: () => onClickedNumber(index),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: ColorSet.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

// Build questions and options for part two
class QuestionsWidget extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Option> onClickedOption;

  const QuestionsWidget({
    super.key,
    required this.controller,
    required this.onChangedPage,
    required this.onClickedOption,
  });

  @override
  Widget build(BuildContext context) => PageView.builder(
        onPageChanged: onChangedPage,
        controller: controller,
        itemCount: 10,
        itemBuilder: (context, index) {
          final question = questions_2[index];

          return buildQuestion(index: index, question: question);
        },
      );

  Widget buildQuestion({required int index, required Question question}) =>
      Container(
        // decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/questionnaire_bg.jpg"),fit: BoxFit.cover,),),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: const TextStyle(
                color: ColorSet.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: OptionsWidget(
                index: index,
                question: question,
                onClickedOption: onClickedOption,
              ),
            ),
          ],
        ),
      );
}

////////////////////////////////  Page  ////////////////////////////////////////
// TODO: Adjust UI to fit other pages
class TitlePage extends StatefulWidget {
  final Map arguments;

  const TitlePage({super.key, required this.arguments});

  @override
  TitlePageState createState() => TitlePageState();
}

class TitlePageState extends State<TitlePage> {
  List title = ['Part I\n基本資料', 'Part II\n習慣養成', 'Part III\n個人性格'];

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
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
        appBar:
            AppBar(backgroundColor: ColorSet.backgroundColor, elevation: 0.0),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(36, 48, 36, 48),
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
                  padding: const EdgeInsets.only(top: 100, left: 50, right: 50),
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
    super.dispose();
  }

  // FIXME: Overflow problem has fixed, but there is also "Incorrect use of ParentDataWidget." problem need to fix.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:
            AppBar(backgroundColor: ColorSet.backgroundColor, elevation: 0.0),
        body: ListView(controller: _scrollController, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(35, 50, 35, 0),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                border: Border.all(color: ColorSet.borderColor, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.fromLTRB(5, 18, 5, 18),
              child: Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '性別',
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
                            backgroundColor:
                                getBackgroundColor("gender", "男"), // 按鈕顏色設定
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
                            backgroundColor: getBackgroundColor("gender", "女"),
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
                        const SizedBox(width: 25),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: getBackgroundColor("gender", "其他"),
                          ),
                          onPressed: () {
                            setState(() {
                              userInfo['gender'] = "其他";
                              isComplete = checkCompletion();
                            });
                          },
                          child: Text(
                            "其他",
                            style: TextStyle(
                              color: getForegroundColor("gender", "其他"),
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
                            userInfo['birthday'] = Calendar.dateToString(date);
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: ColorSet.backgroundColor),
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 9),
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
                            userInfo['height'] = value;
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: ColorSet.backgroundColor),
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 9),
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut);
                          });

                          setState(() {
                            userInfo['weight'] = value;
                            isComplete = checkCompletion();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ))),
            ),
          ),
          isComplete
              ? Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: IconButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TitlePage(arguments: {"part": 1}))),
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 50,
                        color: ColorSet.iconColor,
                      )),
                )
              : Container(),
        ]),
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
  late PageController pageController;
  late ScrollController scrollController;

  final ScrollController _scrollController = ScrollController();

  late Question question;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    pageController = PageController();
    question = questions_2.first;
  }

  // FIXME: Overflow problem has fixed, but there is also "Incorrect use of ParentDataWidget." problem need to fix.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorSet.borderColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.fromLTRB(5, 18, 5, 18),
                child: QuestionsWidget(
                  controller: pageController,
                  onChangedPage: (index) => nextQuestion(index: index),
                  onClickedOption: selectOption,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 20),
              child: IconButton(
                onPressed: () async {
                  if (isComplete) {
                    processInput(); // update the data into userInfo
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TitlePage(arguments: {"part": 2})),
                    );
                  } else {
                    if (pageController.page == 9) {
                      AwesomeDialog dlg = InformDialog().get(
                        context,
                        "尚未完成",
                        "題目尚未填寫完畢喔~",
                      );

                      await dlg.show();
                    } else {
                      nextQuestion(index: null, jump: true);
                    }
                  }
                },
                icon: const Icon(Icons.arrow_circle_right_outlined, size: 50,
                  color: ColorSet.iconColor,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(context) => AppBar(
        backgroundColor: ColorSet.backgroundColor,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(26),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Container(width: 16),
                itemCount: questions_2.length,
                itemBuilder: (context, index) {
                  return buildNumber(index: index);
                },
              ),
            ),
          ),
        ),
      );

  Widget buildNumber({required int index}) {
    final isSelected = question == questions_2[index];
    final isAnswered = questions_2[index].selectedOptions.isNotEmpty;

    Color color = isSelected
        ? ColorSet.exerciseColor
        : isAnswered
            ? ColorSet.bottomBarColor
            : ColorSet.backgroundColor;

    return GestureDetector(
      onTap: () => nextQuestion(index: index, jump: true),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: ColorSet.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void selectOption(Option option) {
    setState(() {
      if (question.selectedOptions.isEmpty) {
        question.selectedOptions.add(option);
      } else {
        if (question.selectedOptions.contains(option)) {
          question.selectedOptions.remove(option);
        } else {
          if (pageController.page == 3 &&
              question.selectedOptions.first.text == "我沒有任何偏好") {
            // 若問題為運動偏好，且已選"我沒有任何偏好"，則清空選項清單並新增現在點選的選項
            question.selectedOptions.clear();
            question.selectedOptions.add(option);
          }

          if (question.isMultiChoice == true) {
            question.selectedOptions.add(option);
          } else {
            question.selectedOptions[0] = option;
          }

          if (option.text == "我沒有任何偏好") {
            // 若選擇"我沒有任何偏好"，則清空選項清單並新增現在點選的選項
            question.selectedOptions.clear();
            question.selectedOptions.add(option);
          }
        }
      }

      isComplete = checkCompletion();
    });
  }

  void nextQuestion({required int? index, bool jump = false}) {
    final nextPage = pageController.page! + 1;
    final indexPage = index ?? nextPage.toInt();

    setState(() {
      question = questions_2[indexPage];
    });

    if (indexPage >= 5) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    if (jump) {
      pageController.jumpToPage(indexPage);
    }
  }

  bool checkCompletion() {
    for (Question q in questions_2) {
      if (q.selectedOptions.isEmpty) return false;
    }
    return true;
  }

  // Process the user's input into pre-defined database format
  void processInput() {
    final List keys = [
      "workoutDays",
      "workoutTime",
      "workoutGoals",
      "",
      "strengthAbility",
      "cardioAbility",
      "yogaAbility",
      "meditationDays",
      "meditationTime",
      "meditationGoals",
    ];

    for (int i = 0; i < questions_2.length; i++) {
      List answer = questions_2[i].selectedOptions;
      if (i == 0 || i == 7) {
        // Get workoutDays || meditationDays
        List days = [for (int j = 0; j < 7; j++) 0];
        for (Option option in answer) {
          // Set the day to 1 if is selected, else 0
          days[option.data] = 1;
        }
        userInfo[keys[i]] = days.join('');
      } else if (i == 1 || i == 8) {
        // Get workoutTime || meditationTime
        userInfo[keys[i]] = answer.first.data;
      } else if (i == 2) {
        // Get workoutGoals
        // Joint all the answers into a string with ", "
        userInfo[keys[i]] =
            List.generate(answer.length, (index) => answer[index].data)
                .join(", ");
      } else if (i == 3) {
        // Get the liking of the three workout types
        for (Option option in answer) {
          // Set the liking to 60 if is selected, else 40
          userInfo[option.data] += 20;
        }
      } else if (i == 4 || i == 5 || i == 6) {
        // Get the ability of the three workout types
        userInfo[keys[i]] = answer.first.data;
      } else if (i == 9) {
        // Get meditationGoals
        // Joint all the answers into a string with ", "
        List reasons =
            List.generate(answer.length, (index) => answer[index].text);
        userInfo[keys[i]] = reasons.join(", ");

        // Get the liking of the three meditation types
        for (Option option in answer) {
          // Count the occurrences for each type (liking score)
          userInfo[option.data] += 1;
        }

        for (String type in [
          "mindfulnessLiking",
          "workLiking",
          "kindnessLiking"
        ]) {
          // Multiply the liking score by 5 then add the base score 40
          userInfo[type] *= 5;
          userInfo[type] += 40;
        }
      }
    }
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
        appBar:
            AppBar(backgroundColor: ColorSet.backgroundColor, elevation: 0.0),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(36, 48, 36, 48),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              border: Border.all(color: ColorSet.borderColor, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
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
                                  fontSize: 30, fontWeight: FontWeight.bold, color: ColorSet.textColor),
                            ),
                          ],
                        ),
                        if (index == 0) // 只在第一頁顯示
                          ...[
                          Positioned(
                            left: 15,
                            top: 400,
                            child: AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                controller.forward(); // 啟動動畫
                                return Transform.translate(
                                  offset:
                                      Offset(controller.value * -50, 0), // X軸位移
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.angleDoubleLeft,
                                        size: 40,
                                      ),
                                      SizedBox(width: 6),
                                      Text('否 NO'),
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
                                  offset:
                                      Offset(controller.value * 50, 0), // X軸位移
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text('是 Yes'),
                                      SizedBox(width: 6),
                                      Icon(
                                        FontAwesomeIcons.angleDoubleRight,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
    );
  }
}

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
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
        appBar:
            AppBar(backgroundColor: ColorSet.backgroundColor, elevation: 0.0),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(36, 48, 36, 12),
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
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorSet.textColor,
                    side: const BorderSide(
                      color: ColorSet.borderColor,
                    ),
                  ),
                  onPressed: () async {
                    await UserDB.insert(userInfo);
                    await GamificationDB.insert(userInfo, character);
                    await Data.init();
                    await PlanAlgo.execute();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (Route<dynamic> route) => false);
                  },
                  child: const Text("確認"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
