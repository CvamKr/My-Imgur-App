import 'package:flutter/material.dart';
import 'package:my_imgur_app/services/api_client_imgur.dart';
import 'package:bloc/bloc.dart';
import 'package:my_imgur_app/services/constants.dart';

import 'display_image_state.dart';

class DisplayImagesBloc extends Cubit<DisplayImagesState> {
  final ApiClientImgur imgurApiClient = ApiClientImgur();
  //pagination vars
  int currentPage = 0;

  final ScrollController scrollController = ScrollController();

  DisplayImagesBloc()
      : super(const DisplayImagesState(
            status: DisplayImagesStatus.initial,
            images: [],
            error: '',
            hasMore: true)) {
    loadImages();
    scrollController.addListener(_scrollListener);
  }

  void loadImages() async {
    if (state.status == DisplayImagesStatus.loading || !state.hasMore) return;

    emit(state.copyWith(status: DisplayImagesStatus.loading));

    try {
      final newImages = await imgurApiClient.fetchMedia(currentPage);

      bool hasMore = newImages.length < kPageLimit ? false : true;

      emit(state.copyWith(
          status: DisplayImagesStatus.success,
          images: [...state.images, ...newImages],
          hasMore: hasMore));

      currentPage++;
    } catch (error) {
      emit(state.copyWith(
        status: DisplayImagesStatus.error,
        error: 'Error fetching images.',
      ));
    }
  }

  void refreshImages() {
    emit(state.copyWith(
      status: DisplayImagesStatus.initial,
      images: [],
      hasMore: true,
      error: '',
    ));
    currentPage = 0;
    loadImages();
  }

  void _scrollListener() {
    debugPrint("In _scrollListner");
    if (scrollController.position.atEdge &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      // User has reached the end, load more images
      debugPrint("end reached, loading more images   ");
      loadImages();
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
