import 'package:flutter/material.dart';

import 'package:g12/services/Database.dart';
import 'package:g12/services/PlanAlgo.dart';
import 'dart:async';
import 'package:datepicker_cupertino/datepicker_cupertino.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swipe_cards/swipe_cards.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Quiz",
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: TitlePage(arguments: {"part": 0}),
      );
}

//////////////////////////////  Data Type  /////////////////////////////////////

// List of questions in part two
final questions = [
  Question(
    text: "運動時間 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "星期一", data: "1"),
      Option(text: "星期二", data: "2"),
      Option(text: "星期三", data: "3"),
      Option(text: "星期四", data: "4"),
      Option(text: "星期五", data: "5"),
      Option(text: "星期六", data: "6"),
      Option(text: "星期日", data: "0"),
    ],
  ),
  Question(
    text: "運動時長",
    options: [
      Option(text: "15分鐘", data: "15"),
      Option(text: "30分鐘", data: "30"),
      Option(text: "40分鐘", data: "45"),
      Option(text: "60分鐘", data: "60"),
    ],
  ),
  Question(
    text: "運動原因與目標 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "減重", data: "減重"),
      Option(text: "紓解壓力", data: "紓解壓力"),
      Option(text: "促進身體健康", data: "促進身體健康"),
      Option(text: "維持運動能力", data: "維持運動能力"),
      Option(text: "提升心肺耐力", data: "提升心肺耐力"),
      Option(text: "鍛鍊肌肉變強壯", data: "鍛鍊肌肉變強壯"),
      Option(text: "提升靈活與機動性", data: "提升靈活與機動性"),
    ],
  ),
  Question(
    text: "運動偏好 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "肌耐力訓練", data: "60", description: "輕量舉重、伏地挺身"),
      Option(text: "心肺耐力訓練", data: "60", description: "慢跑、飛輪、跳繩、游泳"),
      Option(text: "柔軟度訓練", data: "60", description: "瑜珈、皮拉提斯"),
      Option(text: "我沒有任何偏好", data: "0", description: "想嘗試以上三種運動"),
    ],
  ),
  Question(
    text: "肌耐力能力",
    options: [
      Option(
          text: "LV.1", data: "40", description: "僅能完成 3 次左右的深蹲；能持續進行散步、輕量舉重"),
      Option(text: "LV.2", data: "50", description: "一口氣完成 5-7 次的深蹲；能持續進行平板支撐"),
      Option(
          text: "LV.3", data: "60", description: "一口氣完成 8-10 次的深蹲；能持續進行仰臥起坐"),
      Option(
          text: "LV.4", data: "70", description: "一口氣完成 10-15 次的深蹲；能持續進行伏地挺身"),
      Option(
          text: "LV.5", data: "80", description: "一口氣完成 15 次以上的深蹲；能持續進行伏地挺身"),
    ],
  ),
  Question(
    text: "心肺耐力能力",
    options: [
      Option(
          text: "LV.1",
          data: "40",
          description: "能持續快走 15-30 分鐘，結束後講話困難有強烈疲勞感"),
      Option(
          text: "LV.2", data: "60", description: "能持續慢跑 15-30 分鐘，結束能夠正常說話有疲勞感"),
      Option(text: "LV.3", data: "80", description: "能持續跳繩 30 分鐘，結束能夠正常說話無疲勞感"),
    ],
  ),
  Question(
    text: "柔軟度能力",
    options: [
      Option(text: "LV.1", data: "40", description: "只能做簡單伸展動作，不一定保持姿勢正確性"),
      Option(text: "LV.2", data: "60", description: "完成基本伸展動作，保持姿勢正確但未達高水平"),
      Option(text: "LV.3", data: "80", description: "完成複雜伸展動作，並輕鬆保持每個姿勢正確"),
    ],
  ),
  Question(
    text: "冥想時間 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "星期一", data: "1"),
      Option(text: "星期二", data: "2"),
      Option(text: "星期三", data: "3"),
      Option(text: "星期四", data: "4"),
      Option(text: "星期五", data: "5"),
      Option(text: "星期六", data: "6"),
      Option(text: "星期日", data: "0"),
    ],
  ),
  Question(
    text: "冥想時長",
    options: [
      Option(text: "15分鐘", data: "15"),
      Option(text: "30分鐘", data: "30"),
      Option(text: "40分鐘", data: "45"),
      Option(text: "60分鐘", data: "60"),
    ],
  ),
  Question(
    text: "近期煩惱與關注面向 (複選)",
    isMultiChoice: true,
    options: [
      Option(text: "壓力", data: "bodyScan"),
      Option(text: "憂慮", data: "bodyScan"),
      Option(text: "失眠", data: "bodyScan"),
      Option(text: "專注", data: "bodyScan"),
      Option(text: "效率", data: "visualize"),
      Option(text: "動機", data: "visualize"),
      Option(text: "平靜", data: "visualize"),
      Option(text: "自愛", data: "kindness"),
      Option(text: "感激", data: "kindness"),
      Option(text: "人際", data: "kindness"),
      Option(text: "創造力", data: "visualize"),
      Option(text: "情感健康", data: "kindness"),
    ],
  ),
];

