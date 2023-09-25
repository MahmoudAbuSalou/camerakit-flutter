import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements CameraKitFlutterEvents {
  /// There will be interface that we will implement on [_MyAppState] class in the future,
  /// right now we have no method to show override any function
late String _filePath = '';
  late final _cameraKitFlutterEventsImpl =
      CameraKitFlutterEventsImpl(cameraKitFlutterEvents: this);

  @override
  void initState() {
    super.initState();
    _cameraKitFlutterEventsImpl.setTwoCheckoutCredentials(
        Constants.cameraKitAppId,
        Constants.cameraKitGroupId,
        Constants.cameraKitApiTokenStaging);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initCameraKit() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await _cameraKitFlutterEventsImpl.openCameraKit();
    } on PlatformException {
      if (kDebugMode) {
        print("Failed to open camera kit");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  initCameraKit();
                },
                child: const Text("Open CameraKit")),
            _filePath.isNotEmpty ? Image.file(File(_filePath)) :Container()
          ],
        ),
      ),
    );
  }

  @override
  void onCameraKitResult(String result) {
    setState(() {
      _filePath = result;
    });

    if (kDebugMode) {
      print('Result received in flutter=>>>>>>>>>>>>>>>>>>>>>>>> $result');
    }
  }
}
