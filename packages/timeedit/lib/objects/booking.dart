class Booking {
  List<String> headersData;
  DateTime startTime;
  DateTime endTime;
  String id;

  Booking(this.headersData, this.startTime, this.endTime, this.id);

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
        (json["columns"] as List<dynamic>).map((e) => e.toString()).toList(),
        DateTime.parse("${json["startdate"]} ${json["starttime"]}"),
        DateTime.parse("${json["enddate"]} ${json["endtime"]}"),
        json["id"]);
  }
}
