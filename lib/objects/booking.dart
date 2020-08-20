class Booking {
  Booking(
      {this.courseName,
      this.teachers,
      this.startTime,
      this.endTime,
      this.location,
      this.idNum});

  final String courseName;
  final List<List<String>> teachers;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String idNum;

  String description() => teachers[0][1].toString() + " " + teachers[0][0];
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
