FROM ubuntu:18.04

# docker build -t vanessa/simvascular .
# docker tag vanessa/simvascular:latest vanessa/simvascular:2020-04
# docker push vanessa/simvascular
# singularity pull docker://vanessa/simvascular:2020-04

LABEL Maintainer vsochat@stanford.edu
ENV DEBIAN_FRONTEND noninteractive
ENV LD_LIBRARY_PATH=/code/SimVascularSrc/BuildWithMake/Bin/QtWebEngine:/code/SimVascularSrc/BuildWithMake/Lib/x64_linux

RUN apt-get update && \
    apt-get install -y git apt-utils wget

WORKDIR /code

# Prepare for install, file shouldn't have "sudo" hard-coded in it
RUN git clone https://github.com/SimVascular/SimVascular.git SimVascularSrc && \
    cd SimVascularSrc/Externals/Prep/2019.06 && \
    sed -i 's/sudo//g' ubuntu-18-prep.sh && \
    ./ubuntu-18-prep.sh

RUN cd /code/SimVascularSrc/BuildWithMake && \
    /bin/bash quick-build-linux.sh

# Install some version of open MPI https://www.open-mpi.org/software/ompi/v4.0/
RUN wget https://download.open-mpi.org/release/open-mpi/v1.10/openmpi-1.10.7.tar.gz && \
    tar -xzvf openmpi-1.10.7.tar.gz && \
    cd openmpi-1.10.7 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install

# also look in BuildWithmake/Bin
ENTRYPOINT ["/code/SimVascularSrc/BuildWithMake/sv"]
