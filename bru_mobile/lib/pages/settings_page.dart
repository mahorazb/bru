import 'package:flutter/material.dart';
import 'package:bru_mobile/constants/global.dart' as globals;
import 'package:bru_mobile/services/shared_pref.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _isSwitched;
  bool _subGroup = false;
  String subGroup = '1';

  @override
  Widget build(BuildContext context) {
    if(globals.brightness == Brightness.dark){
      _isSwitched = true;
    }else{
      _isSwitched = false;
    }

    var brightness = globals.systemBrightness ? MediaQuery.of(context).platformBrightness : globals.brightness;

    return Scaffold(
      backgroundColor: brightness == Brightness.dark ? Colors.black : Colors.blue[50],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: brightness == Brightness.dark ? Colors.white : Colors.black),
                iconSize: 25.0,
                //color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Параметры', style: TextStyle(
                    color: brightness == Brightness.dark ? Colors.white : Colors.black
                  ),),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: brightness == Brightness.dark ? Colors.black : Colors.blue[50],
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
          ),
        ],
      ),
      body: Container(
         margin: EdgeInsets.only(
                                            top: 3.0,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                            vertical: 15.0
                                          ),
                                           decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)
                      ),
                      color: brightness == Brightness.dark ? Colors.black : Colors.white
          ),
              child: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.group, color: brightness == Brightness.dark ? Colors.white : Colors.black,),
                title: Text('Подгруппа $subGroup', style: TextStyle(
                  color: brightness == Brightness.dark ? Colors.white : Colors.black
                ),),
                trailing: Switch(
                  inactiveTrackColor: Colors.grey[400],
                  onChanged:(val) {
                      setState(() { 
                        _subGroup = val;
                        subGroup = val ? '2' : '1';
                        
                      }); 
                    },
                  value: _subGroup,
                ),
              ),
              GestureDetector(
                child: ListTile(
                leading: Icon(Icons.color_lens, color: brightness == Brightness.dark ? Colors.white : Colors.black),
                title: Text('Обновить расписание', style: TextStyle(
                  color: brightness == Brightness.dark ? Colors.white : Colors.black
                ),),
              ),
                onTap: (){
                  debugPrint('Tap');
                },
              ),
              Divider(color: Colors.grey, thickness: 0.4,),
              ListTile(
                leading: Icon(Icons.color_lens, color: brightness == Brightness.dark ? Colors.white : Colors.black),
                title: Text('Системная тема', style: TextStyle(
                  color: brightness == Brightness.dark ? Colors.white : Colors.black
                ),),
                trailing: Switch(
                  inactiveTrackColor: Colors.grey[400],
                  onChanged: (bool val) {
                    Variable.addInt('systemTheme', val ? 1 : 0);
                    setState(() {
                      globals.systemBrightness = val;
                      
                    });
                  },
                  value: globals.systemBrightness,
                ),
              ),
              ListTile(
                leading: Icon(Icons.brightness_3, color: brightness == Brightness.dark ? Colors.white : Colors.black,),
                title: Text('Черная тема', style: TextStyle(
                  color: brightness == Brightness.dark ? Colors.white : Colors.black
                ),),
                trailing: Switch(
                  inactiveTrackColor: Colors.grey[400],
                  onChanged: !globals.systemBrightness ? (val) {
                      Variable.addInt('theme', val ? 1 : 0);
                      setState(() { 
                        globals.brightness = val ? Brightness.dark : Brightness.light;
                        
                      }); 
                    } : null,
                  value: _isSwitched,
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}