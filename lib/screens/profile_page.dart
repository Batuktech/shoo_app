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

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    String res = await DefaultAssetBundle.of(context).loadString("assets/users.json");
    List<dynamic> jsonData = jsonDecode(res);
    Provider.of<Global_provider>(context, listen: false).setUsers(
      jsonData.map((e) => UserModel.fromJson(e)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        if (!provider.isLoggedIn) {
          return Scaffold(
            appBar: AppBar(title: const Text('Профайл')),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Нэр',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Нууц үг',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (provider.login(_usernameController.text, _passwordController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Амжилттай нэвтэрлээ')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Буруу нэр эсвэл нууц үг')),
                        );
                      }
                    },
                    child: const Text('НЭВТРЭХ'),
                  ),
                  const SizedBox(height: 20),
                  const Text('Туршилт: 12 / 123'),
                ],
              ),
            ),
          );
        }

        final user = provider.currentUser!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Профайл'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => provider.logout(),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.person, size: 80),
                const SizedBox(height: 20),
                Text('${user.firstname} ${user.lastname}', style: const TextStyle(fontSize: 24)),
                Text('@${user.username}'),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(user.email ?? ''),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(user.phone ?? ''),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}