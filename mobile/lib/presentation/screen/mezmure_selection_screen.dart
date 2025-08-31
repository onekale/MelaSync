import 'package:flutter/material.dart';
import 'package:mobile/infrastructure/models/mezmure_model.dart';
import 'package:mobile/presentation/screen/music_player_screen.dart';

class MezmureSelectionScreen extends StatelessWidget {
  final List<MezmureModel> mezmures = [
    MezmureModel(title: "ሰላም", assetPath: "assets/audio/selam.mp3", lyricId: 1),
    MezmureModel(title: "ማነው በፍቅሩ", assetPath: "assets/audio/manw.m4a", lyricId: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "የጥናት ምርጫ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 22, 22, 22), Color.fromARGB(255, 32, 32, 32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mezmures.length,
            itemBuilder: (context, index) {
              final mezmure = mezmures[index];
              return Card(
                color: const Color.fromARGB(255, 226, 226, 226),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(
                    mezmure.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  trailing: const Icon(Icons.play_circle_fill, color: Colors.orange, size: 32),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MusicPlayerScreen(mezmure: mezmure),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
