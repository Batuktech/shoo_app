import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/user_model.dart';

class Global_provider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> cartItems = [];
  List<ProductModel> favoriteItems = [];
  List<UserModel> users = [];
  UserModel? currentUser;
  int currentIdx = 0;

  void setProducts(List<ProductModel> data) {
    products = data;
    notifyListeners();
  }

  void setUsers(List<UserModel> data) {
    users = data;
    notifyListeners();
  }

  bool login(String username, String password) {
    try {
      currentUser = users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  bool get isLoggedIn => currentUser != null;

  void addCartItems(ProductModel item) {
    final index = cartItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      cartItems.removeAt(index);
    } else {
      cartItems.add(item);
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

  void removeFromCart(ProductModel item) {
    cartItems.removeWhere((i) => i.id == item.id);
    notifyListeners();
  }
}