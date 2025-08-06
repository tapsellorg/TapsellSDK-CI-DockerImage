# Tapsell Android SDK CI Docker Image

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0@jdk11-sdk34] - 2025-08-06

- Upgraded base image to `ubuntu:24.04`.
- Simplified package installation, focusing on essential tools like `curl`, `unzip`, `git`, and `openjdk-11-jdk`.
- Removed previous installations of Gradle, Flutter, Node.js/npm, React Native CLI, Cordova, .NET SDK, and Kotlin/Native compiler from the Docker image.
- Use a specific version of Android SDK Command-line tools.
- Minimize Android SDK components to `"platform-tools"`, `"platforms;android-34"`, and `"build-tools;34.0.0"`.
- Introduce all execution `PATH`s
- Added Kotlin compiler `2.1.10` for running Kotlin scripts.
- Versioning Scheme has changed from this release onwards to `5.0.0@jdk11-sdk34`
- This is based on [Tiny-Android](https://github.com/beigirad/tiny-android-docker)


## [4.1.2] - 2023-05-24

### Added
- Added ssh agent to the image

### Changed
- Updated Kotlin to `1.8.21`

## [4.1.1] - 2023-03-29
### Added
- Added wget to download

### Changed
- Updated android sdk version to `33.0.0` 
- Replaced static Android SDK tools with the latest dynamic Android SDK command-line tools from [Android Developer](https://developer.android.com/studio/index.html)
- Updated flutter version to `3.7.8`
- Updated dotnet version to `6.0`

### Added
- Added Kotlin Native installation `1.8.10`
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