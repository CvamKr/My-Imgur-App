import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_imgur_app/pages/displayImage/ui/media_template.dart';
import 'package:my_imgur_app/pages/uploadImage/ui/upload_media.dart';
import '../bloc/display_images_bloc.dart';
import '../bloc/display_image_state.dart';

class DisplayImagesPage extends StatelessWidget {
  const DisplayImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DisplayImagesBloc(),
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Imgur Images'),
            ),
            body: BlocBuilder<DisplayImagesBloc, DisplayImagesState>(
              builder: (context, state) {
                final dispalyImageBloc = context.read<DisplayImagesBloc>();

                if (state.status == DisplayImagesStatus.error) {
                  return const Text('Error loading images}');
                }
                return ListView.builder(
                  controller: dispalyImageBloc.scrollController,
                  itemCount: state.images.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.images.length) {
                      return mediaTemplate(context, state.images[index]);
                    } else {
                      if (state.status == DisplayImagesStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.hasMore) {
                        return Container(); // Return an empty container when not loading
                      } else {
                        return const Center(
                          child: Text("No more items"),
                        );
                      }
                    }
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UploadMediaPage(),
                ),
              ),
            )));
  }
}
