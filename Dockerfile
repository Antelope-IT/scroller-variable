FROM balenalib/raspberry-pi-debian:stretch

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -yq \
  python3 \
  python3-scrollphathd && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ENV MESSAGE_TO_SCROLL 'Please Set A Message'

COPY . .

CMD [ "python3", "./scroller-env.py" ]
