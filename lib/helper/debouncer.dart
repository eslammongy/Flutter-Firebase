import 'dart:async';
import 'package:flutter/material.dart';


class Debounce {
  static Debounce? _instance;
  final int seconds;
  Timer? _timer;

  factory Debounce({required int seconds}) {
    _instance ??= Debounce._internal(seconds: seconds);
    return _instance!;
  }

  Debounce._internal({required this.seconds});

  ///The [callback] function is invoked after the given duration.
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(seconds: seconds), action);
  }
}

