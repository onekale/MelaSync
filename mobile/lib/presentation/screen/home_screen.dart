import 'package:flutter/material.dart';
import 'package:mobile/presentation/screen/mezmure_selection_screen.dart';
import 'package:mobile/presentation/screen/music_upload_screen.dart';
import 'package:mobile/presentation/widgets/general_custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 17, 17),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        title: Center(
          child: Text(
            "እንጩህ",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 65,
                child: GeneralButton(
                  text: 'ወደ ጥናት',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MezmureSelectionScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.play_circle),

                  gradientColors: [Color(0xFF118AB2), Color(0xFF06d6A0)],
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 65,
                child: GeneralButton(
                  text: 'ማጥኛ አስገባ',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MusicUploadPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.upload),
                  gradientColors: [Color(0xFF118AB2), Color(0xFF06d6A0)],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
