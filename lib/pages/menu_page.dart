import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú de Comida'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          '¡Bienvenido al Menú de Comida!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
