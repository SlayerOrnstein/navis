import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/services/videos.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../injection_container.dart';

// ignore: lines_longer_than_80_chars
// TODO(Ornstein): Find more how-to guides for events might be slightly annoying for older events
// ignore: lines_longer_than_80_chars
// TODO(Ornstein): find a way to adapt a stream to network speed, might come later with Youtube_explode
class EventVideoPlayer extends StatefulWidget {
  const EventVideoPlayer({
    Key? key,
    required this.id,
    required this.profileThumbnail,
  }) : super(key: key);

  final String id;
  final String profileThumbnail;

  @override
  _YoutubePlayerState createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<EventVideoPlayer> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  late VideoInformation videoInformation;

  @override
  void initState() {
    super.initState();
    _setupPlayer();
  }

  Future<void> _setupPlayer() async {
    if (mounted) {
      videoInformation =
          await sl<VideoService>().getVideoInformation(widget.id);

      _videoPlayerController = VideoPlayerController.network(
          videoInformation.muxedStreamInfo.first.url.toString());

      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            aspectRatio: videoInformation.aspectRatio,
            autoInitialize: true,
            showControlsOnInitialize: false,
            allowedScreenSleep: false,
            materialProgressColors: ChewieProgressColors(
              playedColor: Theme.of(context).accentColor,
              bufferedColor: Colors.white,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: (MediaQuery.of(context).size.height / 100) * 48,
          child: _chewieController == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: videoInformation.aspectRatio,
                      child: Chewie(controller: _chewieController!),
                    ),
                    PlayerInformation(
                      title: videoInformation.title,
                      description: videoInformation.description,
                      author: videoInformation.author,
                      profileThumbnail: widget.profileThumbnail,
                      link: videoInformation.url,
                    )
                  ],
                ),
        ));
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

class PlayerInformation extends StatelessWidget {
  const PlayerInformation({
    Key? key,
    required this.title,
    required this.description,
    required this.author,
    this.profileThumbnail,
    required this.link,
  }) : super(key: key);

  final String title, description, author, link;
  final String? profileThumbnail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (profileThumbnail != null)
                CircleAvatar(
                  radius: 10.0,
                  backgroundImage:
                      CachedNetworkImageProvider(profileThumbnail!),
                ),
              const SizedBox(width: 8.0),
              Text(
                author,
                style: Theme.of(context).textTheme.caption,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () => link.launchLink(context),
              )
            ],
          ),
        ],
      ),
    );
  }
}
