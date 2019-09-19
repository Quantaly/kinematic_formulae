import 'package:angular/angular.dart';
import 'package:kinematic_formulae/app_component.template.dart' as ng;

import 'package:service_worker/window.dart' as sw;

void main() {
  if (sw.isSupported) {
    sw.register("sw.dart.js");
  } else {
    print("big oof on the servizzle workizzle");
  }
  runApp(ng.AppComponentNgFactory);
}
