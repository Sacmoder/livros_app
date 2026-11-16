// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

void baixarImagemWeb(Uint8List dados, String nomeArquivo) {
  final base64 = base64Encode(dados);
  final link = html.AnchorElement(
    href: 'data:image/png;base64,$base64',
  )
    ..download = nomeArquivo
    ..style.display = 'none';

  html.document.body?.append(link);
  link.click();
  link.remove();
}
