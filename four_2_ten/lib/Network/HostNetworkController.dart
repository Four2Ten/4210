import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:four_2_ten/Model/Colour.dart';

import 'NetworkController.dart';

class HostNetworkController extends NetworkController {

  void createRoom(String name, Colour colour, Function onCreate) {
    var request = {
      "type": "CREATE_ROOM",
      "body": {
        "name": name,
        "colour": colour.toString()
      }
    };
    // assign listener
    super.onCreate = onCreate;
    channel.sink.add(jsonEncode(request));
  }

  void startGame(String roomNumber) {
    var request = {
      "type": "START_GAME",
      "body": {
        "room": roomNumber
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  void startRound(String roomNumber, int round, String question) {
    var request = {
      'type': 'START_ROUND',
      'body': {
        'room': roomNumber,
        'round': round,
        'question': question
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  void indicateTimeUp(String roomNumber) {
    var request = {
      'type': 'TIME_UP',
      'body': {
        'room': roomNumber
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  void endGame(String roomNumber) {
    var request = {
      'type': 'END_GAME',
      'body': {
        'room': roomNumber
      }
    };
    channel.sink.add(jsonEncode(request));
  }

/*
  final _random = new Random();

  String _generateNewPin(List<String> existingRoomPins) {
    String newPin = (minNumberForPin + _random.nextInt(maxNumberForPin - minNumberForPin)).toString();
    while (existingRoomPins.contains(newPin)) {
      newPin = (minNumberForPin + _random.nextInt(maxNumberForPin - minNumberForPin)).toString();
    }
    return newPin;
  }

  void createRoom(Function(String pin) onComplete) {
    ref.once().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      var existingRoomPins = new List<String>();
      if (data != null && data[takenRoomPinsLabel] != null) {
        for (String roomPin in data[takenRoomPinsLabel].values) {
          existingRoomPins.add(roomPin);
        }
      }
      String newPin = _generateNewPin(existingRoomPins);
      ref.child(takenRoomPinsLabel).push().set(newPin);
      // create room
      ref.child(roomLabel + "/" + newPin).set({
        pinLabel: newPin
      });
      onComplete(newPin);
    });
  }

  void startGame(String pin, List<int> roundIntervalDurations) {
    ref.child(roomLabel + "/" + pin + "/" + gameStateLabel)
        .set(GameState.gameStart);
    ref.child(roomLabel + "/" + pin + "/" + intervalsLabel).set(roundIntervalDurations);
  }

  void startRound(String pin) {
    ref.child(roomLabel + "/" + pin + "/" + gameStateLabel)
        .set(GameState.roundStart);
  }

 */

}