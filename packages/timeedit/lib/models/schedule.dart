import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timeedit/models/week.dart';
import 'package:http/http.dart' as http;

import 'booking.dart';

String relToString(RelativeUnit unit) {
  switch (unit) {
    case RelativeUnit.minutes:
      return "m";
      break;
    case RelativeUnit.hours:
      return "h";
      break;
    case RelativeUnit.days:
      return "d";
      break;
    case RelativeUnit.weeks:
      return "w";
      break;
    case RelativeUnit.months:
      return "n";
      break;
    case RelativeUnit.now:
      return "now";
      break;
    case RelativeUnit.setDate:
    default: // Default should never happen, but catch it anyway
      return "set";
      break;
  }
}

RelativeUnit stringToRel(String unit) {
  switch (unit) {
    case "m":
      return RelativeUnit.minutes;
      break;
    case "h":
      return RelativeUnit.hours;
      break;
    case "d":
      return RelativeUnit.days;
      break;
    case "w":
      return RelativeUnit.weeks;
      break;
    case "n":
      return RelativeUnit.months;
      break;
    case "now":
      return RelativeUnit.now;
      break;
    case "set":
    default:
      return RelativeUnit.setDate;
      break;
  }
}

enum RelativeUnit {
  now,
  minutes, // m
  hours, // h
  days, // d
  weeks, // w
  months, // n
  setDate // use rangeStart or rangeEnd parameter
}

class Schedule {
  Schedule({this.headers, this.orgName, this.entryPath, this.schedulePath});
  List<String> headers;

  String userCustomName = "Unnamed Schedule";
  //List<String> headersOrdered = new List<String>(headers.length);

  final String linkbase = "https://cloud.timeedit.net/";
  String orgName; // Example: "chalmers"
  String entryPath; // Example: "public"
  String schedulePath; // Example: "ri1Q7"

  /*

  String orgName; 
  String primaryPage; 
  String secondaryPage; 
  
  */

  DateTime rangeStart = DateTime.now();
  DateTime rangeEnd = Jiffy().add(weeks: 3);

  int relativeStart = 0;
  int relativeEnd = 3;

  int nameCatIndex = -1;
  int locCatIndex = -1;
  int tutorCatIndex = -1;

  RelativeUnit rangeStartType = RelativeUnit.weeks;
  RelativeUnit rangeEndType = RelativeUnit.weeks;

  String getDateParam() {
    String startParam;
    String endParam;

    startParam = dateParam(rangeStartType, relativeStart, rangeStart);
    endParam = dateParam(rangeEndType, relativeEnd, rangeEnd);

    return startParam + "," + endParam;
  }

  String dateParam(RelativeUnit relativeUnit, int relative, DateTime range) {
    switch (relativeUnit) {
      case RelativeUnit.minutes:
        return relative.toString() + ".m";
        break;
      case RelativeUnit.hours:
        return relative.toString() + ".h";
        break;
      case RelativeUnit.days:
        return relative.toString() + ".d";
        break;
      case RelativeUnit.weeks:
        return relative.toString() + ".w";
        break;
      case RelativeUnit.months:
        return relative.toString() + ".n";
        break;
      case RelativeUnit.setDate:
        return DateFormat('yyyyMMdd').format(rangeStart) + ".x";
        break;
      case RelativeUnit.now:
      default:
        return "0.w";
    }
  }

  DateTime getStartDate() {
    switch (rangeStartType) {
      case RelativeUnit.now:
        return DateTime.now();
      case RelativeUnit.minutes:
        return Jiffy(DateTime.now()).add(minutes: relativeStart);
      case RelativeUnit.hours:
        return Jiffy(DateTime.now()).add(hours: relativeStart);
        break;
      case RelativeUnit.days:
        return Jiffy(DateTime.now()).add(days: relativeStart);
        break;
      case RelativeUnit.weeks:
        return Jiffy(DateTime.now()).add(weeks: relativeStart);
        break;
      case RelativeUnit.months:
        return Jiffy(DateTime.now()).add(months: relativeStart);
        break;
      case RelativeUnit.setDate:
        return rangeStart;
        break;
    }
    return DateTime.now();
  }

