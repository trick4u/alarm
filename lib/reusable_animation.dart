// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class ReusableAnimation extends StatefulWidget {
  Widget child;

  ReusableAnimation({required this.child});
  @override
  _ReusableAnimationState createState() => _ReusableAnimationState();
}

class _ReusableAnimationState extends State<ReusableAnimation>

    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 30), vsync: this)
        ..repeat(reverse: true);

  late final Animation<double> _animation = Tween<double>(begin: 1.0, end: 1.5)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  // create a null animation

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState(); //
    _controller.repeat();
  }

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.stop();
        // _controller.forward();
      },
      onDoubleTap: () {
        setState(() {
          isPlaying = true;
          _controller.forward();
        });
      },
      onLongPress: () {
        _controller.reset();
        _controller.forward();
      },
      child: ScaleTransition(
        alignment: Alignment.center,
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
