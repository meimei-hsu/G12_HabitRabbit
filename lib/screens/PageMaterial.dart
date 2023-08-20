import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

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
      BuildContext context, String title, String desc, Function btnOkOnPress) {
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
        btnOkText: '確定',
        btnOkColor: const Color(0xfff6cdb7),
        buttonsTextStyle: const TextStyle(
            color: Color(0xff4b4370),
            fontSize: 18,
            fontWeight: FontWeight.bold),
        btnOkOnPress: () {
          btnOkOnPress();
        },
        btnCancelText: '取消',
        btnCancelColor: const Color(0xfffdfdf5),
        btnCancelOnPress: () {});
  }
}
