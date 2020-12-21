import 'dart:async';

import 'package:flutter/material.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
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

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '4210',
      home: new Scaffold(
        //Here you can set what ever background color you need.
          backgroundColor: HexColor.fromHex('#372549'),
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
                          SizedBox(height: 10),
                          _getElevatedButton('create new room', context),
                          SizedBox(height: 10),
                          _getElevatedButton('join a room', context),
                          SizedBox(height: 10),
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

class FallingImage extends StatefulWidget {
  FallingImage({Key key, this.title, this.imagePath, this.delay}) : super(key: key);
  final String title;
  final String imagePath;
  final double delay;

  @override
  _FallingImageState createState() => _FallingImageState(this.imagePath, this.delay);
}
class _FallingImageState extends State<FallingImage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation curvedAnimation;
  final _random = new Random();
  final String imagePath;
  final double delay;

  _FallingImageState(this.imagePath, this.delay);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(seconds: 15),
        vsync: this
    );

    curvedAnimation = CurvedAnimation(parent: _animationController, curve: Interval(delay, min(delay + 0.3, 1.0), curve: Curves.linear));
    _animationController.forward(from: 0).whenComplete(() {
      _animationController.stop();
    });
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  Animation<Offset> _getOffsetAnimation(double width, double height, double imageWidth, double imageHeight) {
    double horizontalOffsetFactor = (width / (2 * imageWidth)) * pow(-1, _random.nextInt(2)); // randomize sign of offset
    double randomHorizontalPosition = _random.nextDouble() * horizontalOffsetFactor;
    double verticalOffset = height / (2 * imageHeight) + 1;
    return Tween<Offset>(
      begin: Offset(randomHorizontalPosition, -verticalOffset),
      end: Offset(randomHorizontalPosition, verticalOffset),
    ).animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    double imageWidth = 75;
    double imageHeight = 75;
    double randomRotation = _random.nextInt(45) / 360 * pow(-1, _random.nextInt(2));

    return new Center(
          child: new Stack(
              children: <Widget>[
                SlideTransition(
                  child: Container(
                    child: Opacity(
                      opacity: 0.8,
                      child: new RotationTransition(
                          turns: new AlwaysStoppedAnimation(randomRotation),
                          child: Image.asset(
                            this.imagePath,
                            height: imageHeight,
                            width: imageWidth,
                          )
                      ),
                    )
                  ),
                  position: _getOffsetAnimation(width, height, imageWidth, imageHeight)
                )
              ]
          )
    );
  }
}