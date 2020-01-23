import 'package:badges/badges.dart';
import 'package:bru_mobile/models/lesson_model.dart';
import 'package:bru_mobile/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:bru_mobile/constants/global.dart' as globals;
import 'package:bru_mobile/constants/colors.dart';
import 'package:bru_mobile/constants/lessons_constants.dart';

class LessonWidget extends StatefulWidget {
  LessonWidget(this._lesson, this._teacher);

  final Lesson _lesson;
  final User _teacher;

  @override
  _LessonWidgetState createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget> {
  @override
  Widget build(BuildContext context) {
    var brightness = globals.systemBrightness
        ? MediaQuery.of(context).platformBrightness
        : globals.brightness;
    String lesname;

    if (widget._lesson.name.length >= 14)
      lesname = '${widget._lesson.name.substring(0, 14)}...';
    else
      lesname = widget._lesson.name;

    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 5.0, right: 20, left: 20),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: brightness != Brightness.dark
            ? LessonColors.backColor[widget._lesson.type - 1]
            : Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: widget._lesson.type >= 5
            ? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: widget._lesson.type == 5
                    ? [Color(0xFFC1F3F3), Color(0xFFB5B5FF)]
                    : [Color(0xFFFAc0f5), Color(0xFFFFC2C2)])
            : brightness == Brightness.dark
                ? LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: LessonColors.darkBackColor[widget._lesson.type - 1])
                : null,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(lesname,
                      style: TextStyle(
                          fontSize: 21,
                          color: brightness != Brightness.dark
                              ? LessonColors.textColor[widget._lesson.type - 1]
                              : LessonColors.darkTextColor[widget._lesson.type - 1],
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Badge(
                badgeColor: brightness != Brightness.dark
                    ? LessonColors.textColor[widget._lesson.type - 1]
                    : LessonColors.badgeColors[widget._lesson.type - 1],
                shape: BadgeShape.square,
                elevation: 0,
                padding: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                borderRadius: 15,
                toAnimate: false,
                badgeContent: Text(LessonConst.lessonTypes[widget._lesson.type - 1],
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
                  if (widget._lesson.type >= 1 && widget._lesson.type <= 4)
                    Text(LessonConst.lessonTimes[widget._lesson.step - 1],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Colors.black87)),
                  if (widget._lesson.type > 4)
                    Text(widget._lesson.time,
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
                    widget._lesson.location,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ],
          ),
          if (widget._lesson.type != 4) SizedBox(height: 5),
          if (widget._lesson.type != 4)
            Stack(
              children: <Widget>[
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
                              'https://brumobile.000webhostapp.com/images/${widget._teacher.id}.jpg'),
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget._teacher
                                  .fsname,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  //color: brightness != Brightness.dark ? textColor[lesson.type - 1] : darkTextColor[lesson.type - 1]
                                  color: Colors.black),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                                widget._teacher
                                    .lastname,
                                style: TextStyle(
                                    fontSize: 15,
                                    //color: brightness != Brightness.dark ? textColor[lesson.type - 1] : darkTextColor[lesson.type - 1]
                                    color: Colors.black)),
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
        ],
      ),
    );
  }
}
