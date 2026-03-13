import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

// ───────────────────────────────────────────────
//                  MODELS
// ───────────────────────────────────────────────

class NewsArticle {
  final String title;
  final String? description;
  final String? urlToImage;
  final String url;

  NewsArticle({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No title',
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '',
    );
  }
}

// ───────────────────────────────────────────────
//                  GLOBAL STATE
// ───────────────────────────────────────────────

final AudioPlayer globalAudioPlayer = AudioPlayer();
String? currentSongTitle;
String? currentArtist;
String? currentImageUrl;
bool isGlobalPlaying = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Recommended for plugin initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.orange,
      ),
      home: const MusicHomePage(),
    );
  }
}

// ───────────────────────────────────────────────
//                  HOME PAGE
// ───────────────────────────────────────────────

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  List<NewsArticle> _newsArticles = [];
  bool _isLoadingNews = true;
  String? _newsError;

  @override
  void initState() {
    super.initState();

    // Listen to global player state changes
    globalAudioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => isGlobalPlaying = state == PlayerState.playing);
      }
    });

    _fetchMusicNews();
  }

  Future<void> _fetchMusicNews() async {
    const String apiKey = '078a69450e1f488cb3452961ad01fc6d';
    const String url = 'https://newsapi.org/v2/top-headlines?category=entertainment&language=en&pageSize=10';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Api-Key': apiKey,
          'User-Agent': 'Flutter-Music-App/1.0', // Essential for NewsAPI approval
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List articles = data['articles'] ?? [];
        final List<NewsArticle> loadedArticles =
        articles.map((json) => NewsArticle.fromJson(json)).toList();

        if (mounted) {
          setState(() {
            // Only keep articles with images for a cleaner UI
            _newsArticles = loadedArticles.where((a) => a.urlToImage != null).take(6).toList();
            _isLoadingNews = false;
          });
        }
      } else {
        setState(() {
          _newsError = "Error: ${response.statusCode}. Check API Key.";
          _isLoadingNews = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _newsError = 'Could not reach server. Check internet.';
          _isLoadingNews = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'VISUAL HARMONY',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Latest in Music"),
                SizedBox(height: 220, child: _buildNewsList()),
                const SizedBox(height: 24),
                _buildSectionTitle("Continue Listening"),
                _buildTrackTile("Neon Dreams", "Dua Lipa", "https://picsum.photos/seed/song1/400/400"),
                _buildTrackTile("After Hours", "The Weeknd", "https://picsum.photos/seed/song2/400/400"),
                _buildTrackTile("Sunny Days", "Ocean View", "https://picsum.photos/seed/song3/400/400"),
                const SizedBox(height: 140),
              ],
            ),
          ),
          if (currentSongTitle != null) _buildMiniPlayer(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNewsList() {
    if (_isLoadingNews) return const Center(child: CircularProgressIndicator(color: Colors.orange));
    if (_newsError != null) return Center(child: Text(_newsError!, style: const TextStyle(color: Colors.red)));

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _newsArticles.length,
      itemBuilder: (context, index) {
        final article = _newsArticles[index];
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(article.urlToImage!, height: 100, width: 160, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(article.title, maxLines: 3, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrackTile(String title, String artist, String imageUrl) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(title),
      subtitle: Text(artist),
      trailing: const Icon(Icons.play_circle_fill, color: Colors.orange),
      onTap: () {
        setState(() {
          currentSongTitle = title;
          currentArtist = artist;
          currentImageUrl = imageUrl;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MusicPlayerPage(title: title, artist: artist, imageUrl: imageUrl),
          ),
        );
      },
    );
  }

  Widget _buildMiniPlayer() {
    return Positioned(
      bottom: 20, left: 10, right: 10,
      child: Container(
        height: 70,
        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Image.network(currentImageUrl!),
          title: Text(currentSongTitle!),
          trailing: IconButton(
            icon: Icon(isGlobalPlaying ? Icons.pause : Icons.play_arrow, color: Colors.orange),
            onPressed: () => isGlobalPlaying ? globalAudioPlayer.pause() : globalAudioPlayer.resume(),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────
//                  PLAYER PAGE
// ───────────────────────────────────────────────

class MusicPlayerPage extends StatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;

  const MusicPlayerPage({super.key, required this.title, required this.artist, required this.imageUrl});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _playMusic();
    globalAudioPlayer.onDurationChanged.listen((d) => setState(() => duration = d));
    globalAudioPlayer.onPositionChanged.listen((p) => setState(() => position = p));
  }

  void _playMusic() async {
    // Make sure 'assets/audio/neon_dreams.mp3' exists in your project
    await globalAudioPlayer.play(AssetSource('audio/neon_dreams.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Column(
        children: [
          Image.network(widget.imageUrl, height: 300),
          const SizedBox(height: 20),
          Text(widget.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(widget.artist, style: const TextStyle(color: Colors.grey)),
          Slider(
            activeColor: Colors.orange,
            value: position.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 1.0,
            onChanged: (v) => globalAudioPlayer.seek(Duration(seconds: v.toInt())),
          ),
          IconButton(
            iconSize: 80,
            icon: Icon(isGlobalPlaying ? Icons.pause_circle : Icons.play_circle, color: Colors.orange),
            onPressed: () => isGlobalPlaying ? globalAudioPlayer.pause() : globalAudioPlayer.resume(),
          ),
        ],
      ),
    );
  }
}