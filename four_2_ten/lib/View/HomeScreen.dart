import 'dart:io';

import 'package:flutter/material.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/Utils/Instructions.dart';
import 'package:four_2_ten/View/FallingImage.dart';
import "dart:math";

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _random = new Random();

  SizedBox _getElevatedButton(String text, BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          child: _getButtonText(text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(10),
            primary: HexColor.fromHex('#B9E6FF'),
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            print('Pressed');
          },
        )
    );
  }

  FittedBox _getButtonText(String text) {
    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'DidactGothic',
            fontSize: 30,
        )
      )
    );
  }

  List<Widget> _generateFallingCars(int number) {
    List<String> fallingCarsPaths = new List<String>();
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
      return new FallingImage(imagePath: fallingCarsPaths[index], delay: delay * index);
    });
  }

  List<Widget> _getInstructions(TextStyle textStyle)  {
    String text = Instructions.getInstructions();
    List<String> splitText = text.split("\n");
    return new List<Widget>.generate(splitText.length, (int index) {
      return new Text(splitText[index], style: textStyle);
    });
  }

  Future<void> _showInstructions() async {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'DidactGothic',
      fontSize: 20,
      height: 1.5
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How to Play', style: textStyle),
          content: SingleChildScrollView(
            child: ListBody(
              children: _getInstructions(textStyle)
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Okay', style: textStyle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: HexColor.fromHex('#372549'),
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

  @override
  Widget build(BuildContext context) {
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
                          SizedBox(height: 15),
                          _getElevatedButton('create new room', context),
                          SizedBox(height: 15),
                          _getElevatedButton('join a room', context),
                          SizedBox(height: 15),
                          _getElevatedButton('challenge yourself', context),
                        ]
                  ),
                ),
            ]
          )
      ),
    );
  }
}