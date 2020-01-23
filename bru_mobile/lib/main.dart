//import 'package:bru_mobile/widgets/exam.dart';
import 'package:bru_mobile/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("ru_ru", null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BRU Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: LoadPage(),
    );
  }
}