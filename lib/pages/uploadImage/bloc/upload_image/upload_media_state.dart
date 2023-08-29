import 'package:equatable/equatable.dart';

enum UploadStatus { initial, uploading, success, failure }

class UploadMediaState extends Equatable {
  final UploadStatus status;
  final String? uploadedMediaUrl; 
  final String? errorMessage;

  const UploadMediaState({
    this.status = UploadStatus.initial,
    this.uploadedMediaUrl,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, uploadedMediaUrl, errorMessage];

  UploadMediaState copyWith({
    UploadStatus? status,
    String? uploadedMediaUrl,
    String? errorMessage,
  }) {
    return UploadMediaState(
      status: status ?? this.status,
      uploadedMediaUrl: uploadedMediaUrl ?? this.uploadedMediaUrl,
      errorMessage: errorMessage,
    );
  }
}