FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# set compilation environment for python
ENV PYTHON_CONFIGURE_OPTS=--enable-shared
ENV CPPFLAGS=-O2

ARG PYTHON_VERSION=3.8.9
ARG PYINSTALLER_VERSION=3.6

ENV PYPI_URL=https://pypi.python.org/
ENV PYPI_INDEX_URL=https://pypi.python.org/simple
ENV PYENV_VERSION=${PYTHON_VERSION}

RUN \
    set -x \
    # update system
    && apt-get update \
    # install requirements
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        wget \
        git \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libffi-dev \
        #upx
        libgdbm6 \
        uuid-dev \
        upx \
        tk-dev \
        file \
        openssl \
    # install pyenv
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && . ~/.bashrc \
    && curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init --path)"' >> ~/.bashrc \
    && . ~/.bashrc \
    # install python
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && export PATH="$HOME/.pyenv/bin:$PATH" \
    && eval "$(pyenv init --path)" \
    && eval "$(pyenv virtualenv-init -)" \
    && pip install --upgrade pip \
    # install pyinstaller
    && pip install pyinstaller==$PYINSTALLER_VERSION \
    && mkdir /src/

VOLUME /src/
WORKDIR /src/
