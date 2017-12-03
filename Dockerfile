# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM ubuntu:16.04
MAINTAINER htpc-helper

## Connection ports for controlling the UI:
# VNC port:5900
ENV DISPLAY=:1 \
    VNC_PORT=5900

### Envrionment config
ENV TERM=xterm \
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
RUN useradd -m -d $HOME --uid $UID $USER

# Update and upgrade
RUN apt update -q && \
    apt upgrade -qy && \
    apt install -qy \
      locales \
      chromium-browser \
      chromium-browser-l10n \
      chromium-codecs-ffmpeg \
      supervisor \
      xfce4 \
      libnss-wrapper \
      gettext \
      xterm && \
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
ADD ./src/.config/ $HOME/.config/

### Configure startup
ADD ./src/init/ /init/
# add 'souce generate_container_user' to .bashrc
RUN echo 'source /init/generate_container_user' >> $HOME/.bashrc
RUN find "/init/" -name '*.sh' -exec chmod -v a+x {} +

ENTRYPOINT ["/init/vnc_startup.sh"]
CMD ["--tail-log"]
