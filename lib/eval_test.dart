import 'dart:math';

import 'package:eval_ex/expression.dart';

void main() {
  // Evaluate the expression
  String ex = 'x^3+4*x^2-10';
  ex = ex.replaceAll('x', 1.5.toString());
  print(ex);
  Expression expression = Expression(ex);
  double out = expression.eval()!.toDouble();
  // var x = eval_ex('2^3');

  print(out); // -> 4
}

  // int i = ex.indexOf('^');
  // int end = ex.indexOf('^') + 1;
  // while (end < ex.length && ex[end].contains(RegExp(r'[0-9]'))) {
  //   end++;
  // }
  // String replacement = 'pow(' + ex.substring(i - 1, i) + ',' + ex.substring(i + 1, end) + ')';
  // // ex.replaceRange(i-1, end, replacement)
  // ex = ex.replaceRange(i - 1, end, replacement);
  // print(ex);

  // q = q.replaceAll('+', '%2B');
  // q = q.replaceAll('-', '%2D');
  // q = q.replaceAll('*', '%2A');
  // q = q.replaceAll('/', '%2F');
  // q = q.replaceAll('^', '%5E');
  // q += " where x=$x";


    // var raw_url = "http://api.wolframalpha.com/v1/conversation.jsp?appid=9YWYT8-YKLJLK4Q37&i=$q";
    // var url = Uri.parse(raw_url);
    // var response = await http.get(url, headers: {
    //   "Accept": "application/json",
    //   "Access-Control-Allow-Credentials": "true",
    //   "Access-Control-Allow-Origin:": "*", // Required for CORS support to work
    // });

    // if (response.statusCode == 200) {
    //   var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    //   var result = jsonResponse['result'].split(' ').last;
    //   result = double.parse(result.substring(0, result.length - 1));
    //   result = (result * pow(10, error.toString().length - 2)).round() / pow(10, error.toString().length - 2); // rounding off
    //   print(result);
    //   return result;
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    //   return null;
    // }
    // Future<http.Response> fetch(String url) {
    //   return http.get(
    //     Uri.parse(url),
    //   );
    // }

    // String url = "http://api.wolframalpha.com/v1/conversation.jsp?appid=9YWYT8-YKLJLK4Q37&i=$q";
    // http.Response response = await fetch(url);
    // Map<String, dynamic> out = json.decode(response.body);
    // var result = out['result'].split(' ').last;
    // result = double.parse(result.substring(0, result.length - 1));
    // result = (result * pow(10, error.toString().length - 2)).round() / pow(10, error.toString().length - 2); // rounding off
    // return result;



    // ignore_for_file: prefer_const_constructors


// ! ***********************************************************************************
/*
ignore_for_ file: prefer_const_constructors

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
            page = Bisection();
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
        body: Center(
          child: Column(
            children: [
              Text('Bi Section Method'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Bisection()),
                  );
                },
                child: const Text('Bisection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bisection extends StatefulWidget {
  const Bisection({super.key});

  @override
  State<Bisection> createState() => _BisectionState();
  // get the values from the text fields

}

class _BisectionState extends State<Bisection> {
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

  Future<List<List<dynamic>>> calculate() async {
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
                  future: calculate(),
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

class FixedPoint extends StatefulWidget {
  const FixedPoint({super.key});

  @override
  State<FixedPoint> createState() => _FixedPointState();
}

class _FixedPointState extends State<FixedPoint> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
} */
