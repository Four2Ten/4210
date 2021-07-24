import 'dart:math';

import 'package:flutter/material.dart';

class FallingImage extends StatefulWidget {

  final String imagePath;
  final double delay;

  FallingImage(this.imagePath, this.delay, {Key key}) : super(key: key);

  @override
  _FallingImageState createState() => _FallingImageState(this.imagePath, this.delay);
}
class _FallingImageState extends State<FallingImage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> curvedAnimation;
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
    double verticalOffset = height / (2 * imageHeight) + 1.5;
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