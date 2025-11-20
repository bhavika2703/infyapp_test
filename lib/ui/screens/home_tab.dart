import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infyapp_test/ui/screens/video_player_screen.dart';
import '../../blocs/video/video.bloc.dart';
import '../../blocs/video/video_state.dart';
import '../../blocs/video/video_event.dart';
import '../../domain/model/video_model.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    try {
      context.read<VideoBloc>().add( LoadVideos());
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) return const Center(child: CircularProgressIndicator());
        if (state is VideoError) return Center(child: Text('Error: ${state.message}'));
        if (state is VideoLoaded) {
          final videos = state.videos;
          if (videos.isEmpty) return const Center(child: Text('No videos yet'));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: videos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _VideoTile(video: videos[i]),
          );
        }
        return const Center(child: Text('Loading videos...'));
      },
    );
  }
}

class _VideoTile extends StatelessWidget {
  final VideoModel video;
  const _VideoTile({required this.video});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: video.thumbnailUrl.isNotEmpty
            ? Image.network(video.thumbnailUrl, width: 100, fit: BoxFit.cover)
            : Container(width: 100, color: Colors.grey[200]),
        title: Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(video.description.isNotEmpty ? video.description : '', maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => VimeoPlayerSheet(
              embedUrl: video.videoUrl,
              title: video.title,
              description: video.description,
            ),
          );
        },
      ),
    );
  }
}
