export 'package:humankind/src/models/FactionModel.dart';
export 'package:humankind/src/models/VirtueModel.dart';

abstract class AbstractVirtue {
  bool isVisible;
  String value;
  bool wasAlreadyAnimated;

  AbstractVirtue({this.value})
  {
    isVisible = false;
    wasAlreadyAnimated = false;
  }
}