import 'Colour.dart';

class Player {
  String id;
  String name;
  int score = 0;
  Colour colour;
  bool isReady;

  Player(String id, String name, Colour colour) {
    this.id = id;
    this.name = name;
    this.colour = colour;
    this.isReady = false;
  }

  void incrementScore() {
    this.score++;
  }

  void decrementScore() {
    this.score--;
  }
}

