import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BluetoothPage.dart';
import 'GamePage.dart';
import 'SettingsPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.device}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  final BluetoothDevice device;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState(device);
  }
}

class _HomePageState extends State<HomePage> {
  BluetoothDevice _device;

  _HomePageState(this._device);

  String _reactionGameClassicHighscore = "0";
  String _reactionGameBluetoothHighscore = "0";
  String _reactionGameMixedHighscore = "0";

  _readHighscores() async {
    final prefs = await SharedPreferences.getInstance();
    _reactionGameClassicHighscore =
        prefs.getInt("reactionGameClassicHighscore").toString();
    _reactionGameBluetoothHighscore =
        prefs.getInt("reactionGameBluetoothHighscore").toString();
    _reactionGameMixedHighscore =
        prefs.getInt("reactionGameMixedHighscore").toString();
    if (_reactionGameClassicHighscore == "null") {
      _reactionGameClassicHighscore = "0";
    }
    if (_reactionGameBluetoothHighscore == "null") {
      _reactionGameBluetoothHighscore = "0";
    }
    if (_reactionGameMixedHighscore == "null") {
      _reactionGameMixedHighscore = "0";
    }
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    _readHighscores();
    _readColor();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  value: "Settings",
                  child: FlatButton.icon(
                    icon: Icon(Icons.settings),
                    label: Text("Settings"),
                    onPressed: () => _openSettings(),
                  ),
                ),
                PopupMenuItem(
                  value: "Connect Bluetooth Device",
                  child: FlatButton.icon(
                    icon: Icon(Icons.bluetooth),
                    label: Text("Connect Bluetooth Device"),
                    onPressed: () => _openBluetooth(),
                  ),
                ),
              ];
            })
          ],
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: new Text("Choose the Game Mode",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: new GestureDetector(
                onTap: () => _startClassicGame(),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: new Icon(Icons.play_circle_filled, color: Colors.green[500], size: 40,),
                    ),
                    new Text(
                      "Classic",
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    new Text("Highscore: " + _reactionGameClassicHighscore),
                    Container(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: new GestureDetector(
                onTap: _device != null
                    ? () => _startBluetoothGame()
                    : () => _openBluetooth(),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: new Icon(Icons.play_circle_filled,
                          color: _device != null ? Colors.green[500] : Colors.grey, size: 40,),
                    ),
                    new Text(
                      _device != null ? "Wearable" : "Wearable (no device)",
                      style: TextStyle(
                          color: _device != null ? Colors.black : Colors.grey,
                          fontSize: 20),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    new Text(
                      "Highscore: " + _reactionGameBluetoothHighscore,
                      style: TextStyle(
                          color: _device != null ? Colors.black : Colors.grey),
                    ),
                    Container(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: new GestureDetector(
                onTap: _device != null
                    ? () => _startMixedGame()
                    : () => _openBluetooth(),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: new Icon(Icons.play_circle_filled,
                          color: _device != null ? Colors.green[500] : Colors.grey, size: 40,),
                    ),
                    new Text(
                      _device != null ? "Mixed" : "Mixed (no device)",
                      style: TextStyle(
                          color: _device != null ? Colors.black : Colors.grey,
                          fontSize: 20),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    new Text(
                      "Highscore: " + _reactionGameMixedHighscore,
                      style: TextStyle(
                          color: _device != null ? Colors.black : Colors.grey),
                    ),
                    Container(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }

  _startClassicGame() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
              title: "Classic Reaction Game",
              device: null,
            ),
      ),
    );
    _readHighscores();
  }

  _openBluetooth() async {
    _device = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BluetoothPage(
              title: "Bluetooth",
            ),
      ),
    ) as BluetoothDevice;
    setState(() {});
  }

  _startBluetoothGame() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
              title: "Wearable Reaction Game",
              device: _device,
            ),
      ),
    );
    _readHighscores();
  }

  _startMixedGame() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
              title: "Mixed Reaction Game",
              device: _device,
            ),
      ),
    );
    _readHighscores();
  }

  _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          title: "Settings",
        ),
      ),
    );
    setState(() {});
  }

  void _readColor() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('arrow_upward') != null) {
      SettingsPage.upArrowColor = Color(prefs.getInt('arrow_upward'));
    }
    if(prefs.getInt('arrow_forward') != null) {
      SettingsPage.rightArrowColor = Color(prefs.getInt('arrow_forward'));
    }
    if(prefs.getInt('arrow_back') != null) {
      SettingsPage.leftArrowColor = Color(prefs.getInt('arrow_back'));
    }
    if(prefs.getInt('arrow_downward') != null) {
      SettingsPage.downArrowColor = Color(prefs.getInt('arrow_downward'));
    }
    setState(() {});
  }
}
