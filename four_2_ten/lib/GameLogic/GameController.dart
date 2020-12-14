import 'package:flutter/services.dart';
import 'package:four_2_ten/GameLogic/NumberGenerator.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Network/NetworkController.dart';
import 'dart:io';

class GameController {
  // players
  List<Player> otherPlayers;
  Player currPlayer;
  // platform specific channels
  static const android_id_channel = const MethodChannel('com.example.four_2_ten/uid');
  // network controller
  NetworkController networkController = new NetworkController();
  // number generator used to generate questions and room pin
  NumberGenerator numberGenerator = new NumberGenerator();

  Future<String> getId() async {
    try {
      if (Platform.isAndroid) {
        String id = await android_id_channel.invokeMethod('getId');
        return id;
      } else if (Platform.isIOS) {
        // TODO: implement ios method
        return "";
      }
    } on PlatformException catch (e) {
      return null;
    }
  }

  void joinRoom(String pin, String name, Colour colour) async {
    String id = await getId();
    Player player = new Player(id, name, colour);
    networkController.joinRoom(pin, player);
    networkController.attachPlayerJoinListener(pin, (Player player){
      String playerId = player.id;
      if (playerId == id) {
        currPlayer = player;
      } else {
        otherPlayers.add(player);
      }
    });
  }

  void createRoom() {
    String pin = numberGenerator.generateRoomPin();
    networkController.createRoom(pin);
  }





}