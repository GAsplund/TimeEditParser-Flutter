class Booking {
  Booking({this.startTime, this.endTime, this.id, this.data});

  final DateTime startTime;
  final DateTime endTime;
  final String id;
  final List<String> data;

  String tryGetData(int index) {
    if (index >= 0 && index < data.length)
      return data[index];
    else
      return "(Error)";
  }

  factory Booking.fromTEditJson(Map<String, dynamic> json) {
    DateTime start = DateTime.parse(json["startdate"] + " " + json["starttime"]);
    DateTime end = DateTime.parse(json["enddate"] + " " + json["endtime"]);
    return Booking(id: json["id"], data: List.castFrom<dynamic, String>(json["columns"]), startTime: start, endTime: end);
  }
}
