import 'dart:async';

import 'package:four_2_ten/GameLogic/GameState.dart';
import 'package:four_2_ten/Network/HostNetworkController.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';

class HostGameController extends GameController {

  Timer timer;
  int numberOfQuestions;
  int roundDuration;

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