// Define data type (Question & Option) for part two
class Option {
  final String text;
  final String data;
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
  List<Option> selectedOption;

  Question({
    required this.text,
    this.isMultiChoice = false,
    required this.options,
    List<Option>? selectedOption,
  }) : selectedOption = selectedOption ?? [];
}

///////////////////////////////  Widget  ///////////////////////////////////////

// Build options for part two
class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    super.key,
    required this.question,
    required this.onClickedOption,
  });

  @override
  Widget build(BuildContext context) {
    List options =
        question.options.map((option) => buildOption(context, option)).toList();
    List<Widget> optionList = [options.first, const SizedBox(height: 8)];
    for (int i = 1; i < options.length - 1; i++) {
      final child = options[i];
      optionList.add(child);
      optionList.add(const SizedBox(height: 8));
    }
    optionList.add(options.last);

    return ListView(physics: BouncingScrollPhysics(), children: optionList);
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

    return Container(
      height: 50,
      child: Row(children: [
        const SizedBox(width: 12),
        Text(
          option.text,
          style: TextStyle(color: color, fontSize: 20),
        )
      ]),
    );
  }

  Widget buildDescription(Option option) {
    final color = getForeground(option);

    if (question.selectedOption.contains(option)) {
      return Row(children: [
        const SizedBox(width: 12),
        SizedBox(
          width: 200,
          child: Text(
            option.description,
            style: TextStyle(
                color: color, fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ),
      ]);
    } else {
      return Container();
    }
  }

  Color getBackground(Option option) {
    if (question.selectedOption.contains(option)) {
      return Colors.black87;
    } else {
      return Colors.white;
    }
  }

  Color getForeground(Option option) {
    if (question.selectedOption.contains(option)) {
      return Colors.white;
    } else {
      return Colors.black;
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

    return Container(
      height: 50,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: padding),
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
    final isAnswered = questions[index].selectedOption.isNotEmpty;

    Color color = isSelected
        ? Colors.orange.shade300
        : isAnswered
            ? Colors.grey
            : Colors.white;

    return GestureDetector(
      onTap: () => onClickedNumber(index),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.black,
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
          final question = questions[index];

          return buildQuestion(question: question);
        },
      );

  Widget buildQuestion({required Question question}) => Container(
        // decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/questionnaire_bg.jpg"),fit: BoxFit.cover,),),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: OptionsWidget(
                question: question,
                onClickedOption: onClickedOption,
              ),
            ),
          ],
        ),
      );
}

////////////////////////////////  Page  ////////////////////////////////////////

class TitlePage extends StatefulWidget {
  final Map arguments;

  const TitlePage({super.key, required this.arguments});

