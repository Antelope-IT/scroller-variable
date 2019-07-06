Scroller-Variable
=================
This repository contains the source code for the scroller-variable Docker container. Its the first in a family of containers that targets the [Pimoroni Scroll pHAT HD](https://shop.pimoroni.com/products/scroll-phat-hd). It is essentially a learning vehicle for me to learn about Docker, Python, Raspberry Pi and things vaguely IoT. 

The Dockerfile builds an image that works with the [Pimoroni Scroll pHAT HD](https://shop.pimoroni.com/products/scroll-phat-hd) and specifically the [Pimoroni Scroll Bot](https://shop.pimoroni.com/products/scroll-bot-pi-zero-w-project-kit). 
It scrolls a single message infinitely or until the container is stopped. The message to scroll is configured via an environment variable (see below). 

The image runs a simple python script scroller-env.py which takes the value of the environment variable and scrolls it on the screen. The script is based on the 'Displaying Text' example in [Getting Started with Scroll pHAT HD](https://learn.pimoroni.com/tutorial/sandyj/getting-started-with-scroll-phat-hd). I've added code to get the message text from an environment variable and code to respond to SIGINT and SIGTERM events so that the script exits cleanly when the container is stopped.

Health Warning
==============
Please be aware that this is one of the first docker image I have built and the first time I've used Python. I have created this source code by following many "Getting started with..." articles. You are welcome to use this code and to learn from my mistakes, however I make no guarantees as to its functionality or suitability. 

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
   antelopeit/scroller-variable:stretch-python35-1.1
   
docker push \
   antelopeit/scroller-variable:stretch-python35-1.1

docker tag scroll-env-variable \
   antelopeit/scroller-variable:latest
   
docker push \
   antelopeit/scroller-variable:latest  
```

Changes
=======
The base image for the docker file is [balenalib/raspberry-pi-debian](https://hub.docker.com/r/balenalib/raspberry-pi-debian). Initially I used the [balenalib/raspberry-pi-python:3.7-stretch](https://hub.docker.com/r/balenalib/raspberry-pi-python) image however because it was using Python v3.7 it meant that numpy had to built as part of the build process. In an effort to reduce build times and complexity I tried using the balenalib/raspberry-pi-python:3.5.7-stretch-run as the base image so that the build could leverage pre-compiled versions of dependencies from [PiWheels](https://www.piwheels.org/), however, although the build times were reduced the code failed to run. After a day spent on google-bing-duck.duck.go I believe that the problem is down to an incompatibility between how Python modules are compiled for Raspbian and on PiWheels (with the FPECTL module) and Python on the Balena images (compiled without FPECTL). The solution appears to be (credit to Shaun Mulligan, Balena Team) to build the Docker image based on the simplest Balena PiZero Stretch image and then add Python to it via apt-get. Because I'm installing Python v3.5 with apt-get I also took the opportunity to install the python3-scrollphathd library at the same time. This in turn installs its dependencies (numpy, smbus etc.). As a result pip is nolonger required to install any dependencies, simplifying the build further.

Future
======
This version of the Scroller does what I intended it to do, and by changing the base image I have removed the need to build numpy, from the build process. With the exception of my Python script all packages and dependencies are from recognised sources. So although its possibe that I may update the image for newer versions of Raspbian and Python; Buster and v3.7 respectively I don't intend to add more functionality to this repository. Other versions of the Scroller are planned but these will be in separate repositories.   
