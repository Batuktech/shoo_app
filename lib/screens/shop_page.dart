import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/globalProvider.dart';
import '../widgets/ProductView.dart';
import 'dart:convert';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  Future<List<ProductModel>> _getData() async {
    try {
      String res = await DefaultAssetBundle.of(context).loadString("assets/products.json");
      List<dynamic> jsonData = jsonDecode(res);
      List<ProductModel> data = ProductModel.fromList(jsonData);
      
      // Set products in provider
      if (mounted) {
        Provider.of<Global_provider>(context, listen: false).setProducts(data);
      }
      
      return data;
    } catch (e) {
      print('Error loading products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дэлгүүр'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Алдаа гарлаа: ${snapshot.error}'),
            );
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Бараа олдсонгүй'),
            );
          }
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Бараанууд",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(223, 37, 37, 37),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: List.generate(
                      snapshot.data!.length,
                      (index) => ProductViewShop(snapshot.data![index]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}