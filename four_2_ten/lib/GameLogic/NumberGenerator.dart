import 'dart:math';
import 'package:trotter/trotter.dart';
import 'package:function_tree/function_tree.dart';

class NumberGenerator {

  final _min = 1000;
  final _max = 9999;
  final _random = new Random();

  String generate() {
    String randomNumber = _getRandom(_min, _max);
    bool canFormTen = _check(randomNumber);
    while (!canFormTen) {
      randomNumber = _getRandom(_min, _max);
      canFormTen = _check(randomNumber);
    }
    return randomNumber;
  }

  bool _check(String number) {
    var digits = number.split("");
    var operators = ["+", "-", "/", "*"];
    final digitsPermutations = Permutations(digits.length, digits);
    final operatorsPermutations = Amalgams(digits.length - 1, operators);
    for (final digitsPermutation in digitsPermutations()) {
      for (final operatorsPermutation in operatorsPermutations()) {
        int result = 0;
        for (int i = 0; i < digitsPermutation.length - 1; i++) {
          String firstOperand = digitsPermutation[i];
          String secondOperand = digitsPermutation[i + 1];
          String operator = operatorsPermutation[i];
          String expression = firstOperand + operator + secondOperand;
          result += expression.interpret();
        }
        if (result == 0) {
          return true;
        }
      }
    }
    return false;
  }

  String _getRandom(int min, int max) {
    return (min + _random.nextInt(max - min)).toString();
  }
}