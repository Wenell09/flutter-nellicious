import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/models/favorite_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/detail_page.dart';

class FavoritePage extends StatefulWidget {
  final List<FavoriteModel> favorite;
  const FavoritePage({super.key, required this.favorite});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(
          "Favorite",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          (widget.favorite.isEmpty)
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Center(
                    child: Text(
                      "Daftar favorite kosong!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = widget.favorite[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(productId: data.product.productId),
                        )),
                        child: Card(
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            width: double.infinity,
                            height: 110,
                            child: Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      child: Image.network(
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                        data.product.image,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                      )),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Flexible(
                                          child: Text(
                                            data.product.name,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          data.product.category.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                (MyApp.of(context).isDarkMode)
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "Rp.${data.product.price}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.favorite.length,
                )
        ],
      ),
    );
  }
}
