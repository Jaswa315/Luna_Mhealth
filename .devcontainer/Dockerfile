# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bookworm, bullseye, buster
ARG VARIANT="bullseye"
FROM --platform=linux/amd64 buildpack-deps:${VARIANT}-curl

# install utilites (mostly needed for GUI interface)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    coreutils \
    git \
    sudo \
    ninja-build \
    cmake \
    clang \
    pkg-config \
    libgtk-3-dev \
    xfce4 xfce4-terminal \
    tigervnc-standalone-server \
    x11-apps x11-xserver-utils xfonts-base dbus-x11 \
    bash \
    python3 \
    python3-pip \
    openjdk-17-jdk \
    wget \
    unzip \
    && apt-get clean


ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip tools.zip -d cmdline-tools && \
    mv cmdline-tools/cmdline-tools cmdline-tools/latest && \
    rm tools.zip

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

#cloning git is own later due to needing to upgrade flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter


#add flutter to path
ENV PATH "/opt/flutter/bin:$PATH"
#set display environment variable
ENV DISPLAY=:1