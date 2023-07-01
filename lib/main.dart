import 'package:flutter/material.dart';
import 'package:music_player/src/models/audioplayer_model.dart';

import 'package:provider/provider.dart';
import 'package:music_player/src/pages/music_player.dart';

import 'package:music_player/src/theme/theme.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioPlayerModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music player',
        theme: miTema,
        home: MusicPlayer(),
      ),
    );
  }
}
