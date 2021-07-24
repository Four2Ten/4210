import 'Colour.dart';

class Player {
  String id;
  String name;
  int score = 0;
  Colour colour;
  bool isReady = false;

  Player(this.id, this.name, this.colour);

  void incrementScore() {
    this.score++;
  }

  void decrementScore() {
    this.score--;
  }
}

