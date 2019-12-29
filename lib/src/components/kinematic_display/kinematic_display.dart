import 'dart:html';

import 'package:angular/angular.dart';

import '../../kinematics/kinematics.dart';

@Component(
  selector: 'kn-display',
  templateUrl: 'kinematic_display.html',
  styleUrls: ['kinematic_display.css'],
  directives: [coreDirectives],
)
class KinematicDisplayComponent {
  @Input()
  KinematicValue value;

  //double get safeValue => value.value == value.value ? value.value : null;
  //set safeValue(double v) => value.value = v ?? 0;

  bool get isTimeInterval => value.runtimeType == TimeInterval;
  bool get isAcceleration => value.runtimeType == ConstantAcceleration;

  String labelAddendum(int index) {
    var ret = StringBuffer();
    if (value.calculatedValues.length > 1) {
      ret.write(', result ${index + 1} of ${value.calculatedValues.length}');
    }
    if (value.using > 0) {
      ret.write(', calculated using equation ${value.using}');
    }
    return ret.toString();
  }

  void setInput(Event event) {
    value.input = (event.target as CheckboxInputElement).checked;
    value.value = 0;
  }

  void setValue(Event event) {
    value.value =
        double.tryParse((event.target as NumberInputElement).value) ?? 0;
  }
}
