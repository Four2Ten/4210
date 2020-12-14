import 'package:firebase_database/firebase_database.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Utils/StringToEnum.dart';

class NetworkController {
  final ref = FirebaseDatabase.instance.reference();
  String roomLabel = "room";
  String playerLabel = "player";
  final int maximumNumberOfPlayers = 6;

  void createRoom(String pin) {
    ref.child(roomLabel).set({
      'pin': pin
    });
  }

  void joinRoom(String pin, Player player) {
    ref.once().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      if (data[pin] != null) {
        var players = data[pin];
        var userProfile = {
          "name": player.name,
          "colour": player.colour.toString()
        };
        if (players.contains(userProfile)) {
          return;
        } else if (players.length() == maximumNumberOfPlayers) {
          return;
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

  void attachPlayerJoinListener(String pin, Function(Player) onComplete) {
    String path = roomLabel + "/" + pin + "/" + playerLabel;
    ref.child(path).onChildChanged.listen((event) {
      String playerId = event.snapshot.key;
      var userProfile = event.snapshot.value;
      String name = userProfile["name"];
      Colour colour = StringToEnum.stringToColourEnum(userProfile["colour"]);
      onComplete(new Player(playerId, name, colour));
    });
  }
}