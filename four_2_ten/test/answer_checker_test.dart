import 'package:flutter_test/flutter_test.dart';
import 'package:four_2_ten/Utils/AnswerChecker.dart';

void main() {
  group('AnswerChecker', () {

    test('correct answer 1', () {
      var result = AnswerChecker.check("2+3+4+1", "1234");
      expect(result, true);
    });

    test('correct answer 2', () {
      var result = AnswerChecker.check("(9+9-8)*1", "9981");
      expect(result, true);
    });

    test('wrong answer 1', () {
      var result = AnswerChecker.check("2+3*4+1", "1234");
      expect(result, false);
    });

    test('wrong answer 2: did not use all digits', () {
      var result = AnswerChecker.check("(4+6)*1", "4621");
      expect(result, false);
    });

  });
}