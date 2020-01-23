import 'dart:convert';

Lesson lessonFromJson(String str) {
  final jsonData = json.decode(str);
  return Lesson.fromJson(jsonData);
}

String lessonToJson(Lesson data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Lesson {
  final int id;
  final int type;
  final int podgroup;
  final int day;
  final int step;
  final int weekday;
  final int teacherid;
  final String time;
  final String name;
  final String location;
  final String date;

  Lesson({
    this.id,
    this.type,
    this.podgroup,
    this.day,
    this.step,
    this.weekday,
    this.teacherid,
    this.time,
    this.name,
    this.location,
    this.date
  });

  factory Lesson.fromJson(Map<String, dynamic> json){
    return Lesson(
        id: int.parse(json['id'].toString()),
        type: int.parse(json['type'].toString()),
        podgroup: int.parse(json['podgroup'].toString()),
        day: int.parse(json['day'].toString()),
        step: int.parse(json['step'].toString()),
        teacherid: int.parse(json['teacherid'].toString()),
        weekday: int.parse(json['weekday'].toString()),
        time: json['time'] as String,
        name: json['name'] as String,
        location: json["location"] as String,
        date: json["date"] as String,
      );
  }

  factory Lesson.fromMap(Map<String, dynamic> json) => new Lesson(
        id: json['id'],
        type: json['type'],
        podgroup: json['podgroup'],
        day: json['day'],
        step: json['step'],
        teacherid: json['teacherid'],
        weekday: json['weekday'],
        time: json['time'],
        name: json['name'],
        location: json["location"],
        date: json["date"]
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'podgroup': podgroup,
      'day': day,
      'step': step,
      'weekday': weekday,
      'teacherid': teacherid,
      'time': time,
      'name': name,
      'location': location,
      'date': date,
    };
  }
}

