// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:eval_ex/expression.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Navigator(
        onGenerateRoute: (settings) {
          Widget page;
          if (settings.name == '/') {
            page = Main();
          } else if (settings.name == '/bisection') {
            page = BisectionPage();
          } else {
            page = Main();
          }
          return MaterialPageRoute(builder: (context) => page);
        },
        initialRoute: '/',
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BisectionPage()),
                  ),
                  child: const Text('Bisection'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FixedPointPage(),
                        )),
                    child: Text("Fixed-Point Iteration"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ! ***********************************************************************************
// ! ***********************************************************************************
// ! ***********************************************************************************
// ! ***********************************************************************************
// ! ***********************************************************************************

class BisectionPage extends StatefulWidget {
  const BisectionPage({super.key});

  @override
  State<BisectionPage> createState() => _BisectionPageState();
  // get the values from the text fields

}

class _BisectionPageState extends State<BisectionPage> {
  final qController = TextEditingController();
  final aController = TextEditingController();
  final bController = TextEditingController();
  final errorController = TextEditingController();
  bool showFa = true;
  bool showFb = true;
  //

  func(x, q, error, bool isRound) {
    try {
      var eq = q.replaceAll('x', x.toString());
      Expression expression = Expression(eq);

      double result = expression.eval()!.toDouble();
      int error_num = error.toString().length - 2;
      // print('out -> $result');
      if (isRound) {
        result = (result * pow(10, error_num)).round() / pow(10, error_num); // rounding off
        // print('res -> $result');
      }
      return result;
    } catch (e) {
      print('1--> $e');
    }
  }

  Future<List<List>> bisection(double a, double b, double error, String q) async {
    List<List<dynamic>> output = [];
    int error_num = error.toString().length - 2;
    Map<String, dynamic> row = {
      'i': 0,
      "a": a,
      "b": b,
      "c": 0,
      "f(c)": error + 0.1,
      "f(a)": func(a, q, error, false),
      "f(b)": func(b, q, error, false),
    };
    double mid = ((row['a']) + (row['b'])) / 2;
    mid = (mid * pow(10, error_num)).round() / pow(10, error_num);
    row['c'] = mid;
    row['f(c)'] = func(row['c'], q, error, true);
    output.add(row.values.toList());

    if (row['f(c)'] == 0)
      return output;
    else if (row['f(a)'] * row['f(c)'] < 0)
      row['b'] = row['c'];
    else
      row['a'] = row['c'];

    if (row['f(a)'] * row['f(b)'] >= 0) {
      print("2--> You have not assumed right a and b\n");
      return [
        [null]
      ];
    }

    while ((b - a) >= error && row['f(c)'].abs() > error) {
      row['i'] += 1;

      double mid = ((row['a']) + (row['b'])) / 2;
      mid = (mid * pow(10, error_num)).round() / pow(10, error_num);
      row['c'] = mid;

      row['f(a)'] = func(row['a'], q, error, true);
      row['f(b)'] = func(row['b'], q, error, true);

      double fc = func(row['c'], q, error, true);
      if (row['f(c)'] == fc) break;
      row['f(c)'] = func(row['c'], q, error, true);

      List<dynamic> values = row.values.toList();
      output.add(values);

      if (row['f(c)'] == 0)
        break;
      else if (row['f(a)'] * row['f(c)'] < 0)
        row['b'] = row['c'];
      else
        row['a'] = row['c'];
    }

    return output;
  }

  Future<List<List<dynamic>>> evaluate() async {
    double a = double.parse(aController.text);
    double b = double.parse(bController.text);
    double error = double.parse(errorController.text);
    String q = qController.text;

    List<List<dynamic>> result = await bisection(a, b, error, q);
    for (var i = 0; i < result.length; i++) {
      // print(result[i]);
    }
    // print(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Bisection'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextFormField(
                    controller: qController,
                    decoration: const InputDecoration(
                      hintText: 'Equation',
                    ),
                  ),
                  TextFormField(
                    controller: aController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a',
                    ),
                  ),
                  TextFormField(
                    controller: bController,
                    decoration: const InputDecoration(
                      hintText: 'Enter b',
                    ),
                  ),
                  TextFormField(
                    controller: errorController,
                    decoration: const InputDecoration(
                      hintText: 'Enter error',
                    ),
                  ),
                  // calculate button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text('Calculate'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            qController.clear();
                            aController.clear();
                            bController.clear();
                            errorController.clear();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // table
            Column(
              children: [
                FutureBuilder<List<List<dynamic>>>(
                  future: evaluate(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          // border: TableBorder.all()
                          headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 159, 212, 255)),
                          // color rows one pink and one blue

                          columns: <DataColumn>[
                            DataColumn(
                              numeric: true,
                              label: Text('i', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            DataColumn(
                              numeric: true,
                              label: GestureDetector(
                                child: Text('a', style: TextStyle(fontStyle: FontStyle.italic)),
                                onDoubleTap: () => setState(() {
                                  // aController.text = snapshot.data![0][1].toString();
                                  showFa = !showFa;
                                }),
                              ),
                            ),
                            DataColumn(
                              numeric: true,
                              label: GestureDetector(
                                child: Text('b', style: TextStyle(fontStyle: FontStyle.italic)),
                                onDoubleTap: () => setState(() {
                                  // aController.text = snapshot.data![0][1].toString();
                                  showFb = !showFb;
                                }),
                              ),
                            ),
                            DataColumn(
                              numeric: true,
                              label: Text('c', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            DataColumn(
                              numeric: true,
                              label: Text('f(c)', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            // if (showFa)
                            DataColumn(
                              numeric: true,
                              label: Text('f(a)', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            // if (showFb)
                            DataColumn(
                              numeric: true,
                              label: Text('f(b)', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            snapshot.data!.length,
                            (int index) {
                              return DataRow(
                                cells: List<DataCell>.generate(
                                  snapshot.data![index].length,
                                  (int cellIndex) => DataCell(
                                    Text(snapshot.data![index][cellIndex].toString()),
                                  ),
                                ),
                                color: (index % 2 == 0)
                                    ? MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 255, 222, 225))
                                    : MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 255, 193, 193)),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    ));
  }
}

// ! ***********************************************************************************
// ! ***********************************************************************************
// ! ***********************************************************************************
// ! ***********************************************************************************
// ! ***********************************************************************************

class FixedPointPage extends StatefulWidget {
  const FixedPointPage({super.key});

  @override
  State<FixedPointPage> createState() => _FixedPointPageState();
}

class _FixedPointPageState extends State<FixedPointPage> {
  final qController = TextEditingController();
  final p0Controller = TextEditingController();
  final toleranceController = TextEditingController();
  final maxIterationsController = TextEditingController();
  Future<List<List<dynamic>>> evaluate() async {
    // String f, double p0, double tolerance, int maxIterations
    String q = qController.text;
    int i = 0;
    double p0 = double.parse(p0Controller.text);
    double tolerance = double.parse(toleranceController.text);
    int maxIterations = int.parse(maxIterationsController.text);
    List<List<dynamic>> output = [];
    double p = p0;
    double diff = tolerance + 1;

    while (diff > tolerance && i < maxIterations) {
      double p1 = func(q, p);
      diff = (p1 - p).abs();
      // print(', i: $i p: $p, p1: $p1 diff: $diff');
      output.add([i, p, p1, diff]);
      p = p1;
      i++;
    }

    if (i == maxIterations && diff > tolerance) {
      throw Exception('Method failed after $i iterations.');
    }

    return output;
  }

  func(f, p) {
    try {
      var eq = f.replaceAll('x', p.toString());
      Expression expression = Expression(eq);
      double result = expression.eval()!.toDouble();

      return result;
    } catch (e) {
      print('1--> $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text('Fixed Point')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextFormField(
                    controller: qController,
                    decoration: const InputDecoration(
                      hintText: 'Equation',
                    ),
                  ),
                  TextFormField(
                    controller: p0Controller,
                    decoration: const InputDecoration(
                      hintText: 'P0',
                    ),
                  ),
                  TextFormField(
                    controller: toleranceController,
                    decoration: const InputDecoration(
                      hintText: 'Tolerance',
                    ),
                  ),
                  TextFormField(
                    controller: maxIterationsController,
                    decoration: const InputDecoration(
                      hintText: 'Max Iterations',
                    ),
                  ),
                  // calculate button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text('Calculate'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            qController.clear();
                            p0Controller.clear();
                            toleranceController.clear();
                            maxIterationsController.clear();
                          });
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // table
            Column(
              children: [
                FutureBuilder<List<List<dynamic>>>(
                  future: evaluate(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          // border: TableBorder.all()
                          headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 159, 212, 255)),

                          columns: const <DataColumn>[
                            DataColumn(
                              numeric: true,
                              label: Text('i', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            DataColumn(
                              numeric: true,
                              label: Text('pn-1', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            DataColumn(
                              numeric: true,
                              label: Text('pn', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                            DataColumn(
                              numeric: true,
                              label: Text('|pn - pn-1|', style: TextStyle(fontStyle: FontStyle.italic)),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            snapshot.data!.length,
                            (int index) {
                              return DataRow(
                                cells: List<DataCell>.generate(
                                  snapshot.data![index].length,
                                  (int cellIndex) => DataCell(
                                    Text(snapshot.data![index][cellIndex].toString()),
                                  ),
                                ),
                                color: (index % 2 == 0)
                                    ? MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 225, 255, 222))
                                    : MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 193, 255, 196)),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
