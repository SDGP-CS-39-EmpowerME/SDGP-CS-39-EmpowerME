import 'dart:async';
import 'dart:io';
import 'package:empowerme_cs_39/bottom_nav_bar.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';

class DetectionService {
  FlutterSoundRecorder recorder = FlutterSoundRecorder(); // Declares recorder
  bool recorderReady = false;
  String? recordingPath;
  String filename = '';

  String getFileName(){
    return filename;
  }

  Future startRecordingInitial() async {

    await initializeDateFormatting();
    await recorder.openRecorder();
    recorderReady = true;
    if (recorderReady == true) {
      print("startRecorder: Recorder ready");
    } else {
      print("startRecorder: Recorder not ready");
    }
    recordingPath = await filePath(); //stores the file path
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

  Future startRecording() async {
    await initializeDateFormatting();
    recorderReady = true;
    if (recorderReady == true) {
      print("startRecorder: Recorder ready");
    } else {
      print("startRecorder: Recorder not ready");
    }
    recordingPath = await filePath(); //stores the file path
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

    String formattedDateTime = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour.toString().padLeft(2, '0')}-${DateTime.now().minute.toString().padLeft(2, '0')}-${DateTime.now().second.toString().padLeft(2, '0')}";
    filename = "$formattedDateTime recording.wav";
    String filepath = path.join(appRecordingsDir.path, filename);
    print("XXXXXXXXXX FILE PATH: $filepath");
    return filepath;
  }

  Future stopRecorderFinal() async {
    if (recorderReady) { // Check if the recorder is open
      await recorder.stopRecorder();
      final recordedFile = File(recordingPath!);

      if(await recordedFile.exists()){
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File exists\n" + recordingPath!);
      } else {
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File does not exist");
      }

      await recorder.closeRecorder();
      recorderReady = false;
    } else {
      print("Recorder is not open");
    }
  }

  Future<void> stopRecorder() async {
    await recorder.stopRecorder();
    final recordedFile = File(recordingPath!);
    if(await recordedFile.exists()){
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File exists");
    } else {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File does not exist");
    }
  }
}

/*Future record() async {
    if (recorderReady) {
      print("record() method: Recorder working");
      await recorder.startRecorder(
        toFile: recordingPath,
      );
    } else if (!recorderReady){
      print("record() method: Recorder is not open");
      return;
    }
  }*/