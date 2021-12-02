import 'dart:convert';

import 'package:jiffy/jiffy.dart';
import 'package:timeedit/models/date_range.dart';
import 'package:timeedit/models/week.dart';
import 'package:http/http.dart' as http;

import 'booking.dart';

class Schedule {
  Schedule({required this.headers, required this.orgName, required this.entryPath, required this.schedulePath});
  List<String> headers;

  String userCustomName = "Unnamed Schedule";
  //List<String> headersOrdered = new List<String>(headers.length);

  final String linkbase = "https://cloud.timeedit.net/";
  String orgName; // Example: "chalmers"
  String entryPath; // Example: "public"
  String schedulePath; // Example: "ri1Q7"

  DateRange range = DateRange();

  /*

  String orgName; 
  String primaryPage; 
  String secondaryPage; 
  
  */

  int nameCatIndex = -1;
  int locCatIndex = -1;
  int tutorCatIndex = -1;

  Map<String, String> groups = <String, String>{};

  Map<int, List<String>> headerFilters = <int, List<String>>{};
  List<int> idFilters = [];

  String _link(bool useJson, bool addFilters) {
    // Where does sid=3 come from?
    // It's stored in links-database. This link is fetched elsewhere. Maybe get
    // there?
    String params = addFilters ? "?p=${range.getDateParam()}&objects=${groups.keys.join(",-1,")}&sid=3" : "";
    return "$linkbase$orgName/web/$entryPath/$schedulePath${useJson ? ".json" : ".html"}$params";
  }

  String link() => _link(false, true);
  String linkJson() => _link(true, true);

  // Gets the column headers used for the schedule
  Future<List<String>> getHeaders() async {
    http.Response response = await http.get(Uri.parse(_link(true, false)));
    return List.castFrom<dynamic, String>(json.decode(response.body)["columnheaders"]);
  }

  // Gets a list of all bookings from the search parameters
  Future<List<Booking>> getBookings() async {
    http.Response response = await http.get(Uri.parse(linkJson()));
    Map<String, dynamic> scheduleJson = json.decode(response.body);

    // TODO: Figure out why the last week doesn't show any bookings
    // More info gathered: The JSON gives different data than website

    List<Booking> bookings = [];

    for (dynamic item in scheduleJson["reservations"]) {
      bookings.add(Booking.fromTEditJson(item));
    }
    return bookings;
  }

  // Gets a list of all weeks with bookings from the search parameters
  Future<List<Week>> getWeeks() async {
    // TODO: Figure out why the last week doesn't show any bookings
    // More info gathered: The JSON gives different data than website

    List<Week> weeks = [];
    DateTime end = range.getEndDate();
    DateTime start = range.getStartDate();

    int weeksAmount = Jiffy(end).week - Jiffy(start).week;
    for (int w = 0; w <= weeksAmount; w++) {
      weeks.add(Week(Jiffy(Jiffy(start).add(weeks: w)).startOf(Units.WEEK).dateTime));
    }

    List<Booking> bookings = await getBookings();

    for (Booking booking in bookings) {
      int currentWeek = Jiffy(booking.startTime).week - Jiffy(start).week;
      if (currentWeek >= weeks.length || currentWeek < 0) continue;

      int currentWeekDayNum = booking.startTime.weekday - 1;

      /*if (currentWeek >= weeks.length) {
        print("this shouldn't happen!");
      }*/

      if (currentWeekDayNum >= weeks[currentWeek].length) weeks[currentWeek].length = currentWeekDayNum + 1;

      weeks[currentWeek][currentWeekDayNum].add(booking);
    }

    return weeks;
  }

  // TODO: Implement fromTEditLink factory
  /*// Generate a Schedule object from a TimeEdit schedule link
  factory Schedule.fromTEditLink(String link) {
    // Parse link as .json uri
    Uri parsedUri = Uri.dataFromString(link.replaceAll(".html", ".json"));
    Map<String, String> params = parsedUri.queryParameters;

    List<String>? period = params["p"]?.split(",");

    // Get link and try to parse as json

    // TODO: Implement getting Schedule object from TimeEdit link
    // Possibly used for importing directly from a schedule link instead of
    // manually typing in stuff. Dunno if needed though.
    return null;
  }*/

  // Generate a Schedule object from a JSON object
  factory Schedule.fromSettingsJson(Map<String, dynamic> json) {
    // TODO: Check if more data needs to be read
    List<String> fromHeaders = List.castFrom<dynamic, String>(json["headers"]);
    Map<String, String> fromGroups = Map<String, String>.from(json["groups"]);

    String entryPath = "";
    String orgName = "";
    String schedulePath = "";
    if (json.containsKey("path")) {
      orgName = json['entry']['orgName'];
      entryPath = json['entry']['entryPath'];
      schedulePath = json['entry']['schedulePath'];
    }

    Schedule schedule = Schedule(headers: fromHeaders, entryPath: entryPath, orgName: orgName, schedulePath: schedulePath);

    schedule.groups = fromGroups;
    schedule.userCustomName = json['customName'];
    if (json.containsKey("range")) {
      schedule.range = DateRange.fromSettingsJson(json['range']);
    }

    if (json.containsKey("catIndices")) {
      schedule.nameCatIndex = json['catIndices']['name'];
      schedule.locCatIndex = json['catIndices']['loc'];
      schedule.tutorCatIndex = json['catIndices']['tutor'];
    }

    return schedule;
  }

  // Encode the current schedule to a JSON string
  String toSettingsJson() {
    return json.encode({
      'customName': userCustomName,
      'headers': headers,
      'groups': groups,
      'catIndices': {
        'name': nameCatIndex,
        'loc': locCatIndex,
        'tutor': tutorCatIndex
      },
      'range': range.toSettingsJson(),
      'path': {
        'orgName': orgName,
        'entryPath': entryPath,
        'schedulePath': schedulePath
      }
    });
  }
}

/*int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}*/
