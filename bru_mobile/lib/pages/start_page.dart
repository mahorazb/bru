import 'dart:convert';

import 'package:bru_mobile/services/database.dart';
import 'package:bru_mobile/models/lesson_model.dart';
import 'package:bru_mobile/services/shared_pref.dart';
import 'package:bru_mobile/constants/global.dart' as globals;
import 'package:bru_mobile/models/user_model.dart';
import 'package:bru_mobile/pages/lessons_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoadPage extends StatefulWidget {
  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  var checked = false;
  var loading = true;

  check() async {
    Future<dynamic> ok = Variable.isSet('first');
    ok.then((i) {
      setState(() {
        loading = false;
        checked = i;
      });
      if (i) {
        Future<dynamic> getter = Variable.getIntValuesSF('systemTheme');
        getter.then((val) {
          globals.systemBrightness = val == 1 ? true : false;
        });
        getter = Variable.getIntValuesSF('theme');
        getter.then((val) {
          globals.brightness = val == 1 ? Brightness.dark : Brightness.light;
          Navigator.of(context).push(_createRouteHome());
        });
      } else
        Navigator.of(context).push(_createRouteSecond());
    });
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(body: Center(child: new CircularProgressIndicator()))
        : Container();
  }
}


class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final textController = TextEditingController();

  List<Lesson> lessonsL = new List<Lesson>();
  List<User> teachersL = new List<User>();

  var start = false;
  var load = false;

  Future<http.Response> loadDataFromServer() async {
    return await http
        .get('https://brumobile.000webhostapp.com/get.php?group=1');
  }

  loadDataToDatabase() async {
    http.Response jsonString = await loadDataFromServer();

    if (jsonString.statusCode == 200) {
      List<String> outputs = jsonString.body.split('%');

      final parsedLessons = json.decode(outputs[0]) as List;
      final parsedTeachers = json.decode(outputs[1]) as List;

      lessonsL = parsedLessons.map((json) => Lesson.fromJson(json)).toList();
      teachersL = parsedTeachers.map((json) => User.fromJson(json)).toList();

      for (Lesson les in lessonsL) {
        DBProvider.newLesson(les);
      }

      for (User us in teachersL) {
        DBProvider.newUser(us);
      }

      Variable.addInt('first', 1);
      Variable.addInt('systemTheme', 1);
      Variable.addInt('defaultTheme', 0);

      setState(() {
        start = false;
        load = true;
      });

      Navigator.of(context).push(_createRouteHome());
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return start
        ? Scaffold(body: Center(child: new CircularProgressIndicator()))
        : Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/back.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.blue.withOpacity(0.5), BlendMode.screen)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/app.png', scale: 1.7),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        top: 10.0, bottom: 3.0, right: 25, left: 25),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.grey[600]),
                                borderRadius: new BorderRadius.circular(18.0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.grey),
                              hintText: 'Название группы'),
                          controller: textController,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RaisedButton(
                          color: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey)),
                          onPressed: () async {
                            setState(() {
                              start = true;
                            });
                            loadDataToDatabase();
                          },
                          textColor: Colors.grey[600],
                          child: Container(
                              decoration: BoxDecoration(),
                              child: Text('Далее')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

Route _createRouteHome() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => LessonsPage(),
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

Route _createRouteSecond() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SecondPage(),
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