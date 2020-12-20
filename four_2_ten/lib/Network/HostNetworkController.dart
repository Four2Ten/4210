import 'package:firebase_database/firebase_database.dart';
import 'package:four_2_ten/GameLogic/GameState.dart';

import 'NetworkController.dart';
import 'dart:math';

class HostNetworkController extends NetworkController {
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

  void startRound(String pin) {
    ref.child(roomLabel + "/" + pin + "/" + gameStateLabel)
        .set(GameState.roundStart);
  }
}