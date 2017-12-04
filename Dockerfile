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

# Add USER
RUN groupadd -g $UID $USER && \
    useradd -m -d $HOME --uid $UID -g $USER -G sudo $USER

# Update and upgrade
RUN apt update -q && \
    apt upgrade -qy && \
    apt install -qy \
      locales \
      xfce4 \
      sudo \
      chromium-browser \
      chromium-browser-l10n \
      chromium-codecs-ffmpeg && \
    apt purge -qy \
      pm-utils \
      xscreensaver*

# Set locale
RUN locale-gen $LC_ALL

### Install TigerVNC
RUN curl -o /tmp/tigervnc.tar.gz -L https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz && \
    tar xf /tmp/tigervnc.tar.gz -C / --strip 1

### Install Chrome browser
RUN ln -s /usr/bin/chromium-browser /usr/bin/google-chrome
### fix to start chromium in a Docker container, see https://github.com/ConSol/docker-headless-vnc-container/issues/2
RUN echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium-browser.init

### Configure UI
#ADD ./.config/ $HOME/.config/

### Configure startup
ADD init/vnc-startup.sh /etc/my_init.d/
ADD init/chrome-init.sh /etc/my_init.d/
ADD init/xstartup /home/$USER/.vnc/xstartup

# Configure runit
RUN mkdir /etc/service/vncviewer
COPY init/vncviewer.sh /etc/service/vncviewer/run

# RUN mkdir /etc/service/xfce
# COPY init/xfce.sh /etc/service/xfce/run

RUN chmod -R +x /etc/service
