FROM balenalib/raspberry-pi-python:3.7-stretch-build

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN  pip install -r requirements.txt

RUN  pip install smbus

ENV MESSAGE_TO_SCROLL 'Please Set A Message'
COPY . .

CMD [ "python", "./scroller-env.py" ]
