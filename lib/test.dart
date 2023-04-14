// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';
import 'package:eval_ex/expression.dart';

// Future<List<List<dynamic>>> calculate(double a, double b, double error, String q) async {
//   List<List<dynamic>> result = await fixedPoint(a, b, error, q);
//   for (var i = 0; i < result.length; i++) {
//     print(result[i]);
//   }
//   // print(result);
//   return result;
// }

void main() {
  // Func g = (double x) => 2 * cos(x) - x;
  String f = 'x^2-2';
  double p0 = 0;
  double tolerance = 0.01;
  int maxIterations = 100;
  double result = FixedPoint.evaluate(f, p0, tolerance, maxIterations);

  print(result);
}

class FixedPoint {
  static double evaluate(String f, double p0, double tolerance, int maxIterations) {
    int i = 0;
    double p = p0;
    double diff = tolerance + 1;

    while (diff > tolerance && i < maxIterations) {
      double p1 = func(f, p);
      diff = (p1 - p).abs();
      print(', i: $i p: $p, p1: $p1 diff: $diff');
      p = p1;
      i++;
    }

    if (i == maxIterations && diff > tolerance) {
      throw Exception('Method failed after $i iterations.');
    }

    return p;
  }

  static func(f, p) {
    try {
      var eq = f.replaceAll('x', p.toString());
      Expression expression = Expression(eq);
      double result = expression.eval()!.toDouble();

      return result;
    } catch (e) {
      print('1--> $e');
    }
  }
}
