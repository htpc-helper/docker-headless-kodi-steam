# Docker container image with "headless" VNC session

Docker image is installed with the following components:

* Desktop environment [**Xfce4**](http://www.xfce.org)
* VNC-Server (default VNC port `5900`)
* Chromium browser
* Kodi
* Steam

## Usage
The usage is for all provide images **similar**, for instance see following the usage of the `consol/centos-xfce-vnc` image:

Run command

    docker run -d consol/centos-xfce-vnc
  
Change the default user and group within a container to your own with adding `--user $(id -u):$(id -g)`:

    docker run -d --user $(id -u):$(id -g) consol/centos-xfce-vnc

If you want to get into the container use interactive mode `-it` and `bash`     

    docker run -it consol/centos-xfce-vnc bash

Build an image from scratch:

    docker build -t consol/centos-xfce-vnc centos-xfce-vnc

=> connect via __VNC viewer `localhost:5900`__, default password: `vncpassword`

## Hints

### 1) Extend a Image with your own software
Since `1.1.0` all images run as non-root user per default, so that means, if you want to extend the image and install software, you have to switch in the `Dockerfile` back to the `root` user:

```bash
## Custom Dockerfile
FROM consol/centos-xfce-vnc:1.1.0
MAINTAINER Tobias Schneck "tobias.schneck@consol.de"
ENV REFRESHED_AT 2017-04-10

## Install a gedit
USER 0
RUN yum install -y gedit \
    && yum clean all
## switch back to default user
USER 1984
```

### 2) Change User of running Sakuli Container

Per default, since version `1.1.0` all container processes will executed with user id `1984`. You can change the user id like follow: 

#### 2.1) Using root (user id `0`)
Add the `--user` flag to your docker run command:

    docker run -it --user 0 consol/centos-xfce-vnc

#### 2.2) Using user and group id of host system
Add the `--user` flag to your docker run command:

    docker run -it --user $(id -u):$(id -g) consol/centos-xfce-vnc

### 3) Override VNC environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1920x1080`
* `VNC_PW`, default: `vncpassword`

#### 3.1) Example: Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:

    docker run -it -e VNC_PW=my-pw consol/centos-xfce-vnc

#### 3.2) Example: Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in
the docker run command:

    docker run -it -e VNC_RESOLUTION=800x600 consol/centos-xfce-vnc
    
### 4) View only VNC
Since version `1.2.0` it's possible to prevent unwanted control over VNC. Therefore you can set the environment variable `VNC_VIEW_ONLY=true`. If set the docker startup script will create a random cryptic password for the control connection and use the value of `VNC_PW` for the view only connection over the VNC connection.

     docker run -it -e VNC_VIEW_ONLY=true consol/centos-xfce-vnc


**This image is dervied from work by ConSol Software GmbH** <br/>
*Franziskanerstr. 38, D-81669 München* <br/>
*Tel. +49-89-45841-100, Fax +49-89-45841-111*<br/>
*Homepage: http://www.consol.de E-Mail: [info@consol.de](info@consol.de)*
