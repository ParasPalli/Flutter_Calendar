import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../const.dart';
import '../utils/CalenderAuth.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Calender"),
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
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
