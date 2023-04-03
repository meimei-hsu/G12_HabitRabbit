import 'dart:async';

main() {
  Date date = new Date();
  date.getCalendar();
  CountdownTimer timer = new CountdownTimer();
  timer.oneSet();
}

class Date {
  // Method to generate a 2-week-long calendar
  List<String> getCalendar() {
    DateTime today = DateTime.now();
    // Get the first day of the current week
    DateTime startDay = today.subtract(Duration(days: today.weekday - 1));
    // Get the last day of the 2-week period
    DateTime endDay = startDay.add(Duration(days: 14));

    List<String> twoWeekCalendar = [];

    // Loop through the days in the 2-week period and add them to the list
    for (DateTime date = startDay;
        date.isBefore(endDay);
        date = date.add(Duration(days: 1))) {
      twoWeekCalendar.add(
          "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}");
    }
    print('twoWeekCalendar: $twoWeekCalendar');

    return twoWeekCalendar;
  }
}

class CountdownTimer {
  Timer? countdownTimer;
  Duration duration = Duration(seconds: 60);
  bool isEnded = false;

  void start(int seconds, [Function? callback]) {
    // Set the duration of the timer and reset the isEnded flag
    duration = Duration(seconds: seconds);
    isEnded = false;

    // Start the timer and call the setCountDown() method every second
    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      setCountDown();
      // If the timer has ended, call the callback function (if provided)
      if (isEnded == true) {
        callback?.call();
      }
    });
  }

  void stop() {
    countdownTimer!.cancel();
  }

  // Method to update the countdown and rebuild the page
  void setCountDown() {
    extractTime();

    // Reduce the duration by one second
    final reduceSecondsBy = 1;
    final seconds = duration.inSeconds - reduceSecondsBy;

    // If the timer has ended, stop the timer
    if (seconds < 0) {
      isEnded = true;
      stop();
    } else {
      // Otherwise, update the duration with the reduced value
      duration = Duration(seconds: seconds);
    }
  }

  // Method to extract the hours, minutes, and seconds from the current duration
  void extractTime() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));
    print('$minutes:$seconds');
  }

  // Method to start a timer with a work period followed by a rest period
  void oneSet() {
    CountdownTimer timer = new CountdownTimer();
    int work = 4, rest = 2;
    // Start the work period and call the rest period when it ends
    print('work');
    timer.start(work, () {
      print('rest');
      timer.start(rest);
    });
  }
}
