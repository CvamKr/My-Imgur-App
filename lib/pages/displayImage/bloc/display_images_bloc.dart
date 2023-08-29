import 'package:flutter/material.dart';
import 'package:my_imgur_app/services/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:my_imgur_app/services/constants.dart';

import 'display_image_state.dart';

class DisplayImagesBloc extends Cubit<DisplayImagesState> {
  final ApiClientImgur imgurApiClient = ApiClientImgur();
  //pagination vars
  int currentPage = 0; // for pagination

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

  // Future<void> fetchData() async {
  //   if (state.status == DisplayImagesStatus.loading) return;

  //   emit(state.copyWith(status: DisplayImagesStatus.loading));

  //   // Simulate an API call or data fetching process
  //   await Future.delayed(Duration(seconds: 2));

  //   // Generate new items for the current page
  //   List<String> newItems = List.generate(
  //     itemsPerPage,
  //     (index) => 'Item ${(currentPage - 1) * itemsPerPage + index + 1}',
  //   );

  //   emit(state.copyWith(
  //     items: [...state.items, ...newItems],
  //     status: DisplayImagesStatus.loaded,
  //   ));

  //   currentPage++;
  // }

  void loadImages() async {
    if (state.status == DisplayImagesStatus.loading || !state.hasMore) return;

    emit(state.copyWith(status: DisplayImagesStatus.loading));

    try {
      final newImages = await imgurApiClient.fetchImages(currentPage);
      
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
