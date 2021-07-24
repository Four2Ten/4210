import 'package:flutter/services.dart';
import 'package:four_2_ten/Error/JoinGameError.dart';
import 'package:four_2_ten/GameLogic/GameState.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Network/NetworkController.dart';
import 'dart:io';

import 'package:four_2_ten/Utils/AnswerChecker.dart';

class GameController {

  bool isHost = false; //default

  // platform specific channels (mainly for firebase id)
  // static const android_id_channel = const MethodChannel("com.example.four_2_ten/android_channel");
  // game information
  List<Player> otherPlayers = <Player>[];
  late Player currPlayer;
  // String id; // user id
  // GameState gameState;
  late String pin; // room pin
  // List<int> roundDurationIntervals;
  late String currentQuestion;

  // network controller
  late NetworkController networkController;

  // Callback to update UI
  late Function uiCallback;

  GameController() {
    networkController = NetworkController();
  }

  void attachJoinListener(Function onJoin) {
    // TODO: remove duplication
    var onJoinCallback = (List<Player> players) {
      otherPlayers = players.where((element) => element.name != currPlayer.name).toList();
      onJoin();
    };

    networkController.attachJoinListener(onJoinCallback);
  }

  void joinRoom(Function onJoin) {
    var onJoinCallback = (List<Player> players) {
      otherPlayers = players.where((element) => element.name != currPlayer.name).toList();
      onJoin();
    };

    networkController.joinRoom(pin, currPlayer.name, currPlayer.colour, onJoinCallback);
  }

  void attachReadyListener(Function onReceiveReady) {
    var networkCallback = (String name) {
      if (name == currPlayer.name) {
        currPlayer.isReady = true;
      } else {
        otherPlayers.forEach((player) {
          if (player.name == name) {
            player.isReady = true;
          }
        });
      }
      onReceiveReady();
    };

    networkController.attachReadyListener(networkCallback);
  }

  void indicateReady() {
    networkController.indicateReady(pin, currPlayer.name);
  }

  void indicatePass() {
    networkController.indicatePass(pin, currPlayer.name);
  }

  void attachGameStartListener(Function onStartGame) {
    networkController.attachGameStartListener(onStartGame);
  }

  void attachMainGameListeners(Function onStartRound, Function onGetCorrect,
      Function onTimeUp, Function onEndGame) {
    var onGetCorrectCallback = (String name, int score, String correctAnswer) {
      if (currPlayer.name == name) {
        currPlayer.score = score;
      } else {
        otherPlayers.forEach((player) {
          if (player.name == name) {
            player.score = score;
          }
        });
      }

      onGetCorrect(name, score, correctAnswer);
    };

    var onStartRoundCallback = (int round, String question) {
      currentQuestion = question;
      onStartRound(round);
    };

    networkController.attachMainGameListeners(onStartRoundCallback, onGetCorrectCallback,
        onTimeUp, onEndGame);
  }

  void getCorrect(String correctAnswer) {
    currPlayer.score++;
    networkController.getCorrect(pin, currPlayer.name, currPlayer.score, correctAnswer);
  }

  // `userExpression` format: "2+3+4+1"; `questionString` format: "1234"
  bool checkAnswer(String userExpression, String questionString) {
    return AnswerChecker.check(userExpression, questionString);
  }

/*
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
  // note: removed `pin` from arguments as it can be obtained from class property
  void joinRoom(String name, Colour colour) async {
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
   */
}