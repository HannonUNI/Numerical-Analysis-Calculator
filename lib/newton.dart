// 🐛

import 'package:flutter/material.dart';
import 'package:eval_ex/expression.dart';
// import 'dart:math';
import 'package:http/http.dart' as http;

class NewtonPage extends StatefulWidget {
  const NewtonPage({super.key});

  @override
  State<NewtonPage> createState() => _NewtonPageState();
}

class _NewtonPageState extends State<NewtonPage> {
  final qController = TextEditingController();
  final x0Controller = TextEditingController();
  final toleranceController = TextEditingController();
  final maxIterationsController = TextEditingController();

  Future<List<List<dynamic>>> evaluate() async {
    // String f, double p0, double tolerance, int maxIterations
    String q = qController.text; //x^3+4x^2-10
    double x0 = double.parse(x0Controller.text);
    double tolerance = double.parse(toleranceController.text);
    int maxIterations = int.parse(maxIterationsController.text);

    List<List<dynamic>> output = [];

    double x = x0;
    double r = func(q, x);
    int i = 0;
    while (r.abs() > tolerance && maxIterations > 0) {
      double d = func(derive(q), x);
      double x1 = x - (r / d);
      List<dynamic> row = [i, x, x1, r, d, r - d];
      output.add(row);
      x = x1;
      r = func(q, x);
      i++;
      maxIterations--;
    }

    return output;
  }

  func(q, p) {
    String eq = q.toLowerCase();
    eq = eq.replaceAllMapped(RegExp(r'(\d)x'), (e) => '${e.group(1)}*${p.toString()}');
    eq = eq.replaceAll('x', p.toString());
    // print(eq);

    try {
      Expression expression = Expression(eq);
      double result = expression.eval()!.toDouble();
      return result;
    } catch (e) {
      throw Exception('Invalid equation');
    }
  }

  derive(q) async {
    var ogq = q;
    q = q.replaceAll('+', '%2B');
    q = q.replaceAll('-', '%2D');
    q = q.replaceAll('*', '%2A');
    q = q.replaceAll('/', '%2F');
    q = q.replaceAll('^', '%5E');
    q += "derivative";
    // var raw_url = "http://api.wolframalpha.com/v1/conversation.jsp?appid=9YWYT8-YKLJLK4Q37&i=$q";
    // var raw_url = "http://api.wolframalpha.com/v1/result?appid=9YWYT8-YKLJLK4Q37&i=$q"; //short answer
    var raw_url = "http://api.wolframalpha.com/v1/simple?appid=9YWYT8-YKLJLK4Q37&i=$q"; //image

    print(raw_url);
    var url = Uri.parse(raw_url);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}.');
      // return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newton'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  TextField(
                    controller: qController,
                    decoration: const InputDecoration(
                      hintText: 'Enter the equation',
                    ),
                  ),
                  TextField(
                    controller: x0Controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter the initial guess',
                    ),
                  ),
                  TextField(
                    controller: toleranceController,
                    decoration: const InputDecoration(
                      hintText: 'Enter the tolerance',
                    ),
                  ),
                  TextField(
                    controller: maxIterationsController,
                    decoration: const InputDecoration(
                      hintText: 'Enter the maximum number of iterations',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List<List<dynamic>> output = await evaluate();
                      // print(output);
                    },
                    child: const Text('Evaluate'),
                  ),
                ],
              ),

              // SizedBox(height: 20),
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
                                label: Text('x', style: TextStyle(fontStyle: FontStyle.italic)),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text('x+1', style: TextStyle(fontStyle: FontStyle.italic)),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text('f(x)', style: TextStyle(fontStyle: FontStyle.italic)),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text('f`(x)', style: TextStyle(fontStyle: FontStyle.italic)),
                              ),
                              DataColumn(
                                numeric: true,
                                label: Text('x1-x', style: TextStyle(fontStyle: FontStyle.italic)),
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
      ),
    );
  }
}
