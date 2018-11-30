FROM ubuntu:14.04

# docker build -t vanessa/simvascular .
# docker tag vanessa/simvascular:latest vanessa/simvascular:2018-11-25
# docker push vanessa/simvascular
# singularity run docker://vanessa/simvascular

LABEL Maintainer vsochat@stanford.edu
ENV DEBIAN_FRONTEND noninteractive
ENV PATH $PATH:/usr/local/sv/simvascular/2018-11-25

RUN mkdir -p /code && \
    apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-4.9 g++-4.9
    
RUN apt-get install -y libssl1.0.0 \
                       libssl-dev \
                       libx11-6 \
                       libxss1 \
                       libxslt-dev \
                       libgl1-mesa-glx \
                       libxtst6 \
                       xorg \ 
                       libgomp1 \
                       libasound2 \
                       dcmtk \
                       libicu52 \
                       openbox \
                       libgstreamer0.10-0 \
                       libgstreamer-plugins-base0.10-dev \
                       libxi-dev \
                       libxmu-dev \
                       libmpich2-dev \
                       libatlas-base-dev \
                       libnss3 \
                       openmpi-bin \
                       openmpi-common \ 
                       libopenmpi-dev \
                       wget 

RUN wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz && \
    tar -xzvf openmpi-3.1.2.tar.gz && \
    cd openmpi-3.1.2 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install

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
