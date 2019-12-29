import 'dart:html';

import 'package:angular/angular.dart';

import 'src/components/kinematic_display/kinematic_display.dart';
import 'src/components/pwa_prompt/pwa_prompt.dart';
import 'src/kinematics/kinematics.dart';
import 'src/services/pwa_prompt_service.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'kn-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [coreDirectives, KinematicDisplayComponent, PwaPrompt],
  providers: [ClassProvider(PwaPromptService)],
)
class AppComponent {
  final kinematics = Kinematics();

  void multipleAnswersHint() {
    window.alert('In certain formulas, time or velocity is squared. '
        'This means that calculating them requires a square root, '
        'which can be positive or negative.\n\n'
        'Both answers are mathematically correct (and may be identical), '
        'but might not apply to the specific problem. '
        'Ensure your answer(s) make sense in context!');
  }
}
