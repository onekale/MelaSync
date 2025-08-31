import 'package:flutter/material.dart';
import 'package:mobile/presentation/screen/home_screen.dart';
import 'package:mobile/presentation/screen/music_player_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Mela Sync',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}