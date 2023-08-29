import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../../models/imgur_image_model.dart';

Widget mediaTemplate(BuildContext context, ImgurMediaModel imgurMedia) {
  Widget mediaWidget;

  if (imgurMedia.type.contains('image')) {
    mediaWidget = CachedNetworkImage(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      imageUrl: imgurMedia.link,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else if (imgurMedia.type.contains('video')) {
    final VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(imgurMedia.link));
    final ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    mediaWidget = Chewie(controller: chewieController);
  } else {
    mediaWidget = const Text('Unsupported Media');
  }

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: mediaWidget,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Text(
              imgurMedia.description,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
