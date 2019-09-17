import 'kinematic_helpers.dart';

class Kinematics {
  Displacement _displacement;
  TimeInterval _timeInterval;
  InitialVelocity _initialVelocity;
  FinalVelocity _finalVelocity;
  ConstantAcceleration _constantAcceleration;

  Displacement get displacement => _displacement ??= Displacement._(this);
  double get dx => displacement.value;

  TimeInterval get timeInterval => _timeInterval ??= TimeInterval._(this);
  double get t => timeInterval.value;

  InitialVelocity get initialVelocity =>
      _initialVelocity ??= InitialVelocity._(this);
  double get v0 => initialVelocity.value;

  FinalVelocity get finalVelocity => _finalVelocity ??= FinalVelocity._(this);
  double get v => finalVelocity.value;

  ConstantAcceleration get constantAcceleration =>
      _constantAcceleration ??= ConstantAcceleration._(this);
  double get a => constantAcceleration.value;

  bool quadformPlus = false;

  int get numInputs =>
      binInt(displacement.input) +
      binInt(timeInterval.input) +
      binInt(initialVelocity.input) +
      binInt(finalVelocity.input) +
      binInt(constantAcceleration.input);
}

abstract class KinematicValue {
  final Kinematics parent;
  String get name;
  String get simpleName => name;

  bool input = false;

  double _value = 0;
  set value(double newValue) => _value = newValue;
  double get value {
    if (input) return _value;
    if (parent.numInputs != 3) return double.nan;
    try {
      return _calcValue();
    } on NoSuchMethodError {
      return double.nan;
    }
  }

  double get dx => parent.dx;
  double get t => parent.t;
  double get v0 => parent.v0;
  double get v => parent.v;
  double get a => parent.a;

  double _calcValue();

  KinematicValue._(this.parent);
}

/*
1) v = v0 + at

2) Δx = ((v + v0) / 2)t

3) Δx = v0t + (1/2)at^2

4) v^2 = v0^2 + 2aΔx

5) Δx = vt - (1/2)at^2
*/

class Displacement extends KinematicValue {
  Displacement._(Kinematics parent) : super._(parent);

  @override
  final name = "Displacement (Δx)";

  @override
  double _calcValue() {
    if (!parent.timeInterval.input) {
      return dxFrom4(v, v0, a);
    } else if (!parent.initialVelocity.input) {
      return dxFrom5(v, t, a);
    } else if (!parent.finalVelocity.input) {
      return dxFrom3(v0, t, a);
    } else if (!parent.constantAcceleration.input) {
      return dxFrom2(v, v0, t);
    }
    return double.nan; // should never get here
  }
}

class TimeInterval extends KinematicValue {
  TimeInterval._(Kinematics parent) : super._(parent);

  @override
  final name = "Time Interval (t)";

  @override
  double _calcValue() {
    if (!parent.displacement.input) {
      return tFrom1(v, v0, a);
    } else if (!parent.initialVelocity.input) {
      return tFrom5(dx, v, a, quadformPlus: parent.quadformPlus);
    } else if (!parent.finalVelocity.input) {
      return tFrom3(dx, v0, a, quadformPlus: parent.quadformPlus);
    } else if (!parent.constantAcceleration.input) {
      return tFrom2(dx, v, v0);
    }
    return double.nan; // should never get here
  }
}

class InitialVelocity extends KinematicValue {
  InitialVelocity._(Kinematics parent) : super._(parent);

  @override
  final name = "Initial Velocity (v<sub>0</sub>)";
  @override
  final simpleName = "Initial Velocity (v0)";

  @override
  double _calcValue() {
    if (!parent.displacement.input) {
      return v0From1(v, a, t);
    } else if (!parent.timeInterval.input) {
      return v0From4(v, a, dx);
    } else if (!parent.finalVelocity.input) {
      return v0From3(dx, t, a);
    } else if (!parent.constantAcceleration.input) {
      return v0From2(dx, v, t);
    }
    return double.nan; // should never get here
  }
}

class FinalVelocity extends KinematicValue {
  FinalVelocity._(Kinematics parent) : super._(parent);

  @override
  final name = "Final Velocity (v)";

  @override
  double _calcValue() {
    if (!parent.displacement.input) {
      return vFrom1(v0, a, t);
    } else if (!parent.timeInterval.input) {
      return vFrom4(v0, a, dx);
    } else if (!parent.initialVelocity.input) {
      return vFrom5(dx, t, a);
    } else if (!parent.constantAcceleration.input) {
      return vFrom2(dx, v0, t);
    }
    return double.nan; // should never get here
  }
}

class ConstantAcceleration extends KinematicValue {
  ConstantAcceleration._(Kinematics parent) : super._(parent);

  @override
  final name = "Acceleration (a)";

  @override
  double _calcValue() {
    if (!parent.displacement.input) {
      return aFrom1(v, v0, t);
    } else if (!parent.timeInterval.input) {
      return aFrom4(v, v0, dx);
    } else if (!parent.initialVelocity.input) {
      return aFrom5(dx, v, t);
    } else if (!parent.finalVelocity.input) {
      return aFrom3(dx, v0, t);
    }
    return double.nan; // should never get here
  }
}
