import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Event {
  final String title;

  Event(this.title);
}

class CalendarPage extends StatefulWidget {
  final String title;

  @override
  const CalendarPage({Key? key, required this.title}) : super(key: key);
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Color successColor = Colors.green;
  Color failureColor = Colors.red;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> events = {
    DateTime.now().subtract(Duration(days: 2)): [Event('Event 1')],
    DateTime.now().subtract(Duration(days: 1)): [Event('Event 2')],
    DateTime.now(): [Event('Event 3'), Event('Event 4')],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();

    DateTime today = DateTime.now();

    // 初始化事件为空列表
    for (int i = -3; i <= 3; i++) {
      DateTime date = _selectedDay.add(Duration(days: i));
      events[date] = [];
    }

    // 设置前三天为成功事件
    for (int i = 2; i >= 0; i--) {
      DateTime date = today.subtract(Duration(days: i));
      events[date] = [Event('success')];
    }

    // 设置最近三天为失败事件
    for (int i = 0; i < 3; i++) {
      DateTime date = today.add(Duration(days: i));
      events[date] = [Event('failure')];
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    //return events[day] ?? [];
    final eventsList = events[day];
    if (eventsList != null) {
      return eventsList;
    } else {
      // 如果没有事件列表，则返回一个空列表
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update _focusedDay here as well
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                DateTime startDay = day.subtract(Duration(days: 3));
                DateTime endDay = day.add(Duration(days: 3));

                List<Widget> eventDecorations = [];

                List<Event> eventsList = _getEventsForDay(day);
                Color eventColor = eventsList.any((event) => event.title == 'success') ? successColor : failureColor;

                if (eventsList.isNotEmpty) {
                  eventDecorations.add(
                    Positioned(
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eventColor,
                        ),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  );
                }

                // 遍历日期范围内的每一天
                for (DateTime date = startDay; date.isBefore(endDay); date = date.add(Duration(days: 1))) {
                  eventsList = _getEventsForDay(date);
                  eventColor = eventsList.any((event) => event.title == 'success') ? successColor : failureColor;

                  if (eventsList.isNotEmpty) {
                    eventDecorations.add(
                      Positioned(
                        bottom: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: eventColor,
                          ),
                          width: 16,
                          height: 16,
                        ),
                      ),
                    );
                  }
                }
                /*List<Widget> eventDecorations = [
      for (int i = 0; i < eventsList.length; i++)
      Positioned(
        bottom: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: eventColor,
          ),
          width: 16,
          height: 16,
        ),
      ),
      /*...events.map((event) => Positioned(
        bottom: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: eventColor,
          ),
          width: 16,
          height: 16,
        ),
      )).toList(),*/
    ];*/
                return eventDecorations;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  if (day.weekday == DateTime.sunday) {
                    final text = DateFormat.E().format(day);

                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected Day: $_selectedDay',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Events for Selected Day:',
              style: TextStyle(fontSize: 16),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _getEventsForDay(_selectedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay)[index];
                return ListTile(
                  title: Text(event.title),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}