# Tapsell Android SDK CI Docker Image

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.1.0] - 2023-03-29

### Changed
- Updated android sdk version to `33.0.0` 
- Replaced static Android SDK tools with the latest dynamic Android SDK command-line tools from [Android Developer](https://developer.android.com/studio/index.html)
- Updated flutter version to `3.7.8`
- Updated dotnet version to `6.0`

### Added
- Added Kotlin Native installation
- Added NDK installation

## [4.0.0] - 2022-05-08

### Changed
- Changed base image to ubuntu:20.04
- Replaced Android SDK tools with the latest Android SDK command-line tools 
- Updated flutter version
- Updated .net Core SDK version
- Removed unnecessary package installations
- Removed redundant gradle installation
- Removed redundant jar file downloads
- Added a fix for build-tools v31+ incompatibility with gradle versions below 7

### Added
- Added Cordova installation