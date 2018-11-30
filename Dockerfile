FROM ubuntu:18.04

# docker build -t vanessa/simvascular .
# docker tag vanessa/simvascular:latest vanessa/simvascular:2018-11-25
# docker push vanessa/simvascular
# singularity run docker://vanessa/simvascular

LABEL Maintainer vsochat@stanford.edu
ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/sv/simvascular/2018-11-25

RUN mkdir -p /code && \
    apt-get update && \
    apt-get install -y libssl1.0.0 \
                       libssl-dev \
                       libx11-6 \
                       libxss1 \
                       libgl1-mesa-glx \
                       libxtst6 \
                       xorg \ 
                       libgomp1 \
                       libasound2 \
                       openbox

ADD SimVascular-ubuntu-x64-2018.11.25.deb /code
RUN dpkg -i /code/SimVascular-ubuntu-x64-2018.11.25.deb && \
    ./usr/local/sv/simvascular/2018-11-25/setup-symlinks.sh && \
    export PATH=$PATH:/usr/local/sv/simvascular/2018-11-25

WORKDIR /code
ENTRYPOINT ["simvascular"]
