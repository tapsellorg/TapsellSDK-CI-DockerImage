FROM ubuntu:20.04

LABEL maintainer tapsellorg

ARG DEBIAN_FRONTEND=noninteractive

ENV ANDROID_HOME "/android-sdk-linux"
RUN mkdir -p ${ANDROID_HOME}

RUN apt-get -qq update && apt-get install -y locales \
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

# install command line tools
ARG CMD_LINE_TOOLS_VERSION=8092744
RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${CMD_LINE_TOOLS_VERSION}_latest.zip -o tools.zip && \
	unzip -q tools.zip -d ${ANDROID_HOME} && \
	rm tools.zip

# install flutter
ARG FLUTTER_VERSION=2.10.5-stable
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
RUN cd ${ANDROID_HOME}/build-tools/32.0.0 \
  && mv d8 dx \
  && cd lib  \
  && mv d8.jar dx.jar

RUN npm install -g react-native-cli
RUN npm install -g cordova

# install .net Core SDK
RUN curl -s https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb && \
	dpkg -i packages-microsoft-prod.deb && \
	apt-get update && \
	apt-get install apt-transport-https -y && \
	apt-get install dotnet-sdk-3.1 -y && \
	rm packages-microsoft-prod.deb