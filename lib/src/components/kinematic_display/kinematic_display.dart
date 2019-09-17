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

  bool get isTimeInterval => value.runtimeType == TimeInterval;
  bool get isAcceleration => value.runtimeType == ConstantAcceleration;
}