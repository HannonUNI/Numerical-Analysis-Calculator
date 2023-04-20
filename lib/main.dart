// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'bisection.dart';
import 'fixed_point.dart';
import 'newton.dart';

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
                  child: Text("Fixed-Point Iteration"),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewtonPage()),
                        ),
                    child: Text("Newton's Method")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
