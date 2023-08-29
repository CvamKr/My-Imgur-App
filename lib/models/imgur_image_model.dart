import 'dart:convert';

ImgurMediaModel imgurMediaModelFromJson(String str) =>
    ImgurMediaModel.fromJson(json.decode(str));

String imgurMediaModelToJson(ImgurMediaModel data) =>
    json.encode(data.toJson());

class ImgurMediaModel {
  String id;
  String description;
  String link;
  String type;

  ImgurMediaModel({
    this.id = "",
    this.description = "",
    this.link = "",
    this.type = "",
  });

  factory ImgurMediaModel.fromJson(Map<String, dynamic> json) =>
      ImgurMediaModel(
        id: json["id"] ?? "",
        description: json["description"] ?? "",
        link: json["link"] ?? "",
        type: json["type"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "link": link,
        "type": type,
      };
}
