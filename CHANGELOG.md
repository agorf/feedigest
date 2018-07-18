# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][] and this project adheres to
[Semantic Versioning][].

## [Unreleased][]

## [0.2.0][] - 2018-07-18

### Added

- Support filtering feeds through an external command.
- Opening informational text in digest email.
- Support for specifying path to YAML configuration file.
- Support for command-line options.

### Changed

- Configuration from environment variables to a YAML file.
- `entry_window` config option unit from seconds to hours.

## [0.1.0][] - 2018-07-04

### Changed

- Bump version to 0.1.0 to signify 0.0.2 (which should have been 0.1.0) has
  breaking changes.

## [0.0.3][] - 2018-07-03 [YANKED]

### Changed

- Use subcommands instead of symlinks to feedigest binary.
- Do not require SMTP options when printing the email.

## [0.0.2][] - 2018-06-29 [YANKED]

### Added

- README file.
- This CHANGELOG file.
- Signature in digest email.
- `bundler-audit` as a development dependency.

### Removed

- `FEEDIGEST_DELIVERY_METHOD` option. Now only SMTP is supported.

### Changed

- Clean up and refactor code.
- `dotenv` to be a development dependency.
- `FEEDIGEST_SMTP_HOST` option to `FEEDIGEST_SMTP_ADDRESS`
- `feedigest-generate` command to `feedigest-print`

## 0.0.1 - 2018-06-12

Initial release.

[Keep a Changelog]: http://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: http://semver.org/spec/v2.0.0.html
[0.0.2]: https://github.com/agorf/feedigest/compare/0.0.1...0.0.2
[0.0.3]: https://github.com/agorf/feedigest/compare/0.0.2...0.0.3
[0.1.0]: https://github.com/agorf/feedigest/compare/0.0.3...0.1.0
[0.2.0]: https://github.com/agorf/feedigest/compare/0.1.0...0.2.0
[Unreleased]: https://github.com/agorf/feedigest/compare/0.2.0...HEAD
