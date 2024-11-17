# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.1] - 2024-11-17

### Added

- The horizontal rule (`---`) will not be visible if it is placed at the very top or very bottom of the page.
- Include necessary files in the Docker image

## [0.2.0] - 2024-11-17

### Changed

- CVs and cover letters are now written in Markdown and converted to Typst using a Pandoc template

### Added

- `linkify` Pandoc Lua filter that automatically converts keywords in the document into hyperlinks

## [0.1.0] - 2024-11-13

### Added

- English and French versions.
- CV and cover letter in Typst
- `just` for rendering
- GitHub actions for rendering and publishing to GitHub Pages
