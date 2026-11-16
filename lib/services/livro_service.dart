import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/livro.dart';

class LivroService {
  static const String _chave = 'livros_app_ony';

  static Future<List<Livro>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString(_chave);

    if (dados == null || dados.isEmpty) {
      return [];
    }

    final lista = jsonDecode(dados) as List<dynamic>;
    return lista
        .map((item) => Livro.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  static Future<void> salvar(List<Livro> livros) async {
    final prefs = await SharedPreferences.getInstance();
    final dados = jsonEncode(
      livros.map((livro) => livro.toJson()).toList(),
    );
    await prefs.setString(_chave, dados);
  }

  static List<Livro> ordenarPorTitulo(List<Livro> livros) {
    final copia = List<Livro>.from(livros);
    copia.sort((a, b) {
      final tituloA = a.titulo.toLowerCase();
      final tituloB = b.titulo.toLowerCase();
      return tituloA.compareTo(tituloB);
    });
    return copia;
  }
}
