FROM ubuntu:16.04

MAINTAINER Abraham Arce "xe1gyq@gmail.com"

ARG ANACONDA_VERSION=5.3.1

ENV TIMEZONE America/Mexico_City
ENV USER root

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    bzip2 && \
    rm -rf /var/lib/apt/lists/*

#RUN python3 -m pip3 install --upgrade pip

RUN groupadd user && \
    useradd -g user -s /bin/bash -d /home/user -m user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER user
WORKDIR /home/user

RUN curl -O https://repo.continuum.io/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh

RUN bash Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -b -p /home/user/conda && \
    sudo ln -s /home/user/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /home/user/conda/etc/profile.d/conda.sh" >> /home/user/.profile && \
    echo ". /home/user/conda/etc/profile.d/conda.sh" >> /home/user/.bashrc && \
    echo "conda activate base" >> /home/user/.profile && \
    echo "conda activate base" >> /home/user/.bashrc && \
    . /home/user/conda/etc/profile.d/conda.sh && \
    conda update conda && \
    conda config --add channels intel && \
    conda create -n idp intelpython3_core python=3
    #conda activate idp

RUN . /home/user/conda/etc/profile.d/conda.sh && \
    conda install jupyter && \
    python -m ipykernel install --user --name idp --display-name "Python (idp)"

RUN . /home/user/conda/etc/profile.d/conda.sh && \
    conda activate idp && \
    conda install \
    keras \
    tensorflow \
    tensorflow-gpu \
    scikit-learn \
    matplotlib \
    pandas \
    seaborn
    #conda install --quiet --yes && \
    #notebook \
    #jupyterhub \
    #jupyterlab

CMD ["/bin/bash"]
