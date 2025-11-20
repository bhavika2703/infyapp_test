import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infyapp_test/ui/screens/video_player_screen.dart';

import '../../blocs/video/video.bloc.dart';
import '../../blocs/video/video_state.dart';
import '../../domain/model/video_model.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is VideoError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is VideoLoaded) {
          final videos = state.videos;
          if (videos.isEmpty) {
            return const Center(child: Text('No videos found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            itemCount: videos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _VideoListTile(video: videos[index]),
          );
        }
        return const Center(child: Text('Loading videos...'));
      },
    );
  }
}


class _VideoListTile extends StatelessWidget {
  final VideoModel video;
  const _VideoListTile({required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => VimeoPlayerSheet(embedUrl: video.videoUrl, title: video.title, description: video.description),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                width: 140,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (c, s) => Container(width: 140, height: 90, color: Colors.grey[200]),
                errorWidget: (c, s, e) => Container(width: 140, height: 90, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(video.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}