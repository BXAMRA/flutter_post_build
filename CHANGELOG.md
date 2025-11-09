# Changelog

## 1.1.0

- **FEAT**: Added `move_files` option. When set to `false`, files are copied to the `final_directory` instead of being moved, leaving the original build artifacts intact.
- **DOCS**: Updated README to include documentation for the new `move_files` flag.

## 1.0.0

- **Initial Release**
- Core functionality to rename and move build artifacts based on `pubspec.yaml` configuration.
- Supports `package_name` and `final_directory` options.
