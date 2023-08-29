
import 'package:equatable/equatable.dart';

import '../../../models/imgur_image_model.dart';

enum DisplayImagesStatus { initial, loading, success, error }

class DisplayImagesState extends Equatable {
  final DisplayImagesStatus status;
  final List<ImgurMediaModel> images;
  final String error;
    final bool hasMore;


  const DisplayImagesState({
    required this.status,
    required this.images,
    required this.error,
    required this.hasMore
  });

  DisplayImagesState copyWith({
    DisplayImagesStatus? status,
    List<ImgurMediaModel>? images,
    String? error,
    bool? hasMore
  }) {
    return DisplayImagesState(
      status: status ?? this.status,
      images: images ?? this.images,
      error: error ?? this.error,
      hasMore: hasMore?? this.hasMore
    );
  }

  @override
  List<Object?> get props => [status, images, error, hasMore];
}
