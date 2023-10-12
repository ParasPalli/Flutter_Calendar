import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Secret {
  static const ANDROID_CLIENT_ID =
      "12859863108-83n4t2ihc79e6sicr2cb57vd42r248oa.apps.googleusercontent.com";
  static const IOS_CLIENT_ID =
      "12859863108-26sre0tauo45cfq5vvc8a590up5r9b4r.apps.googleusercontent.com";
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}

final GoogleSignIn googleSignIn = GoogleSignIn(
  // clientId: '[YOUR_OAUTH_2_CLIENT_ID]',
  scopes: [
    GoogleAPI.CalendarApi.calendarScope,
    GoogleAPI.CalendarApi.calendarEventsReadonlyScope,
  ],
);

Future<void> FirebaseLogin(googleUser) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  if (googleUser != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }
}

Future<List<GoogleAPI.Event>> getGoogleEventsData() async {
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  await FirebaseLogin(googleUser);

  final GoogleAPIClient httpClient =
      GoogleAPIClient(await googleUser!.authHeaders);

  final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
  final GoogleAPI.Events calEvents = await calendarApi.events.list(
    "primary",
  );
  final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
  if (calEvents.items != null) {
    for (int i = 0; i < calEvents.items!.length; i++) {
      final GoogleAPI.Event event = calEvents.items![i];
      if (event.start == null) {
        continue;
      }
      appointments.add(event);
    }
  }

  return appointments;
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

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<GoogleAPI.Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start?.date ?? event.start!.dateTime!.toLocal())
        : (event.end?.date != null
            ? event.end!.date!.add(const Duration(days: -1))
            : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments![index].location ?? '';
  }

  @override
  String getNotes(int index) {
    return appointments![index].description ?? '';
  }

  @override
  String getSubject(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary!;
  }
}
