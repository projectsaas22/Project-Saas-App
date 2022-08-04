import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final excel = Excel.createExcel();

  static int rows = 2;

  @override
  Widget build(BuildContext context) {
    var accelerometerX = "";
    var accelerometerY = "";
    var accelerometerZ = "";

    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    if (_accelerometerValues != null) {
      accelerometerX = _accelerometerValues![0].toStringAsFixed(5);
      accelerometerY = _accelerometerValues![1].toStringAsFixed(5);
      accelerometerZ = _accelerometerValues![2].toStringAsFixed(5);
    }

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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green[100],
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: startSensor,
                        child: Text(
                          "Start | Record",
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: Colors.green[900],
                                letterSpacing: 0.6,
                                fontSize: 16,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: stopSensor,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[100],
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          "Stop | Export",
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: Colors.red[900],
                                letterSpacing: 0.6,
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Note: The file will be saved to your 'Downloads' folder.",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  )
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

  // @override
  // void initState() {
  //   super.initState();
  //   _streamSubscriptions.add(
  //     accelerometerEvents.listen(
  //       (AccelerometerEvent event) {
  //         setState(() {
  //           _accelerometerValues = <double>[event.x, event.y, event.z];
  //         });
  //       },
  //     ),
  //   );
  //   _streamSubscriptions.add(
  //     gyroscopeEvents.listen(
  //       (GyroscopeEvent event) {
  //         setState(() {
  //           _gyroscopeValues = <double>[event.x, event.y, event.z];
  //         });
  //       },
  //     ),
  //   );
  //   _streamSubscriptions.add(
  //     userAccelerometerEvents.listen(
  //       (UserAccelerometerEvent event) {
  //         setState(() {
  //           _userAccelerometerValues = <double>[event.x, event.y, event.z];
  //         });
  //       },
  //     ),
  //   );
  //   _streamSubscriptions.add(
  //     magnetometerEvents.listen(
  //       (MagnetometerEvent event) {
  //         setState(() {
  //           _magnetometerValues = <double>[event.x, event.y, event.z];
  //         });
  //       },
  //     ),
  //   );
  // }

  void startSensor() {
    final sheet = excel[excel.getDefaultSheet()!];
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value =
        "S.N";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value =
        "Timestamp";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1)).value =
        "Accelerometer-X";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1)).value =
        "Accelerometer-Y";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 1)).value =
        "Accelerometer-Z";

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rows))
              .value = rows - 1;

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rows))
              .value = DateFormat('kk:mm:ss:ms').format(DateTime.now());

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rows))
              .value = event.x;

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rows))
              .value = event.y;

          sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rows))
              .value = event.z;

          rows++;
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

  void stopSensor() async {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    // var saveExcel = writeCounter(excel);
    // print(saveExcel);

    String filename =
        "SensorTry" + DateFormat('kk-mm-ss').format(DateTime.now());
    List<int>? excelFile = excel.save(fileName: 'SensorTry.xlsx');

    PermissionStatus status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      await File('/storage/emulated/0/Download/$filename.xlsx')
          .writeAsBytes(excelFile!, flush: true)
          .then((value) {
        log('saved');
      });
    } else if (status == PermissionStatus.denied) {
      log('Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      log('Take the user to the settings page.');
    }
  }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/filename.xlsx');
  // }

  // Future<File> writeCounter(Excel excel) async {
  //   final file = await _localFile;
  //   return file.writeAsBytes(excel.encode()!);
  // }
}
