import 'package:flutter/services.dart';
import 'package:four_2_ten/GameLogic/NumberGenerator.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Network/NetworkController.dart';
import 'dart:io';

import 'package:four_2_ten/Utils/AnswerChecker.dart';

class GameController {
  // players
  List<Player> otherPlayers = new List<Player>();
  Player currPlayer;
  // platform specific channels
  static const android_id_channel = const MethodChannel("com.example.four_2_ten/android_channel");
  // network controller
  NetworkController networkController = new NetworkController();

  Future<String> _getId() async {
    try {
      if (Platform.isAndroid) {
        String id = await android_id_channel.invokeMethod('getId');
        return id;
      } else if (Platform.isIOS) {
        // TODO: implement ios method
        return "";
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      return null;
    }
  }


  void joinRoom(String pin, String name, Colour colour) async {
    String id = await _getId();
    Player player = new Player(id, name, colour);
    networkController.joinRoom(pin, player);
    networkController.attachPlayerJoinListener(pin, (Player player){
      String playerId = player.id;
      if (playerId == id) {
        currPlayer = player;
      } else {
        otherPlayers.add(player);
      }
      print(currPlayer);
    });
  }

  void handleRoomCreation(String pin) {
    // TODO: implement
    print(pin);
  }

  void createRoom() {
    networkController.createRoom(handleRoomCreation);
  }

  bool checkAnswer(String userExpression, String questionString) {
    return AnswerChecker.check(userExpression, questionString);
  }

}