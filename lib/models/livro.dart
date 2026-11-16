enum StatusLivro { lido, desejado }

extension StatusLivroExt on StatusLivro {
  String get valor {
    switch (this) {
      case StatusLivro.lido:
        return 'lido';
      case StatusLivro.desejado:
        return 'desejado';
    }
  }

  static StatusLivro fromString(String? valor) {
    switch (valor) {
      case 'lido':
        return StatusLivro.lido;
      case 'desejado':
      default:
        return StatusLivro.desejado;
    }
  }
}

class Livro {
  final String id;
  final String titulo;
  final String autor;
  final StatusLivro status;
  final int nota;
  final DateTime? dataLeitura;
  final String observacao;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.status,
    this.nota = 0,
    this.dataLeitura,
    this.observacao = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'status': status.valor,
      'nota': nota,
      'dataLeitura': dataLeitura?.toIso8601String(),
      'observacao': observacao,
    };
  }

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      titulo: (json['titulo'] ?? '').toString(),
      autor: (json['autor'] ?? '').toString(),
      status: StatusLivroExt.fromString(json['status']?.toString()),
      nota: (json['nota'] as int?) ?? 0,
      dataLeitura: json['dataLeitura'] != null
          ? DateTime.tryParse(json['dataLeitura'].toString())
          : null,
      observacao: (json['observacao'] ?? '').toString(),
    );
  }
}
