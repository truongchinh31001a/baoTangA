import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/artifact.dart';
import '../../providers/audio_player_provider.dart';
import '../../widgets/audio_control_bar.dart';
import '../../widgets/web_video_player.dart';

class ArtifactDetailScreen extends StatefulWidget {
  final Artifact artifact;

  const ArtifactDetailScreen({super.key, required this.artifact});

  String get artifactId => artifact.artifactId;

  @override
  State<ArtifactDetailScreen> createState() => _ArtifactDetailScreenState();
}

class _ArtifactDetailScreenState extends State<ArtifactDetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final audio = context.read<AudioPlayerProvider>();
    final hasVideo = widget.artifact.videoUrl != null &&
        widget.artifact.videoUrl!.isNotEmpty;
    final hasAudio = widget.artifact.audioUrl != null &&
        widget.artifact.audioUrl!.isNotEmpty;

    // Nếu có audio (và không phải đang xem video), tự động play
    if (!hasVideo && hasAudio && audio.sourceId != widget.artifactId) {
      audio.playSource(
        sourceId: widget.artifactId,
        sourceType: 'artifact',
        title: widget.artifact.name,
        imageUrl: widget.artifact.imageUrl,
        audioUrl: widget.artifact.audioUrl!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final artifact = widget.artifact;
    final hasVideo = artifact.videoUrl != null && artifact.videoUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết Hiện vật')),

      bottomNavigationBar: hasVideo
          ? null
          : const Padding(
              padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: AudioControlBar(),
            ),

      body: Column(
        children: [
          // Nội dung chính
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nếu có video → chỉ hiển thị video player
                  if (hasVideo)
                    SizedBox(
                      height: 240,
                      child: WebVideoPlayer(videoUrl: artifact.videoUrl!),
                    )
                  else if (artifact.imageUrl.isNotEmpty)
                    Image.network(
                      artifact.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),

                  // Tên hiện vật
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      artifact.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Mô tả
                  if (artifact.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        artifact.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
