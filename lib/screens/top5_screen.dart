import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import '../models/livro.dart';
import '../services/compartilhamento_imagem.dart'
    if (dart.library.html) '../services/compartilhamento_imagem_web.dart'
    as compartilhamento;
import '../widgets/ranking_card.dart';

class Top5Screen extends StatefulWidget {
  final List<Livro> livros;

  const Top5Screen({
    super.key,
    required this.livros,
  });

  @override
  State<Top5Screen> createState() => _Top5ScreenState();
}

class _Top5ScreenState extends State<Top5Screen> {
  final GlobalKey _repaintKey = GlobalKey();

  List<Livro> get _top5 {
    final lidos = widget.livros
        .where((livro) => livro.status == StatusLivro.lido)
        .toList()
      ..sort((a, b) => b.nota.compareTo(a.nota));

    return lidos.take(5).toList();
  }

  Future<void> _compartilhar() async {
    final renderObject = _repaintKey.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderRepaintBoundary) {
      return;
    }

    try {
      final imagem = await renderObject.toImage(pixelRatio: 3.0);
      final bytes = await imagem.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) {
        return;
      }

      final dados = bytes.buffer.asUint8List();
      final params = ShareParams(
        text: 'Meu Top 5 de livros',
        files: [
          XFile.fromData(
            dados,
            name: 'top5_livros.png',
            mimeType: 'image/png',
          ),
        ],
      );

      await SharePlus.instance.share(params);
    } catch (_) {
      if (kIsWeb) {
        final renderObject = _repaintKey.currentContext?.findRenderObject();
        if (renderObject == null || renderObject is! RenderRepaintBoundary) {
          return;
        }

        final imagem = await renderObject.toImage(pixelRatio: 3.0);
        final bytes = await imagem.toByteData(format: ui.ImageByteFormat.png);
        if (bytes == null) {
          return;
        }

        compartilhamento.baixarImagemWeb(
          bytes.buffer.asUint8List(),
          'top5_livros.png',
        );
        return;
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o compartilhamento agora.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 5'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: RepaintBoundary(
            key: _repaintKey,
            child: RankingCard(livros: _top5),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _compartilhar,
        icon: const Icon(Icons.share_outlined),
        label: const Text('Compartilhar'),
      ),
    );
  }
}
