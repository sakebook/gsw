# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-01-08
### Changed
- **Major Redesign**: `gsw` now defaults to **Session-scoped switching** (current terminal tab only) for improved safety.
- `gsw <config>`: Switches configuration for the current session by default.
- `gsw -g <config>` or `gsw --global <config>`: Switches the global configuration.
- Simplified help and usage messages to reflect the new session-first approach.

### Removed
- `gsw-local` command has been completely removed (its functionality is now the default behavior of `gsw`).

## [0.2.0] - 2026-01-07
### Added
- `--help` / `-h` flag for both `gsw` and `gsw-local` commands.
  - Shows static usage documentation (without config list for faster output).
  - Running without arguments still shows config list + usage.

## [0.1.1] - 2026-01-06
### Added
- `--version` / `-v` flag to display version information.

## [0.1.0] - 2026-01-06

### Added
- Initial release of `gsw`.
- `gsw <config>`: Global configuration switching.
- `gsw-local <config>`: Local (per-session) configuration switching via `CLOUDSDK_ACTIVE_CONFIG_NAME`.
- Support for **Bash** and **Zsh**.
- `install.sh` for one-line installation.
- Automated tests using BATS and GitHub Actions.
