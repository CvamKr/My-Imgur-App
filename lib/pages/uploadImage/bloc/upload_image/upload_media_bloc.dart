import 'package:bloc/bloc.dart';
import 'package:my_imgur_app/services/api_client_imgur.dart';

import 'upload_media_state.dart';

class UploadMediaBloc extends Cubit<UploadMediaState> {
  final ApiClientImgur _apiClient = ApiClientImgur(); 

  UploadMediaBloc() : super(const UploadMediaState());

  Future<void> uploadImageOrVideo(String filePath, String mediaType, String discription) async {
    emit(state.copyWith(status: UploadStatus.uploading));

    try {
      final response = await _apiClient.uploadMedia(filePath, mediaType, discription);

      if (response.statusCode == 200) {
        final uploadedImageUrl = response.data['data']['link'];
        emit(state.copyWith(
          status: UploadStatus.success,
          uploadedMediaUrl: uploadedImageUrl,
        ));
      } 
    } catch (e) {
      emit(state.copyWith(
        status: UploadStatus.failure,
        errorMessage: 'An error occurred: $e',
      ));
    }
  }
}
