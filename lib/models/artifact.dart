class Artifact {
  final String artifactId;
  final String name;
  final String imageUrl;
  final String description;
  final String? audioUrl;
  final String? videoUrl;

  Artifact({
    required this.artifactId,
    required this.name,
    required this.imageUrl,
    required this.description,
    this.audioUrl,
    this.videoUrl,
  });

  factory Artifact.fromJson(Map<String, dynamic> json) {
    return Artifact(
      artifactId: json['ArtifactId'],
      name: json['Name'],
      imageUrl: json['ImageUrl'],
      description: json['Description'],
      audioUrl: json['AudioUrl'],
      videoUrl: json['VideoUrl'],
    );
  }
}
