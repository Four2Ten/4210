import 'package:four_2_ten/Colour.dart';

class Player {
  String id;
  String name;
  int score;
  Colour colour;

  Player(String id, String name, int score, Colour colour) {
    this.id = id;
    this.name = name;
    this.score = score;
    this.colour = colour;
  }

  void incrementScore() {
    this.score++;
  }

  void decrementScore() {
    this.score--;
  }
}

