import 'dart:math' as math;

int binInt(bool bin) => bin ? 1 : 0;

/*
1) v = v0 + at

2) Δx = ((v + v0) / 2)t

3) Δx = v0t + (1/2)at^2

4) v^2 = v0^2 + 2aΔx

5) Δx = vt - (1/2)at^2
*/

double quadform(double a, double b, double c, {bool plus = false}) =>
    (-b + (plus ? 1 : -1) * math.sqrt(b * b - 4 * a * c)) / (2 * a);

double vFrom1(double v0, double a, double t) => v0 + a * t;
double v0From1(double v, double a, double t) => v - a * t;
double aFrom1(double v, double v0, double t) => (v - v0) / t;
double tFrom1(double v, double v0, double a) => (v - v0) / a;

double dxFrom2(double v, double v0, double t) => ((v + v0) / 2) * t;
double vFrom2(double dx, double v0, double t) => dx / t * 2 - v0;
double v0From2(double dx, double v, double t) => dx / t * 2 - v;
double tFrom2(double dx, double v, double v0) => dx / ((v + v0) / 2);

double dxFrom3(double v0, double t, double a) => v0 * t + (1 / 2) * a * t * t;
double v0From3(double dx, double t, double a) => (dx - (1 / 2) * a * t * t) / t;
double tFrom3(double dx, double v0, double a, {bool quadformPlus = false}) =>
    quadform((1 / 2) * a, v0, -dx, plus: quadformPlus);
double aFrom3(double dx, double v0, double t) =>
    (dx - v0 * t) / ((1 / 2) * t * t);

double vFrom4(double v0, double a, double dx) =>
    math.sqrt(v0 * v0 + 2 * a * dx);
double v0From4(double v, double a, double dx) => math.sqrt(v * v - 2 * a * dx);
double aFrom4(double v, double v0, double dx) => (v * v - v0 * v0) / (2 * dx);
double dxFrom4(double v, double v0, double a) => (v * v - v0 * v0) / (2 * a);

double dxFrom5(double v, double t, double a) => v * t - (1 / 2) * a * t * t;
double vFrom5(double dx, double t, double a) => (dx + (1 / 2) * a * t * t) / t;
double tFrom5(double dx, double v, double a, {bool quadformPlus = false}) =>
    quadform(-(1 / 2) * a, v, -dx, plus: quadformPlus);
double aFrom5(double dx, double v, double t) =>
    -(dx - v * t) / ((1 / 2) * t * t);
