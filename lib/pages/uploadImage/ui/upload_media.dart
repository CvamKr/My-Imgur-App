import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../bloc/image_video_picker/image_video_picker_bloc.dart';
import '../bloc/image_video_picker/image_video_picker_state.dart';

class UploadMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ImageVideoPickerBloc(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Imgur Images'),
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
                    ElevatedButton(
                      onPressed: state.state == ImageVideoPickerStateEnum.imagePicked
                          ? () =>
                          null
                              // context.read<ImageVideoPickerBloc>().uploadMedia()
                          : null,
                      child: const Text('Upload to Imgur'),
                    ),
                    if (state.state == ImageVideoPickerStateEnum.imagePicked)
                      Image.file(File(state.image!.path))
                    else if (state.state ==
                        ImageVideoPickerStateEnum.videoPicked)
                      AspectRatio(
                        aspectRatio:
                            state.videoPlayerController!.value.aspectRatio,
                        child: VideoPlayer(state.videoPlayerController!),
                      ),
                  ],
                );
              },
            )));
  }
}
