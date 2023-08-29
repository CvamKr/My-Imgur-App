import 'package:flutter/material.dart';

import 'pages/displayImage/ui/display_image.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Center(
          child: DisplayImagesPage() 
          
          // UploadImagePage(),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyListView(),
    );
  }
}

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<String> items = [];
  bool isLoading = false;
  int currentPage = 1;
  final int itemsPerPage = 15;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController.addListener(() {_scrollListener();});

  }

  void _scrollListener() {
    debugPrint("In _scrollListner");
    if (
      scrollController.position.atEdge &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      // User has reached the end, load more images
      debugPrint("end reached, loading more images   ");
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Simulate an API call or data fetching process
    await Future.delayed(Duration(seconds: 2));

    // Generate new items for the current page
    List<String> newItems = List.generate(
      itemsPerPage,
      (index) => 'Item ${(currentPage - 1) * itemsPerPage + index + 1}',
    );

    setState(() {
      items.addAll(newItems);
      isLoading = false;
      currentPage++;
    });
  }

  Widget buildListView() {
    return ListView.builder(
      controller: scrollController,
      itemCount: items.length + 1, // +1 for the loading indicator
      itemBuilder: (context, index) {
        if (index < items.length) {
          return ListTile(
            title: Text(items[index]),
          );
        } else {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(); // Return an empty container when not loading
          }
        }
      },
      // Detect when the user scrolls to the end of the list
      // onEndReached: fetchData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paginated ListView'),
      ),
      body: buildListView(),
    );
  }
}

