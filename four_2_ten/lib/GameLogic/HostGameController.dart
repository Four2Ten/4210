import 'package:four_2_ten/Network/HostNetworkController.dart';

import 'GameController.dart';

class HostGameController extends GameController {
  HostGameController() {
    networkController = new HostNetworkController();
  }
  void handleRoomCreation(String pin) {
    // TODO: inform view of room creation
    print(pin);
  }

  void createRoom() {
    (networkController as HostNetworkController).createRoom(handleRoomCreation);
  }

  void startRound() {
    (networkController as HostNetworkController).startRound(this.pin);
  }

}