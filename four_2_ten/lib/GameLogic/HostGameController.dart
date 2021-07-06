import 'dart:async';

import 'package:four_2_ten/GameLogic/GameState.dart';
import 'package:four_2_ten/Network/HostNetworkController.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';

import 'NumberGenerator.dart';

// Note: a solo player is also a host, but it doesn't need Network
class HostGameController extends GameController {

  Timer timer;
  int numberOfQuestions;
  int roundDuration;

  // For "Challenge Yourself" Mode
  bool isSolo;
  int roundNumber = 0;

  // number generator used to generate questions
  NumberGenerator numberGenerator = new NumberGenerator();

  HostGameController() : super() {
    networkController = HostNetworkController();
    super.isHost = true;
  }

  void handleRoomCreation(String pin) {
    // TODO: inform view of room creation
    print(pin);
  }

  void setRoomSettings(int numberOfQuestions, int timerDuration) {
    this.numberOfQuestions = numberOfQuestions;
    this.roundDuration = timerDuration;
  }

  void createRoom() {
    (networkController as HostNetworkController).createRoom(handleRoomCreation);
  }

  void startGame() {
    int interval = (this.roundDuration / 3).floor();
    List<int> roundDurationIntervals = [interval, 2 * interval, 3 * interval];
    (networkController as HostNetworkController).startGame(this.pin, roundDurationIntervals);
  }

  void startRound() {
    (networkController as HostNetworkController).startRound(this.pin);
  }

  // For "Challenge Yourself" Mode
  void _startNextRound(Timer timer) {
    roundNumber++;
    if (roundNumber > numberOfQuestions) {
      print("ROUND ENDED!");
      return;
    }

    super.currentQuestion = numberGenerator.generate();
    super.uiCallback();
  }

  // For "Challenge Yourself" Mode
  void startSoloRound({bool isPass = false}) {
    if (!isSolo) {
      print("This method shouldn't be called!");
      return;
    }

    if (timer != null) {
      timer.cancel();
    }

    roundNumber++;
    if (roundNumber > numberOfQuestions) {
      print("ROUND ENDED!");
      return;
    }

    super.currentQuestion = numberGenerator.generate();

    timer = new Timer.periodic(Duration(seconds: this.roundDuration), _startNextRound);
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
}