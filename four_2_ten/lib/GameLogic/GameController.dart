import 'package:flutter/services.dart';
import 'package:four_2_ten/Error/JoinGameError.dart';
import 'package:four_2_ten/GameLogic/GameState.dart';
import 'package:four_2_ten/GameLogic/NumberGenerator.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Network/HostNetworkController.dart';
import 'package:four_2_ten/Network/NetworkController.dart';
import 'dart:io';

import 'package:four_2_ten/Utils/AnswerChecker.dart';

class GameController {
  // platform specific channels (mainly for firebase id)
  static const android_id_channel = const MethodChannel("com.example.four_2_ten/android_channel");
  // game information
  List<Player> otherPlayers = new List<Player>();
  Player currPlayer;
  String id; // user id
  GameState gameState;
  String pin; // room pin
  List<int> roundDurationIntervals;

  // network controller
  NetworkController networkController;
  // number generator used to generate questions
  NumberGenerator numberGenerator = new NumberGenerator();

  GameController() {
    networkController = new NetworkController();
  }

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
    if (this.id == null) {
      this.id = await _getId();
    }
    Player player = new Player(this.id, name, colour);
    try {
      networkController.joinRoom(pin, player);
      attachRoomListeners(pin);
    } on JoinGameError catch (error) {
      // TODO: inform view of error
    }
  }

  void handleNewPlayer(String pin, Player player) {
    String playerId = player.id;
    if (playerId == this.id) {
      currPlayer = player;
      this.pin = pin;
    } else {
      otherPlayers.add(player);
    }
  }

  void handleGameStateChange(GameState gameState) {
    this.gameState = gameState;
    switch(gameState) {
      case GameState.gameStart: {
        networkController.getRoundIntervals(this.pin,
                (List<int> intervals) => this.roundDurationIntervals = intervals);
        break;
      }
      case GameState.roundStart: {
        break;
      }
      case GameState.roundEnd: {
        break;
      }
      case GameState.pause: {
        break;
      }
      case GameState.gameEnd: {
        break;
      }
    }
  }

  void pauseGame() {
    networkController.pauseGame(this.pin);
  }

  void attachRoomListeners(String pin) {
    // listener to detect new players
    networkController.attachPlayerJoinListener(pin, handleNewPlayer);
    networkController.attachGameStateListener(pin, handleGameStateChange);
  }

  void startRound() {
    (networkController as HostNetworkController).startRound(this.pin);
  }

  // `userExpression` format: "2+3+4+1"; `questionString` format: "1234"
  bool checkAnswer(String userExpression, String questionString) {
    return AnswerChecker.check(userExpression, questionString);
  }
}