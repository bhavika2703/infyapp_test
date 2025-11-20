// lib/domain/models/video_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int? duration;
  final List<String>? tags;
  final Timestamp? createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.duration,
    this.tags,
    this.createdAt,
  });

  factory VideoModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};

    int? parsedDuration;
    if (data['duration'] != null && data['duration'].toString().trim().isNotEmpty) {
      try {
        parsedDuration = int.parse(data['duration'].toString());
      } catch (_) {
      }
    }


    List<String>? tags;
    if (data['tags'] is List) {
      tags = (data['tags'] as List).whereType<String>().map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      if (tags.isEmpty) tags = null;
    }

    return VideoModel(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      videoUrl: (data['videoUrl'] ?? '').toString(),
      thumbnailUrl: (data['thumbnailUrl'] ?? data['thumbnail_url'] ?? '').toString(),
      duration: parsedDuration,
      tags: tags,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}
