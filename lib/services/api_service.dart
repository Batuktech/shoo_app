import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  
  // Login and get token
static Future<String?> login(String username, String password) async {
  try {

    print("➡️ SENDING:");
    print("username = $username");
    print("password = $password");

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    print("⬅️ RESPONSE:");
    print("status: ${response.statusCode}");
    print("body: ${response.body}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        
        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        return token;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
  
static Future<UserModel?> getUser(int id) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  } catch (e) {
    print("GET USER ERROR: $e");
    return null;
  }
}

  // Get user cart
  static Future<List<dynamic>?> getUserCart(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carts/user/$userId'),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Get cart error: $e');
      return null;
    }
  }
  
  // Add to cart - returns the created cart
  static Future<Map<String, dynamic>?> addToCart(int userId, int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/carts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'date': DateTime.now().toIso8601String(),
          'products': [
            {'productId': productId, 'quantity': quantity}
          ]
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Add to cart error: $e');
      return null;
    }
  }
  
  // Update cart quantity
  static Future<bool> updateCartItem(int userId, int productId, int quantity) async {
    try {
      // In a real app, you'd get the cart ID first
      // For this fake API, we'll just call add to cart
      final response = await http.put(
        Uri.parse('$baseUrl/carts/1'), // Using cart ID 1 as placeholder
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'date': DateTime.now().toIso8601String(),
          'products': [
            {'productId': productId, 'quantity': quantity}
          ]
        }),
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Update cart error: $e');
      return false;
    }
  }
  
  // Remove from cart - Note: This requires a cart ID, not product ID
  static Future<bool> removeFromCart(int cartId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/carts/$cartId'),
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Remove from cart error: $e');
      return false;
    }
  }
  
  // Get products (for reference)
  static Future<List<dynamic>?> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Get products error: $e');
      return null;
    }
  }
  
  // Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  // Clear token (logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}