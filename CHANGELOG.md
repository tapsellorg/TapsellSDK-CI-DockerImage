# Tapsell Android SDK CI Docker Image

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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