import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/models/user_model.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }


  void _showLanguageDialog() {
    final provider = Provider.of<Global_provider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: provider.locale.languageCode,
                onChanged: (value) {
                  provider.changeLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Монгол'),
              leading: Radio<String>(
                value: 'mn',
                groupValue: provider.locale.languageCode,
                onChanged: (value) {
                  provider.changeLanguage(value!);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        final isMongolian = provider.locale.languageCode == 'mn';
        
        // Login Screen
        if (!provider.isLoggedIn) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                isMongolian ? 'Профайл' : 'Profile',
                style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_outline, size: 50, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: isMongolian ? 'Хэрэглэгчийн нэр' : 'Username',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: isMongolian ? 'Нууц үг' : 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                        setState(() => _isLoading = true);
                        
                        final success = await provider.login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isMongolian ? 'Амжилттай нэвтэрлээ!' : 'Login successful!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isMongolian ? 'Нэр эсвэл нууц үг буруу байна' : 'Invalid username or password'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        
                        setState(() => _isLoading = false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isMongolian ? 'НЭВТРЭХ' : 'LOGIN', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                            const SizedBox(width: 8),
                            Text(isMongolian ? 'Туршилтын бүртгэл' : 'Test Account', 
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700])),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isMongolian 
                            ? 'Хэрэглэгчийн нэр: mor_2314\nНууц үг: 83r5^_'
                            : 'Username: mor_2314\nPassword: 83r5^_',
                          style: TextStyle(color: Colors.blue[900], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Profile Screen
        final user = provider.currentUser!;
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              isMongolian ? 'Миний профайл' : 'My Profile',
              style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[400],
                      child: Text(
                        '${user.firstname?[0] ?? ''}${user.lastname?[0] ?? ''}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('${user.firstname ?? ''} ${user.lastname ?? ''}', 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(user.email ?? '', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(
                Icons.shopping_bag_outlined,
                isMongolian ? 'Миний захиалгууд' : 'My orders',
                () {},
              ),
              _buildMenuItem(
                Icons.location_on_outlined,
                isMongolian ? 'Хүргэлтийн хаяг' : 'Shipping addresses',
                () {},
              ),
              _buildMenuItem(
                Icons.payment_outlined,
                isMongolian ? 'Төлбөрийн хэрэгслүүд' : 'Payment methods',
                () {},
              ),
              _buildMenuItem(
                Icons.language,
                isMongolian ? 'Хэл солих' : 'Change Language',
                _showLanguageDialog,
              ),
              _buildMenuItem(
                Icons.settings_outlined,
                isMongolian ? 'Тохиргоо' : 'Settings',
                () {},
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isMongolian ? 'Амжилттай гарлаа' : 'Logged out successfully')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB3022),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isMongolian ? 'ГАРАХ' : 'LOGOUT',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}