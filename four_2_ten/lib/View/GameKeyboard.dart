import 'package:flutter/material.dart';

class GameKeyboard extends StatefulWidget {
  @override
  _GameKeyboardState createState() => _GameKeyboardState();
}

class _GameKeyboardState extends State<GameKeyboard> {

  Widget _getButton(String text, double size, double fontSize, bool isPressed) {
    return SizedBox(
      width: size,
      height: size,
      child: Card(
        color: Colors.lightGreenAccent, // TODO: use our colour
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "WalterTurncoat",
              fontSize: fontSize,
            ),
          )
        ),
      ),
    );
  }

  Widget _getRow(double size, List<String> texts, List<double> fontSizes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getButton(texts[0], size, fontSizes[0], false),
        _getButton(texts[1], size, fontSizes[1], false),
        _getButton(texts[2], size, fontSizes[2], false),
        _getButton(texts[3], size, fontSizes[3], false),
      ],
    );
  }

  // `size refers to button size`
  Widget _getButtons(double size, List<String> numbers) {
    double symbolFontSize = 35;
    double wordFontSize = 15;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getRow(size, [numbers[0], numbers[1], '+', '-'], List.filled(4, symbolFontSize)),
        _getRow(size, [numbers[2], numbers[3], '×', '÷'], List.filled(4, symbolFontSize)),
        _getRow(size, ['(', ')', 'GO!', 'PASS'],
            [symbolFontSize, symbolFontSize, wordFontSize, wordFontSize]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // TODO: figure out how to remove the horizontal margins
    return SizedBox(
      // width: screenWidth,
      height: screenHeight / 2,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.lightBlue, // TODO: use our colour
        child: _getButtons(screenWidth / 6, ['2', '4', '7', '9']),
      ),
    );
  }
}
