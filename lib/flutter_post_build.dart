import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

// ============================================================
// Flutter Post-Build Organizer
// v1.1.1 (Global Edition) - November 09, 2025
// Copyright 2025 BXAMRA
// Website: https://bxamra.github.io/
// ============================================================

void runPostBuild() {
  // --- 1. Load and Parse Configuration ---
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print(
        'Error: pubspec.yaml not found. Run this tool from the root of a Flutter project.');
    exit(1);
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final pubspecYaml = loadYaml(pubspecContent);

  final config = pubspecYaml['flutter_post_builder'];
  if (config == null || config is! YamlMap) {
    print(
        'Error: "flutter_post_builder" configuration not found or is invalid in pubspec.yaml.');
    exit(1);
  }

  final packageName = config['package_name'] as String?;
  if (packageName == null || packageName.isEmpty) {
    print('Error: "package_name" is missing or empty in the configuration.');
    exit(1);
  }

  final finalDirectory = config['final_directory'] as String?;

  final moveFiles = config['move_files'] as bool? ?? true;

  // --- 2. Prepare Directories ---
  final sourceDir = Directory('build/app/outputs/flutter-apk/');
  if (!sourceDir.existsSync()) {
    print(
        'Error: Build directory not found. Have you run "flutter build apk --release" first?');
    exit(1);
  }

  Directory? targetDir;
  if (finalDirectory != null && finalDirectory.isNotEmpty) {
    targetDir = Directory(finalDirectory);
    if (!targetDir.existsSync()) {
      print('Creating target directory: ${targetDir.path}');
      targetDir.createSync(recursive: true);
    }
  }

  // --- 3. Process Files ---
  print('Scanning for release APKs...');
  int filesProcessed = 0;

  sourceDir.listSync().forEach((entity) {
    if (entity is File) {
      final fileName = p.basename(entity.path);

      if (fileName.startsWith('app-') && fileName.endsWith('-release.apk')) {
        final newName = fileName.replaceFirst('app-', '$packageName-');

        if (targetDir != null && !moveFiles) {
          final newPath = p.join(targetDir.path, newName);
          print('  - Copying "$fileName" to "$newPath"');
          entity.copySync(newPath);
        }
        // Otherwise, perform the default MOVE operation.
        else {
          final destinationDir = targetDir?.path ?? entity.parent.path;
          final newPath = p.join(destinationDir, newName);
          print('  - Moving "$fileName" to "$newPath"');
          entity.renameSync(newPath);
        }

        filesProcessed++;
      }
    }
  });

  if (filesProcessed > 0) {
    print('\nSuccess! $filesProcessed build artifact(s) have been processed.');
    if (targetDir != null) {
      print('Files are located in the "${targetDir.path}" directory.');
      if (!moveFiles) {
        print('Original files remain in the build output directory.');
      }
    }
  } else {
    print('No release APKs starting with "app-" were found to process.');
  }
}
