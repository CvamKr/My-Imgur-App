import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../bloc/image_video_picker/image_video_picker_bloc.dart';
import '../bloc/image_video_picker/image_video_picker_state.dart';
import '../bloc/upload_image/upload_media_bloc.dart';
import '../bloc/upload_image/upload_media_state.dart';

class UploadMediaPage extends StatelessWidget {
  UploadMediaPage({Key? key}) : super(key: key);

  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final imageVideoBloc = context.read<ImageVideoPickerBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Media to Imgur'),
      ),
      body: BlocBuilder<ImageVideoPickerBloc, ImageVideoPickerState>(
        builder: (context, state) {
          return ListView(
            children: [
              ElevatedButton(
                onPressed: () =>
                    context.read<ImageVideoPickerBloc>().pickImage(),
                child: const Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: () =>
                    context.read<ImageVideoPickerBloc>().pickVideo(),
                child: const Text('Pick Video'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Enter a description (optional)',
                  ),
                ),
              ),
              BlocListener<UploadMediaBloc, UploadMediaState>(
                listener: (context, state) {
                  if (state.status == UploadStatus.uploading) {
                    _showResultDialog('Uploading...', context, state);
                  } else if (state.status == UploadStatus.success) {
                    _showResultDialog(
                        'Upload successful! Yay!!', context, state);
                  } else if (state.status == UploadStatus.failure) {
                    _showResultDialog(
                        'Upload failed. Error: ${state.errorMessage}',
                        context,
                        state);
                  }
                },
                child: ElevatedButton(
                  onPressed: _isUploadButtonEnabled(state)
                      ? () => _uploadToImgur(context, imageVideoBloc)
                      : null,
                  child: const Text('Upload to Imgur'),
                ),
              ),
              _buildMediaWidget(state),
            ],
          );
        },
      ),
    );
  }

  bool _isUploadButtonEnabled(ImageVideoPickerState state) {
    return state.state == ImageVideoPickerStateEnum.imagePicked ||
        state.state == ImageVideoPickerStateEnum.videoPicked;
  }

  void _uploadToImgur(
      BuildContext context, ImageVideoPickerBloc imageVideoBloc) {
    final mediaType = imageVideoBloc.state.state == ImageVideoPickerStateEnum.imagePicked
        ? 'image'
        : 'video';
    final mediaPath = mediaType == 'image'
        ? imageVideoBloc.state.image!.path
        : imageVideoBloc.state.video!.path;
    context.read<UploadMediaBloc>().uploadImageOrVideo(
        mediaPath,
        mediaType,
        descriptionController.text,
    );
  }

  Widget _buildMediaWidget(ImageVideoPickerState state) {
    if (state.state == ImageVideoPickerStateEnum.imagePicked) {
      return Image.file(File(state.image!.path));
    } else if (state.state == ImageVideoPickerStateEnum.videoPicked) {
      return Chewie(
        controller: ChewieController(
          videoPlayerController: VideoPlayerController.file(File(state.video!.path)),
          autoPlay: true,
          looping: true,
        ),
      );
    }
    return Container();
  }

  void _showResultDialog(String message, BuildContext context, UploadMediaState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Status'),
          content: Text(message),
          actions: state.status == UploadStatus.uploading
              ? []
              : <Widget>[
                  TextButton(
                    onPressed: () {
                      // Close final upload result dialog
                      Navigator.of(context).pop();
                      // Close uploading progress dialog
                      Navigator.of(context).pop();
                      // Navigate back to displayMediaPage();
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
        );
      },
    );
  }
}
