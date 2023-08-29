import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'image_video_picker_state.dart';

class ImageVideoPickerBloc extends Cubit<ImageVideoPickerState> {
  ImageVideoPickerBloc() : super(ImageVideoPickerState(state: ImageVideoPickerStateEnum.initial));

  void pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      emit(state.copyWith(state: ImageVideoPickerStateEnum.imagePicked, image: pickedImage, video: null));
    }
  }

  void pickVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final videoPlayerController = VideoPlayerController.file(File(pickedVideo.path));
      await videoPlayerController.initialize();
      emit(state.copyWith(state: ImageVideoPickerStateEnum.videoPicked, image: null, video: pickedVideo, videoPlayerController: videoPlayerController));
    }
  }

  
}