  @override
  _TitlePageState createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  List title = ['Part I\n基本資料', 'Part II\n習慣養成', 'Part III\n個人性格'];

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      switch (widget.arguments['part']) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PartOnePage()));
          break;
        case 1:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PartTwoPage()));
          break;
        case 2:
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PartThreePage()));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(36, 48, 36, 48),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: SizedBox(
              width: 400.0,
              child: TextLiquidFill(
                text: title[widget.arguments['part']],
                boxBackgroundColor: Colors.white,
                waveColor: Colors.orange.shade300,
                textStyle: const TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 400.0,
                loadDuration: const Duration(milliseconds: 1200),
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
  @override
  _PartOnePageState createState() => _PartOnePageState();
}

class _PartOnePageState extends State<PartOnePage> {
  late Map answer = {"gender": "", "birthday": "", "height": "", "weight": ""};
  bool isComplete = false;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  bool checkCompletion() {
    for (MapEntry e in answer.entries) {
      if (e.value == "") return false;
    }
    return true;
  }

  Color getForegroundColor(String key, String value) {
    return answer[key] == value ? Colors.white : Colors.black;
  }

  Color getBackgroundColor(String key, String value) {
    return answer[key] == value ? Colors.black87 : Colors.white;
  }

  TextStyle getQuestionStyle() {
    return const TextStyle(
      color: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 48, 36, 12),
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '性別',
                        style: getQuestionStyle(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
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
                                answer['gender'] = "男";
                                isComplete = checkCompletion();
                              });
                            },
                            child: Text(
                              "男",
                              style: TextStyle(
                                color:
                                    getForegroundColor("gender", "男"), // 字體顏色設定
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  getBackgroundColor("gender", "女"),
                            ),
                            onPressed: () {
                              setState(() {
                                answer['gender'] = "女";
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
                          SizedBox(width: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  getBackgroundColor("gender", "其他"),
                            ),
                            onPressed: () {
                              setState(() {
                                answer['gender'] = "其他";
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
                    SizedBox(height: 36),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '生日',
                        style: getQuestionStyle(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DatePickerCupertino(
                          hintText: '請選擇日期',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          onDateTimeChanged: (date) {
                            setState(() {
                              answer['birthday'] = Calendar.toKey(date);
                              isComplete = checkCompletion();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 36),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '身高',
                        style: getQuestionStyle(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Container(
                        width: 250,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white),
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 9),
                            border: InputBorder.none,
                            hintText: '請輸入您的身高(cm)',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              answer['height'] = value;
                              isComplete = checkCompletion();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 36),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '體重',
                        style: getQuestionStyle(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Container(
                        width: 250,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white),
                        child: TextField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 9),
                            border: InputBorder.none,
                            hintText: '請輸入您的體重(kg)',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              answer['weight'] = value;
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
            isComplete
                ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0.0),
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TitlePage(arguments: {"part": 1}))),
                      child: Icon(Icons.arrow_circle_right_outlined),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

// Part II 習慣養成
class PartTwoPage extends StatefulWidget {
  const PartTwoPage({super.key});

  @override
  _PartTwoPageState createState() => _PartTwoPageState();
}

class _PartTwoPageState extends State<PartTwoPage> {
  late PageController pageController;
  late ScrollController scrollController;
  late Question question;
  bool isComplete = false;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    pageController = PageController();
    question = questions.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 24, 36, 12),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: QuestionsWidget(
                  controller: pageController,
                  onChangedPage: (index) => nextQuestion(index: index),
                  onClickedOption: selectOption,
                ),
              ),
            ),
            isComplete
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0.0),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TitlePage(arguments: {"part": 2}))),
                    child: Icon(Icons.arrow_circle_right_outlined),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(context) => AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(26),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Container(
              height: 50,
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Container(width: 16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return buildNumber(index: index);
                },
              ),
            ),
          ),
        ),
      );

  Widget buildNumber({required int index}) {
    final isSelected = question == questions[index];
    final isAnswered = questions[index].selectedOption.isNotEmpty;

    Color color = isSelected
        ? Colors.orange.shade300
        : isAnswered
            ? Colors.grey
            : Colors.white;

    return GestureDetector(
      onTap: () => nextQuestion(index: index, jump: true),
      child: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void selectOption(Option option) {
    setState(() {
      if (question.selectedOption.isEmpty) {
        question.selectedOption.add(option);
      } else {
        if (question.selectedOption.contains(option)) {
          question.selectedOption.remove(option);
        } else {
          if (question.isMultiChoice == true) {
            question.selectedOption.add(option);
          } else {
            question.selectedOption[0] = option;
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
      question = questions[indexPage];
    });

    if (indexPage >= 5) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    if (jump) {
      pageController.jumpToPage(indexPage);
    }
  }

  bool checkCompletion() {
    for (Question q in questions) {
      if (q.selectedOption.isEmpty) return false;
    }
    return true;
  }
}

// Part III 個人性格
class PartThreePage extends StatefulWidget {
  const PartThreePage({super.key});

  @override
  _PartThreePageState createState() => _PartThreePageState();
}

class _PartThreePageState extends State<PartThreePage>
    with SingleTickerProviderStateMixin {
  late List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;

  @override
  void initState() {
    List<String> _list = [
      '當我處於極大壓力時，我常覺得自己快要崩潰',
      '看到別人的成功會使我感到壓力，讓我變得焦躁不安',
      '即使是一個很小的煩惱也可能讓我感到挫敗',
      '我總是會按時完成計畫',
      '我會依事情的輕重緩急妥善安排時間',
      '我的目標明確，能按部就班地朝目標努力',
      '我在能發揮創意的環境下，做事最有效率',
      '我喜歡實驗新的做事方法',
      '我樂在學習新事物',
      '我能和朋友建立和諧的關係',
      '我很能理解別人的感受',
      '我想要盡最大的能力幫助別人',
    ];

    for (int i = 0; i < _list.length; i++) {
      _swipeItems.add(SwipeItem(
        content: _list[i],
        likeAction: () {
          _recordSwipeResult(_list[i], true);
        },
        nopeAction: () {
          _recordSwipeResult(_list[i], false);
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  void _recordSwipeResult(String name, bool liked) {
    // TODO: 將結果回傳到資料庫，並處理相應的邏輯
    if (liked) {
      print("Liked $name");
      // 將 "是" 的結果回傳到資料庫
    } else {
      print("Disliked $name");
      // 將 "否" 的結果回傳到資料庫
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the animation controller
    AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create a curved animation for the repeating effect
    Animation<double> _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );

    // Add a status listener to reset the animation when it completes
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 250), () {
          _controller.repeat();
        });
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(36, 48, 36, 48),
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 400.0,
              child: SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.white,
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
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (index == 0) // 只在第一頁顯示
                          ...[
                          Positioned(
                            left: 15,
                            top: 400,
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                _controller.forward(); // 啟動動畫
                                return Transform.translate(
                                  offset: Offset(
                                      _controller.value * -50, 0), // X軸位移
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
                              animation: _controller,
                              builder: (context, child) {
                                _controller.forward(); // 啟動動畫
                                return Transform.translate(
                                  offset:
                                      Offset(_controller.value * 50, 0), // X軸位移
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Stack Finished"),
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                itemChanged: (SwipeItem item, int index) {
                  print("item: ${item.content}, index: $index");
                  print("item: ${item.content}, index: $index");
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
// TODO: connect to backend
class ResultPage extends StatefulWidget {
  final Map arguments;

  const ResultPage({super.key, required this.arguments});

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
        title: const Text(
          '測驗結果',
          style: TextStyle(
            color: Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFFAF0CA),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              '以下為您所對應的人格角色：\n',
              style: TextStyle(
                color: Color(0xFF0D3B66),
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            imageWidget,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA493),
              ),
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => false);
              },
              child: const Text("確認",
                  style: TextStyle(
                    color: Color(0xFF0D3B66),
                  )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
