import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_player_provider.dart';

class AudioControlBar extends StatelessWidget {
  const AudioControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioPlayerProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔘 Thanh tiến trình
          Slider(
            value: audio.position.inMilliseconds.toDouble(),
            max: audio.duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              audio.seek(Duration(milliseconds: value.toInt()));
            },
            activeColor: Colors.white,
            inactiveColor: Colors.white30,
          ),

          const SizedBox(height: 12),

          // 🎛️ Hàng nút điều khiển
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 🔉 Điều chỉnh âm lượng (simple slider popup)
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black87,
                    builder: (_) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Âm lượng',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Slider(
                                  value: audio.volume,
                                  min: 0,
                                  max: 1,
                                  onChanged: (v) {
                                    audio.setVolume(v);
                                    setState(() {});
                                  },
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white30,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),

              // ⏪ Tua lùi 5s
              IconButton(
                icon: const Icon(Icons.replay_5, color: Colors.white),
                onPressed: () {
                  final newPos = audio.position - const Duration(seconds: 5);
                  audio.seek(newPos > Duration.zero ? newPos : Duration.zero);
                },
              ),

              // ▶️ / ⏸️ Play/Pause
              GestureDetector(
                onTap: () {
                  audio.isPlaying ? audio.pause() : audio.resume();
                },
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(
                    audio.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 36,
                  ),
                ),
              ),

              // ⏩ Tua tiến 5s
              IconButton(
                icon: const Icon(Icons.forward_5, color: Colors.white),
                onPressed: () {
                  final newPos = audio.position + const Duration(seconds: 5);
                  final max = audio.duration;
                  audio.seek(newPos < max ? newPos : max);
                },
              ),

              // ❤️ Yêu thích (placeholder)
              const Icon(Icons.favorite_border, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
