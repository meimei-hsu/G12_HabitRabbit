import 'dart:async';
//測試！！
main() {
  Date date = Date();
  date.getCalendar();
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