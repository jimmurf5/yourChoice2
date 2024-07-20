import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class LongPressButton extends StatefulWidget {
  final VoidCallback onLongPressCompleted;

  const LongPressButton({super.key, required this.onLongPressCompleted});

  @override
  LongPressButtonState createState() => LongPressButtonState();
}

class LongPressButtonState extends State<LongPressButton> {
  Timer? _timer;
  bool _isLongPressing = false;

  void _startLongPress() {
    _isLongPressing = true;
    _timer = Timer(const Duration(seconds: 8), () {
      if (_isLongPressing) {
        widget.onLongPressCompleted();
      }
    });
  }

  void _stopLongPress() {
    _isLongPressing = false;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startLongPress(),
      onLongPressEnd: (_) => _stopLongPress(),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(FontAwesomeIcons.bars),
      ),
    );
  }
}
