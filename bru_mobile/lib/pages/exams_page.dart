import 'package:bru_mobile/services/database.dart';
import 'package:bru_mobile/models/lesson_model.dart';
import 'package:bru_mobile/models/user_model.dart';
import 'package:bru_mobile/widgets/exam_widget.dart';
import 'package:bru_mobile/pages/settings_page.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:bru_mobile/constants/global.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

Route _createRouteSettings() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class ExamsPage extends StatefulWidget {
  @override
  _ExamsPageState createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage>
    with TickerProviderStateMixin {
  CalendarController _controller;
  AnimationController _animationController;
  Map<DateTime, List<Lesson>> _events = Map();
  List _selectedEvents;
  DateTime _selectedDate;
  DateTime _selectedDay;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Flushbar flushbar;
  FlushbarStatus flush_status;

  List<User> examUsers;
  Map tids = Map();

  var startClosed = false;
  var loaded = false;
  var examLoaded = false;

  PersistentBottomSheetController sheetController;

  var openedSheet = false;

  @override
  void initState() {
    super.initState();

    _controller = CalendarController();

    Future<List<Lesson>> exams = DBProvider.getAllExams();
    exams.then((val) {
      for (Lesson les in val) {
        final date = DateTime.parse(les.date);

        //print(DateTime.parse(les.date));
        setState(() {
          _events[date] = [les];
        });
        //_events.addAll({date : [les]});

      }

      Future<List<User>> users = DBProvider.getUsers();
      users.then((valu) {
        int j = 0;
        setState(() {
          examUsers = valu;
          for (User u in valu) {
            tids[u.id] = j;
            j++;
          }
          examLoaded = true;

          _animationController = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 200),
          );

          _animationController.forward();

          var now = DateTime.now();
          _selectedDay = new DateTime(now.year, now.month, now.day);
          debugPrint('$_selectedDay');

          _selectedEvents = _events[_selectedDay] ?? [];
          _selectedDate = _selectedDay;

          if (_selectedEvents != null) if (_selectedEvents.length != 0)
            _showFlushBar();
          //_showMyBottomSheet();
        });
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
      _selectedDate = day;
    });
  }

  Future<http.Response> loadDataFromServer() async {
    return await http
        .get('https://brumobile.000webhostapp.com/get.php?group=1');
  }

  void updateDataDatabase() async {
    http.Response jsonString = await loadDataFromServer();

    if (jsonString.statusCode == 200) {
      List<Lesson> lessonsL = new List<Lesson>();
      List<User> teachersL = new List<User>();

      List<String> outputs = jsonString.body.split('%');

      final parsedLessons = json.decode(outputs[0]) as List;
      final parsedTeachers = json.decode(outputs[1]) as List;

      lessonsL = parsedLessons.map((json) => Lesson.fromJson(json)).toList();
      teachersL = parsedTeachers.map((json) => User.fromJson(json)).toList();

      for (Lesson les in lessonsL) {
        //DBProvider.newLesson(les);
      }

      for (User us in teachersL) {
        //DBProvider.newUser(us);
      }

      setState(() {
        loaded = false;
      });
    }
  }

  void _showFlushBar() {

    if (flush_status == FlushbarStatus.SHOWING) {
      flushbar.dismiss();
    }

    if (_selectedEvents.length != 0) {
      DateFormat day = DateFormat("dd");
      DateFormat month = DateFormat.MMM('RU_RU');
      DateFormat weekday = DateFormat.EEEE("RU_RU");
      String dayText = day.format(_selectedDate);
      String monthText = month.format(_selectedDate);
      String weekText = weekday.format(_selectedDate);

      flushbar = Flushbar(
        onStatusChanged: (status) async {
          await _onStatusFlushbarChanged(status);
        },
        isDismissible: false,
        flushbarPosition: FlushbarPosition.BOTTOM,
        animationDuration: Duration(milliseconds: 500),
        reverseAnimationCurve: Curves.easeInBack,
        forwardAnimationCurve: Curves.easeInOutBack,
        flushbarStyle: FlushbarStyle.FLOATING,
        backgroundColor: (globals.systemBrightness
                    ? MediaQuery.of(context).platformBrightness
                    : globals.brightness) ==
                Brightness.dark
            ? Colors.black
            : Colors.white,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.only(top: 0, bottom: 0),
        messageText: Container(
            height: 170,
            color: (globals.systemBrightness
                        ? MediaQuery.of(context).platformBrightness
                        : globals.brightness) ==
                    Brightness.dark
                ? Colors.black
                : Colors.white,
            child: Container(
              color: (globals.systemBrightness
                          ? MediaQuery.of(context).platformBrightness
                          : globals.brightness) ==
                      Brightness.dark
                  ? Colors.black
                  : Colors.white,
              child: Column(
                children: <Widget>[
                  Text(
                    '$dayText $monthText, ${weekText[0].toUpperCase()}${weekText.substring(1)}',
                    style: TextStyle(
                        fontSize: 16,
                        color: (globals.systemBrightness
                                    ? MediaQuery.of(context).platformBrightness
                                    : globals.brightness) !=
                                Brightness.dark
                            ? Colors.black
                            : Colors.white),
                  ),
                  Expanded(
                    child: Container(
                      decoration: new BoxDecoration(
                        color: (globals.systemBrightness
                                    ? MediaQuery.of(context).platformBrightness
                                    : globals.brightness) ==
                                Brightness.dark
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          ExamWidget(
                                _selectedEvents[0],
                                examUsers[
                                    tids[_selectedEvents[0].teacherid]]),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            )),
      )..show(context);
    } else {
      Container();
    }
  }

  _onStatusFlushbarChanged(FlushbarStatus status) {
    setState(() {
      flush_status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = globals.systemBrightness
        ? MediaQuery.of(context).platformBrightness
        : globals.brightness;
    return !examLoaded
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            key: scaffoldKey,
            backgroundColor:
                brightness == Brightness.dark ? Colors.black : Colors.white,
            appBar: AppBar(
              backgroundColor: brightness == Brightness.dark
                  ? Colors.black
                  : Colors.blue[50],
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Расписание ',
                          style: TextStyle(
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Сессия',
                            style: TextStyle(fontSize: 14, color: Colors.grey))
                      ],
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  flushbar.dismiss();
                  Navigator.of(context).push(_createRouteSettings());
                },
              ),
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.today,
                      color: brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  iconSize: 25.0,
                  //color: Colors.black,
                  onPressed: () {
                    setState(() {
                      loaded = true;
                    });
                    updateDataDatabase();
                  },
                ),
              ],
            ),
            body: ModalProgressHUD(
              opacity: 0,
              inAsyncCall: loaded,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    decoration: new BoxDecoration(
                      color: brightness == Brightness.dark
                          ? Colors.black
                          : Colors.blue[50],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(
                        color: brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        child: TableCalendar(
                            locale: 'RU_RU',
                            events: _events,
                            calendarController: _controller,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                color: Colors.grey,
                              ),
                              weekendStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                color: Colors.grey,
                              ),
                            ),
                            headerVisible: false,
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                            ),
                            builders: CalendarBuilders(
                              selectedDayBuilder: (context, date, _) {
                                return FadeTransition(
                                  opacity: Tween(begin: 0.0, end: 1.0)
                                      .animate(_animationController),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      border: Border.all(
                                        width: 2.0,
                                        color: brightness != Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      //color: brightness != Brightness.dark ? Colors.grey[200] : Colors.white,
                                    ),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      '${date.day}',
                                      style: TextStyle().copyWith(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: brightness != Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              dayBuilder: (context, date, _) {
                                return Container(
                                  child: _buildDayMarker(date),
                                );
                              },
                              todayDayBuilder: (context, date, _) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    color: brightness != Brightness.dark
                                        ? Colors.grey[200]
                                        : Color(0xFF2D2D2D),
                                  ),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle().copyWith(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: brightness != Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                );
                              },
                              markersBuilder:
                                  (context, date, events, holidays) {
                                final children = <Widget>[];

                                if (events.isNotEmpty &&
                                    date.isAfter(_selectedDay.subtract(Duration(days: 1)))) {
                                  children.add(
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      child: _buildEventsMarker(date, events),
                                    ),
                                  );
                                }

                                return children;
                              },
                            ),
                            onDaySelected: (date, events) {
                              _onDaySelected(date, events);

                              if (flush_status == FlushbarStatus.SHOWING)
                                flushbar.dismiss();

                              _showFlushBar();
   

                              _animationController.forward(from: 0.0);
                            }),
                      ),
                    ),
                  ),
                  /*Expanded(
              child: _buildEventList()
            )*/
                ],
              ),
            ),
          );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _controller.isSelected(date)
            ? Colors.purple[500]
            : Colors.blue[400],
      ),
      width: 6.0,
      height: 6.0,
    );
  }

  Widget _buildDayMarker(DateTime date) {
    var brightness = globals.systemBrightness
        ? MediaQuery.of(context).platformBrightness
        : globals.brightness;
    var parseDate = new DateTime(date.year, date.month, date.day);
    if (_events.containsKey(parseDate)) {
      if (parseDate.isBefore(_selectedDay)) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: brightness == Brightness.dark
                  ? Colors.grey[600]
                  : Colors.grey[400]),
          alignment: Alignment.center,
          margin: EdgeInsets.all(5),
          child: Text(
            '${date.day}',
            style: TextStyle().copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        );
      } else {
        if (_events[parseDate][0].type == 6) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                //colors: [Color(0xFFFAc0f5), Color(0xFFFFC2C2)],
                colors: brightness == Brightness.dark
                    ? [Color(0xFFF995EC), Color(0xFFFF9598)]
                    : [Color(0xFFFAc0f5), Color(0xFFFFC2C2)],
              ),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.all(5),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFC1F3F3), Color(0xFFB5B5FF)],
              ),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.all(5),
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          );
        }
      }
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        alignment: Alignment.center,
        margin: EdgeInsets.all(5),
        child: Text(
          '${date.day}',
          style: TextStyle().copyWith(
            fontSize: 14.0,
            color: brightness != Brightness.dark ? Colors.black : Colors.white,
          ),
        ),
      );
    }
  }
}
