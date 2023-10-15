import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../const.dart';
import '../utils/CalendarDataSource.dart';
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
              SfCalendar(
                view: CalendarView.month,
                initialDisplayDate: DateTime.now(),
                dataSource: GoogleDataSource(events: snapshot.data),
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ),
              snapshot.data != null
                  ? Container()
                  : Center(
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
