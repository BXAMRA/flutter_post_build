# Flutter Post-Build Organizer

[![pub package](https://img.shields.io/pub/v/flutter_post_build.svg)](https://pub.dev/packages/flutter_post_build)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A simple and configurable command-line tool to automatically rename and organize your Flutter build artifacts (APKs) after the build process is complete.

## About

The `flutter build` command produces predictably named files (e.g., `app-release.apk`). This tool runs after the build to rename these files based on your own `package_name` and move them to a clean directory, solving a common workflow problem without complex Gradle scripts.

## Features

- **Rename APKs**: Automatically renames `app-release.apk` to `<your-package-name>-release.apk`.
- **Organize Artifacts**: Optionally moves the final APKs to a separate directory (e.g., `./release`).
- **Copy or Move**: Choose to either move the files or create a copy, leaving the original build artifacts intact.
- **Simple Configuration**: All settings are managed in your project's `pubspec.yaml`.
- **Easy to Use**: A single command to run after your build.

## Installation

You can install the tool globally (recommended) or as a development dependency in your Flutter project.

### Option A: Global Activation (Recommended)

This makes the `flutter_post_build` command available in any Flutter project on your machine.

```bash
dart pub global activate flutter_post_build
```

### Option B: Dev Dependency

This scopes the tool to a single project.

```bash
flutter pub add --dev flutter_post_build
```

## Configuration

In the `pubspec.yaml` of the Flutter project you want to build, add the following configuration block:

```yaml
flutter_post_builder:
  # (Required) The new base name for your APK files.
  package_name: "myNewAppName"

  # (Optional) The directory to move the final APKs to.
  # If omitted, APKs are simply renamed in their original build folder.
  final_directory: "./release"

  # (Optional) If set to `false`, files will be copied to `final_directory`
  # instead of moved. Defaults to `true`.
  # This option only has an effect if `final_directory` is also set.
  move_files: false
```

## Usage

The workflow is a simple two-step process:

**1. Build your Flutter App**
Run the standard build command.

```bash
flutter build apk --release
```

**2. Run the Post-Build Tool**
After the build is successful, run the tool.

- If installed globally:

```bash
flutter_post_build
```

- If installed as a dev dependency:

```bash
dart run flutter_post_build
```

Your renamed and organized APKs will be ready in the location you specified!

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.
