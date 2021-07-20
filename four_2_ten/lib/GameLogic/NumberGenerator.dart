import 'dart:math';

class NumberGenerator {
  // Generates a 4-digit string randomly (i.e. may not be solvable)
  String generate() {
    List<int> digits = List.empty(growable: true);
    Random random = new Random();
    for (int i = 0; i < 4; i++) {
      digits.add(random.nextInt(10));
    }
    return digits.map((e) => e.toString()).join("");
  }
}