import 'package:flutter/material.dart';

import '../models/livro.dart';
import '../screens/edicao_livro_screen.dart';
import '../screens/top5_screen.dart';
import '../services/livro_service.dart';
import '../widgets/livro_card.dart';

class ListaLivrosScreen extends StatefulWidget {
  const ListaLivrosScreen({super.key});

  @override
  State<ListaLivrosScreen> createState() => _ListaLivrosScreenState();
}

class _ListaLivrosScreenState extends State<ListaLivrosScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pesquisaController = TextEditingController();
  late final TabController _tabController;
  List<Livro> _livros = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _carregarLivros();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarLivros() async {
    final livros = await LivroService.carregar();
    if (!mounted) {
      return;
    }
    setState(() => _livros = LivroService.ordenarPorTitulo(livros));
  }

  List<Livro> get _livrosFiltrados {
    final termo = _pesquisaController.text.trim().toLowerCase();
    final statusAtual = _tabController.index == 0 ? StatusLivro.lido : StatusLivro.desejado;

    return _livros
        .where((livro) => livro.status == statusAtual)
        .where((livro) {
          if (termo.isEmpty) {
            return true;
          }
          return livro.titulo.toLowerCase().contains(termo) ||
              livro.autor.toLowerCase().contains(termo);
        })
        .toList();
  }

  Future<void> _abrirFormulario({Livro? livro}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EdicaoLivroScreen(livro: livro),
      ),
    );

    if (resultado is Livro) {
      final itens = List<Livro>.from(_livros);
      final indice = itens.indexWhere((item) => item.id == resultado.id);

      if (indice >= 0) {
        itens[indice] = resultado;
      } else {
        itens.add(resultado);
      }

      itens.sort((a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));
      setState(() => _livros = itens);
      await LivroService.salvar(_livros);
    }
  }

  Future<void> _excluirLivro(Livro livro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir livro?'),
        content: Text('Deseja remover “${livro.titulo}” da lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() => _livros.removeWhere((item) => item.id == livro.id));
      await LivroService.salvar(_livros);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus livros'),
        actions: [
          IconButton(
            onPressed: () {
              if (_livros.where((livro) => livro.status == StatusLivro.lido).isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Top5Screen(livros: _livros),
                  ),
                );
              }
            },
            tooltip: 'Top 5',
            icon: const Icon(Icons.emoji_events_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _pesquisaController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar por título ou autor',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            onTap: (_) => setState(() {}),
            tabs: const [
              Tab(text: 'Lidos'),
              Tab(text: 'Desejados'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLista(StatusLivro.lido),
                _buildLista(StatusLivro.desejado),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        tooltip: 'Adicionar livro',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLista(StatusLivro status) {
    final livros = _livrosFiltrados;

    if (livros.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            status == StatusLivro.lido
                ? 'Nenhum livro lido ainda.'
                : 'Nenhum livro desejado por enquanto.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: livros.length,
      itemBuilder: (context, index) {
        final livro = livros[index];
        return LivroCard(
          livro: livro,
          onEditar: () => _abrirFormulario(livro: livro),
          onExcluir: () => _excluirLivro(livro),
        );
      },
    );
  }
}
