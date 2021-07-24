import 'dart:async';

import 'package:four_2_ten/Network/HostNetworkController.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';

import 'NumberGenerator.dart';

// Note: a Solo player is also a host, but they don't need Network
class HostGameController extends GameController {

  late Timer timer;
  late int numberOfQuestions;
  late int roundDuration;
  late int roundNumber = 0;
  late int numberOfPasses = 0;

  // For generating questions
  late NumberGenerator numberGenerator = new NumberGenerator();

  // For "Challenge Yourself" Mode
  late bool isSolo;

  HostGameController() : super() {
    networkController = HostNetworkController();
    super.isHost = true;
  }

  void setRoomSettings(int numberOfQuestions, int timerDuration) {
    this.numberOfQuestions = numberOfQuestions;
    this.roundDuration = timerDuration;
  }

  void createRoom(Function onCreate) {
    (networkController as HostNetworkController).createRoom(currPlayer.name,
        currPlayer.colour, onCreate);
  }

  bool isEveryoneReady() {
    return otherPlayers.fold(true, (previousValue, element) => previousValue && element.isReady);
  }

  void startGame() {
    (networkController as HostNetworkController).startGame(pin);
  }

  void indicateTimeUp() {
    (networkController as HostNetworkController).indicateTimeUp(pin);
  }

  void endGame() {
    (networkController as HostNetworkController).endGame(pin);
  }

  @override
  void attachMainGameListeners(Function onStartRound, Function onGetCorrect,
      Function onTimeUp, Function onEndGame) {
    // TODO: remove duplication!
    var onStartRoundCallback = (int round, String question) {
      currentQuestion = question;
      onStartRound(round);
    };

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
      // NOTE: specific to host
      Timer(Duration(milliseconds: 1200), startRound);
    };

    networkController.attachMainGameListeners(onStartRoundCallback, onGetCorrectCallback,
        onTimeUp, onEndGame);
  }

  void attachPassCallback() {
    var onPassCallback = () {
      numberOfPasses++;
      int numberOfPlayers = otherPlayers.length + 1;
      print("number of passes is " + numberOfPasses.toString());
      print("number of players is " + numberOfPlayers.toString());
      if (numberOfPasses == numberOfPlayers) {
        startRound();
        numberOfPasses = 0;
      }
    };
    (networkController as HostNetworkController).attachOnPassListener(onPassCallback);
  }

  void startRound() {
    if (timer != null) {
      timer.cancel();
    }

    roundNumber++;
    if (roundNumber > numberOfQuestions) {
      print("ROUND ENDED!");
      return;
    }

    if (isSolo) {
      // For "Challenge Yourself" Mode
      super.currentQuestion = numberGenerator.generate();
      timer = new Timer.periodic(Duration(seconds: this.roundDuration), _startNextRound);
    } else {
      // For Multi-player Mode
      timer = new Timer.periodic(Duration(seconds: this.roundDuration), _startNextRound);
      String question = numberGenerator.generate();
      (networkController as HostNetworkController).startRound(pin, roundNumber, question);
    }
  }

  void _startNextRound(Timer timer) {
    if (isSolo) {
      roundNumber++;
      if (roundNumber > numberOfQuestions) {
        print("ROUND ENDED!");
        return;
      }
      super.currentQuestion = numberGenerator.generate();
      super.uiCallback(roundNumber);
    } else {
      startRound();
    }
  }

/*
  void startGame() {
    int interval = (this.roundDuration / 3).floor();
    List<int> roundDurationIntervals = [interval, 2 * interval, 3 * interval];
    (networkController as HostNetworkController).startGame(this.pin, roundDurationIntervals);
  }
  void startRound() {
    (networkController as HostNetworkController).startRound(this.pin);
  }
  @override
  void handleGameStateChange(GameState gameState) {
    super.handleGameStateChange(gameState);
    if (gameState == GameState.roundStart) {
      this.timer = new Timer(Duration(seconds: this.roundDuration), handleRoundEnd);
    }
  }
  void handleRoundEnd() {
    (networkController as HostNetworkController).endRound(this.pin);
  }
   */
}