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
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              IconButton(
                icon: Icon(
                  provider.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
                  color: provider.isFavorite(product) ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  if (!provider.isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login first')),
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
                Container(
                  height: 300,
                  color: Colors.grey[100],
                  child: Center(
                    child: Image.network(product.image!, fit: BoxFit.contain),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.category ?? '', 
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text(product.title!, 
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
                      const SizedBox(height: 12),
                      if (product.rating != null)
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(
                              i < (product.rating!.rate ?? 0).round() ? Icons.star : Icons.star_border,
                              size: 20, color: Colors.amber)),
                            const SizedBox(width: 8),
                            Text('${product.rating!.rate?.toStringAsFixed(1) ?? '0.0'} (${product.rating!.count ?? 0})'),
                          ],
                        ),
                      const SizedBox(height: 20),
                      Text('\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(product.description!, 
                        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6)),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(
                        provider.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
                        color: provider.isFavorite(product) ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        if (!provider.isLoggedIn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                        } else {
                          provider.toggleFavorite(product);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!provider.isLoggedIn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                        } else {
                          provider.addCartItems(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(provider.isInCart(product) ? 'Added to cart' : 'Removed from cart'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(provider.isInCart(product) ? Icons.shopping_cart : Icons.shopping_cart_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(provider.isInCart(product) ? 'IN CART' : 'ADD TO CART',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
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