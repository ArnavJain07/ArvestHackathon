import 'package:flutter/material.dart';

class ProgressTracker extends StatelessWidget {
  final double progress; // Progress as a percentage (0.0 to 1.0)

  const ProgressTracker({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(value: progress),
        SizedBox(height: 10),
        Text('${(progress * 100).toStringAsFixed(0)}% to your goal!'),
      ],
    );
  }
}
