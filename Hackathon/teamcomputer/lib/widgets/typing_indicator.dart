import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _dotAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Rich is thinking"),
        SizedBox(width: 4.0),
        AnimatedBuilder(
          animation: _dotAnimation,
          builder: (context, child) {
            return Row(
              children: [
                Opacity(opacity: _dotAnimation.value, child: Text('.')),
                Opacity(opacity: _dotAnimation.value, child: Text('.')),
                Opacity(opacity: _dotAnimation.value, child: Text('.')),
              ],
            );
          },
        ),
      ],
    );
  }
}
