import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class DetectionService {
  FlutterSoundRecorder recorder = FlutterSoundRecorder(); // Declares recorder
  bool recorderReady = false;
  String? recordingPath;

  Future startRecording() async {
    await initializeDateFormatting();
    await recorder.openRecorder();

    recorderReady = true;
    if (recorderReady == true)
      print("startRecorder: Recorder ready");
    else
      print("startRecorder: Recorder not ready");
    recordingPath = await filePath(); //stores the file path
    await record();
  }

  Future<String> filePath() async{
    Directory? appDocDir = await getExternalStorageDirectory();
    if (appDocDir == null) {
      print("External storage directory not found");
      return "";
    }
    Directory appRecordingsDir = Directory(path.join(appDocDir.path, 'App Recordings'));
    if (!await appRecordingsDir.exists()) {
      await appRecordingsDir.create(recursive: true);
    }
    String filename = "${DateTime.now().millisecondsSinceEpoch}_recording.wav";
    String filepath = path.join(appRecordingsDir.path, filename);
    print("XXXXXXXXXX FILE PATH: $filepath");
    return filepath;
  }

  Future record() async {
    if (recorderReady) {
      print("record() method: Recorder working");
      await recorder.startRecorder(
        toFile: recordingPath,
      );
    } else if (!recorderReady){
      print("record() method: Recorder is not open");
      return;
    }
  }

  Future stopRecorder() async {
    if (recorderReady) { // Check if the recorder is open
      await recorder.stopRecorder();
      final recordedFile = File(recordingPath!);

      if(await recordedFile.exists()){
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File exists\n" + recordingPath!);
      } else {
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File does not exist");
      }
      //recordSubscription!.cancel();
      await recorder.closeRecorder();
      recorderReady = false;
    } else {
      print("Recorder is not open");
    }
  }
}



  /*Future<void> stopRecorder() async {
    await recorder.stopRecorder();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filename = "${DateTime.now().millisecondsSinceEpoch}_recording.wav";
    String filepath = path.join(appDocDir.path, filename);
    final recordedFile = File(filepath);
    if(await recordedFile.exists()){
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File exists");
    } else {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File does not exist");
    }
    recordSubscription?.cancel();
    await recorder.closeRecorder();
  }
}*/



//before filename fix
/*import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class DetectionService {
  FlutterSoundRecorder recorder = FlutterSoundRecorder(); // Declares recorder
  StreamSubscription? recordSubscription;

  Future<void> startRecording(int duration) async {
    await initializeDateFormatting();
    //await requestMicrophonePermission(); // Request microphone permission
    //final location = await Permission.locationAlways.request();


    await recorder.openRecorder();
    await recorder.setSubscriptionDuration(Duration(milliseconds: duration));

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filename = "${DateTime.now().toString()}_recording.wav";
    String filepath = path.join(appDocDir.path, filename);*//*"storage/emulated/0/Download/";*//*

    await recorder.startRecorder(
      toFile: filepath,
      codec: Codec.pcm16WAV,
      sampleRate: 44100,
    );

    recordSubscription = recorder.onProgress!.listen((e) {
      try {
        var date = DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds, isUtc: true);
        var formattedTime = DateFormat('mm:ss:SS', 'en_GB').format(date);
        // Update UI or perform further processing with formattedTime
      } catch (error) {
        print("Error during recording progress: $error");
      }
    });
  }

  Future<void> stopRecorder() async {
    await recorder.stopRecorder();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filename = "${DateTime.now().toString()}_recording.wav";
    String filepath = path.join(appDocDir.path, filename);
    final recordedFile = File(filepath);
    if(await recordedFile.exists()){
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File exists");
    } else {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File does not exist");
    }
    recordSubscription!.cancel();
    await recorder.closeRecorder();
  }
}*/

/*
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';

class DetectionService {
  FlutterSoundRecorder recorder = FlutterSoundRecorder(); // Declares recorder as a class member

  void startRecording(int duration) async {
    await recorder.openRecorder();
    await recorder.setSubscriptionDuration(Duration(milliseconds: duration));
    await initializeDateFormatting();

    // ... permission requests

    await startRecorder(); // Call the startRecorder method
  }

  Future<void> startRecorder() async {
    //String filepath = "storage/emulated/0/Download/";

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filename = DateTime.now().toString() + '.wav';

    //String filepath = '${appDocDir.path}/recordings/$filename';

    Future<String> getDownloadPath() async {
      final directory = await getDownloadsDirectory();
      return directory!.path;
    }
    String filepath = getDownloadPath() as String;

    */
/*Directory dir = Directory(path.dirname(filepath));
    if (!dir.existsSync()) {
      dir.createSync();
    }*//*


    await recorder.startRecorder(
      toFile: filepath,
      codec: Codec.pcm16WAV,
      sampleRate: 44100,
    );

    StreamSubscription recordSubscription = recorder.onProgress!.listen((e) {
      try {
        var date = DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds, isUtc: true);
        var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

      } catch (error) {
        print("Error during recording progress: $error");
      }
    });
    recordSubscription.cancel();
  }

  Future<void> stopRecorder() async {
    await recorder.stopRecorder();
  }
}

*/
