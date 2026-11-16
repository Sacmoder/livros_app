import 'package:flutter/material.dart';

import '../models/livro.dart';

class LivroCard extends StatelessWidget {
  final Livro livro;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  const LivroCard({
    super.key,
    required this.livro,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final nota = livro.status == StatusLivro.lido ? livro.nota : 0;
    final data = livro.dataLeitura != null
        ? '${livro.dataLeitura!.day.toString().padLeft(2, '0')}/${livro.dataLeitura!.month.toString().padLeft(2, '0')}/${livro.dataLeitura!.year}'
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        livro.titulo,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        livro.autor,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Editar',
                ),
                IconButton(
                  onPressed: onExcluir,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Excluir',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                Chip(
                  label: Text(
                    livro.status == StatusLivro.lido ? 'Lido' : 'Desejado',
                  ),
                  avatar: Icon(
                    livro.status == StatusLivro.lido
                        ? Icons.check_circle
                        : Icons.bookmark_border,
                    size: 16,
                  ),
                ),
                if (livro.status == StatusLivro.lido)
                  Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < nota ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (data != null || livro.observacao.isNotEmpty) ...[
              const SizedBox(height: 8),
              if (data != null)
                Text(
                  'Leitura: $data',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (livro.observacao.isNotEmpty)
                Text(
                  'Obs.: ${livro.observacao}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
