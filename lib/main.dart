import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Native Get Battery Level'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const batteryChannel = MethodChannel('hilo/battery');

  String batteryLevel = 'Waiting...';

  Timer? _timer;

  void _initTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _getBatteryLevel(),
    );
  }



  Future<void> _getBatteryLevel() async {
    int newBatteryLevel = 0;

    try {

      final arguments = {'name': 'Hilo Abs'};

      // newBatteryLevel =
      // await batteryChannel.invokeMethod('getBatteryLevel', arguments);

      var a =
      await batteryChannel.invokeMethod('getBatteryLevel', arguments);

      print('New battery Level : ${a[0]}');
    } on PlatformException catch (_) {
      newBatteryLevel = -2;
    }

    setState(() {
     batteryLevel = '$newBatteryLevel%';
    });
  }

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Battery Level:',
            ),
            Text(
              batteryLevel,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('Get Battery Level')),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
