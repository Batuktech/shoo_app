import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/screens/product_detail.dart';
import '../models/product_model.dart';

class ProductViewShop extends StatelessWidget {
  final ProductModel data;

  const ProductViewShop(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Product_detail(data))),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.43,
            child: Card(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.network(data.image!, height: 150, fit: BoxFit.contain),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              provider.isFavorite(data) ? Icons.favorite : Icons.favorite_border,
                              color: provider.isFavorite(data) ? Colors.red : Colors.grey,
                              size: 18,
                            ),
                            onPressed: () {
                              if (provider.isLoggedIn) {
                                provider.toggleFavorite(data);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.title!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('\$${data.price}', style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}