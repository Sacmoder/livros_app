import 'package:flutter/material.dart';

import '../models/livro.dart';

class EdicaoLivroScreen extends StatefulWidget {
  final Livro? livro;

  const EdicaoLivroScreen({
    super.key,
    this.livro,
  });

  @override
  State<EdicaoLivroScreen> createState() => _EdicaoLivroScreenState();
}

class _EdicaoLivroScreenState extends State<EdicaoLivroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _observacaoController = TextEditingController();

  DateTime? _dataLeitura;
  StatusLivro _status = StatusLivro.lido;
  int _nota = 3;

  @override
  void initState() {
    super.initState();

    final livro = widget.livro;
    if (livro != null) {
      _tituloController.text = livro.titulo;
      _autorController.text = livro.autor;
      _observacaoController.text = livro.observacao;
      _status = livro.status;
      _nota = livro.nota;
      _dataLeitura = livro.dataLeitura;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataLeitura ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() => _dataLeitura = data);
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final livro = Livro(
        id: widget.livro?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        titulo: _tituloController.text.trim(),
        autor: _autorController.text.trim(),
        status: _status,
        nota: _status == StatusLivro.lido ? _nota : 0,
        dataLeitura: _dataLeitura,
        observacao: _observacaoController.text.trim(),
      );

      Navigator.pop(context, livro);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tituloTela = widget.livro == null ? 'Novo livro' : 'Editar livro';

    return Scaffold(
      appBar: AppBar(
        title: Text(tituloTela),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.menu_book_outlined),
                ),
                validator: (valor) {
                  if ((valor ?? '').trim().isEmpty) {
                    return 'Informe o título.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (valor) {
                  if ((valor ?? '').trim().isEmpty) {
                    return 'Informe o autor.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<StatusLivro>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: StatusLivro.lido,
                    child: Text('Lido'),
                  ),
                  DropdownMenuItem(
                    value: StatusLivro.desejado,
                    child: Text('Desejado'),
                  ),
                ],
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => _status = valor);
                  }
                },
              ),
              const SizedBox(height: 16),
              if (_status == StatusLivro.lido) ...[
                Text(
                  'Nota',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    final valor = index + 1;
                    return IconButton(
                      onPressed: () => setState(() => _nota = valor),
                      icon: Icon(
                        valor <= _nota ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      ),
                    );
                  }),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dataLeitura == null
                          ? 'Data de leitura'
                          : 'Leitura: ${_dataLeitura!.day}/${_dataLeitura!.month}/${_dataLeitura!.year}',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _selecionarData,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: const Text('Selecionar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
