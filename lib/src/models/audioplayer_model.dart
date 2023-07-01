import 'package:flutter/material.dart';

class AudioPlayerModel with ChangeNotifier {

  // ignore: unused_field
  bool _playing = false;
  late AnimationController _controller;
  late Duration _songDuration = const Duration(milliseconds: 0);
  late Duration _current = const Duration(milliseconds: 0);
  
  String get sontTotalDuration => printDuration(songDuration);
  String get currentSecond => printDuration(current);

  double get percent => (_songDuration.inSeconds > 0) ? _current.inSeconds / _songDuration.inSeconds : 0;

  // ignore: unnecessary_getters_setters
  AnimationController get controller => _controller;

  set controller(AnimationController value) {
    _controller = value;
  }

  // ignore: unnecessary_getters_setters
  bool get playing => _playing;

  set playing(bool value) {
    _playing = value;
    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  Duration get songDuration => _songDuration;

  set songDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  Duration get current => _current;

  set current(Duration value) {
    _current = value;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";
  }

}
