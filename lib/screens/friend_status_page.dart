import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:g12/screens/page_material.dart';
import 'package:g12/services/page_data.dart';

class FriendStatusPage extends StatefulWidget {
  const FriendStatusPage({super.key});

  @override
  FriendStatusPageState createState() => FriendStatusPageState();
}

class FriendStatusPageState extends State<FriendStatusPage> {
  double getImageWidthPercentage() {
    String character = Data.characterName;
    String characterImageURL = Data.characterImageURL;
    double percentage = 0;

    if (character == "Mouse") {
      percentage = (characterImageURL.contains("_2")) ? 0.4 : 0.6;
    } else if (character == "Cat") {
      percentage = (characterImageURL.contains("_2")) ? 0.4 : 0.65;
    } else if (character == "Pig") {
      percentage = (characterImageURL.contains("_2")) ? 0.5 : 0.65;
    } else if (character == "Sheep") {
      percentage = (characterImageURL.contains("_2")) ? 0.65 : 0.6;
    } else if (character == "Dog") {
      percentage = (characterImageURL.contains("_2")) ? 0.55 : 0.5;
    } else if (character == "Fox") {
      percentage = (characterImageURL.contains("_2")) ? 0.55 : 0.5;
    }
    if (character == "Lion") {
      percentage = (characterImageURL.contains("_2")) ? 0.6 : 0.65;
    } else if (character == "Sloth") {
      percentage = 0.7;
    }
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorSet.backgroundColor,
        appBar: AppBar(
          backgroundColor: ColorSet.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: ColorSet.iconColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '${FriendData.userName} 的資訊',
            style: const TextStyle(
                color: ColorSet.textColor,
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
          //automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Image
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width *
                    getImageWidthPercentage(),
                child: Image.asset('assets/images/${FriendData.character}.png'),
              ),
              const SizedBox(height: 10),
              Text(
                FriendData.userName,
                style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "社交碼：${FriendData.socialCode}",
                style: const TextStyle(
                  color: ColorSet.textColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              // Information
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 3; i++) ...[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      width: MediaQuery.of(context).size.width * 0.29,
                      decoration: BoxDecoration(
                        color: ColorSet.backgroundColor,
                        border:
                            Border.all(color: ColorSet.borderColor, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon([
                                CupertinoIcons.star_circle,
                                Icons.fitness_center_outlined,
                                Icons.self_improvement_outlined
                              ][i], color: ColorSet.iconColor,),
                              const SizedBox(width: 10),
                              Text(
                                ["等級\n資訊", "運動\n寶物", "冥想\n寶物"][i],
                                style: const TextStyle(
                                    color: ColorSet.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Center(
                          child: Text(
                            "${[
                              FriendData.level,
                              FriendData.workoutGem,
                              FriendData.meditationGem
                            ][i]}",
                            style: const TextStyle(
                                color: ColorSet.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                    (i == 2) ? Container() : const SizedBox(width: 12),
                  ]
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "成就",
                  style: TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    List titles = ["運動累積時間", "冥想累積時間", "運動最大連續天數", "冥想最大連續天數"];
                    List icons = [
                      CupertinoIcons.timer,
                      CupertinoIcons.timer,
                      CupertinoIcons.chart_bar_alt_fill,
                      CupertinoIcons.chart_bar_alt_fill
                    ];

                    // method of rounding the number to given goal
                    int roundTo(int num, int goal) {
                      if (num % goal > 0) return (num ~/ goal) * goal + goal;
                      return num;
                    }

                    int value = (index < 2)
                        ? Random().nextInt(170) + 580
                        : Random().nextInt(15) + 5;
                    int goal =
                        (index < 2) ? roundTo(value, 500) : roundTo(value, 5);

                    return Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: ColorSet.backgroundColor,
                        border:
                            Border.all(color: ColorSet.borderColor, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 25),
                          Icon(
                            icons[index],
                            size: 40,
                            color: (index % 2) == 0
                                ? ColorSet.exerciseColor
                                : ColorSet.meditationColor,
                          ),
                          Expanded(
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "  ${titles[index]}",
                                  style: const TextStyle(
                                      color: ColorSet.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              subtitle: LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width * 0.48,
                                animation: true,
                                lineHeight: 15.0,
                                percent: value / goal,
                                trailing: Text(
                                  "$value / $goal",
                                  style: const TextStyle(
                                    color: ColorSet.textColor,
                                    fontSize: 12,
                                  ),
                                ),
                                barRadius: const Radius.circular(16),
                                backgroundColor: ColorSet.backgroundColor,
                                progressColor: (index % 2) == 0
                                    ? ColorSet.exerciseColor
                                    : ColorSet.meditationColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}