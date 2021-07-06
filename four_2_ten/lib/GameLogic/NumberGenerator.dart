import 'dart:math';

class NumberGenerator {
  String generate() {
    // TODO: implement
    List<int> digits = List.empty(growable: true);
    Random random = new Random();
    for (int i = 0; i < 4; i++) {
      digits.add(random.nextInt(10));
    }
    return digits.map((e) => e.toString()).join("");
  }

  String generateRoomPin() {
    // TODO: implement
    return "1234";
  }
}