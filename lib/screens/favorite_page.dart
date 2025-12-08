import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/screens/product_detail.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        // Check if logged in
        if (!provider.isLoggedIn) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Favorites', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text('Please login first', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.changeCurrentIdx(3),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text('LOGIN'),
                  ),
                ],
              ),
            ),
          );
        }

        // Check if favorites is empty
        if (provider.favoriteItems.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('Favorites', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text('No favorites yet', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Favorites', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.favoriteItems.length,
            itemBuilder: (context, index) {
              final item = provider.favoriteItems[index];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Product_detail(item))),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(item.image!, fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title!, maxLines: 2, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(item.category ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (item.rating != null)
                                  Row(
                                    children: [
                                      ...List.generate(5, (i) => Icon(
                                        i < (item.rating!.rate ?? 0).round() ? Icons.star : Icons.star_border,
                                        size: 14,
                                        color: Colors.amber,
                                      )),
                                      const SizedBox(width: 4),
                                      Text('(${item.rating!.count ?? 0})', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                    ],
                                  ),
                                Text('\$${item.price?.toStringAsFixed(2) ?? '0.00'}', 
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => provider.toggleFavorite(item),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}