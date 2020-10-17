class Booking {
  Booking({this.startTime, this.endTime, this.id, this.data});

  final DateTime startTime;
  final DateTime endTime;
  final String id;
  final List<String> data;

  factory Booking.fromTEditJson(Map<String, dynamic> json) {
    DateTime start =
        DateTime.parse(json["startdate"] + " " + json["starttime"]);
    DateTime end = DateTime.parse(json["enddate"] + " " + json["endtime"]);
    return Booking(
        id: json["id"],
        data: List.castFrom<dynamic, String>(json["columns"]),
        startTime: start,
        endTime: end);
  }
}

/*
 *
 * public string Classes;
 * public string Name;
 * public string Location { get; set; }
 * public string Group;
 * public List<List<string>> teachers = new List<List<string>>();
 * public string StartTime { get; set; }
 * public string EndTime { get; set; }
 * public string Id { get; set; }
 *
 * //public string Heading;
 * public string Text => Name;
 * public string Description => Location + ", " + teachers[0][1].ToString() + " " + teachers[0][0];
 *
 */
