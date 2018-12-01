FROM ubuntu:16.04

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
                       openbox \
                       wget \
                       g++ \
                       build-essential \
                       libmpich-dev \
                       libnss3 \
                       libxmu-dev \
                       libxslt-dev \
                       dcmtk \
                       libxi-dev \
                       libatlas-base-dev \
                       python3 \
                       python3-pip

ADD SimVascular-ubuntu-x64-2018.11.25.deb /code
RUN dpkg -i /code/SimVascular-ubuntu-x64-2018.11.25.deb && \
    ./usr/local/sv/simvascular/2018-11-25/setup-symlinks.sh && \
    export PATH=$PATH:/usr/local/sv/simvascular/2018-11-25

RUN wget https://download.open-mpi.org/release/open-mpi/v1.10/openmpi-1.10.7.tar.gz && \
    tar -xzvf openmpi-1.10.7.tar.gz && \
    cd openmpi-1.10.7 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install

RUN wget http://ftp.br.debian.org/debian/pool/main/i/icu/libicu52_52.1-8+deb8u7_amd64.deb && \
    dpkg -i libicu52_52.1-8+deb8u7_amd64.deb && \
    wget http://mitk.org/download/releases/MITK-Diffusion-2017.07/Linux/MITK-Diffusion-2017.07-linux64.tar.gz && \
    tar -xzvf MITK-Diffusion-2017.07-linux64.tar.gz && \
    cd MITK-Diffusion-2017.07-linux64

ADD SimVascular-ubuntu-x64-2018.11.25.deb /code
ADD svSolver-2017-08-14-Linux-64bit.deb /code
ADD svFSI-linux-x64-2018.07.03.deb /code
ADD LICENSE /code

RUN dpkg -i /code/svSolver-2017-08-14-Linux-64bit.deb && \
    dpkg -i /code/SimVascular-ubuntu-x64-2018.11.25.deb && \
    dpkg -i /code/svFSI-linux-x64-2018.07.03.deb && \
    ./usr/local/sv/simvascular/2018-11-25/setup-symlinks.sh && \
    bash /usr/local/sv/svFSI/2018-07-03/setup-symlinks.sh && \
    bash /usr/local/sv/svsolver/2017-08-14/setup-symlinks.sh

WORKDIR /code
ENTRYPOINT ["simvascular"]
