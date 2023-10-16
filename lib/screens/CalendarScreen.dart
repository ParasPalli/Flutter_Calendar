import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import '../utils/CalenderAuth.dart';
import 'SignInScreen.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Calender"),
        actions: [
          IconButton(
            onPressed: () {
              mainPage(context);
            },
            icon: const Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getGoogleEventsData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              CellCalendar(
                daysOfTheWeekBuilder: (dayIndex) {
                  final labels = ["S", "M", "T", "W", "T", "F", "S"];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      labels[dayIndex],
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                events: snapshot.data ?? [],
                onCellTapped: (date) {
                  final eventsOnTheDate = snapshot.data.where((event) {
                    final eventDate = event.eventDate;
                    return eventDate.year == date.year &&
                        eventDate.month == date.month &&
                        eventDate.day == date.day;
                  }).toList();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("${date.month.monthName} ${date.day}"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: eventsOnTheDate
                            .map<Widget>(
                              (event) => Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(4),
                                margin: const EdgeInsets.only(bottom: 12),
                                color: event.eventBackgroundColor,
                                child: Text(
                                  event.eventName,
                                  style: event.eventTextStyle,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
              snapshot.data != null
                  ? Container()
                  : const Center(
                      child: progressIndication,
                    ),
            ],
          );
        },
      ),
    );
  }
}

void mainPage(context) async {
  try {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  } catch (e) {
    print('Error during sign-out: $e');
  }
}
