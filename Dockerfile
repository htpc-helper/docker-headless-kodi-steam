# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM phusion/baseimage
MAINTAINER htpc-helper

### Envrionment config
ENV DISPLAY=:1 \
    TERM=xterm \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false \
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
    dpkg --add-architecture i386 && \
    dpkg --configure -a

# Update and upgrade
RUN apt update -q && \
    apt upgrade -qy

# Install system
RUN apt install -qy \
      locales \
      xfce4

# Set locale
RUN locale-gen $LC_ALL

# Install applications
RUN apt install -qy \
      steam \
      kodi \
      kodi-pvr-hts \
      chromium-browser \
      chromium-browser-l10n \
      chromium-codecs-ffmpeg && \
    apt purge -qy \
      pm-utils \
      xscreensaver*

### Install TigerVNC
RUN curl -o /tmp/tigervnc.tar.gz -L https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz && \
    tar xf /tmp/tigervnc.tar.gz -C / --strip 1

# Configure runit
RUN mkdir /etc/service/vncviewer
COPY init/vncviewer.sh /etc/service/vncviewer/run
RUN chmod -R +x /etc/service
