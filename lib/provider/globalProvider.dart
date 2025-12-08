import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global_provider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> cartItems = [];
  List<ProductModel> favoriteItems = [];
  List<UserModel> users = [];
  UserModel? currentUser;
  int currentIdx = 0;
  Locale _locale = const Locale('en');
  bool _isProductsLoaded = false;

  Locale get locale => _locale;

  void setProducts(List<ProductModel> data) {
    products = data;
    _isProductsLoaded = true;
    notifyListeners();
  }

  bool get isProductsLoaded => _isProductsLoaded;

  void setUsers(List<UserModel> data) {
    users = data;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      // Call API to get token
      final token = await ApiService.login(username, password);
      
      if (token != null) {
        // Find user from local data
        currentUser = users.firstWhere(
          (user) => user.username == username && user.password == password,
        );
        
        // Load user's cart from API
        if (currentUser?.id != null) {
          await loadUserCart(currentUser!.id!);
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> loadUserCart(int userId) async {
    try {
      final cartData = await ApiService.getUserCart(userId);
      if (cartData != null && cartData.isNotEmpty) {
        // Clear current cart
        cartItems.clear();
        
        // Load cart items
        final cart = cartData[0];
        final cartProducts = cart['products'] as List;
        
        for (var item in cartProducts) {
          final productId = item['productId'];
          final quantity = item['quantity'];
          
          // Find product in local products list
          final product = products.firstWhere(
            (p) => p.id == productId,
            orElse: () => products[0],
          );
          
          // Add to cart with quantity
          product.count = quantity;
          cartItems.add(product);
        }
        
        notifyListeners();
      }
    } catch (e) {
      print('Load cart error: $e');
    }
  }

  void logout() {
    currentUser = null;
    cartItems.clear();
    favoriteItems.clear();
    ApiService.clearToken();
    notifyListeners();
  }

  bool get isLoggedIn => currentUser != null;

  Future<void> addCartItems(ProductModel item) async {
    final index = cartItems.indexWhere((i) => i.id == item.id);
    
    if (index != -1) {
      cartItems.removeAt(index);
      if (currentUser?.id != null) {
        // Call API to remove from cart
        await ApiService.removeFromCart(item.id!);
      }
    } else {
      cartItems.add(item);
      if (currentUser?.id != null) {
        // Call API to add to cart
        await ApiService.addToCart(currentUser!.id!, item.id!, item.count);
      }
    }
    notifyListeners();
  }

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

  bool isInCart(ProductModel item) {
    return cartItems.any((i) => i.id == item.id);
  }

  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  void increaseQuantity(ProductModel item) {
    final index = cartItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      cartItems[index].count++;
      notifyListeners();
    }
  }

  void decreaseQuantity(ProductModel item) {
    final index = cartItems.indexWhere((i) => i.id == item.id);
    if (index != -1 && cartItems[index].count > 1) {
      cartItems[index].count--;
      notifyListeners();
    }
  }

  Future<void> removeFromCart(ProductModel item) async {
    cartItems.removeWhere((i) => i.id == item.id);
    if (currentUser?.id != null) {
      await ApiService.removeFromCart(item.id!);
    }
    notifyListeners();
  }

  // Language settings
  Future<void> changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    notifyListeners();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }
}