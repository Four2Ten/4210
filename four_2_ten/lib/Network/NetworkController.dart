import 'package:firebase_database/firebase_database.dart';
import 'package:four_2_ten/Error/JoinGameError.dart';
import 'package:four_2_ten/GameLogic/GameState.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Utils/StringToEnum.dart';

class NetworkController {
  final ref = FirebaseDatabase.instance.reference();
  String takenRoomPinsLabel = "takenRoomPins"; // for storing room ids
  String roomLabel = "rooms"; // for storing rooms and players
  String pinLabel = "pin";
  String playerLabel = "player";
  String gameStateLabel = "gameState";

  final int maximumNumberOfPlayers = 6;
  final maxNumberForPin = 9999;
  final minNumberForPin = 1000;

  void joinRoom(String pin, Player player) {
    ref.once().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      var roomInfo = data[roomLabel][pin];
      if (roomInfo != null) {
        var players = roomInfo[playerLabel];
        players = players == null ? new List<Player>() : players;
        // if there are already too many players or the game is already ongoing
        if (players.length == maximumNumberOfPlayers || roomInfo[gameStateLabel] != null) {
          throw new JoinGameError("Room is already full");
        } else {
          _addPlayerToRoom(pin, player);
        }
      }
    });
  }

  void _addPlayerToRoom(String pin, Player player) {
    var userProfile = {
      "name": player.name,
      "colour": player.colour.toString()
    };
    ref.child(roomLabel + "/" + pin + "/" + playerLabel + "/"+ player.id)
        .set(userProfile);
  }

  void attachPlayerJoinListener(String pin, Function(Player) onChange) {
    String path = roomLabel + "/" + pin + "/" + playerLabel;
    ref.child(path).onChildChanged.listen((event) {
      String playerId = event.snapshot.key;
      var userProfile = event.snapshot.value;
      String name = userProfile["name"];
      Colour colour = StringToEnum.stringToColourEnum(userProfile["colour"]);
      onChange(new Player(playerId, name, colour));
    });
  }

  void attachGameStateListener(String pin, Function(GameState) onChange) {
    String path = roomLabel + "/" + pin + "/" + gameStateLabel;
    ref.child(path).onChildChanged.listen((event) {
      String gameStateString = event.snapshot.value;
      GameState gameState = StringToEnum.stringToGameStateEnum(gameStateString);
      onChange(gameState);
    });
  }
}