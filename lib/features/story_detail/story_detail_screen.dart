import 'package:flutter/material.dart';
import '../../models/story.dart';
import '../../services/story_service.dart';
import '../../widgets/audio_control_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/audio_player_provider.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId;
  const StoryDetailScreen({super.key, required this.storyId});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late Future<Story> futureStory;

  @override
  void initState() {
    super.initState();
    futureStory = StoryService.fetchStoryDetail(widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Story>(
      future: futureStory,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết Câu chuyện')),
            body: Center(child: Text('Lỗi: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('Chi tiết Câu chuyện')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final story = snapshot.data!;
        final hasAudio = story.audioUrl != null && story.audioUrl!.isNotEmpty;

        // Nếu có audio, tự động play (chỉ gọi 1 lần)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final audio = context.read<AudioPlayerProvider>();
          if (hasAudio && audio.sourceId != story.storyId) {
            audio.playSource(
              sourceId: story.storyId,
              title: story.title,
              imageUrl: story.imageUrl,
              audioUrl: story.audioUrl!,
              sourceType: "story",
            );
          }
        });

        return Scaffold(
          appBar: AppBar(title: const Text('Chi tiết Câu chuyện')),
          bottomNavigationBar: const Padding(
            padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            child: AudioControlBar(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (story.imageUrl.isNotEmpty)
                  Image.network(
                    story.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    story.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (story.content != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      story.content!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
