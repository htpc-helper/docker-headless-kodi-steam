# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM phusion/baseimage
MAINTAINER htpc-helper

### Environment config
ENV DISPLAY=:1 \
    VNC_COL_DEPTH=24 \
    TERM=xterm \
    DEBIAN_FRONTEND=noninteractive \
    USER=htpc-helper \
    HOME=/home/htpc-helper \
    UID=1100 \
    LANG="en_AU.UTF-8" \
    LANGUAGE="en_AU:en" \
    LC_ALL="en_AU.UTF-8"

# Add user
RUN useradd -m -d $HOME --uid $UID $USER

# Add repos
RUN apt-add-repository ppa:team-xbmc/ppa && \
    dpkg --add-architecture i386

# Update and upgrade
RUN apt update -q && \
    apt upgrade -qy

# Install system
RUN apt install -qy \
      locales \
      xfce4

# Set locale
RUN locale-gen $LC_ALL

# Install app dependencies
RUN apt install -qy \
      python-apt \
      gdebi \
      libgl1-mesa-dri:i386 \
      libgl1-mesa-glx:i386 \
      libc6:i386 \
      zenity-common \
      libwebkit2gtk-4.0-37 \
      zenity \

# Install applications
RUN apt install -qy \
      kodi \
      kodi-pvr-hts \
      chromium-browser \
      chromium-browser-l10n \
      chromium-codecs-ffmpeg && \
    apt purge -qy \
      pm-utils \
      xscreensaver*

### Install Steam
RUN curl -o /tmp/steam.deb -L https://steamcdn-a.akamaihd.net/client/installer/steam.deb && \
    dpkg -i /tmp/steam.deb

### Install TigerVNC
RUN curl -o /tmp/tigervnc.tar.gz -L https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz && \
    tar xf /tmp/tigervnc.tar.gz -C / --strip 1

### Cleanup
RUN apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/tmp/*

# Configure runit
RUN mkdir /etc/service/vncserver
COPY init/vncserver.sh /etc/service/vncserver/run
RUN chmod -R +x /etc/service
