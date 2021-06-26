import 'dart:math';
import 'package:trotter/trotter.dart';

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
    digits.map((digit) => int.parse(digit));

    var expressions = _generateExpressions(digits);
  }

  [String] _generateExpressions(digits) {
    final permutations = Permutations(digits.length, digits);
    for (final permutation in permutations()) {
      var withOperators = _insertOperators(permutation);
    }
  }

  // (1 + (2)) + (3) + (4)

  [[String]] _insertOperators(digits) {
    var operators = ["+", "-", "/", "*"];
    final operatorAmalgams = Amalgams(digits.length - 1, operators);
    [[String]] withOperators = [];
    for (final operatorAmalgam in operatorAmalgams()) {
      [String] result = [];
      for (int i = 0; i < digits.length; i++) {
        String digit = digits[i];
        result.add(digit);
        if (i != digits.length - 1){
          result.add(operatorAmalgan[i]);
        }
      }
      withOperators.add(result);
    }
    return withOperators;
  }

  String _getRandom(int min, int max) {
    return (min + _random.nextInt(max - min)).toString();
  }
}