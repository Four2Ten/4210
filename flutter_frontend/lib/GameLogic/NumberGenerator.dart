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

  int calculate_result(digits, operators) {
    int result = 0;
    for (int i = 0; i < digits.length - 1; i++) {
      String firstOperand = digits[i];
      String secondOperand = digits[i + 1];
      String operator = operators[i];

      if (secondOperand == '0' && operator == "/") {
        return null;
      }

      String expression = firstOperand + operator + secondOperand;
      result += expression.interpret().toInt();
    }
    return result;
  }

  bool _check(String number) {
    var digits = number.split("");
    var operators = ["+", "-", "/", "*"];
    var indices = new List<int>.generate(digits.length, (i) => i);
    final indexPermutations = Permutations(indices.length, indices)();
    final digitsPermutations = indexPermutations.map(
      (indices) => indices.map((index) => digits[index]).toList()
    );
    final operatorsPermutations = Amalgams(digits.length - 1, operators)();
    for (final digitsPermutation in digitsPermutations) {
      for (final operatorsPermutation in operatorsPermutations) {
        int result = calculate_result(digitsPermutation, operatorsPermutation);
        if (result == 10) {
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