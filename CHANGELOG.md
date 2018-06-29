# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][] and this project adheres to
[Semantic Versioning][].

## [Unreleased]

## [0.0.2][] - 2018-07-29

### Added

- README file.
- This CHANGELOG file.
- Signature in digest email.
- `bundler-audit` as a development dependency.

### Removed

- `FEEDIGEST_DELIVERY_METHOD` option. Now only SMTP is supported.

### Changed

- Clean up and refactor code.
- dotenv to be a development dependency.
- `FEEDIGEST_SMTP_HOST` option to `FEEDIGEST_SMTP_ADDRESS`
- `feedigest-generate` command to `feedigest-print`

## 0.0.1 - 2018-06-12

Initial release.

[Keep a Changelog]: http://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: http://semver.org/spec/v2.0.0.html
[Unreleased]: https://github.com/agorf/feedigest/compare/0.0.2...HEAD
[0.0.2]: https://github.com/agorf/feedigest/compare/0.0.1...0.0.2
