import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 
class ShakeWidget extends AnimatedWidget {
  /// ShakeWidget constructur
  const ShakeWidget(
      {required AnimationController controller,
      required Widget child,
      required double intensity})
      : _intensity = intensity, _child = child,
        _controller = controller,
        super(listenable: controller);

  final Widget _child;
  final double _intensity;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: _intensity)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(listenable as Animation<double>);

    _controller.duration = Duration(milliseconds: 800);

    return Positioned(
      child: _child,
      left: offsetAnimation.value,
      right: _intensity - offsetAnimation.value,
      bottom: 0,
      top: 0,
    );
  }
}

///
class ZoomWidget extends AnimatedWidget {
  /// ZoomWidget constructor
  const ZoomWidget(
      {required AnimationController controller,
      required Widget child,
      required double intensity})
      : _intensity = intensity, _child = child,
        _controller = controller,
        super(listenable: controller);

  final Widget _child;
  final double _intensity;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: _intensity)
        .chain(CurveTween(curve: Curves.ease))
        .animate(listenable as Animation<double>);

    _controller.duration = Duration(milliseconds: 400);

    return Positioned(
      child: _child,
      left: -offsetAnimation.value,
      right: -offsetAnimation.value,
      bottom: -offsetAnimation.value,
      top: -offsetAnimation.value,
    );
  }
}
