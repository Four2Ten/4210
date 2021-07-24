import 'package:four_2_ten/GameLogic/GameState.dart';
import 'package:four_2_ten/Model/Colour.dart';

class StringToEnum {
  static Colour stringToColourEnum(String string) {
    switch(string) {
      case "darkBlue":
          return Colour.darkBlue;
      case "lightBlue":
          return Colour.lightBlue;
      case "green":
          return Colour.green;
      case "orange":
          return Colour.orange;
      case "pink":
          return Colour.pink;
      case "red":
          return Colour.red;
      default:
          return Colour.darkBlue; // Default to dark blue
    }
  }

  static GameState stringToGameStateEnum(String string) {
    switch(string) {
      case "roundEnd":
          return GameState.roundEnd;
      case "roundStart":
          return GameState.roundStart;
      case "gameEnd":
          return GameState.gameEnd;
      case "pause":
          return GameState.pause;
    }
  }
}