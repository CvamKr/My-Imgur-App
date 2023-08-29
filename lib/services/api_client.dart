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

  Future<Response> uploadImage2(String token, String imagePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath, filename: 'image.png'),
    });

    final response = await _dio.post(
      'upload',
      data: formData,
      options: Options(headers: {'Authorization': 'Client-ID $clientId'}),
    );

    return response;
  }

  Future<void> uploadMedia2(String mediaPath) async {
    final formData = FormData.fromMap({
      'image':
          await MultipartFile.fromFile(mediaPath, filename: 'image_nature.png'),
    });
    debugPrint("image upload started..");
    try {
      final response = await _dio.post(
        'https://api.imgur.com/3/upload',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $kAccessToken'},
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Image uploaded successfully!');
        debugPrint('Image link: ${response.data['data']['link']}');
      } else {
        debugPrint('Image upload failed');
      }
    } catch (error) {
      debugPrint('Error uploading image: $error');
    }
  }

  Future<List<ImgurMediaModel>> fetchImages(int page) async {
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

  Future<void> uploadMedia(
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
    } catch (error) {
      debugPrint('Error uploading media: $error');
    }
  }
}
