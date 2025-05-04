# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bookworm, bullseye, buster
ARG VARIANT="bullseye"
FROM buildpack-deps:${VARIANT}-curl

# install utilites (mostly needed for GUI interface)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    coreutils \
    git \ 
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
    && apt-get clean


#cloning git is own later due to needing to upgrade flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter


#add flutter to path
ENV PATH "/opt/flutter/bin:$PATH"
#set display environment variable
ENV DISPLAY=:1