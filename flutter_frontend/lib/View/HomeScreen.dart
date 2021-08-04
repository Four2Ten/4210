import 'package:flutter/material.dart';
import 'package:four_2_ten/Config/appConfig.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/Utils/Instructions.dart';
import 'package:four_2_ten/View/CustomElevatedButton.dart';
import 'package:four_2_ten/View/FallingImage.dart';
import 'package:four_2_ten/View/JoinRoomScreen.dart';
import 'package:four_2_ten/View/RoomSettings.dart';
import "dart:math";

import 'package:global_configuration/global_configuration.dart';

class HomeScreen extends StatefulWidget {

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  HomeScreen(this.title, {Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _random = new Random();

  _HomeScreenState() {
    GlobalConfiguration().loadFromMap(appConfig);
  }

  List<Widget> _generateFallingCars(int number) {
    List<String> fallingCarsPaths = <String>[];
    List<String> carAssetPaths = [
      'lib/assets/images/red_car.png',
      'lib/assets/images/pink_car.png',
      'lib/assets/images/orange_car.png',
      'lib/assets/images/lightblue_car.png',
      'lib/assets/images/darkblue_car.png',
      'lib/assets/images/green_car.png',
    ];
    for (int i = 0; i < number; i++) {
      String carPath = carAssetPaths[_random.nextInt(carAssetPaths.length)];
      fallingCarsPaths.add(carPath);
    }
    double delay = 1 / (2 * number);
    return new List<Widget>.generate(fallingCarsPaths.length, (int index) {
      return new FallingImage(fallingCarsPaths[index], delay * index);
    });
  }

  List<Widget> _getInstructions(TextStyle textStyle)  {
    String text = Instructions.getInstructions();
    return new List<Widget>.generate(1, (int index) {
      return new Text(text, style: textStyle);
    });
    // List<String> splitText = text.split("\n");
    // return new List<Widget>.generate(splitText.length, (int index) {
    //   return new Text(splitText[index], style: textStyle);
    // });
  }

  Future<void> _showInstructions() async {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'DidactGothic',
      fontSize: GlobalConfiguration().getValue("smallFontSize"),
      height: 1.5,

    );
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Play?', style: textStyle),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          backgroundColor: HexColor.fromHex('#372549'),
          content: SingleChildScrollView(
              child: ListBody(
                children: _getInstructions(textStyle),
              ),
            ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it!', style: textStyle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  AppBar _getHeader() {
    return AppBar(
        elevation: 0,
        backgroundColor: HexColor.fromHex('#372549').withOpacity(0),
      actions: <Widget>[
        IconButton(
        icon: const Icon(Icons.help),
        onPressed: () {
          _showInstructions();
        }) ,
      ]
    );
  }

  void onCreateNewRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoomSettings()),
    );
  }

  void onJoinRoom() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinRoomScreen(new GameController())),
    );
  }

  void onChallengeYourself() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoomSettings(isSoloMode: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var gap = MediaQuery.of(context).size.height * 0.05;
    return new MaterialApp(
      title: '4210',
      home: new Scaffold(
        //Here you can set what ever background color you need.
          backgroundColor: HexColor.fromHex('#372549'),
          appBar: _getHeader(),
          body: new Stack(
              children: <Widget> [
                new Stack(
                  children: _generateFallingCars(15),
                ),
                Center(
                  child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('lib/assets/images/home_screen_title.png')),
                          SizedBox(height: gap),
                          CustomElevatedButton('create new room', onCreateNewRoom),
                          SizedBox(height: gap),
                          CustomElevatedButton('join a room', onJoinRoom),
                          SizedBox(height: gap),
                          CustomElevatedButton('challenge yourself', onChallengeYourself),
                        ]
                  ),
                ),
            ]
          )
      ),
    );
  }
}