import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mo_co_app/GameButton.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title, this.device}) : super(key: key);

  final BluetoothDevice device;

  final String title;


  @override
  _GamePageState createState() {
    if (device == null) {
      return _NoVibrateGamePageState(device);
    } else {
      if(title == "Mixed Reaction Game") {
        return _MixedGamePageState(device);
      } else {
        return _VibrateGamePageState(device);
      }
    }
  }
}

abstract class _GamePageState extends State<GamePage> {
  bool _gameIsRunning = false;


  _GamePageState(this._device, this._iconSize);

  final BluetoothDevice _device;

  final double _iconSize;

  int _highscore;
  int _counter = 0;
  Timer _timer;

  int _animationSpeedInMiliseconds = _baseAnimationSpeedInMiliseconds;
  static final int _baseAnimationSpeedInMiliseconds = 3000;
  IconData _activeIcon;
  Alignment _alignment = Alignment.centerLeft;

  Future _startAnimation() async {
    setState(() {
      _animationSpeedInMiliseconds = 0;
      _alignment = Alignment.centerLeft;
    });
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _counter++;
      _animationSpeedInMiliseconds =
          (_baseAnimationSpeedInMiliseconds * (pow(0.98, _counter))).round();
      _alignment = Alignment.centerRight;
    });
    await Future.delayed(const Duration(milliseconds: 100));
    _timer =
        Timer(Duration(milliseconds: _animationSpeedInMiliseconds - 100), () {
          _gameOver();
        });
  }

  _writeCharacteristic();

  _stopVibration();

  _readHighscore(String key) async {
    final prefs = await SharedPreferences.getInstance();
    _highscore = prefs.getInt(key) ?? 0;
    setState(() {});
  }

  _saveHighscore(int score);

  _gameOver() {
    _stopVibration();
    _animationSpeedInMiliseconds = _baseAnimationSpeedInMiliseconds;
    if(_counter>_highscore) {
      _highscore = _counter;
      _saveHighscore(_counter);
    }
    _counter = 0;
    _gameIsRunning = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('GAME OVER'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() { });
                },
              )
            ],
          );
        });
  }

  void _topButtonPressed() {
    buttonAction(Icons.arrow_upward);
  }

  void _leftButtonPressed() {
    buttonAction(Icons.arrow_back);
  }

  void _rightButtonPressed() {
    buttonAction(Icons.arrow_forward);
  }

  void _bottomButtonPressed() {
    buttonAction(Icons.arrow_downward);
  }

  void buttonAction(IconData icon) {
    if(_gameIsRunning) {
      _timer.cancel();
      if (_activeIcon == icon) {
        _startAnimation();
      } else {
        _gameOver();
      }
    }
  }


  Container _generateIcon() {
    if (_animationSpeedInMiliseconds == 0 || _counter == 0) {
      return null;
    }

    int random = Random.secure().nextInt(4);
    Color color;
    switch (random) {
      case 0:
        _activeIcon = Icons.arrow_upward;
        color = Colors.yellow;
        break;
      case 1:
        _activeIcon = Icons.arrow_back;
        color = Colors.blue;
        break;
      case 2:
        _activeIcon = Icons.arrow_forward;
        color = Colors.red;
        break;
      case 3:
        _activeIcon = Icons.arrow_downward;
        color = Colors.green;
        break;
    }
    if (_counter != 0)
      _writeCharacteristic();
    return Container(
      height: _iconSize,
      child: Icon(_activeIcon, size: _iconSize, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Score: " + _counter.toString(),
                  style: TextStyle(fontSize: 30),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Highscore: " + _highscore.toString(),
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            Expanded(
              child: Container(
                width: 100,
              ),
            ),
            Row(
              children: <Widget>[
                AnimatedContainer(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width + 20,
                  padding: EdgeInsets.all(0.0),
                  duration: Duration(
                      milliseconds: _animationSpeedInMiliseconds),
                  alignment: _alignment,
                  child: _generateIcon(),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GameButton(
                  onPressed: _topButtonPressed,
                  color: Colors.yellow,
                  icon: Icons.arrow_upward,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GameButton(
                  onPressed: _leftButtonPressed,
                  color: Colors.blue,
                  icon: Icons.arrow_back,
                ),
                GameButton(
                  onPressed: null,
                  color: Colors.white,
                  icon: null,
                ),
                GameButton(
                  onPressed: _rightButtonPressed,
                  color: Colors.red,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GameButton(
                  onPressed: _bottomButtonPressed,
                  color: Colors.green,
                  icon: Icons.arrow_downward,
                ),
              ],
            ),
            Container(height: 80,)
          ],
        ),
      ),
      floatingActionButton: _gameIsRunning ? null : FloatingActionButton(
        onPressed: _startRound,
        tooltip: 'start animation',
        child: Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _startRound() {
    if(!_gameIsRunning) {
      _startAnimation();
      _gameIsRunning = true;
    }
  }
}

class _VibrateGamePageState extends _GamePageState {

  _VibrateGamePageState(BluetoothDevice device) : super(device, 0);

  @override
  initState() {
    super.initState();
    _readHighscore("reactionGameBluetoothHighscore");
  }

  _saveHighscore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'reactionGameBluetoothHighscore';
    prefs.setInt(key, score);
    setState(() {});
  }


  _writeCharacteristic() async {
    BluetoothCharacteristic bluetoothCharacteristic = BluetoothCharacteristic(
        uuid: Guid("713d0003-503e-4c75-ba94-3148f18d941e"),
        serviceUuid: Guid("713d0000-503e-4c75-ba94-3148f18d941e"),
        descriptors: null,
        properties: CharacteristicProperties(
            broadcast: false,
            read: true,
            writeWithoutResponse: true,
            write: true,
            notify: false,
            indicate: false,
            authenticatedSignedWrites: false,
            extendedProperties: false,
            notifyEncryptionRequired: false,
            indicateEncryptionRequired: false
        ));
    List<int> valueToWrite;
    if (_activeIcon == Icons.arrow_upward) {
      valueToWrite = [0xFF, 0x00, 0x00, 0x00];
    } else if (_activeIcon == Icons.arrow_back) {
      valueToWrite = [0x00, 0x00, 0x00, 0xFF];
    } else if (_activeIcon == Icons.arrow_forward) {
      valueToWrite = [0x00, 0xFF, 0x00, 0x00];
    } else {
      valueToWrite = [0x00, 0x00, 0xFF, 0x00];
    }
    await _device.writeCharacteristic(bluetoothCharacteristic, valueToWrite,
        type: CharacteristicWriteType.withoutResponse);
  }

  _stopVibration() async {
    BluetoothCharacteristic bluetoothCharacteristic = BluetoothCharacteristic(
        uuid: Guid("713d0003-503e-4c75-ba94-3148f18d941e"),
        serviceUuid: Guid("713d0000-503e-4c75-ba94-3148f18d941e"),
        descriptors: null,
        properties: CharacteristicProperties(
            broadcast: false,
            read: true,
            writeWithoutResponse: true,
            write: true,
            notify: false,
            indicate: false,
            authenticatedSignedWrites: false,
            extendedProperties: false,
            notifyEncryptionRequired: false,
            indicateEncryptionRequired: false
        ));
    await _device.writeCharacteristic(
        bluetoothCharacteristic, [0x00, 0x00, 0x00, 0x00],
        type: CharacteristicWriteType.withoutResponse);
  }
}

class _NoVibrateGamePageState extends _GamePageState {

  _NoVibrateGamePageState(BluetoothDevice device) : super(device, 75);

  @override
  initState() {
    super.initState();
    _readHighscore("reactionGameClassicHighscore");
  }

  _saveHighscore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'reactionGameClassicHighscore';
    prefs.setInt(key, score);
  }

  _writeCharacteristic() {}

  _stopVibration() {}
}

class _MixedGamePageState extends _GamePageState {

  _MixedGamePageState(BluetoothDevice device) : super(device, 75);

  @override
  initState() {
    super.initState();
    _readHighscore("reactionGameMixedHighscore");
  }

  _saveHighscore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'reactionGameMixedHighscore';
    prefs.setInt(key, score);
    setState(() {});
  }


  _writeCharacteristic() async {
    BluetoothCharacteristic bluetoothCharacteristic = BluetoothCharacteristic(
        uuid: Guid("713d0003-503e-4c75-ba94-3148f18d941e"),
        serviceUuid: Guid("713d0000-503e-4c75-ba94-3148f18d941e"),
        descriptors: null,
        properties: CharacteristicProperties(
            broadcast: false,
            read: true,
            writeWithoutResponse: true,
            write: true,
            notify: false,
            indicate: false,
            authenticatedSignedWrites: false,
            extendedProperties: false,
            notifyEncryptionRequired: false,
            indicateEncryptionRequired: false
        ));
    List<int> valueToWrite;
    if (_activeIcon == Icons.arrow_upward) {
      valueToWrite = [0xFF, 0x00, 0x00, 0x00];
    } else if (_activeIcon == Icons.arrow_back) {
      valueToWrite = [0x00, 0x00, 0x00, 0xFF];
    } else if (_activeIcon == Icons.arrow_forward) {
      valueToWrite = [0x00, 0xFF, 0x00, 0x00];
    } else {
      valueToWrite = [0x00, 0x00, 0xFF, 0x00];
    }
    await _device.writeCharacteristic(bluetoothCharacteristic, valueToWrite,
        type: CharacteristicWriteType.withoutResponse);
  }

  _stopVibration() async {
    BluetoothCharacteristic bluetoothCharacteristic = BluetoothCharacteristic(
        uuid: Guid("713d0003-503e-4c75-ba94-3148f18d941e"),
        serviceUuid: Guid("713d0000-503e-4c75-ba94-3148f18d941e"),
        descriptors: null,
        properties: CharacteristicProperties(
            broadcast: false,
            read: true,
            writeWithoutResponse: true,
            write: true,
            notify: false,
            indicate: false,
            authenticatedSignedWrites: false,
            extendedProperties: false,
            notifyEncryptionRequired: false,
            indicateEncryptionRequired: false
        ));
    await _device.writeCharacteristic(
        bluetoothCharacteristic, [0x00, 0x00, 0x00, 0x00],
        type: CharacteristicWriteType.withoutResponse);
  }
}