import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  
  // Login and get token
  static Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
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
  
  // Get user cart
  static Future<List<dynamic>?> getUserCart(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carts/user/$userId'),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Get cart error: $e');
      return null;
    }
  }
  
  // Add to cart
  static Future<bool> addToCart(int userId, int productId, int quantity) async {
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
      
      return response.statusCode == 200;
    } catch (e) {
      print('Add to cart error: $e');
      return false;
    }
  }
  
  // Remove from cart
  static Future<bool> removeFromCart(int cartId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/carts/$cartId'),
      );
      
      return response.statusCode == 200;
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
      
      if (response.statusCode == 200) {
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