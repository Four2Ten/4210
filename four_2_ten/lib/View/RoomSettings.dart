import 'dart:math';

import 'package:flutter/material.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:four_2_ten/Config/doubleValueGameConfig.dart';
import 'package:four_2_ten/Config/appConfig.dart';

class RoomSettings extends StatefulWidget {
  RoomSettings({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RoomSettingsState createState() => RoomSettingsState();
}
class RoomSettingsState extends State<RoomSettings> with SingleTickerProviderStateMixin {
  double _currentNumberOfQuestions;
  double _currentDurationValue;
  double minNumOfQuestions;
  double maxNumOfQuestions;
  double minRoundDuration;
  double maxRoundDuration;

  RoomSettingsState() {
    GlobalConfiguration().loadFromMap(doubleValueGameConfig);
    GlobalConfiguration().loadFromMap(appConfig);
    minNumOfQuestions = GlobalConfiguration().getValue("minNumOfQuestions");
    maxNumOfQuestions = GlobalConfiguration().getValue("maxNumOfQuestions");
    minRoundDuration = GlobalConfiguration().getValue("minRoundDuration");
    maxRoundDuration = GlobalConfiguration().getValue("maxRoundDuration");
    _currentNumberOfQuestions = ((minNumOfQuestions + maxNumOfQuestions) / 2).roundToDouble();
    _currentDurationValue = ((minRoundDuration + maxRoundDuration) / 2).roundToDouble();
  }

  Text _getText(String string) {
    double bigFontSize = GlobalConfiguration().getValue("bigFontSize");
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontFamily: "WalterTurncoat",
      fontSize: bigFontSize,
    );
    return new Text(string, style: textStyle, textAlign: TextAlign.center);
  }

  RichText _getSliderText(List<String> text, int indexToBold) {
    double smallFontSize = GlobalConfiguration().getValue("smallFontSize");
    return new RichText(
        text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
          style: new TextStyle(
            color: Colors.white,
            fontFamily: "WalterTurncoat",
            fontSize: smallFontSize,
          ),
          children: new List<TextSpan>.generate(text.length, (int index) {
            if (index == indexToBold) {
              TextStyle emphasisedTextStyle = new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: smallFontSize + 2,
              );
              return new TextSpan(text: text[index], style: emphasisedTextStyle);
            } else {
              return new TextSpan(text: text[index]);
            }
          }),
        ),
        textAlign: TextAlign.center
    );
  }

  void setNumOfQuestions(double value) {
    setState(() {
      _currentNumberOfQuestions = value;
    });
  }

  void setRoundDuration(double value) {
    setState(() {
      _currentDurationValue = value;
    });
  }

  SliderTheme _getSlider(double curr, double min, double max, Function(double) onChange) {
    return SliderTheme(
      data: SliderThemeData(
          thumbColor: HexColor.fromHex('#FFD4D4'),
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
          activeTrackColor: HexColor.fromHex('#B9E6FF'),
      ),
      child: Slider(
        value: curr,
        min: min,
        max: max,
        divisions: (max - min).round(),
        label: curr.round().toString(),
        onChanged: (double value) {
          onChange(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth * 0.05;
    double headerAndSliderPadding = screenHeight * 0.1;
    double sliderAndDescriptionPadding = screenHeight * 0.01;
    List<String> questionSliderDescription = [
      "The first person to get ",
      _currentNumberOfQuestions.round().toString(),
      " questions correct wins"];
    List<String> durationSliderDescription = [
      "Proceeds to next round after ",
      _currentDurationValue.round().toString(),
      "s if no one gets it correct"
    ];

    return new Scaffold(
        backgroundColor: HexColor.fromHex('#372549'),
        body: new Container(
          padding: new EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
          child: Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _getText("number of questions"),
                  SizedBox(height: headerAndSliderPadding),
                  _getSlider(_currentNumberOfQuestions, minNumOfQuestions, maxNumOfQuestions, setNumOfQuestions),
                  SizedBox(height: sliderAndDescriptionPadding),
                  _getSliderText(questionSliderDescription, 1),
                  SizedBox(height: headerAndSliderPadding),
                  _getText("timer duration"),
                  SizedBox(height: headerAndSliderPadding),
                  _getSlider(_currentDurationValue, minRoundDuration, maxRoundDuration, setRoundDuration),
                  SizedBox(height: sliderAndDescriptionPadding),
                  _getSliderText(durationSliderDescription, 1)
                ]
            )
          )
        )
    );
  }
}