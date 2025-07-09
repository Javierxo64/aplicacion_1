import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../constants/colors.dart';
import 'menu_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _login(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Mostrar indicador de carga
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Iniciando sesión...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Ejecutar el login
      await authService.signInWithGoogle();

      // Navegar al menú principal si el login es exitoso
      if (authService.token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
      }
    } catch (e) {
      // Mostrar error si falla
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.vintageBackground,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo CoffeePlace
              Image.asset(
                'assets/images/logo.jpg',
                height: 300,
              ),
              const SizedBox(height: 18),

              const SizedBox(height: 40),
              // Botón de login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vintagePrimary,
                  foregroundColor: AppColors.vintageCream,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _login(context),
                child: const Text('Acceder con cuenta UTEM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}