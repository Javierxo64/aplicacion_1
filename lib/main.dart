import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoffeePlace',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.vintagePrimary,
          secondary: AppColors.vintageAccent,
          background: AppColors.vintageBackground,
        ),
        scaffoldBackgroundColor: AppColors.vintageBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.vintagePrimary,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: AppColors.vintageCream,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.brown, width: 1),
          ),
          margin: const EdgeInsets.all(8),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Colors.brown),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.vintagePrimary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}