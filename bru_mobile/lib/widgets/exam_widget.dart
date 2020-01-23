import 'package:badges/badges.dart';
import 'package:bru_mobile/models/lesson_model.dart';
import 'package:bru_mobile/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:bru_mobile/constants/global.dart' as globals;
import 'package:bru_mobile/constants/colors.dart';

class ExamWidget extends StatefulWidget {
  ExamWidget(this._lesson, this._teacher);

  final Lesson _lesson;
  final User _teacher;

  @override
  _ExamWidgetState createState() => _ExamWidgetState();
}

class _ExamWidgetState extends State<ExamWidget> {
  @override
  Widget build(BuildContext context) {
    var brightness = globals.systemBrightness
        ? MediaQuery.of(context).platformBrightness
        : globals.brightness;
    Lesson lesson = widget._lesson;
    User teacher = widget._teacher;
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 5.0, right: 20, left: 20),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: brightness != Brightness.dark
            ? ExamsColors.backColor[lesson.type - 1]
            : Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: lesson.type == 5
                ? [Color(0xFFC1F3F3), Color(0xFFB5B5FF)]
                : [Color(0xFFFAc0f5), Color(0xFFFFC2C2)]),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(lesson.name,
                      style: TextStyle(
                          fontSize: 20.5,
                          color: brightness != Brightness.dark
                              ? ExamsColors.textColor[lesson.type - 1]
                              : ExamsColors.darkTextColor[lesson.type - 1],
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Badge(
                badgeColor: brightness != Brightness.dark
                    ? ExamsColors.textColor[lesson.type - 1]
                    : ExamsColors.darkTextColor[lesson.type - 1],
                shape: BadgeShape.square,
                elevation: 0,
                padding: EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
                borderRadius: 15,
                toAnimate: false,
                badgeContent: Text(
                    lesson.type == 6 ? 'Экзамен' : 'Консультация',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(lesson.time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black87,
                      )),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.black87, size: 15),
                  Text(
                    lesson.location,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20.0,
                    //backgroundImage: AssetImage('assets/images/${lesson.teacherid}.jpg'),
                    //backgroundImage: Image.network('https://brumobile.000webhostapp.com/images/1.jpg'),
                    backgroundImage: NetworkImage(
                        'https://brumobile.000webhostapp.com/images/${teacher.id}.jpg'),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        teacher.fsname,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 2.0),
                      Text(teacher.lastname,
                          style:
                              TextStyle(fontSize: 15, color: Colors.black87)),
                    ],
                  )
                ],
              ),
              Column(
                children: <Widget>[],
              )
            ],
          ),
        ],
      ),
    );
  }
}
