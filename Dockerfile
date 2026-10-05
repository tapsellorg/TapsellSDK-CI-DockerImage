FROM ubuntu:24.04
LABEL authors="tapsellorg"

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/android-sdk

# Install base tools and dependencies
RUN apt-get update && apt-get install -qqy --no-install-recommends \
    curl \
    git \
    zip \
    unzip \
    openjdk-17-jdk-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and install Android SDK command-line tools
ARG CMD_TOOLS_VERSION=16111833
ARG CMD_FILE_NAME=commandlinetools-linux-${CMD_TOOLS_VERSION}_latest.zip
ARG CMD_DIR=$ANDROID_HOME/cmdline-tools
RUN curl -fsSL -o $CMD_FILE_NAME https://dl.google.com/android/repository/$CMD_FILE_NAME \
    && mkdir -p $CMD_DIR \
    && unzip -q $CMD_FILE_NAME -d $CMD_DIR \
    && mv $CMD_DIR/cmdline-tools $CMD_DIR/latest \
    && rm $CMD_FILE_NAME
ENV PATH=$PATH:$CMD_DIR/latest/bin

# Install SDK components (platforms, build-tools, etc.)
# cmdline-tools 23.0 resolves the SDK root from <sdk>/cmdline-tools/latest/
# and handles licenses automatically, so no --sdk_root or --licenses needed.
RUN sdkmanager \
        "platform-tools" \
        "platforms;android-36" \
        "build-tools;36.0.0" \
    && rm -rf /root/.android/cache

# Install Kotlin compiler for running kotlin scripts
ARG KOTLIN_VERSION=2.1.10
ARG KOTLIN_FILE_NAME=kotlin-compiler-$KOTLIN_VERSION.zip
ARG KOTLIN_DIR=$ANDROID_HOME/kotlin-compiler
RUN curl -fsSL -o $KOTLIN_FILE_NAME https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/$KOTLIN_FILE_NAME \
    && unzip -q $KOTLIN_FILE_NAME -d $KOTLIN_DIR \
    && rm $KOTLIN_FILE_NAME

ENV PATH=$PATH:$ANDROID_HOME/platform-tools:$KOTLIN_DIR/kotlinc/bin
