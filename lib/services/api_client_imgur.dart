import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_imgur_app/models/imgur_image_model.dart';

import 'constants.dart';

class ApiClientImgur {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.imgur.com/3/',
    headers: {
      'Authorization': 'Bearer $kAccessToken',
    },
  ));

  Future<List<ImgurMediaModel>> fetchMedia(int page) async {
    try {
      final response = await _dio.get(
        'account/me/images?page=$page&perPage=$kPageLimit',
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map<ImgurMediaModel>((item) {
          return ImgurMediaModel.fromJson(item);
        }).toList();
      } else {
        throw Exception('Failed to fetch images');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to fetch images');
    }
  }

  Future<Response> uploadMedia(
      String mediaPath, String mediaType, String description) async {
    FormData formData = FormData();

    if (mediaType == "image") {
      formData = FormData.fromMap({
        'image':
            await MultipartFile.fromFile(mediaPath, filename: 'media_upload'),
        'description': description
      });
    } else {
      formData = FormData.fromMap({
        'video':
            await MultipartFile.fromFile(mediaPath, filename: 'media_upload'),
        'description': description
      });
    }
    debugPrint("Media upload started..");

    try {
      final response = await _dio.post(
        'https://api.imgur.com/3/upload',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $kAccessToken'},
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Media uploaded successfully!');
        debugPrint('Media link: ${response.data['data']['link']}');
      } else {
        debugPrint('Media upload failed');
      }
      debugPrint("response: ${response.data}");
      return response; 
    } catch (error) {
      debugPrint('Error uploading media: $error');
      rethrow; 
    }
  }
}
