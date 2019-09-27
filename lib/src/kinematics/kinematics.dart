import 'kinematic_helpers.dart';

class Kinematics {
  Displacement _displacement;
  TimeInterval _timeInterval;
  InitialVelocity _initialVelocity;
  FinalVelocity _finalVelocity;
  ConstantAcceleration _constantAcceleration;

  Displacement get displacement => _displacement ??= Displacement._(this);
  double get dx => displacement._value;

  TimeInterval get timeInterval => _timeInterval ??= TimeInterval._(this);
  double get t => timeInterval._value;

  InitialVelocity get initialVelocity =>
      _initialVelocity ??= InitialVelocity._(this);
  double get v0 => initialVelocity._value;

  FinalVelocity get finalVelocity => _finalVelocity ??= FinalVelocity._(this);
  double get v => finalVelocity._value;

  ConstantAcceleration get constantAcceleration =>
      _constantAcceleration ??= ConstantAcceleration._(this);
  double get a => constantAcceleration._value;

  List<KinematicValue> get inputs => [
        if (displacement.input) displacement,
        if (timeInterval.input) timeInterval,
        if (initialVelocity.input) initialVelocity,
        if (finalVelocity.input) finalVelocity,
        if (constantAcceleration.input) constantAcceleration,
      ];

  List<KinematicValue> get calculating => numInputs == 3
      ? [
          if (!displacement.input) displacement,
          if (!timeInterval.input) timeInterval,
          if (!initialVelocity.input) initialVelocity,
          if (!finalVelocity.input) finalVelocity,
          if (!constantAcceleration.input) constantAcceleration,
        ]
      : [null, null];

  int get numInputs => inputs.length;

  // displacement and acceleration can never have multiple answers
  bool get multipleAnswers =>
      timeInterval.values.length > 1 ||
      initialVelocity.values.length > 1 ||
      finalVelocity.values.length > 1;
}

final nameRegex = RegExp("(.*) \\(.*\\)");

abstract class KinematicValue {
  final Kinematics parent;
  String get name;
  String get plaintextName => name;
  String get simpleName => nameRegex.firstMatch(name).group(1);

  bool input = false;

  double _value = 0;
  set value(double newValue) => _value = newValue;
  List<double> get values {
    if (input) return [_value];
    if (parent.numInputs != 3) return [null];
    try {
      return _calculate().values().map((n) => n == n ? n : null).toList();
    } on NoSuchMethodError {
      print("got NoSuchMethodError");
      return [null];
    } on NegativeSqrt {
      print("got NegativeSqrt");
      return [null, null];
    }
  }

  int get using {
    if (input) return -1;
    if (parent.numInputs != 3) return -1;
    try {
      return _calculate().using;
    } on NoSuchMethodError {
      return -1;
    }
  }

  double get dx => parent.dx;
  double get t => parent.t;
  double get v0 => parent.v0;
  double get v => parent.v;
  double get a => parent.a;

  CalcResult _calculate();

  KinematicValue._(this.parent);
}

class CalcResult {
  final List<double> Function() values;
  final int using;
  CalcResult(this.values, this.using);
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
  CalcResult _calculate() {
    if (!parent.timeInterval.input) {
      return CalcResult(() => dxFrom4(v, v0, a), 4);
    } else if (!parent.initialVelocity.input) {
      return CalcResult(() => dxFrom5(v, t, a), 5);
    } else if (!parent.finalVelocity.input) {
      return CalcResult(() => dxFrom3(v0, t, a), 3);
    } else if (!parent.constantAcceleration.input) {
      return CalcResult(() => dxFrom2(v, v0, t), 2);
    }
    return null; // should never get here
  }
}

class TimeInterval extends KinematicValue {
  TimeInterval._(Kinematics parent) : super._(parent);

  @override
  final name = "Time Interval (t)";

  @override
  CalcResult _calculate() {
    if (!parent.displacement.input) {
      return CalcResult(() => tFrom1(v, v0, a), 1);
    } else if (!parent.initialVelocity.input) {
      return CalcResult(() => tFrom5(dx, v, a), 5);
    } else if (!parent.finalVelocity.input) {
      print("using right equation");
      return CalcResult(() {
        var ret = tFrom3(dx, v0, a);
        print("ret is $ret");
        return ret;
      }, 3);
    } else if (!parent.constantAcceleration.input) {
      return CalcResult(() => tFrom2(dx, v, v0), 2);
    }
    return null; // should never get here
  }
}

class InitialVelocity extends KinematicValue {
  InitialVelocity._(Kinematics parent) : super._(parent);

  @override
  final name = "Initial Velocity (v<sub>0</sub>)";
  @override
  final plaintextName = "Initial Velocity (v0)";

  @override
  CalcResult _calculate() {
    if (!parent.displacement.input) {
      return CalcResult(() => v0From1(v, a, t), 1);
    } else if (!parent.timeInterval.input) {
      return CalcResult(() => v0From4(v, a, dx), 4);
    } else if (!parent.finalVelocity.input) {
      return CalcResult(() => v0From3(dx, t, a), 3);
    } else if (!parent.constantAcceleration.input) {
      return CalcResult(() => v0From2(dx, v, t), 2);
    }
    return null; // should never get here
  }
}

class FinalVelocity extends KinematicValue {
  FinalVelocity._(Kinematics parent) : super._(parent);

  @override
  final name = "Final Velocity (v)";

  @override
  CalcResult _calculate() {
    if (!parent.displacement.input) {
      return CalcResult(() => vFrom1(v0, a, t), 1);
    } else if (!parent.timeInterval.input) {
      return CalcResult(() => vFrom4(v0, a, dx), 4);
    } else if (!parent.initialVelocity.input) {
      return CalcResult(() => vFrom5(dx, t, a), 5);
    } else if (!parent.constantAcceleration.input) {
      return CalcResult(() => vFrom2(dx, v0, t), 2);
    }
    return null; // should never get here
  }
}

class ConstantAcceleration extends KinematicValue {
  ConstantAcceleration._(Kinematics parent) : super._(parent);

  @override
  final name = "Acceleration (a)";

  @override
  CalcResult _calculate() {
    if (!parent.displacement.input) {
      return CalcResult(() => aFrom1(v, v0, t), 1);
    } else if (!parent.timeInterval.input) {
      return CalcResult(() => aFrom4(v, v0, dx), 4);
    } else if (!parent.initialVelocity.input) {
      return CalcResult(() => aFrom5(dx, v, t), 5);
    } else if (!parent.finalVelocity.input) {
      return CalcResult(() => aFrom3(dx, v0, t), 3);
    }
    return null; // should never get here
  }
}
