import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_imgur_app/models/imgur_image_model.dart';

Widget mediaTemplate(BuildContext context, ImgurMediaModel imgurImage) {
  return Column(
    children: [
      CachedNetworkImage(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        imageUrl: imgurImage.link,
        placeholder: (context, url) => Center(child: Text("...loading")),
        errorWidget: (context, url, error) =>
            Icon(Icons.error), // Widget to display if an error occurs
      ),
      Container(
        height: 400,
        width: 200,
        color: Colors.grey,
      )
    ],
  );
}
