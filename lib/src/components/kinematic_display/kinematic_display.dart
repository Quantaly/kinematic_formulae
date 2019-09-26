import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../kinematics/kinematics.dart';

@Component(
  selector: "kn-display",
  templateUrl: "kinematic_display.html",
  styleUrls: ["kinematic_display.css"],
  directives: [coreDirectives, formDirectives],
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
    if (value.values.length > 1) {
      ret.write(", result ${index + 1} of ${value.values.length}");
    }
    if (value.using > 0) {
      ret.write(", calculated using equation ${value.using}");
    }
    return ret.toString();
  }

  void setValue(Event event) {
    value.value = double.tryParse((event.target as InputElement).value) ?? 0;
  }
}
