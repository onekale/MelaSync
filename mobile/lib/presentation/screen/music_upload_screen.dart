import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/presentation/widgets/general_custom_button.dart';

class MusicUploadPage extends StatefulWidget {
  const MusicUploadPage({super.key});

  @override
  State<MusicUploadPage> createState() => _MusicUploadPageState();
}

class _MusicUploadPageState extends State<MusicUploadPage> {
  File? audioFile;
  File? lyricsFile;
  String uploadUrl = "https://mz09ts4f-3000.uks1.devtunnels.ms/music/upload";

  Future<void> pickFiles() async {
    final audioResult = await FilePicker.platform.pickFiles(type: FileType.audio);
    final lyricsResult = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);

    if (audioResult != null && lyricsResult != null) {
      setState(() {
        audioFile = File(audioResult.files.single.path!);
        lyricsFile = File(lyricsResult.files.single.path!);
      });
    }
  }

  Future<void> uploadFiles() async {
    if (audioFile == null || lyricsFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text("እባክዎትን ሁለቱንም መረጃዎች ያስገቡ")));
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('audio', audioFile!.path));
    request.files.add(await http.MultipartFile.fromPath('lyrics', lyricsFile!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Upload successful")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed: ${response.statusCode}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black87, title: const Text("ድምጹን እና ዘሩን ያስገቡ", style: TextStyle(color: Colors.white),)),
      body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 26, 26, 26), Color.fromARGB(255, 44, 44, 44)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: pickFiles,
                icon: const Icon(Icons.attach_file),
                label: const Text("ፋይል ይምረጡ"),
              ),
              const SizedBox(height: 10),
              if (audioFile != null) Text("Audio: ${audioFile!.path.split('/').last}"),
              if (lyricsFile != null) Text("Lyrics: ${lyricsFile!.path.split('/').last}"),
              const SizedBox(height: 20),
        
                SizedBox(
                  // width: double.infinity,
                  height: 65,
                  child: GeneralButton(
                    text: 'ያስገቡ',
                    onPressed: uploadFiles,
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
