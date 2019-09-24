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

  double get safeValue => value.value == value.value ? value.value : null;
  set safeValue(double v) => value.value = v ?? 0;

  bool get isTimeInterval => value.runtimeType == TimeInterval;
  bool get isAcceleration => value.runtimeType == ConstantAcceleration;

  String get labelAddendum =>
      value.using > 0 ? ", calculated using equation ${value.using}" : "";

  String get quadformAddendum => value.parent.needsQuadform
      ? "The current answer uses a "
          "${value.parent.quadformPlus ? "positive" : "negative"} square root."
      : "The button is currently disabled because time is known or another "
          "formula is being used.";
}
