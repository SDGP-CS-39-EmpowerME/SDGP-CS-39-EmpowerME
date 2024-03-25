import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:empowerme_cs_39/bottom_nav_bar.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StreamDetection{
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  StreamController<Uint8List> audioStreamController = StreamController<Uint8List>.broadcast();
  //FlutterBackgroundService service = FlutterBackgroundService();
  late Timer timer;
  bool recorderReady = false;
  String? recordingPath;
  String? recordingPathChunk;
  String filename = '';
  StreamSubscription? subscription;
  late String lat;
  late String long;
  late String locationCoords;

  String getFileName(){
    return filename;
  }

  Future<String> filePath(String folderName) async{
    Directory? appDocDir = await getExternalStorageDirectory();
    if (appDocDir == null) {
      print("External storage directory not found");
      return "";
    }
    Directory appRecordingsDir = Directory(path.join(appDocDir.path, folderName));
    if (!await appRecordingsDir.exists()) {
      await appRecordingsDir.create(recursive: true);
    }

    String formattedDateTime = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour.toString().padLeft(2, '0')}-${DateTime.now().minute.toString().padLeft(2, '0')}-${DateTime.now().second.toString().padLeft(2, '0')}";
    filename = "$formattedDateTime recording.wav";
    String filepath = path.join(appRecordingsDir.path, filename);
    print("++++++++++ $folderName XXXXXXXXXX FILE PATH: $filepath");
    return filepath;
  }

  Future <void> startRecording() async {
    await initializeDateFormatting();
    //BottomNavBar nav = BottomNavBar as BottomNavBar;
    await recorder.openRecorder();
    //await recorder.setBufferSize(bufferSize);
    recorderReady = true;
    if (recorderReady == true) {
      print("startRecorder: Recorder ready");
    } else {
      print("startRecorder: Recorder not ready");
    }
    recordingPath = await filePath('Main Recording'); //stores the file path
    await recorder.startRecorder(
      toFile: recordingPath,
      codec: Codec.pcm16WAV,
    );
    await recorder.onProgress!.listen(
      (event) {
        print("ssssssssssssssssss inside onProgress listen part");
        audioStreamController.add(event as Uint8List);
      },
      onError:(error){
        print("Error in onProgress stream: $error");
      }
    );
    /*timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      storeChunk();
    });*/
    startTimer();
  }

  void startTimer(){
    timer = Timer(const Duration(milliseconds: 100),waitForChunkCreation);
  }

  void waitForChunkCreation() async {
    await storeChunk();
    timer = Timer(const Duration(seconds: 15),waitForChunkCreation);
  }
  
  Future<void> storeChunk () async {
    List<Uint8List> chunks = [];
    print("000000000000000000000000000 inside storeChunk() method");
    subscription = await audioStreamController.stream.listen(
          (chunk) {
            print("Chunk data: $chunk");  // This will print the chunk data
            chunks.add(chunk);
            print("big chunkus added");
          },
          onError: (error) {
            print("Error in stream: $error");
          },
    );
    recordingPathChunk = await filePath('App Recordings'); //stores the file path
    print("OOOOOOOOOOOOOOOOOOOOOOOOOOOO   storeChunk(): $recordingPathChunk");
    try {
      if (chunks.isNotEmpty) { // Check if chunks list has elements
        for (int i = 0; i < chunks.length; i++){
          File file = File(recordingPathChunk!);
          await file.writeAsBytes(chunks[i]);
          onRecordButtonTapped(recordingPathChunk!);
        }
      } else {
        print("No audio data received yet");
      }
    } on Exception catch (e) {
      print("EEEEEEEEEEEEEEEEEEEEE storeChunk() Error message $e");
    }
  }

  Future <void> stopRecording() async {
    timer.cancel();
    await recorder.stopRecorder();
    await recorder.closeRecorder();
    audioStreamController.close();
    subscription?.cancel();
  }

  /// every time the button is pressed and the file names and the coords are obtained, the key-value pair should be formed.
  /// The instance should be the same thing for all pairs and the instance should be created only once. Change below code to make that happen. meka me nikan liyala thiyenne.
  void onRecordButtonTapped(String filePathChunk) async {
    //Starts a SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    //Stores the coordinates with the file name as the key
    await prefs.setString(filePathChunk,locationCoords);
  }

  //listen to location settings
  void liveLocation(FlutterBackgroundService service) {
    service.invoke('setAsForeground');
    LocationSettings locSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 30,
    );
    Geolocator.getPositionStream(locationSettings: locSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
    });
  }

  Future<void> getLocation() async {
    await _getCurrentLocation().then((value){
      lat = '${value.latitude}';
      long = '${value.longitude}';
      locationCoords = '$lat,$long';
      print("L   O   C   A   T   I   O   N   --->  $locationCoords");
    });
  }

  Future <Position> _getCurrentLocation() async {
    try{
      return await Geolocator.getCurrentPosition();
    } catch (e){
      return Future.error(e);
    }
  }
}