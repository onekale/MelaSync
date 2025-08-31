import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/infrastructure/models/mezmure_model.dart';

class MusicPlayerScreen extends StatefulWidget {
  final MezmureModel mezmure;
  const MusicPlayerScreen({super.key, required this.mezmure});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final player = AudioPlayer();
  final scrollController = ScrollController();
  List<Map<String, dynamic>> lyrics = [];
  Duration currentPosition = Duration.zero;
  int currentLineIndex = 0;
  bool userScrolling = false;
  bool isPlaying = false;
  bool isLoading = true;
  int? lockedLineIndex;
  bool isSeekingBack = false;

  @override
  void initState() {
    super.initState();
    loadMusic();
    player.positionStream.listen((pos) async {
      setState(() {
        currentPosition = pos;
        _updateCurrentLine();
      });

      // Auto repeat if locked
      if (lockedLineIndex != null &&
          lockedLineIndex! < lyrics.length - 1 &&
          pos >= lyrics[lockedLineIndex! + 1]["time"] &&
          !isSeekingBack) {
        isSeekingBack = true;
        await player.seek(lyrics[lockedLineIndex!]["time"]);
        isSeekingBack = false;
      }

      if (!userScrolling) {
        scrollToCurrentLine();
      }
    });

    // player.positionStream.listen((pos) {
    //   setState(() {
    //     currentPosition = pos;
    //     _updateCurrentLine();
    //   });

    //   if (!userScrolling) {
    //     scrollToCurrentLine();
    //   }
    // });

    scrollController.addListener(() {
      if (scrollController.position.isScrollingNotifier.value) {
        userScrolling = true;
      }
    });

    player.playingStream.listen((playing) {
      setState(() {
        isPlaying = playing;
      });
    });
  }

  Future<void> loadMusic() async {
    print("loading music");
    final lyricUrl = "https://mz09ts4f-3000.uks1.devtunnels.ms/music/lyrics/${widget.mezmure.lyricId}";
    // final lyricUrl =
        // "http://localhost:3000/music/lyrics/${widget.mezmure.lyricId}";
    await player.setAsset('${widget.mezmure.assetPath}');
    // print(lyricUrl);

    final response = await http.get(Uri.parse(lyricUrl));
    print("Response status: ${response.statusCode}");
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      lyrics =
          data
              .map<Map<String, dynamic>>(
                (e) => {
                  "time": Duration(seconds: e['time']),
                  "line": e['line'],
                },
              )
              .toList();
      setState(() {});
      setState(() {
        isLoading = false;
      });
    } else {
      print("There is server error");
    }
  }

  void _updateCurrentLine() {
    for (int i = 0; i < lyrics.length; i++) {
      if (currentPosition < lyrics[i]["time"]) {
        currentLineIndex = i > 0 ? i - 1 : 0;
        return;
      }
    }
    currentLineIndex = lyrics.length - 1;
  }

  void scrollToCurrentLine() {
    if (!scrollController.hasClients || lyrics.isEmpty) return;

    final double lineHeight = 80; // Estimate your AnimatedContainer height
    final double screenHeight = MediaQuery.of(context).size.height;
    final double offset =
        (lineHeight * currentLineIndex) - (screenHeight / 2) + (lineHeight / 2);

    scrollController.animateTo(
      offset.clamp(0.0, scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void seekToLine(Duration time) {
    player.seek(time);
  }

  @override
  void dispose() {
    player.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Text(
            "ጥናት ማጫወቻ",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 26, 26, 26),
              Color.fromARGB(255, 44, 44, 44),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            isLoading
                ? Center(
                  child: Lottie.asset(
                    'assets/animations/loading.json', // <-- your Lottie animation file
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                )
                : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: lyrics.length,
                      itemBuilder: (context, index) {
                        final line = lyrics[index];
                        final isActive = index == currentLineIndex;

                        return GestureDetector(
                          onTap: () {
                            userScrolling = false;
                            seekToLine(line["time"]);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow:
                                  isActive
                                      ? [
                                        BoxShadow(
                                          color: Colors.greenAccent.withOpacity(
                                            0.4,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ]
                                      : [],
                              border: Border.all(
                                color:
                                    isActive
                                        ? Colors.lightGreen
                                        : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    line["line"],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: isActive ? 20 : 16,
                                      color:
                                          isActive
                                              ? Colors.black
                                              : Colors.white70,
                                      fontWeight:
                                          isActive
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (lockedLineIndex == index) {
                                        lockedLineIndex = null; // unlock
                                      } else {
                                        lockedLineIndex =
                                            index; // lock this line
                                        seekToLine(
                                          line["time"],
                                        ); // go to it immediately
                                      }
                                    });
                                  },
                                  child: Icon(
                                    lockedLineIndex == index
                                        ? Icons.lock_rounded
                                        : Icons.lock_open_rounded,
                                    color:
                                        lockedLineIndex == index
                                            ? Colors.orangeAccent
                                            : Colors.white54,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),

                            // child:
                            // Text(
                            //   line["line"],
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //     fontSize: isActive ? 20 : 16,
                            //     color: isActive ? Colors.black : Colors.white70,
                            //     fontWeight:
                            //         isActive
                            //             ? FontWeight.bold
                            //             : FontWeight.normal,
                            //     height: 1.4,
                            //   ),
                            // ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

            const SizedBox(height: 8),

            // Fancy Slider
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = player.duration ?? Duration.zero;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.orangeAccent,
                      inactiveTrackColor: Colors.white30,
                      thumbColor: Colors.orange,
                      overlayColor: Colors.green.withAlpha(40),
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: duration.inMilliseconds.toDouble(),
                      value:
                          position.inMilliseconds
                              .clamp(0, duration.inMilliseconds)
                              .toDouble(),
                      onChanged: (value) {
                        player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // Play / Pause Button
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white.withOpacity(0.9),
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 36,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  isPlaying ? player.pause() : player.play();
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
