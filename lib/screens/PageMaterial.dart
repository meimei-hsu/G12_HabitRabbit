import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InformDialog {
  AwesomeDialog get(BuildContext context, String title, String desc,
      {Function? btnOkOnPress}) {
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
        dialogBackgroundColor: const Color(0xfffdfdf5),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        desc: desc,
        descTextStyle: const TextStyle(
          color: Color(0xff4b4370),
          fontSize: 16,
        ),
        title: title,
        titleTextStyle: const TextStyle(
            color: Color(0xfff6cdb7),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        btnOkText: '好',
        btnOkColor: const Color(0xfff6cdb7),
        buttonsTextStyle: const TextStyle(
            color: Color(0xff4b4370),
            fontSize: 18,
            fontWeight: FontWeight.bold),
        btnOkOnPress: () {
          (btnOkOnPress != null) ? btnOkOnPress() : null;
        });
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
        dialogBackgroundColor: const Color(0xfffdfdf5),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        desc: desc,
        descTextStyle: const TextStyle(
          color: Color(0xff4b4370),
          fontSize: 16,
        ),
        title: title,
        titleTextStyle: const TextStyle(
            color: Color(0xfff6cdb7),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        btnOkText: (options != null) ? options[0] : '確定',
        btnOkColor: const Color(0xfff6cdb7),
        buttonsTextStyle: const TextStyle(
            color: Color(0xff4b4370),
            fontSize: 18,
            fontWeight: FontWeight.bold),
        btnOkOnPress: () {
          btnOkOnPress();
        },
        btnCancelText: (options != null) ? options[1] : '取消',
        btnCancelColor: const Color(0xfffdfdf5),
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
      glowColor: const Color(0xffd4d6fc),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                      const TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                  style: TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
                      const TextStyle(color: Color(0xff4b4370), fontSize: 18),
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
