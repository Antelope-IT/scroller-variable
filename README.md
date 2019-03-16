Scroller-Variable
=================
This repository contains the source code for the scroller-variable Docker container. Its the first in a family of containers that targets the [Pimoroni Scroll pHAT HD](https://shop.pimoroni.com/products/scroll-phat-hd). It is essentially a learning vehicle for me to learn about Docker, Python, Raspberry Pi and things vaguely IoT. 

The Dockerfile builds an image that works with the [Pimoroni Scroll pHAT HD](https://shop.pimoroni.com/products/scroll-phat-hd) and specifically the [Pimoroni Scroll Bot](https://shop.pimoroni.com/products/scroll-bot-pi-zero-w-project-kit). 
It scrolls a single message infinitely or until the container is stopped. The message to scroll is configured via an environment variable (see below). 

The image runs a simple python script scroller-env.py which takes the value of the environment variable and scrolls it on the screen. The script is based on the 'Displaying Text' example in [Getting Started with Scroll pHAT HD](https://learn.pimoroni.com/tutorial/sandyj/getting-started-with-scroll-phat-hd). I've added code to get the message text from an environment variable and code to respond to SIGINT and SIGTERM events so that the script exits cleanly when the container is stopped.

Health Warning
==============
Please be aware that this is the first docker image I have built and the first time I've used Python. I have created this source code by following many "Getting started with..." articles. You are welcome to use this code and to learn from my mistakes, however I make no guarantees as to its functionality or suitability. 

Build
---------
```
docker build \
  --tag=scroll-env-variable \
  .  
  
```

Usage
---------
```
docker run \
  -d \
  -e MESSAGE_TO_SCROLL='< The message you want to appear on the Scroll pHAT HD >' \
  --device /dev/i2c-1 \
  --name < your_container_name_here > \
  scroll-env-variable

```
Publish
-------
```
docker tag scroll-env-variable \
   antelopeit/scroller-variable:stretch-python37-1.0
   
docker push \
   antelopeit/scroller-variable:stretch-python37-1.0   
```

Future
======
The base image for the docker file [balenalib/raspberry-pi-python](https://hub.docker.com/r/balenalib/raspberry-pi-python) is AFAIK a sound starting point. I tried other images but couldn't get them to work. This was the first image I could get to work. The image is probably larger than strictly necessary, this is because its a 'build' version of the image. I could possibly change it for the 'run' version of the image, however as part of the installation the Docker file installs the scrollphathd python library. This library has a dependency on numpy amongst others but because the base image is using Python 3.7 this means that there is no readily available pre-compiled version of numpy on [PiWheels](https://www.piwheels.org/). The net result of this is that the installation has to build numpy. I don't know the full implications of this but I do know that on a Pi Zero it takes a while and you should probably not trust a version of numpy built on my Pi Zero. In order to resolve this problem it would probably be better to build the image with a Python v3.5 based image and hope that it installs a prebuilt numpy library from PiWheels. This in turn would obviate the need to build the numpy library and thus remove the need to use the 'build' version of the base image (if it were ever needed) and allowing the use of the smaller 'run' version of the base image.
