import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../services/page_data.dart';

class ColorSet {
  static const Color backgroundColor = Color(0xFFFDFDFD);
  static const Color bottomBarColor = Color(0xFFF4F4F6);
  static const Color chartLineColor = Color(0xFFCAD2D2);
  static const Color failColor = Color(0xFFFEE8E8);
  static const Color successColor = Color(0xFFDEF0DE);
  static const Color exerciseColor = Color(0xFFFAE5DA);
  static const Color meditationColor = Color(0xFFE9EAFD);
  static const Color friendColor = Color(0xFFFAE5DA);
  static const Color usersColor = Color(0xFFE9EAFD);
  static const Color textColor = Color(0xFF2F4F4F);
  static const Color iconColor = Color(0xFF2F4F4F);
  static const Color borderColor = Color(0xFF2F4F4F);
  static const Color buttonColor = Color(0xFFFAE5DA);
  static const Color errorColor = Color(0xFFFAE5DA);
  static const Color hintColor = Color(0xFFCAD2D2);
}

class InformDialog {
  AwesomeDialog get(BuildContext context, String title, String desc,
      {Function? btnOkOnPress}) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        width: MediaQuery.of(context).size.width * 0.9,
        customHeader: Image.asset(
          height: 75,
          width: 75,
          'assets/images/Carrot.png',
        ),
        dialogBorderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        buttonsBorderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        dialogBackgroundColor: ColorSet.backgroundColor,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        desc: desc,
        descTextStyle: const TextStyle(
          color: ColorSet.textColor,
          fontSize: 16,
        ),
        title: title,
        titleTextStyle: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        btnOkText: '好',
        btnOkColor: ColorSet.buttonColor,
        buttonsTextStyle: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold),
        btnOkOnPress: () {
          (btnOkOnPress != null) ? btnOkOnPress() : null;
        });
  }
}

class HintDialog {
  AwesomeDialog get(BuildContext context, String title, String selectableText,
      {Function? btnOkOnPress}) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        width: MediaQuery.of(context).size.width * 0.9,
        customHeader: Image.asset(
          height: 75,
          width: 75,
          'assets/images/Carrot.png',
        ),
        dialogBorderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        buttonsBorderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        dialogBackgroundColor: ColorSet.backgroundColor,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        body: Center(
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: ColorSet.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SelectableText(
                selectableText,
                style: const TextStyle(color: ColorSet.textColor, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        btnOkText: '好',
        btnOkColor: ColorSet.buttonColor,
        buttonsTextStyle: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold),
        btnOkOnPress: () {
          (btnOkOnPress != null) ? btnOkOnPress() : null;
        });
  }
}

class CongratsDialog {
  static void show(BuildContext context,
      {required String habit, required Widget widgetAfterDismiss}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final ConfettiController controller =
            ConfettiController(duration: const Duration(seconds: 3))
              ..play(); // start the animation
        Future.delayed(const Duration(seconds: 4), () {
          Navigator.pop(context);
          showModalBottomSheet(
              isDismissible: false,
              isScrollControlled: true,
              enableDrag: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              backgroundColor: ColorSet.bottomBarColor,
              context: context,
              builder: (context) => widgetAfterDismiss);
        });
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    const Text(
                      "你做到了！",
                      style: TextStyle(
                          color: ColorSet.buttonColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "恭喜獲得${(habit == "workout") ? "運動" : "冥想"}寶物，你的小${Data.characterNameZH}很愛你呦~",
                      style: const TextStyle(
                          color: ColorSet.buttonColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                        height: 150,
                        width: 150,
                        (habit == "workout")
                            ? Data.workoutGemImageUrl
                            : Data.meditationGemImageUrl),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: controller,
                blastDirection: pi / 2,
                maxBlastForce: 5,
                minBlastForce: 1,
                emissionFrequency: 0.02,
                numberOfParticles: 10,
                gravity: 0, // particles will pop-up
              ),
            ),
          ],
        );
      },
    );
  }
}

class ConfirmDialog {
  AwesomeDialog get(
      BuildContext context, String title, String desc, Function btnOkOnPress,
      {Function? btnCancelOnPress, List? options}) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        width: MediaQuery.of(context).size.width * 0.9,
        dialogBorderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        buttonsBorderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        dialogBackgroundColor: ColorSet.backgroundColor,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        desc: desc,
        descTextStyle: const TextStyle(
          color: ColorSet.textColor,
          fontSize: 16,
        ),
        title: title,
        titleTextStyle: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        btnOkText: (options != null) ? options[0] : '確定',
        btnOkColor: ColorSet.buttonColor,
        buttonsTextStyle: const TextStyle(
            color: ColorSet.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold),
        btnOkOnPress: () {
          btnOkOnPress();
        },
        btnCancelText: (options != null) ? options[1] : '取消',
        btnCancelColor: ColorSet.backgroundColor,
        btnCancelOnPress: () {
          (btnCancelOnPress != null) ? btnCancelOnPress() : null;
        });
  }
}

class RatingScoreBar {
  RatingBar getSatisfiedScoreBar(Function onRatingUpdate) {
    return RatingBar.builder(
      initialRating: 0,
      itemCount: 5,
      itemSize: 60,
      glowColor: ColorSet.hintColor,
      glowRadius: 1,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_very_dissatisfied_rounded,
                  color: Colors.red.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "不滿意",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 1:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  color: Colors.redAccent.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 2:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_neutral_rounded,
                  color: Colors.amber.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "還行",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 3:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_satisfied_rounded,
                  color: Colors.lightGreen.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 4:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_very_satisfied_rounded,
                  color: Colors.green.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "非常滿意",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          default:
            return Container();
        }
      },
      onRatingUpdate: (rating) {
        onRatingUpdate(rating);
      },
    );
  }

  RatingBar getTiredScoreBar(Function onRatingUpdate, type) {
    return RatingBar.builder(
      initialRating: 0,
      itemCount: 5,
      itemSize: 60,
      glowColor: const Color(0xffd4d6fc),
      glowRadius: 1,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Column(
              children: [
                Icon(
                  Icons.add_reaction_outlined,
                  color: Colors.green.withOpacity(0.6),
                  size: 50,
                ),
                Text(
                  (type == 0) ? "完全不累" : "太短",
                  style:
                      const TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 1:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_satisfied_rounded,
                  color: Colors.lightGreen.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 2:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_neutral_rounded,
                  color: Colors.amber.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "剛好",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 3:
            return Column(
              children: [
                Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  color: Colors.redAccent.withOpacity(0.6),
                  size: 50,
                ),
                const Text(
                  "",
                  style: TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          case 4:
            return Column(
              children: [
                Icon(
                  Icons.sick_outlined,
                  color: Colors.red.withOpacity(0.6),
                  size: 50,
                ),
                Text(
                  (type == 0) ? "非常累" : "太長",
                  style:
                      const TextStyle(color: ColorSet.textColor, fontSize: 18),
                )
              ],
            );
          default:
            return Container();
        }
      },
      onRatingUpdate: (rating) {
        onRatingUpdate(rating);
      },
    );
  }
}
