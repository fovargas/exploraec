// Hook PostToolUse de Claude Code: formatea solo el archivo .dart que se editó.
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final evento = jsonDecode(await stdin.transform(utf8.decoder).join());
  final ruta = (evento['tool_input']?['file_path'] as String?)?.replaceAll(
    r'\',
    '/',
  );
  if (ruta == null || !ruta.endsWith('.dart')) return;
  if (!RegExp(r'/(lib|test)/').hasMatch(ruta)) return;
  if (ruta.contains('/lib/playground/') ||
      ruta.endsWith('/bienvenida_claude_design.dart')) {
    return;
  }
  await Process.run('dart', ['format', ruta], runInShell: true);
}
