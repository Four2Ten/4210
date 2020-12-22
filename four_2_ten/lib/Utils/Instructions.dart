import 'package:global_configuration/global_configuration.dart';
import 'package:four_2_ten/Config/stringValueGameConfig.dart';

class Instructions {
  static String getInstructions()  {
     GlobalConfiguration().loadFromMap(stringValueGameConfig);
     return GlobalConfiguration().getValue("instructions");
  }
}