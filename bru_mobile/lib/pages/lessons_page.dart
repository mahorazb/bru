import 'package:bru_mobile/services/database.dart';
import 'package:bru_mobile/models/lesson_model.dart';
import 'package:bru_mobile/models/user_model.dart';
import 'package:bru_mobile/pages/exams_page.dart';
import 'package:bru_mobile/widgets/lesson_widget.dart';
import 'package:flutter/material.dart';
import 'package:bru_mobile/constants/global.dart' as globals;

class LessonsPage extends StatefulWidget {
  LessonsPage({Key key}) : super(key: key);

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  var startDate;
  var today;
  var response;
  var isLoaded = false;
  var exams = true;

  List<String> days;
  List<User> loadedTeachers;
  List<Lesson> loadedLessons1;
  List<Lesson> loadedLessons2;
  List<Lesson> loadedLessons3;
  List<Lesson> loadedLessons4;
  List<Lesson> loadedLessons5;
  List<Lesson> loadedLessons6;
  Map tids = Map();

  @override
  void initState() {
    loadDataFromDatabase();
    super.initState();
  }

  void getDates() {
    today = new DateTime.now();
    startDate = today.add(new Duration(days: -(today.weekday - 1)));
  }

  void loadDataFromDatabase() {
    Future<List<User>> susers = DBProvider.getUsers();
    Future<List<Lesson>> ll;
    susers.then((i) {
      loadedTeachers = i;

      int j = 0;

      for (User u in loadedTeachers) {
        tids[u.id] = j;
        j++;
      }

      ll = DBProvider.getLessons(1);
      ll.then((i) {
        setState(() {
          loadedLessons1 = i;
        });
      });
      ll = DBProvider.getLessons(2);
      ll.then((i) {
        setState(() {
          loadedLessons2 = i;
        });
      });
      ll = DBProvider.getLessons(3);
      ll.then((i) {
        setState(() {
          loadedLessons3 = i;
        });
      });
      ll = DBProvider.getLessons(4);
      ll.then((i) {
        setState(() {
          loadedLessons4 = i;
        });
      });
      ll = DBProvider.getLessons(5);
      ll.then((i) {
        setState(() {
          loadedLessons5 = i;
        });
      });
      ll = DBProvider.getLessons(6);
      ll.then((i) {
        setState(() {
          loadedLessons6 = i;
          isLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getDates();
    var brightness = globals.systemBrightness
        ? MediaQuery.of(context).platformBrightness
        : globals.brightness;
    //brightness = Brightness.dark;
    return !isLoaded
        ? Scaffold(body: Center(child: new CircularProgressIndicator()))
        : exams
            ? ExamsPage()
            : WillPopScope(
                onWillPop: () => Future.value(false),
                child: Scaffold(
                  body: DefaultTabController(
                    length: 6,
                    initialIndex: today.weekday == 7
                        ? today.weekday - 2
                        : today.weekday - 1,
                    child: Scaffold(
                      backgroundColor: brightness == Brightness.dark
                          ? Colors.black
                          : Colors.blue[50],
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
                                  Text('Верхняя неделя',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey))
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
                            //Navigator.of(context).push(_createRouteSettings());
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
                            onPressed: () {},
                          ),
                        ],
                        bottom: TabBar(
                          indicatorColor: brightness != Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          labelColor: brightness != Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          indicatorPadding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: -3.0),
                          tabs: [
                            Column(
                              children: <Widget>[
                                Text('ПН',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    '${startDate.add(new Duration(days: 0)).day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('ВТ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    '${startDate.add(new Duration(days: 1)).day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('СР',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    '${startDate.add(new Duration(days: 2)).day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('ЧТ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    '${startDate.add(new Duration(days: 3)).day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('ПТ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    '${startDate.add(new Duration(days: 4)).day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text('СБ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    '${startDate.add(new Duration(days: 5)).day.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15)),
                              ],
                            ),
                            //Tab(text: 'ПН\n${startDate.add(new Duration(days: 0)).day.toString().padLeft(2, '0')}'),
                            //Tab(text: 'ВТ\n${startDate.add(new Duration(days: 1)).day.toString().padLeft(2, '0')}'),
                            //Tab(text: 'СР\n${startDate.add(new Duration(days: 2)).day.toString().padLeft(2, '0')}'),
                            //Tab(text: 'ЧТ\n${startDate.add(new Duration(days: 3)).day.toString().padLeft(2, '0')}'),
                            //Tab(text: 'ПТ\n${startDate.add(new Duration(days: 4)).day.toString().padLeft(2, '0')}'),
                            //Tab(text: 'СБ\n${startDate.add(new Duration(days: 5)).day.toString().padLeft(2, '0')}'),
                          ],
                        ),
                      ),
                      /*body: Column(
              children: <Widget>[
                CategorySelector(),
                Expanded(
                    child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)
                      ),
                    ),
                  ),
                ),
              ],
            )*/
                      body: TabBarView(
                        children: <Widget>[
                          _buildLessonsList(context, loadedLessons1, 1),
                          _buildLessonsList(context, loadedLessons2, 2),
                          _buildLessonsList(context, loadedLessons3, 3),
                          _buildLessonsList(context, loadedLessons4, 4),
                          _buildLessonsList(context, loadedLessons5, 5),
                          _buildLessonsList(context, loadedLessons6, 6),
                          //ExamsRecent(),
                          //Text(today.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Widget _buildLessonsList(BuildContext context, List<Lesson> lessons, int day) {
    var brightness = globals.systemBrightness
        ? MediaQuery.of(context).platformBrightness
        : globals.brightness;
    return lessons.length == 0
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.hot_tub,
                    color: brightness != Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    size: 35.0),
                SizedBox(height: 10),
                Text(
                  'На этот день нет расписания.',
                  style: TextStyle(
                    color: brightness != Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
                decoration: BoxDecoration(
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
                  child: ListView.builder(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          lessons == null ? 0 : lessons.length,
                      itemBuilder: (BuildContext context, int index) {

                        if (lessons[index].day == day)
                          return LessonWidget(lessons[index], loadedTeachers[tids[lessons[index].teacherid]]);
                        else
                          return Column();
                      }),
                )),
          );
  }
}