  DateTime getEndDate() {
    switch (rangeEndType) {
      case RelativeUnit.now:
        return DateTime.now();
      case RelativeUnit.minutes:
        return Jiffy(DateTime.now()).add(minutes: relativeEnd);
      case RelativeUnit.hours:
        return Jiffy(DateTime.now()).add(hours: relativeEnd);
      case RelativeUnit.days:
        return Jiffy(DateTime.now()).add(days: relativeEnd);
      case RelativeUnit.weeks:
        return Jiffy(DateTime.now()).add(weeks: relativeEnd);
      case RelativeUnit.months:
        return Jiffy(DateTime.now()).add(months: relativeEnd);
      case RelativeUnit.setDate:
        return rangeEnd;
      default:
        return Jiffy(DateTime.now()).add(weeks: 3);
    }
  }

  Map<String, String> groups = new Map<String, String>();

  Map<int, List<String>> headerFilters = new Map<int, List<String>>();
  List<int> idFilters = [];

  String _link(bool useJson, bool addFilters) {
    // Where does sid=3 come from?
    // It's stored in links-database. This link is fetched elsewhere. Maybe get
    // there?
    String params = addFilters ? "?p=${getDateParam()}&objects=${groups.keys.join(",-1,")}&sid=3" : "";
    return "$linkbase$orgName/web/$entryPath/$schedulePath${useJson ? ".json" : ".html"}$params";
  }

  String link() => _link(false, true);
  String linkJson() => _link(true, true);

  // Gets the column headers used for the schedule
  Future<List<String>> getHeaders() async {
    http.Response response = await http.get(_link(true, false));
    return List.castFrom<dynamic, String>(json.decode(response.body)["columnheaders"]);
  }

  // Gets a list of all bookings from the search parameters
  Future<List<Booking>> getBookings() async {
    http.Response response = await http.get(linkJson());
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
    DateTime end = getEndDate();
    DateTime start = getStartDate();

    int weeksAmount = Jiffy(end).week - Jiffy(start).week;
    for (int w = 0; w <= weeksAmount; w++) {
      weeks.add(new Week(Jiffy(Jiffy(start).add(weeks: w)).startOf(Units.WEEK)));
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

  // Generate a Schedule object from a TimeEdit schedule link
  factory Schedule.fromTEditLink(String link) {
    // Parse link as .json uri
    Uri parsedUri = Uri.dataFromString(link.replaceAll(".html", ".json"));
    Map<String, String> params = parsedUri.queryParameters;

    List<String> period = params["p"]?.split(",");

    // Get link and try to parse as json

    // TODO: Implement getting Schedule object from TimeEdit link
    // Possibly used for importing directly from a schedule link instead of
    // manually typing in stuff. Dunno if needed though.
    return null;
  }

  // Generate a Schedule object from a JSON object
  factory Schedule.fromSettingsJson(Map<String, dynamic> json) {
    // TODO: Check if more data needs to be read
    List<String> fromHeaders = List.castFrom<dynamic, String>(json["headers"]);
    Map<String, String> fromGroups = new Map<String, String>.from(json["groups"]);
    Schedule schedule = new Schedule(headers: fromHeaders);
    schedule.groups = fromGroups;
    schedule.userCustomName = json['customName'];
    if (json.containsKey("range")) {
      schedule.rangeStartType = RelativeUnit.values[json['range']['startType']];
      schedule.rangeEndType = RelativeUnit.values[json['range']['endType']];
      schedule.rangeStart = DateTime.fromMicrosecondsSinceEpoch(json['range']['startDate']);
      schedule.rangeEnd = DateTime.fromMicrosecondsSinceEpoch(json['range']['endDate']);
      schedule.relativeStart = json['range']['relativeStart'];
      schedule.relativeEnd = json['range']['relativeEnd'];
    }

    if (json.containsKey("catIndices")) {
      schedule.nameCatIndex = json['catIndices']['name'];
      schedule.locCatIndex = json['catIndices']['loc'];
      schedule.tutorCatIndex = json['catIndices']['tutor'];
    }

    if (json.containsKey("path")) {
      schedule.orgName = json['entry']['orgName'];
      schedule.entryPath = json['entry']['entryPath'];
      schedule.schedulePath = json['entry']['schedulePath'];
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
      'range': {
        'startType': rangeStartType.index,
        'endType': rangeEndType.index,
        'startDate': rangeStart.millisecondsSinceEpoch,
        'endDate': rangeEnd.millisecondsSinceEpoch,
        'relativeStart': relativeStart,
        'relativeEnd': relativeEnd
      },
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
