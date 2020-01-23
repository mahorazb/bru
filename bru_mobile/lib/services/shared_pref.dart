import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Variable {

  static addInt(String vname, int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(vname, val);
    debugPrint('Sets!');
  }

  static getIntValuesSF(String vname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int intValue = prefs.getInt(vname);
    debugPrint('Get $vname');
    return intValue;
  }

  static isSet(String vname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey(vname);
    return checkValue;
  }

}