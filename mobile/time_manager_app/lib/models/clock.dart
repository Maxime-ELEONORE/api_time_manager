class Clock {
  String id;
  String time;
  bool status;

  Clock({required this.id, required this.time, required this.status});

  Clock.constructor(this.id, this.time, this.status);

// create Clock.empty constructor that create au clock with empty field
  Clock.empty()
      : id = "",
        time = "",
        status = false;

  factory Clock.fromJson(Map<String, dynamic> json) {
    return Clock(id: json['id'], time: json['time'], status: json['status']);
  }
}
