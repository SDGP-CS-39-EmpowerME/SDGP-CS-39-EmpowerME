import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Recording App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecordingPage(),
    );
  }
}

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  Timer? _timer;
  List<double> _intensityList = [];

  @override
  void initState() {
    super.initState();
    _startRecordingSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRecordingSimulation() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final intensity = Random().nextDouble();
      setState(() {
        _intensityList.add(intensity);
        if (_intensityList.length > 20) {
          _intensityList.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Recording'),
        backgroundColor: Color(0xFF007CCF),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(),
          ),
          Center(
            child: SizedBox(
              height: 100,
              child: SpectrogramVisualization(intensityList: _intensityList),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundIconButton(icon: Icons.play_arrow, onPressed: () {}),
                RecordingButton(),
                RoundIconButton(icon: Icons.stop, onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpectrogramVisualization extends StatelessWidget {
  final List<double> intensityList;

  SpectrogramVisualization({required this.intensityList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: intensityList.map((intensity) {
        return Container(
          width: 12.0, // Adjust the width here
          height: 180.0 * intensity, // Adjust the height here
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.5 + intensity * 0.5),
            borderRadius: BorderRadius.vertical(
                //top: Radius.circular(10.0),
                ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.5 + intensity * 0.5),
                blurRadius: 4.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class RecordingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.purpleAccent, width: 3.0),
      ),
      child: Icon(
        Icons.mic,
        color: Colors.purpleAccent,
        size: 30.0,
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const RoundIconButton({Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }
}
