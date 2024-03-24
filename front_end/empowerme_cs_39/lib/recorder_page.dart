import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class VoiceRecorderPage2 extends StatefulWidget {
  @override
  _VoiceRecorderPage2State createState() => _VoiceRecorderPage2State();
}

class _VoiceRecorderPage2State extends State<VoiceRecorderPage2> {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool recorderReady = false;
  String? recordingPath;
  late String fileName;
  bool _isRecording = false;
  int _elapsedTime = 0;
  late Timer _timer;
  bool _isDetecting = false;
  List<String> _recordings = [];
  int _snippetCount = 0;
  final int _maxSnippetDuration = 30; // Duration of each snippet in seconds
  int _maxSnippets = 3; // Maximum number of snippets to record before saving
  late Directory _appDirectory;
  int selectedIndex = 0;
  bool _isPlaying = false;
  bool _isPageEnabled = true;

  @override
  void initState() {
    super.initState();
    _initLocalPath();
    initializeDateFormatting();
  }

  Future<void> _initLocalPath() async {
    _appDirectory = (await getExternalStorageDirectory())!;
  }
  Future<void> _startRecording() async {

    if(await Permission.microphone.isGranted){
      await initializeDateFormatting();
      await recorder.openRecorder();
      recordingPath = await _filePath();
      print('openRecorder() working with returned filepath');
      recorderReady = true;
      if (recorderReady) {
        print("record() method: Recorder working");
        await recorder.startRecorder(
          toFile: recordingPath,
        );
      } else if (!recorderReady){
        print("record() method: Recorder is not open");
        return;
      }
      setState(() {
        _isRecording = true;
        _elapsedTime = 0;
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _elapsedTime++;
            if (_elapsedTime % _maxSnippetDuration == 0) {
              _saveRecordings(); // Save recording every 30 seconds
            }
          });
        });
      });
    }
    else if (await Permission.microphone.isDenied){
      await Permission.microphone.request();
    } else if (await Permission.microphone.isPermanentlyDenied){
      openAppSettings();
    }
  }

  Future<void> _stopRecording() async {
    print('before stopRecorder()');
    await recorder.stopRecorder();
    print('after stopRecorder()');
    final recordedFile = File(recordingPath!);

    if(await recordedFile.exists()){
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File exists\n" + recordingPath!);
    } else {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>File does not exist");
    }
    setState(() {
      _isRecording = false;
      _timer.cancel();
      _saveRecordings();
      _snippetCount++;
      if (_snippetCount == _maxSnippets) {
        _saveRecordings();
      }
    });
  }

  /*Future<void> _closeRecorder() async {
    await recorder.closeRecorder();
  }*/

  Future<void> _saveRecordings() async {
    //String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    File file = File('${_appDirectory.path}/$fileName');
    await file.writeAsString('Recording ${_recordings.length + 1}');
    _recordings.add(fileName);

    print('File saved at: ${file.path}');

    // You can implement your logic to save recordings to local storage here
    print('Recordings saved to local storage: $_recordings');
    _snippetCount = 0;
    await recorder.closeRecorder();
  }

  Future<String> _filePath() async {
    Directory? appDocDir = await getExternalStorageDirectory();
    if (appDocDir == null) {
      print("External storage directory not found");
      return "";
    }
    Directory appRecordingsDir = Directory(path.join(appDocDir.path, 'Manual Record'));
    if (!await appRecordingsDir.exists()) {
      await appRecordingsDir.create(recursive: true);
    }

    String formattedDateTime = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}_${DateTime.now().hour.toString().padLeft(2, '0')}-${DateTime.now().minute.toString().padLeft(2, '0')}-${DateTime.now().second.toString().padLeft(2, '0')}";
    fileName = "$formattedDateTime manual recording.wav";
    // String filename = "${DateTime.now().millisecondsSinceEpoch}_recording.wav";
    String filepath = path.join(appRecordingsDir.path, fileName);
    print("XXXXXXXXXX FILE PATH: $filepath");
    return filepath;
  }

  String _formatTime(int seconds) {
    String minutesStr = (seconds ~/ 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Voice Recorder',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _recordings.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_recordings[index]),
                      onTap: () {
                        // Play the selected recording
                        // You can implement your logic to play the recording here
                        print('Playing ${_recordings[index]}');
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isRecording ? 'Recording...' : 'Tap to Record',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Duration: ${_formatTime(_elapsedTime)}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _isPageEnabled
                          ? () {
                        if (_isRecording) {
                          _stopRecording();
                        } else {
                          _startRecording();
                        }
                      }
                          : null,
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        size: 50.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isDetecting) CircularProgressIndicator(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 40, color: selectedIndex == 0 ? Colors.blue : Colors.grey,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 30),
              child: _isDetecting ? const Icon(Icons.pause_rounded, size: 40) : _isPlaying ? const Icon(Icons.pause_rounded, size: 40) : const Icon(Icons.play_arrow_rounded, size: 40),
            ),
            label: 'Detect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded, size: 40, color: selectedIndex == 2 ? Colors.blue : Colors.grey,),
            label: 'Profile',
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            if (index == 1) {
              _isDetecting = !_isDetecting;
              _isPageEnabled = !_isDetecting;
              if (_isRecording) {
                _stopRecording(); // Stop recording if it's in progress
              }
            } else {
              _isDetecting = false;
              _isPageEnabled = true;
            }
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_isRecording) {
      _timer.cancel();
    }
    recorder.closeRecorder();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: VoiceRecorderPage2(),
  ));
}
