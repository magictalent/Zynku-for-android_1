import 'package:flutter/material.dart';

enum AnimationTrigger {
  onPageLoad,
  onActionTrigger,
  onPageLoadReverse,
  onActionTriggerReverse,
}

class AnimationInfo {
  final AnimationTrigger trigger;
  final Animation<double>? animation;
  final bool applyInitialState;

  AnimationInfo({
    required this.trigger,
    this.animation,
    this.applyInitialState = false,
  });
}
