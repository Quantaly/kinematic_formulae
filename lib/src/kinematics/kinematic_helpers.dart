import 'dart:math' as math;

/*
1) v = v0 + at

2) Δx = ((v + v0) / 2)t

3) Δx = v0t + (1/2)at^2

4) v^2 = v0^2 + 2aΔx

5) Δx = vt - (1/2)at^2
*/

class NegativeSqrt {}

double safeSqrt(double n) {
  var ret = math.sqrt(n);
  if (ret != ret) {
    throw NegativeSqrt();
  }
  return ret;
}

List<double> quadform(double a, double b, double c) {
  if (a != 0) {
    // 0 = a^2x + bx + c
    return [
      (-b - safeSqrt(b * b - 4 * a * c)) / (2 * a),
      (-b + safeSqrt(b * b - 4 * a * c)) / (2 * a)
    ];
  } else if (b != 0) {
    // 0 = bx + c
    return [-c / b];
  } else {
    // 0 = c
    return [null];
  }
}

List<double> sqrts(double n) => [-safeSqrt(n), safeSqrt(n)];

List<double> vFrom1(double v0, double a, double t) => [v0 + a * t];
List<double> v0From1(double v, double a, double t) => [v - a * t];
List<double> aFrom1(double v, double v0, double t) => [(v - v0) / t];
List<double> tFrom1(double v, double v0, double a) => [(v - v0) / a];

List<double> dxFrom2(double v, double v0, double t) => [((v + v0) / 2) * t];
List<double> vFrom2(double dx, double v0, double t) => [dx / t * 2 - v0];
List<double> v0From2(double dx, double v, double t) => [dx / t * 2 - v];
List<double> tFrom2(double dx, double v, double v0) => [dx / ((v + v0) / 2)];

List<double> dxFrom3(double v0, double t, double a) =>
    [v0 * t + (1 / 2) * a * t * t];
List<double> v0From3(double dx, double t, double a) =>
    [(dx - (1 / 2) * a * t * t) / t];
List<double> tFrom3(double dx, double v0, double a) =>
    quadform((1 / 2) * a, v0, -dx);
List<double> aFrom3(double dx, double v0, double t) =>
    [(dx - v0 * t) / ((1 / 2) * t * t)];

List<double> vFrom4(double v0, double a, double dx) =>
    sqrts(v0 * v0 + 2 * a * dx);
List<double> v0From4(double v, double a, double dx) =>
    sqrts(v * v - 2 * a * dx);
List<double> aFrom4(double v, double v0, double dx) =>
    [(v * v - v0 * v0) / (2 * dx)];
List<double> dxFrom4(double v, double v0, double a) =>
    [(v * v - v0 * v0) / (2 * a)];

List<double> dxFrom5(double v, double t, double a) =>
    [v * t - (1 / 2) * a * t * t];
List<double> vFrom5(double dx, double t, double a) =>
    [(dx + (1 / 2) * a * t * t) / t];
List<double> tFrom5(double dx, double v, double a) =>
    quadform(-(1 / 2) * a, v, -dx);
List<double> aFrom5(double dx, double v, double t) =>
    [-(dx - v * t) / ((1 / 2) * t * t)];
