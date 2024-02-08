import 'package:flutter/material.dart';
// ignore: camel_case_types
class Connect_smartwatch extends StatelessWidget {
  const Connect_smartwatch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 8),
            Text('Smerwatch Connected'),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.watch, color: Colors.white),
            onPressed: () {},
          ),
          
        ],
      ),
      body: Column(
        children: [
          // Search list section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search Device',
              ),
            ),
          ),
          // Expanded section for the main content
          Expanded(
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 200),
                duration: const Duration(milliseconds: 1000),
                builder: (context, size, child) {
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: size / 2,
                        ),
                      ],
                    ),
                    child: Image.asset("assets/Blutooth.png"),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

     





