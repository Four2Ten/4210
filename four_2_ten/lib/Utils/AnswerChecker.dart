import 'package:flutter/foundation.dart';

class AnswerChecker {

  // `userExpression` format: "2+3+4+1"; `questionString` format: "1234"
  static bool check(String userExpression, String questionString) {
    if (!_areAllDigitsUsed(userExpression, questionString)) {
      return false;
    }

    var finalValue = _evaluate(userExpression);

    return (finalValue - 10.0).abs() < 0.0000001; // prevent floating point rounding error
  }

  static bool _areAllDigitsUsed(String userExpression, String questionString) {
    List<int> userDigits = [];
    List<int> questionDigits = [];

    for (var i = 0; i < userExpression.length; i++) {
      if (RegExp(r'^[0-9]').hasMatch(userExpression[i])) {
        userDigits.add(int.parse(userExpression[i]));
      }
    }

    for (var i = 0; i < questionString.length; i++) {
      if (RegExp(r'^[0-9]').hasMatch(questionString[i])) {
        questionDigits.add(int.parse(questionString[i]));
      }
    }

    userDigits.sort();
    questionDigits.sort();

    return listEquals(userDigits, questionDigits);
  }

  // `tokens` is a string
  static double _evaluate(String tokens) {
    // stack to store integer values
    var values = List.empty(growable: true);

    // stack to store operators
    var operators = List.empty(growable: true);

    var counter = 0;

    while (counter < tokens.length) {
      // current token is a whitespace, skip it
      if (tokens[counter] == ' ') {
        counter++;
        continue;
      } else if (tokens[counter] == '(') {
        // current token is an opening bracket, push it to operations stack
        operators.add(tokens[counter]);
      } else if (RegExp(r'^[0-9]').hasMatch(tokens[counter])) {
        var value = double.parse(tokens[counter]);

        // There may be more than one digits in the number.
        // This is not allowed.
        if (counter + 1 < tokens.length &&
            RegExp(r'^[0-9]').hasMatch(tokens[counter + 1])) {
          throw new FormatException("Every digit must be a single number");
        }

        values.add(value);
      } else if (tokens[counter] == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          var val2 = values.removeLast();
          var val1 = values.removeLast();
          var operator = operators.removeLast();

          values.add(_performOperation(val1, operator, val2));
        }

        // pop opening bracket
        operators.removeLast();
      } else { // current token is an operator

        // While top of 'operators' has same or
        // greater precedence to current
        // token, which is an operator,
        // Apply this operator
        // to top two elements in values stack.
        while (operators.isNotEmpty &&
            _getPrecedence(operators.last) >= _getPrecedence(tokens[counter])) {
          var val2 = values.removeLast();
          var val1 = values.removeLast();
          var operator = operators.removeLast();

          values.add(_performOperation(val1, operator, val2));
        }

        // push current token to `operators` stack
        operators.add(tokens[counter]);
      }

      counter++;
    }

    // The entire expression has been parsed at this point.
    // Apply remaining operators on remaining values.
    while (operators.isNotEmpty) {
      var val2 = values.removeLast();
      var val1 = values.removeLast();
      var operator = operators.removeLast();

      values.add(_performOperation(val1, operator, val2));
    }

    // Top of `values` contains the result.
    return values.last;
  }

  static int _getPrecedence(operation) {
    if (operation == "+" || operation == "-") {
      return 1;
    } else if (operation == "*" || operation == "/") {
      return 2;
    } else {
      return 0;
    }
  }

  static double _performOperation(double val1, String operator, double val2) {
    if (operator == "+") {
      return (val1 + val2).toDouble();
    } else if (operator == "-") {
      return (val1 - val2).toDouble();
    } else if (operator == "*") {
      return (val1 * val2).toDouble();
    } else if (operator == "/") {
      return val1 / val2;
    } else {
      throw new FormatException("Invalid operator!");
    }
  }

}