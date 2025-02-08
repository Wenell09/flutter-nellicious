import 'package:flutter/material.dart';
import 'package:flutter_nellicious/data/models/product_model.dart';
import 'package:flutter_nellicious/main.dart';
import 'package:flutter_nellicious/pages/detail_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final List<ProductModel> product;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah card per baris
          crossAxisSpacing: 10, // Spasi horizontal antara card
          mainAxisSpacing: 10, // Spasi vertikal antara card
          childAspectRatio: 1 / 1.2), //1 lebar 1.3 tinggi
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        final data = product[index];
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(productId: data.productId),
              )),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: CircularProgressIndicator());
                          },
                          data.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              data.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFFF5BB17),
                              ),
                              Text(
                                data.ratings.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          data.category.name,
                          style: TextStyle(
                            color: (MyApp.of(context).isDarkMode)
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Rp.${data.price}",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.red,
                    size: 35,
                  )),
            ),
          ],
        );
      },
      itemCount: product.length,
    );
  }
}
