import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListWheelScrollView(
        // useMagnifier: true,
        // magnification: 1.5,
        diameterRatio: 1.5,
        offAxisFraction: 1,
        itemExtent: 200,
        children: [
          for (final x in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                color: Colors.teal,
                alignment: Alignment.center,
                child: Text(
                  'Pick me $x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
