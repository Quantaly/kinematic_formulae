import 'package:angular/angular.dart';

import 'src/components/kinematic_display/kinematic_display.dart';
import 'src/kinematics/kinematics.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'kn-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [coreDirectives, KinematicDisplayComponent],
)
class AppComponent {
  final kinematics = Kinematics();
}
