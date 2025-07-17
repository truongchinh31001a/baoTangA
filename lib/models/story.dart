class Story {
  final String storyId;
  final String artifactId;
  final String title;
  final String imageUrl;
  final DateTime createdAt;
  final bool isGlobal;

  // Dành cho chi tiết
  final String? content;
  final String? audioUrl;

  Story({
    required this.storyId,
    required this.artifactId,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
    required this.isGlobal,
    this.content,
    this.audioUrl,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      storyId: json['StoryId'],
      artifactId: json['ArtifactId'],
      title: json['Title'],
      imageUrl: json['ImageUrl'],
      createdAt: DateTime.parse(json['CreatedAt']),
      isGlobal: json['IsGlobal'],
      content: json['Content'], // Có thể null
      audioUrl: json['AudioUrl'], // Có thể null
    );
  }
}
