import 'package:flutter/material.dart';
import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:music_player/src/models/audioplayer_model.dart';

import 'package:music_player/src/widgets/appbar.dart';

// ignore: use_key_in_widget_constructors
class MusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            children: [
              CustomAppBar(),
              ImageDiscDuration(),
              TitlePlay(),
              Expanded(child: Lyrics())
            ],
          ),
        ],
      )
    );
  }
}

// ignore: use_key_in_widget_constructors
class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * .8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ],
        ),
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Lyrics extends StatefulWidget {
  @override
  State<Lyrics> createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  final _controller = FixedExtentScrollController(initialItem: 0);
  late Timer upperSliderTimer;

  void startController() {
    int totalitems = getLengthInt; //total length of items
    int counter = 0;
    bool end = false;
    if (counter <= totalitems) {
      upperSliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        _controller
          .animateToItem(counter, duration: const Duration(seconds: 1), curve: Curves.easeInCubic)
          .whenComplete(() {
            if (counter == getLengthInt) {
              counter = 0;
              end = true;
            }
          });

        counter++;
        if (end) _controller.dispose();
      });
    }
  }

  @override
  void initState() {
    startController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      children: getLyrics().map((verse) => Text(verse, style: TextStyle(
        fontSize: 20,
        color: Colors.white.withOpacity((.6))
      ))).toList(),
      itemExtent: getLength,
      diameterRatio: 1.5,
      physics: const BouncingScrollPhysics(),
      controller: _controller,
    );
  }
}

// ignore: use_key_in_widget_constructors
class TitlePlay extends StatefulWidget {
  @override
  State<TitlePlay> createState() => _TitlePlayState();
}

class _TitlePlayState extends State<TitlePlay> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController _controller;
  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);

    assetAudioPlayer.open(
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      autoStart: true,
      showNotification: true
    );

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio?.audio.duration ?? const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      margin: const EdgeInsets.only(top: 40, bottom: 20),
      child: Row(
        children: [
          Column(
            children: [
              Text('Far away', style: TextStyle(
                fontSize: 30,
                color: Colors.white.withOpacity((.8))
              )),
              Text('-- Breaking Benjamin --', style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity((.5))
              )),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              final audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false); 

              if (isPlaying) {
                _controller.reverse();
                isPlaying = false;
                audioPlayerModel.controller.stop();
              } else {
                _controller.forward();
                isPlaying = true;
                audioPlayerModel.controller.repeat();
              }

              if (firstTime) {
                open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            backgroundColor: const Color(0xffF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause, 
              progress: _controller
            ),
            elevation: 0,
            highlightElevation: 0,
          ),
        ],
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class ImageDiscDuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          ImageDisc(),
          const SizedBox(width: 20),
          ProgressBar(),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

// ignore: use_key_in_widget_constructors
class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: Colors.white.withOpacity(0.4));
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final percent = audioPlayerModel.percent;

    return Column(
      children: [
        Text(audioPlayerModel.sontTotalDuration, style: style),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              width: 3,
              height: 230,
              color: Colors.white.withOpacity(.1),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 3,
                height: 230 * percent,
                color: Colors.white.withOpacity(.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(audioPlayerModel.currentSecond, style: style),
      ],
    );
  }
}

// ignore: use_key_in_widget_constructors
class ImageDisc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              child: const Image(image: AssetImage('assets/aurora.jpg')),
              duration: const Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (animationController) => audioPlayerModel.controller = animationController,
              animate: false,
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(100)
              ),
            ),
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xff1C1C25),
                borderRadius: BorderRadius.circular(100)
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: const LinearGradient(
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24)
        ],
        begin: Alignment.bottomLeft),
      ),
    );
  }
}
