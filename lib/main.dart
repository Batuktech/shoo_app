import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import '../../../screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final provider = Global_provider();
  await provider.loadLanguage();
  
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return MaterialApp(
          locale: provider.locale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('mn', ''),
          ],
          theme: ThemeData(
            useMaterial3: false,
          ),
          home: HomePage(),
        );
      },
    );
  }
}