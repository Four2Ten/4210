import 'package:flutter/material.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';
import 'package:four_2_ten/GameLogic/HostGameController.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';

import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/View/Commons.dart';
import 'package:four_2_ten/View/CustomElevatedButton.dart';
import 'package:four_2_ten/View/WaitingRoom.dart';
import 'package:global_configuration/global_configuration.dart';

// For now, Two players can choose the same colour.
// TODO: only can choose unique colours.
class ChooseCarScreen extends StatefulWidget {
  final GameController gameController;

  ChooseCarScreen(this.gameController);

  @override
  ChooseCarScreenState createState() => ChooseCarScreenState(gameController);
}

class ChooseCarScreenState extends State<ChooseCarScreen> {
  GameController gameController;

  late Colour _chosenColour;
  late String _name;

  ChooseCarScreenState(this.gameController);

  Widget _getRow(Colour firstColour, Colour secondColour,
      Colour thirdColour, double imageWidth) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(onPressed: () => _onPickCar(firstColour), child: _getSizedImage(firstColour, imageWidth)),
        FlatButton(onPressed: () => _onPickCar(secondColour), child: _getSizedImage(secondColour, imageWidth)),
        FlatButton(onPressed: () => _onPickCar(thirdColour), child: _getSizedImage(thirdColour, imageWidth)),
      ],
    );
  }

  Image _getSizedImage(Colour colour, double width) {
    String source = Commons.colourToAssetString(colour);

    return Image(
      image: AssetImage(source),
      width: width,
    );
  }

  void _onPickCar(Colour colour) {
    _chosenColour = colour;
  }

  void _onPressEnterGame() {
    gameController.currPlayer = Player("8888888", _name, _chosenColour); // TODO: 8888 is a placeholder

    if (gameController.isHost) {
      Function onCreateCallback = (roomNumber) {
        gameController.pin = roomNumber;
        print("ROOM NUMBER IS " + roomNumber);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WaitingRoom(gameController)),
        );
      };
      (gameController as HostGameController).createRoom(onCreateCallback);
    } else {
      gameController.joinRoom(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WaitingRoom(gameController)),
        );
      });
    }
  }

  void _onTextFieldChange(String value) {
    _name = value;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth * 0.05;
    double smallFontSize = GlobalConfiguration().getValue("smallFontSize");

    // spacing sizes
    double topSpacing = screenHeight * 0.1;
    double headerAndFirstRowSpacing = screenHeight * 0.1;
    double interRowSpacing = screenHeight * 0.08;
    double rowAndTextFieldSpacing = screenHeight * 0.05;
    double textFieldAndButtonSpacing = screenHeight * 0.05;
    double imageWidth = screenWidth / 5;

    return new Scaffold(
        backgroundColor: HexColor.fromHex('#372549'),
        body: new Container(
            padding: new EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
            child: Center(
                child: SingleChildScrollView( // to prevent bottom overflow
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: topSpacing),
                      Commons.getTitle('Pick Your Car'),
                      SizedBox(height: headerAndFirstRowSpacing),
                      _getRow(Colour.lightBlue, Colour.orange, Colour.green, imageWidth),
                      SizedBox(height: interRowSpacing),
                      _getRow(Colour.darkBlue, Colour.pink, Colour.red, imageWidth),
                      SizedBox(height: rowAndTextFieldSpacing),
                      TextField(
                        onChanged: _onTextFieldChange,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "WalterTurncoat",
                          fontSize: smallFontSize,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your name...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "WalterTurncoat",
                            fontSize: smallFontSize,
                          )
                        ),
                      ),
                      SizedBox(height: textFieldAndButtonSpacing),
                      CustomElevatedButton('Enter Game', _onPressEnterGame),
                    ]
                  ),
                )
            )
        )
    );
  }
}