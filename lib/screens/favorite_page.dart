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
        if (!provider.isLoggedIn) {
          return Scaffold(
            appBar: AppBar(title: const Text('Дуртай')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text('Нэвтэрнэ үү'),
                  ElevatedButton(
                    onPressed: () => provider.changeCurrentIdx(3),
                    child: const Text('Нэвтрэх'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.favoriteItems.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Дуртай')),
            body: const Center(child: Text('Дуртай бараа байхгүй')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Дуртай')),
          body: ListView.builder(
            itemCount: provider.favoriteItems.length,
            itemBuilder: (context, index) {
              final item = provider.favoriteItems[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(item.image!, width: 50),
                  title: Text(item.title!, maxLines: 2),
                  subtitle: Text('\${item.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => provider.toggleFavorite(item),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Product_detail(item)),
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