import 'package:flutter/material.dart';

import 'screens/lista_livros_screen.dart';

void main() {
  runApp(const OnyApp());
}

class OnyApp extends StatelessWidget {
  const OnyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ony Livros',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ListaLivrosScreen(),
    );
  }
}