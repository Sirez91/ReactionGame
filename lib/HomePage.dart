import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BluetoothPage.dart';
import 'GamePage.dart';

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

  String _gameOneHighscore = "0";

  _readHighscores() async {
    final prefs = await SharedPreferences.getInstance();
    _gameOneHighscore = prefs.getInt("NoVibrateHighscore").toString() ?? "0";
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    _readHighscores();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return <PopupMenuEntry> [
                PopupMenuItem(
                  value: "test",
                  child: FlatButton.icon(
                    icon: Icon(Icons.settings),
                    label: Text("Settings"),
                    onPressed: () => _openBluetooth(),
                  ),
                ),
                PopupMenuItem(
                  value: "test2",
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
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                        icon: Icon(Icons.play_circle_filled),
                        onPressed: () => _startGame()),
                    new Text("Game Variant One"),
                    Spacer(flex: 3,),
                    new Text("Highscore: " + _gameOneHighscore),
                    Container(width: 50,)
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                        icon: Icon(Icons.play_circle_filled),
                        onPressed: () => _startGame()),
                    new Text("Game Variant 1212212"),
                    Spacer(flex: 3,),
                    new Text("Highscore: " + _gameOneHighscore),
                    Container(width: 50,)
                  ],
                ),
              ],
            )));
  }

  _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          title: "Game",
          device: _device,
        ),
      ),
    );
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
  }


}
