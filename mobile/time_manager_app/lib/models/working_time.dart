class WorkingTime {
  String id;
  String userId;
  String start;
  String end;

  WorkingTime(
      {required this.id,
      required this.userId,
      required this.start,
      required this.end});

  WorkingTime.empty()
      : id = "",
        userId = "",
        start = "",
        end = "";
}
