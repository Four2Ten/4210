import 'GameController.dart';
import 'NumberGenerator.dart';

class HostGameController extends GameController {

  // number generator used to generate questions
  NumberGenerator numberGenerator = new NumberGenerator();

  String generate() {
    return numberGenerator.generate();
  }

}