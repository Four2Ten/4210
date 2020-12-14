import 'package:firebase_database/firebase_database.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Utils/StringToEnum.dart';
import 'dart:math';

class NetworkController {
  final ref = FirebaseDatabase.instance.reference();
  String takenRoomPinsLabel = "takenRoomPins"; // for storing room ids
  String roomLabel = "rooms"; // for storing rooms and players
  String pinLabel = "pin";
  String playerLabel = "player";
  final int maximumNumberOfPlayers = 6;
  final _random = new Random();
  final maxNumberForPin = 9999;
  final minNumberForPin = 1000;

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

  void joinRoom(String pin, Player player) {
    ref.once().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      print(data[roomLabel][pin]);
      if (data[roomLabel][pin] != null) {
        var players = data[roomLabel][pin][playerLabel];
        print(players);
        players = players == null ? new List<Player>() : players;
        var userProfile = {
          "name": player.name,
          "colour": player.colour.toString()
        };
        if (players.length == maximumNumberOfPlayers) {
          return;
        } else {
          _addPlayerToRoom(pin, player);
        }
      }
    });
  }

  void _addPlayerToRoom(String pin, Player player) {
    var userProfile = {
      "name": player.name,
      "colour": player.colour.toString()
    };
    ref.child(roomLabel + "/" + pin + "/" + playerLabel + "/"+ player.id)
        .set(userProfile);
  }

  void attachPlayerJoinListener(String pin, Function(Player) onComplete) {
    String path = roomLabel + "/" + pin + "/" + playerLabel;
    ref.child(path).onChildChanged.listen((event) {
      String playerId = event.snapshot.key;
      var userProfile = event.snapshot.value;
      String name = userProfile["name"];
      Colour colour = StringToEnum.stringToColourEnum(userProfile["colour"]);
      onComplete(new Player(playerId, name, colour));
    });
  }
}