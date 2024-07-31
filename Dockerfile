FROM ubuntu:22.04

LABEL maintainer tapsellorg

ENV KOTLIN_VERSION "1.8.21"
ENV GRADLE_VERSION "7.6.1"
ENV NDK_VERSION r21d
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME "/android-sdk-linux"
ENV ANDROID_NDK_HOME "/android-ndk-linux"

RUN mkdir -p ${ANDROID_HOME}

RUN apt-get -qq update && apt-get install -y locales \
    && apt-get install -y wget \
    && apt-get install openssh-client -y wget \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

# install necessary packages
RUN apt-get install -qqy --no-install-recommends \
	curl \
	git \
	unzip \
	zip \
	xz-utils \
	openjdk-11-jdk \
	nodejs \
	npm \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#install gradle
RUN wget https://downloads.gradle-dn.com/distributions/gradle-${GRADLE_VERSION}-bin.zip
RUN unzip gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_HOME /gradle-${GRADLE_VERSION}
ENV PATH $PATH:/gradle-${GRADLE_VERSION}/bin

# download and unzip latest command line tools
RUN export CMD_LINE_TOOLS_VERSION="$(curl -s https://developer.android.com/studio/index.html | grep -oP 'commandlinetools-linux-\K\d+' | uniq)" && \
  curl -s https://dl.google.com/android/repository/commandlinetools-linux-${CMD_LINE_TOOLS_VERSION}_latest.zip -o /tools.zip && \
  unzip -q tools.zip -d ${ANDROID_HOME} && \
  rm tools.zip

# Install Google's repo tool version 1.23 (https://source.android.com/setup/build/downloading#installing-repo)
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo


# install flutter
ARG FLUTTER_VERSION=3.7.8-stable
RUN curl -s https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz -o flutter.tar.xz && \
	tar -xf flutter.tar.xz -C /opt && \
	rm flutter.tar.xz

ENV PATH "$PATH:${ANDROID_HOME}/cmdline-tools:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin"

# create repositories.cfg
RUN mkdir -p ~/.android && touch ~/.android/repositories.cfg

# Accept licenses
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --licenses --sdk_root=${ANDROID_HOME}

# Update
RUN ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --update --sdk_root=${ANDROID_HOME}

ADD packages.txt .
RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < ./packages.txt && \
    ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager ${PACKAGES} --sdk_root=${ANDROID_HOME}

# fix build-tools v31+ problem with gradle versions below 7
RUN cd ${ANDROID_HOME}/build-tools/33.0.0 \
  && mv d8 dx \
  && cd lib  \
  && mv d8.jar dx.jar

RUN npm install -g react-native-cli
RUN npm install -g cordova

# install .net Core SDK
RUN curl -s https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
	dpkg -i packages-microsoft-prod.deb && \
	apt-get update && \
	apt-get install apt-transport-https -y && \
	apt-get install dotnet-sdk-6.0 -y && \
	rm packages-microsoft-prod.deb

# Kotlin/Native compiler
RUN wget -q -O /kotlin_native.tar.gz https://download.jetbrains.com/kotlin/native/builds/releases/${KOTLIN_VERSION}/linux-x86_64/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION}.tar.gz && \
    mkdir -p ~/.konan/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION} && \
    tar -zxvf /kotlin_native.tar.gz -C /root/.konan/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION} && \
    rm -v /kotlin_native.tar.gz

# NDK support
#RUN mkdir /tmp/android-ndk && \
#    cd /tmp/android-ndk && \
#    curl -s -O https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
#    unzip -q android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
#    mv ./android-ndk-${NDK_VERSION} ${ANDROID_NDK_HOME} && \
#    cd ${ANDROID_NDK_HOME} && \
#    rm -rf /tmp/android-ndk