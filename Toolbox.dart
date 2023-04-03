import 'dart:async';
import 'package:intl/intl.dart';

main() {
  Date date = new Date();
  date.getWeekday();
  CountdownTimer timer = new CountdownTimer();
  timer.oneSet();
}

class Date {
  void getWeekday() {
    DateTime date = DateTime.now();
    String weekday = DateFormat('EEEE').format(date);
    String day = DateFormat('MMMMd').format(date);
    print('$weekday, $day');
  }
}

class CountdownTimer {
  Timer? countdownTimer;
  Duration duration = Duration(seconds: 60);
  bool isEnded = false;

  // Add a method called startTimer() to start the timer.
  void start(int seconds, [Function? callback]) {
    duration = Duration(seconds: seconds);
    isEnded = false;

    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setCountDown();
      if (isEnded == true && callback != null) {
        callback();
      }
    });
  }

  // Add a method called stopTimer() to stop the timer.
  void stop() {
    countdownTimer!.cancel();
  }

  // Add a method called setCountDown() to update the countdown and rebuild the page.
  void setCountDown() {
    extractTime();
    final reduceSecondsBy = 1;
    final seconds = duration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      isEnded = true;
      stop();
    } else {
      duration = Duration(seconds: seconds);
    }
  }

  // Extract the hours,minutes and second from the current duration variable.
  void extractTime() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));
    print('$minutes:$seconds');
  }

  void oneSet() {
    CountdownTimer timer = new CountdownTimer();
    int work = 4, rest = 2;
    print('work');
    timer.start(work, () {
      print('rest');
      timer.start(rest);
    });
  }
}
