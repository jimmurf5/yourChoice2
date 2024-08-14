import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

/// A customizable button that detects long press gestures and triggers a callback
/// after a specified duration of continuous press.
class LongPressButton extends StatefulWidget {
  //the callback function that gets triggered after the long press duration is completed
  final VoidCallback onLongPressCompleted;
  final int pressTime; //duration for the long press in seconds

  const LongPressButton({
    super.key,
    required this.onLongPressCompleted,
    required this.pressTime
  });

  @override
  LongPressButtonState createState() => LongPressButtonState();
}

class LongPressButtonState extends State<LongPressButton> with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _isLongPressing = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.pressTime),
    );

    _animationController.addListener(() {
      setState(() {

      });
    });
  }

  /// Starts the long press timer. If the user continues to press the button
  void _startLongPress() {
    _isLongPressing = true;

    _animationController.forward(from: 0.0); //start the progress animation

    _timer = Timer(Duration(seconds: widget.pressTime), () {
      /* If the user continues to press for the duration specified
      by [widget.pressTime], the [widget.onLongPressCompleted]
      callback is triggered. */
      if (_isLongPressing) {
        widget.onLongPressCompleted();
      }
    });
  }

  /// Stops the long press timer. This method is called when the user releases
  void _stopLongPress() {
    setState(() {
      _isLongPressing = false;
    });
    _timer?.cancel();
    _animationController.stop(); //stop the progress animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startLongPress(),
      onLongPressEnd: (_) => _stopLongPress(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Display the IconButton
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.bars),
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          // Display the progress indicator as an overlay
          if (_isLongPressing)
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: _animationController.value,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            )
        ],
      ),
    );
  }
}
