import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';

class BagsPage extends StatelessWidget {
  const BagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        if (!provider.isLoggedIn) {
          return Scaffold(
            appBar: AppBar(title: const Text('Сагс')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
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

        if (provider.cartItems.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Сагс')),
            body: const Center(child: Text('Сагс хоосон')),
          );
        }

        double total = provider.cartItems.fold(0, (sum, item) => sum + (item.price! * item.count));
        
        return Scaffold(
          appBar: AppBar(title: const Text('Сагс')),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(item.image!, width: 50),
                        title: Text(item.title!, maxLines: 2),
                        subtitle: Text('\${item.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => provider.decreaseQuantity(item),
                            ),
                            Text('${item.count}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => provider.increaseQuantity(item),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Нийт: \${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        provider.cartItems.clear();
                        provider.notifyListeners();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Амжилттай!')),
                        );
                      },
                      child: const Text('ХУДАЛДАН АВАХ'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}