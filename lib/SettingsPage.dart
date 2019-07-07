import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  static Color upArrowColor = Colors.yellow;
  static Color leftArrowColor = Colors.blue;
  static Color rightArrowColor = Colors.red;
  static Color downArrowColor = Colors.green;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState(title);
  }
}

class SettingsState extends State<SettingsPage> {
  String title;

  SettingsState(this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
            automaticallyImplyLeading: true,
            title: new Text(title),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: Column(
          children: <Widget>[
            Container(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  ' Tab an Icon to\nchange its color',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: MaterialColorPicker(
                            onColorChange: (Color color) {
                              SettingsPage.upArrowColor = color;
                              _saveSetting(color, "arrow_upward");
                              setState(() {});
                            },
                            selectedColor: SettingsPage.upArrowColor,
                          ),
                        );
                      }),
                  child: Icon(
                    Icons.arrow_upward,
                    color: SettingsPage.upArrowColor,
                    size: 75,
                  ),
                ),
                Container(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: MaterialColorPicker(
                            onColorChange: (Color color) {
                              SettingsPage.leftArrowColor = color;
                              _saveSetting(color, "arrow_back");
                              setState(() {});
                            },
                            selectedColor: SettingsPage.leftArrowColor,
                          ),
                        );
                      }),
                  child: Icon(
                    Icons.arrow_back,
                    color: SettingsPage.leftArrowColor,
                    size: 75,
                  ),
                ),
                Container(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: MaterialColorPicker(
                            onColorChange: (Color color) {
                              SettingsPage.rightArrowColor = color;
                              _saveSetting(color, "arrow_forward");
                              setState(() {});
                            },
                            selectedColor: SettingsPage.rightArrowColor,
                          ),
                        );
                      }),
                  child: Icon(
                    Icons.arrow_forward,
                    color: SettingsPage.rightArrowColor,
                    size: 75,
                  ),
                ),
                Container(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: MaterialColorPicker(
                            onColorChange: (Color color) {
                              SettingsPage.downArrowColor = color;
                              _saveSetting(color, "arrow_downward");
                              setState(() {});
                            },
                            selectedColor: SettingsPage.downArrowColor,
                          ),
                        );
                      }),
                  child: Icon(
                    Icons.arrow_downward,
                    color: SettingsPage.downArrowColor,
                    size: 75,
                  ),
                ),

                Container(
                  width: 20,
                ),
              ],
            ),
          ],
        ));
  }

  _saveSetting(Color color, String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, color.value);
  }
}
