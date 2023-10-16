import 'package:cell_calendar/cell_calendar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;

import '../const.dart';
import 'gSignOutSignIn.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    GoogleAPI.CalendarApi.calendarScope,
    GoogleAPI.CalendarApi.calendarEventsReadonlyScope,
  ],
);

Future<List<CalendarEvent>> getGoogleEventsData() async {
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  await FirebaseLogin(googleUser);

  final GoogleAPIClient httpClient =
      GoogleAPIClient(await googleUser!.authHeaders);

  final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);

  final List<CalendarEvent> eventsList = [];

  final GoogleAPI.Events calEvents = await calendarApi.events.list(
    "primary",
  );

  if (calEvents.items != null) {
    for (int i = 0; i < calEvents.items!.length; i++) {
      final GoogleAPI.Event event = calEvents.items![i];
      if (event.start == null) {
        continue;
      }
      eventsList.add(
        CalendarEvent(
          eventName: event.summary ?? "No Title",
          eventDate: event.start?.date ?? event.start!.dateTime!.toLocal(),
          eventTextStyle: eventTextStyle,
        ),
      );
    }
  }

  return eventsList;
}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}
