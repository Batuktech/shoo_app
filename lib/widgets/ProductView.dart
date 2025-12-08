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
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Product_detail(data))),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        data.image!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Image error: $error');
                          return const Center(child: Icon(Icons.error, size: 40, color: Colors.red));
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            provider.isFavorite(data) ? Icons.favorite : Icons.favorite_border,
                            color: provider.isFavorite(data) ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            if (provider.isLoggedIn) {
                              provider.toggleFavorite(data);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login first')),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(data.category ?? '', 
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]), maxLines: 1),
                      const SizedBox(height: 4),
                      Text(data.title!, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.2)),
                      const SizedBox(height: 6),
                      if (data.rating != null)
                        Row(
                          children: [
                            ...List.generate(5, (i) => Icon(
                              i < (data.rating!.rate ?? 0).round() ? Icons.star : Icons.star_border,
                              size: 12, color: Colors.amber)),
                            const SizedBox(width: 4),
                            Text('(${data.rating!.count ?? 0})', 
                              style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                          ],
                        ),
                      const SizedBox(height: 6),
                     Text('\$${data.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}