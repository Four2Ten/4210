import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Utils/StringToEnum.dart';

class NetworkController {
  // final ref = FirebaseDatabase.instance.reference();
  // String takenRoomPinsLabel = "takenRoomPins"; // for storing room ids
  // String roomLabel = "rooms"; // for storing rooms and players
  // String pinLabel = "pin";
  // String playerLabel = "player";
  // String gameStateLabel = "gameState";
  // String intervalsLabel = "intervals";

  final int maximumNumberOfPlayers = 6;
  // final maxNumberForPin = 9999;
  // final minNumberForPin = 1000;

  // Open a WebSocket to connect to backend server
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://tracker-project-298913.as.r.appspot.com'),
  );

  // Function callbacks
  Function onJoin;
  Function onCheckRoom;
  Function onCreate;
  Function onReceiveReady;
  Function onStartGame;
  Function onStartRound;
  Function onGetCorrect;
  Function onPass = () {}; // default
  Function onTimeUp;
  Function onEndGame;

  NetworkController() {
    _attachListener();
  }

  void _attachListener() {
    channel.stream.listen((message) {
      print("RECEIVED " + message);

      var reply = jsonDecode(message);
      var type = reply['type'];
      switch (type) {
        case 'CREATE_ROOM_REPLY':
          onCreate(reply['body']);
          break;
        case 'JOIN_ROOM_REPLY':
          bool isSuccess = reply['body']['message'] == 'success';
          if (isSuccess) {
            List<Player> players = List.empty(growable: true);
            for (var item in reply['body']['player']) {
              Player player = new Player("placeholder", item['name'],
                  StringToEnum.stringToColourEnum(item['colour'].substring(7))); // TODO: remove substirng hardcoding
              players.add(player);
            }
            onJoin(players);
          } else {
            // TODO: implement
          }
          break;
        case 'CHECK_ROOM_REPLY':
          bool isSuccess = reply['body']['message'] == 'success';
          String roomNumber = reply['body']['room'];
          String players = reply['body']['player'];
          onCheckRoom(isSuccess, roomNumber, players);
          break;
        case 'INDICATE_READY':
          var name = reply['body']['name'];
          onReceiveReady(name);
          break;
        case 'START_GAME':
          onStartGame();
          break;
        case 'START_ROUND':
          var round = reply['body']['round'];
          var question = reply['body']['question'];
          onStartRound(round, question);
          break;
        case 'GET_CORRECT':
          var correctPlayerName = reply['body']['name'];
          var score = reply['body']['score'];
          var correctAnswer = reply['body']['correctAnswer'];
          onGetCorrect(correctPlayerName, score, correctAnswer);
          break;
        case 'PASS':
          onPass();
          break;
        case 'TIME_UP':
          onTimeUp();
          break;
        case 'END_GAME':
          onEndGame();
          break;
        default:
          print("INVALID COMMAND!");
      }
    });
  }

  void checkRoom(String roomNumber) {
    var request = {
      'type': 'CHECK_ROOM',
      'body': {
        'room': roomNumber
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  void attachCheckRoomListener(Function onCheckRoom) {
    this.onCheckRoom = onCheckRoom;
  }

  void joinRoom(String roomNumber, String name, Colour colour, Function onJoin) {
    this.onJoin = onJoin;

    var request = {
      'type': 'JOIN_ROOM',
      'body': {
        'room': roomNumber,
        'name': name,
        'colour': colour.toString()
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  void attachJoinListener(Function onJoin) {
    this.onJoin = onJoin;
  }

  void attachReadyListener(Function onReceiveReady) {
    this.onReceiveReady = onReceiveReady;
  }

  void indicateReady(String roomNumber, String name) {
    var request = {
      'type': 'INDICATE_READY',
      'body': {
        'room': roomNumber,
        'name': name
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  void indicatePass(String roomNumber, String name) {
    var request = {
      'type': 'PASS',
      'body': {
        'room': roomNumber,
        'name': name
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  void attachGameStartListener(Function onStartGame) {
    this.onStartGame = onStartGame;
  }

  void attachMainGameListeners(Function onStartRound, Function onGetCorrect,
      Function onTimeUp, Function onEndGame) {
    this.onStartRound = onStartRound;
    this.onGetCorrect = onGetCorrect;
    this.onTimeUp = onTimeUp;
    this.onEndGame = onEndGame;
  }

  void getCorrect(String roomNumber, String name, int score, String correctAnswer) {
    var request = {
      'type': 'GET_CORRECT',
      'body': {
        'room': roomNumber,
        'name': name,
        'score': score,
        'correctAnswer': correctAnswer
      }
    };
    channel.sink.add(jsonEncode(request));
  }

  /*
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

  void pauseGame(String pin) {
    ref.child(roomLabel + "/" + pin + "/" + gameStateLabel)
        .set(GameState.pause);
  }

  void endRound(String pin) {
    ref.child(roomLabel + "/" + pin + "/" + gameStateLabel)
        .set(GameState.roundEnd);
  }

  void getRoundIntervals(String pin, Function(List<int>) setRoundInterval) async {
    ref.once().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      var intervalInfo = data[roomLabel][pin][intervalsLabel];
      setRoundInterval(intervalInfo);
    });
  }

  void attachPlayerJoinListener(String pin, Function(String, Player) onChange) {
    String path = roomLabel + "/" + pin + "/" + playerLabel;
    ref.child(path).onChildChanged.listen((event) {
      String playerId = event.snapshot.key;
      var userProfile = event.snapshot.value;
      String name = userProfile["name"];
      Colour colour = StringToEnum.stringToColourEnum(userProfile["colour"]);
      onChange(pin, new Player(playerId, name, colour));
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
   */
}