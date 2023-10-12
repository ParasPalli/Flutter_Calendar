import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../utils/CalenderAuth.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Calender"),
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
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() async {
    if (googleSignIn.currentUser != null) {
      googleSignIn.disconnect();
      googleSignIn.signOut();

      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
    }

    super.dispose();
  }
}
