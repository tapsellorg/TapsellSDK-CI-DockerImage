FROM ubuntu:24.04
LABEL authors="tapsellorg"

# Install base tools and dependencies
RUN apt-get update && apt-get install -qqy --no-install-recommends \
    bash \
    curl \
    unzip \
    git \
    zip \
    unzip \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV ANDROID_HOME='/android-sdk'

# Download and install Android SDK Command-line tools
ARG CMD_TOOLS_VERSION=13114758
ARG CMD_FILE_NAME=commandlinetools-linux-${CMD_TOOLS_VERSION}_latest.zip
ARG CMD_DIR=$ANDROID_HOME/cmdline-tools
RUN curl -o $CMD_FILE_NAME https://dl.google.com/android/repository/$CMD_FILE_NAME \
    && mkdir -p $CMD_DIR \
    && unzip -o -q $CMD_FILE_NAME -d $CMD_DIR \
    && mv $CMD_DIR/cmdline-tools/* $CMD_DIR \
    && rm $CMD_FILE_NAME
ENV PATH=$PATH:$CMD_DIR/bin

# Accept licenses (this step avoids interactive license prompts)
RUN yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses

# Install SDK components (platforms, build-tools, etc.)
RUN sdkmanager --sdk_root=${ANDROID_HOME}\
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0"
ENV PATH=$PATH:$ANDROID_HOME/platform-tools

# Install Kotlin compiler for running kotlin scripts
ARG KOTLIN_VERSION=2.1.10
ARG KOTLIN_FILE_NAME=kotlin-compiler-$KOTLIN_VERSION.zip
ARG KOTLIN_DIR=${ANDROID_HOME}/kotlin-compiler
RUN curl -L -o $KOTLIN_FILE_NAME https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/$KOTLIN_FILE_NAME \
    && unzip -o -q $KOTLIN_FILE_NAME -d $KOTLIN_DIR \
    && rm $KOTLIN_FILE_NAME
ENV PATH=$PATH:"$KOTLIN_DIR/kotlinc/bin:$PATH"