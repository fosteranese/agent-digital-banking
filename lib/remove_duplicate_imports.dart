import 'dart:io';

import 'package:my_sage_agent/logger.dart';

void main() {
  final libDir = Directory('lib');

  if (!libDir.existsSync()) {
    logger.e('❌ No lib/ directory found.');
    return;
  }

  final dartFiles = libDir.listSync(recursive: true).where((f) => f.path.endsWith('.dart')).map((f) => File(f.path));

  for (final file in dartFiles) {
    cleanImports(file);
  }

  logger.i('✅ Finished cleaning duplicate imports in lib/');
}

void cleanImports(File file) {
  final lines = file.readAsLinesSync();

  final seen = <String>{};
  final cleaned = <String>[];

  for (var line in lines) {
    if (line.trim().startsWith('import')) {
      final normalized = line.trim().replaceAll(RegExp(r"\s+"), " ");
      if (!seen.contains(normalized)) {
        seen.add(normalized);
        cleaned.add(line);
      }
      // duplicate → skip
    } else {
      cleaned.add(line);
    }
  }

  file.writeAsStringSync(cleaned.join('\n'));
  logger.i('🧹 Cleaned: ${file.path}');
}
