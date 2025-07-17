import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/artifact_detail/artifact_detail_screen.dart';
import '../features/story_detail/story_detail_screen.dart';
import '../providers/audio_player_provider.dart';
import '../services/artifact_service.dart';

class NowPlayingBanner extends StatelessWidget {
  const NowPlayingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioPlayerProvider>();

    if (audio.sourceId == null) return const SizedBox.shrink();

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Ảnh
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              audio.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 48,
                height: 48,
                color: Colors.grey[700],
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Tiêu đề (tap để quay lại màn chi tiết)
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final type = audio.sourceType;
                final id = audio.sourceId;

                if (type == "story") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryDetailScreen(storyId: id!),
                    ),
                  );
                } else if (type == "artifact") {
                  final lang = Localizations.localeOf(context).languageCode;

                  try {
                    final artifact = await ArtifactService.fetchArtifact(
                      id!,
                      lang,
                    );

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArtifactDetailScreen(
                            artifact: artifact,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Không tìm thấy hiện vật'),
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(
                audio.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),

          // Nút play/pause
          IconButton(
            icon: Icon(
              audio.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              audio.isPlaying ? audio.pause() : audio.resume();
            },
          ),

          // Nút đóng
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              audio.stop(); // sẽ reset toàn bộ player
            },
          ),
        ],
      ),
    );
  }
}
