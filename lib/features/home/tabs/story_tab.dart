// lib/features/home/tabs/story_tab.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/story.dart';
import '../../../services/story_service.dart';
import '../../story_detail/story_detail_screen.dart';
import '../../../providers/language_provider.dart';

class StoryTab extends StatefulWidget {
  const StoryTab({super.key});

  @override
  State<StoryTab> createState() => _StoryTabState();
}

class _StoryTabState extends State<StoryTab> {
  late Future<List<Story>> _storiesFuture;
  List<Story> _allStories = [];
  List<Story> _filteredStories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _storiesFuture = _loadStories();
    _searchController.addListener(_filterStories);
  }

  Future<List<Story>> _loadStories() async {
    final stories = await StoryService.fetchStories();
    _allStories = stories;
    _filteredStories = stories;
    return stories;
  }

  void _filterStories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStories = _allStories
          .where((s) => s.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().languageCode;
    final localized = {
      'vi': {
        'title': 'Câu chuyện',
        'searchHint': 'Tìm kiếm câu chuyện...',
        'noResult': 'Không tìm thấy câu chuyện nào.',
      },
      'en': {
        'title': 'Stories',
        'searchHint': 'Search stories...',
        'noResult': 'No stories found.',
      },
    };
    final texts = localized[lang]!;

    return SafeArea(
      child: FutureBuilder<List<Story>>(
        future: _storiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  texts['title']!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'InriaSans',
                  ),
                ),
              ),

              // Thanh tìm kiếm
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: texts['searchHint'],
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Danh sách câu chuyện
              Expanded(
                child: _filteredStories.isEmpty
                    ? Center(child: Text(texts['noResult']!))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredStories.length,
                        itemBuilder: (context, index) {
                          final story = _filteredStories[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StoryDetailScreen(
                                      storyId: story.storyId),
                                ),
                              );
                            },
                            child: Container(
                              height: 200,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  // Ảnh nền
                                  Positioned.fill(
                                    child: Image.network(
                                      story.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  // Gradient
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.6),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Tiêu đề
                                  Positioned(
                                    left: 16,
                                    bottom: 16,
                                    right: 60,
                                    child: Text(
                                      story.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 2,
                                            color: Colors.black54,
                                            offset: Offset(0.5, 0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Nút play
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.85),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.play_arrow,
                                            color: Colors.black),
                                        onPressed: () {
                                          // TODO: Play audio
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
