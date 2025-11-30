import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/globalProvider.dart';

class Product_detail extends StatelessWidget {
  final ProductModel product;
  const Product_detail(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Дэлгэрэнгүй'),
            actions: [
              IconButton(
                icon: Icon(
                  provider.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
                  color: provider.isFavorite(product) ? Colors.red : null,
                ),
                onPressed: () {
                  if (!provider.isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Нэвтэрнэ үү')),
                    );
                  } else {
                    provider.toggleFavorite(product);
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(product.image!, height: 250),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text('\${product.price}', style: const TextStyle(fontSize: 24, color: Colors.green)),
                      const SizedBox(height: 10),
                      Text(product.description!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (!provider.isLoggedIn) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Нэвтэрнэ үү')),
                );
              } else {
                provider.addCartItems(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(provider.isInCart(product) ? 'Сагсанд нэмэгдлээ' : 'Хасагдлаа')),
                );
              }
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Сагсанд'),
          ),
        );
      },
    );
  }
}