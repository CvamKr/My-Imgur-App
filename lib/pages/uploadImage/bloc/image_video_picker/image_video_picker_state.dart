import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


// States
enum ImageVideoPickerStateEnum {
  initial,
  imagePicked,
  videoPicked,
}

class ImageVideoPickerState extends Equatable {
  final ImageVideoPickerStateEnum state;
  final XFile? image;
  final XFile? video;
  final VideoPlayerController? videoPlayerController;

  ImageVideoPickerState({
    required this.state,
    this.image,
    this.video,
    this.videoPlayerController,
  });

  @override
  List<Object?> get props => [state, image, video, videoPlayerController];

  ImageVideoPickerState copyWith({
    ImageVideoPickerStateEnum? state,
    XFile? image,
    XFile? video,
    VideoPlayerController? videoPlayerController,
  }) {
    return ImageVideoPickerState(
      state: state ?? this.state,
      image: image ?? this.image,
      video: video ?? this.video,
      videoPlayerController: videoPlayerController ?? this.videoPlayerController,
    );
  }
}

