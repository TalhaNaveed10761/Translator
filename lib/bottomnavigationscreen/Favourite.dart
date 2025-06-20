import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_26/bottomnavigationscreen/FavouriteItem.dart';
import 'package:flutter_application_26/database/DatabaseHelper.dart';
import 'package:intl/intl.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<FavoriteItem> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final items = await DatabaseHelper.getFavorites();
    setState(() {
      favoriteItems = items.reversed.toList();
    });
  }

  void _deleteFavoriteItem(int id) async {
    await DatabaseHelper.deleteFavorite(id);
    setState(() {
      favoriteItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        centerTitle: false,
        title: const Text(
          "Favourite",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4F4F4F),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Expanded(
              child: favoriteItems.isEmpty
                  ? const Center(child: Text('No favorites added'))
                  : ListView.builder(
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        final item = favoriteItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Stack(
                            children: [
                              Container(
                                height: height * 0.15,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFFD5D5D5)),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (item.fromFlag != null)
                                            Image.network(item.fromFlag!,
                                                width: 30, height: 30),
                                          SizedBox(width: width * 0.02),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: item
                                                              .originalText));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Text copied')),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    item.originalText,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .visible),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (item.toFlag != null)
                                            Image.network(item.toFlag!,
                                                width: 30, height: 30),
                                          SizedBox(width: width * 0.02),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: item
                                                              .translatedText));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Text copied')),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 3),
                                                  child: Text(
                                                    item.translatedText,
                                                    style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _deleteFavoriteItem(item.id!),
                                  child: const Icon(
                                    Icons.close,
                                    color: Color(0xFF455A64),
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
