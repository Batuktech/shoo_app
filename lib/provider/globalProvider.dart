import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global_provider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> cartItems = [];
  List<ProductModel> favoriteItems = [];

  UserModel? currentUser;
  int? _currentCartId;

  Locale _locale = const Locale('en');
  int currentIdx = 0;

  bool _isProductsLoaded = false;
  bool isLoggedIn = false;

  Locale get locale => _locale;
  bool get isProductsLoaded => _isProductsLoaded;

  // -------------------------------------------------------------
  // PRODUCT LOADING
  // -------------------------------------------------------------
  void setProducts(List<ProductModel> data) {
    products = data;
    _isProductsLoaded = true;
    notifyListeners();
  }

  // get user by ID from API
Future<void> loadUser(int id) async {
  final user = await ApiService.getUser(id);
  if (user != null) {
    currentUser = user;
    notifyListeners();
  }
}



  // -------------------------------------------------------------
  // LOGIN (FAKESTORE API)
  // -------------------------------------------------------------
    Future<bool> login(String username, String password) async {
      try {
        final token = await ApiService.login(username, password);

        if (token == null) return false;

        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);

        // FakeStore always logs in as USER ID = 2
        final user = await ApiService.getUser(2);

        if (user == null) {
          return false;
        }

        currentUser = user;
        isLoggedIn = true;

        await loadUserCart(2);

        notifyListeners();
        return true;

      } catch (e) {
        print("LOGIN ERROR: $e");
        return false;
      }
    }


  


  // -------------------------------------------------------------
  // LOAD USER CART FROM API
  // -------------------------------------------------------------
  Future<void> loadUserCart(int userId) async {
    try {
      final cartData = await ApiService.getUserCart(userId);

      if (cartData == null || cartData.isEmpty) return;

      cartItems.clear();

      final cart = cartData[0];
      _currentCartId = cart["id"];
      final items = cart["products"] as List;

      for (var item in items) {
        final productId = item["productId"];
        final quantity = item["quantity"];

        try {
          final product = products.firstWhere((p) => p.id == productId);

          cartItems.add(
            ProductModel(
              id: product.id,
              title: product.title,
              price: product.price,
              description: product.description,
              category: product.category,
              image: product.image,
              rating: product.rating,
              count: quantity,
              isFavorite: product.isFavorite,
            ),
          );
        } catch (_) {
          print("Product $productId not found locally");
        }
      }

      notifyListeners();
    } catch (e) {
      print("LOAD CART ERROR: $e");
    }
  }

  // -------------------------------------------------------------
  // LOGOUT
  // -------------------------------------------------------------
  void logout() async {
    currentUser = null;
    cartItems.clear();
    favoriteItems.clear();
    _currentCartId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");

    isLoggedIn = false;

    notifyListeners();
  }

  // -------------------------------------------------------------
  // CART OPERATIONS
  // -------------------------------------------------------------
  Future<void> addCartItems(ProductModel item) async {
    final index = cartItems.indexWhere((i) => i.id == item.id);

    if (index != -1) {
      // Remove from local cart
      cartItems.removeAt(index);

      if (_currentCartId != null) {
        await ApiService.removeFromCart(_currentCartId!);
      }
    } else {
      cartItems.add(item);

      if (currentUser?.id != null) {
        final result = await ApiService.addToCart(
            currentUser!.id!, item.id!, item.count);

        if (result != null && result["id"] != null) {
          _currentCartId = result["id"];
        }
      }
    }

    notifyListeners();
  }

  bool isInCart(ProductModel item) {
    return cartItems.any((i) => i.id == item.id);
  }

  void increaseQuantity(ProductModel item) {
    final index = cartItems.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    cartItems[index].count++;

    ApiService.updateCartItem(
      currentUser!.id!,
      item.id!,
      cartItems[index].count,
    );

    notifyListeners();
  }

  void decreaseQuantity(ProductModel item) {
    final index = cartItems.indexWhere((i) => i.id == item.id);
    if (index == -1 || cartItems[index].count <= 1) return;

    cartItems[index].count--;

    ApiService.updateCartItem(
      currentUser!.id!,
      item.id!,
      cartItems[index].count,
    );

    notifyListeners();
  }

  Future<void> removeFromCart(ProductModel item) async {
    cartItems.removeWhere((i) => i.id == item.id);

    if (_currentCartId != null) {
      await ApiService.removeFromCart(_currentCartId!);
    }

    notifyListeners();
  }

  // -------------------------------------------------------------
  // FAVORITES
  // -------------------------------------------------------------
  void toggleFavorite(ProductModel item) {
    final index = favoriteItems.indexWhere((i) => i.id == item.id);

    if (index != -1) {
      favoriteItems.removeAt(index);
      item.isFavorite = false;
    } else {
      favoriteItems.add(item);
      item.isFavorite = true;
    }
    notifyListeners();
  }

  bool isFavorite(ProductModel item) {
    return favoriteItems.any((i) => i.id == item.id);
  }

  // -------------------------------------------------------------
  // UI CONTROLS
  // -------------------------------------------------------------
  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  // -------------------------------------------------------------
  // LANGUAGE SETTINGS
  // -------------------------------------------------------------
  Future<void> changeLanguage(String code) async {
    _locale = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);
    notifyListeners();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = Locale(prefs.getString('language') ?? 'en');
    notifyListeners();
  }
}
