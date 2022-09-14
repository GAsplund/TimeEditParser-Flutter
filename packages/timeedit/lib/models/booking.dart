/// Represents a booking from TimeEdit.
class Booking {
  Booking({required this.startTime, required this.endTime, required this.id, required this.data});

  final DateTime startTime;
  final DateTime endTime;
  final String id;
  final List<String> data;

  /// Attempts to get column data at [index].
  ///
  /// If the index is out of bounds,
  /// a default "(Error)" will be returned instead.
  String tryGetData(int index) {
    if (index >= 0 && index < data.length) {
      return data[index];
    } else {
      return "(Error)";
    }
  }

  /// Instantiates a new [Booking] from TimeEdit JSON data.
  factory Booking.fromTEditJson(Map<String, dynamic> json) {
    DateTime start = DateTime.parse(json["startdate"] + " " + json["starttime"]);
    DateTime end = DateTime.parse(json["enddate"] + " " + json["endtime"]);

    return Booking(id: json["id"], data: List.castFrom<dynamic, String>(json["columns"]), startTime: start, endTime: end);
  }
}
