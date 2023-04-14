import 'package:flutter/material.dart';
import 'package:eval_ex/expression.dart';

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
