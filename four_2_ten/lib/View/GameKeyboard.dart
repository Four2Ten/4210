import 'package:flutter/material.dart';

class GameKeyboard extends StatefulWidget {
  final List<int> numbers;

  GameKeyboard(this.numbers);

  @override
  _GameKeyboardState createState() => _GameKeyboardState(numbers);
}

class _GameKeyboardState extends State<GameKeyboard> {
  final List<int> numbers;
  List<bool> isPressedStates = [false, false, false, false]; // whether user has pressed a number button
  String currentString = ""; // what the user has entered on the keyboard

  static const GO_BUTTON_TEXT = "GO!";
  static const PASS_BUTTON_TEXT = "PASS";

  _GameKeyboardState(this.numbers);

  void _onPressKeyboardButton(String text) {
    if (text == GO_BUTTON_TEXT) {
      // TODO: implement
      print("pressed GO");
    } else if (text == PASS_BUTTON_TEXT) {
      // TODO: implement
      print("pressed PASS");
    } else {
      setState(() {
        currentString += text;
      });
    }
  }

  Widget _getButton(String text, double size, double fontSize, bool isPressed, {int index}) {
    return SizedBox(
      width: size,
      height: size,
      child: Card(
        color: isPressed ? Colors.grey : Colors.lightGreenAccent, // TODO: use our colour
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (!isPressed) {
              _onPressKeyboardButton(text);
            }

            RegExp _numeric = RegExp(r'^[0-9]$');
            if (_numeric.hasMatch(text)) {
              setState(() {
                isPressedStates[index] = true;
              });
            }
          },
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
        )
      ),
    );
  }

  Widget _getRow(double size, List<String> texts, List<double> fontSizes, {int firstIndex, int secondIndex}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getButton(texts[0], size, fontSizes[0],
            firstIndex == null ? false : isPressedStates[firstIndex], index: firstIndex),
        _getButton(texts[1], size, fontSizes[1],
            secondIndex == null ? false : isPressedStates[secondIndex], index: secondIndex),
        _getButton(texts[2], size, fontSizes[2], false),
        _getButton(texts[3], size, fontSizes[3], false),
      ],
    );
  }

  // `size refers to button size`
  Widget _getButtons(double size) {
    double symbolFontSize = 35;
    double wordFontSize = 15;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getRow(size, [numbers[0].toString(), numbers[1].toString(), '+', '-'],
            List.filled(4, symbolFontSize), firstIndex: 0, secondIndex: 1),
        _getRow(size, [numbers[2].toString(), numbers[3].toString(), '×', '÷'],
            List.filled(4, symbolFontSize), firstIndex: 2, secondIndex: 3),
        _getRow(size, ['(', ')', GO_BUTTON_TEXT, PASS_BUTTON_TEXT],
            [symbolFontSize, symbolFontSize, wordFontSize, wordFontSize]),
      ],
    );
  }

  // Includes display text + delete button
  Widget _getKeyboardTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          currentString,
          style: TextStyle(
            color: Colors.black,
            fontFamily: "WalterTurncoat",
            fontSize: 35, // TODO: standardise later
          ),
        ),
        IconButton(
          icon: const Icon(Icons.backspace),
          tooltip: 'Backspace',
          onPressed: () {
            setState(() {
              if (currentString != null && currentString.length > 0) {
                currentString = currentString.substring(0, currentString.length - 1);
              }
            });
          },
        ),
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
        child: Column(
          children: [
            _getKeyboardTop(),
            _getButtons(screenWidth / 6),
          ],
        )
      ),
    );
  }
}
