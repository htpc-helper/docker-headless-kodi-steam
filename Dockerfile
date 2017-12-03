# This Dockerfile is used to build an headles vnc image based on Ubuntu

FROM ubuntu:16.04
MAINTAINER htpc-helper

## Connection ports for controlling the UI:
# VNC port:5900
ENV DISPLAY=:1 \
    VNC_PORT=5900

### Envrionment config
ENV TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/tmp/install \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false \
    USER=htpc-helper \
    UID=1100 \
    LANG="en_AU.UTF-8" \
    LANGUAGE="en_AU:en" \
    LC_ALL="en_AU.UTF-8"

# Add USER
RUN useradd -m -d /headless --uid $UID $USER

# Update and upgrade
RUN apt update -q && \
    apt upgrade -qy && \
    apt install \
      locales

# Set locale
RUN locale-gen $LC_ALL

### Add all install scripts for further steps
ADD ./src/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh

### Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

USER 1984

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--tail-log"]
