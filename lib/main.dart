import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saas Sensor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sensor Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final accelerometerX = _accelerometerValues![0].toStringAsFixed(5);
    final accelerometerY = _accelerometerValues![1].toStringAsFixed(5);
    final accelerometerZ = _accelerometerValues![2].toStringAsFixed(5);
    var gyroX = "";
    var gyroY = "";
    var gyroZ = "";
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    if (_gyroscopeValues != null) {
      gyroX = _gyroscopeValues![0].toStringAsFixed(5);
      gyroY = _gyroscopeValues![1].toStringAsFixed(5);
      gyroZ = _gyroscopeValues![2].toStringAsFixed(5);
    }
    // final userAccelerometer = _userAccelerometerValues
    //     ?.map((double v) => v.toStringAsFixed(1))
    //     .toList();
    // final magnetometer =
    //     _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '- Accelerometer -',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF242424),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'X-Axis: $accelerometerX',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Y-Axis: $accelerometerY',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Z-Axis: $accelerometerZ',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '- Gyroscope -',
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF242424),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'X-Axis: $gyroX',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Y-Axis: $gyroY',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Z-Axis: $gyroZ',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }
}
