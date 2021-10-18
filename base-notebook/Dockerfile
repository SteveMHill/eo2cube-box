FROM ubuntu:20.04


SHELL [ "/bin/bash", "--login", "-c" ]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -q update \
 && apt-get install -yq  build-essential \
    libpq-dev \
    gcc \
    wget \
    python3.9 \
    python3-pip \
    ca-certificates \
    sudo \
    git \
    npm \
    locales \
    fonts-liberation \
    run-one \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Create a non-root user
ARG username=datacube
ARG uid=1000
ARG gid=100
ENV USER $username
ENV UID $uid
ENV GID $gid
ENV HOME /home/$USER

RUN adduser --disabled-password \
    --gecos "Non-root user" \
    --uid $UID \
    --gid $GID \
    --home $HOME \
    $USER


ENV MINICONDA_VERSION latest
ENV CONDA_DIR $HOME/miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -O ~/miniconda.sh && \
    chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH
RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.profile
RUN conda init bash

RUN conda update --name base --channel defaults conda && \
    conda install -c conda-forge mamba && \
    conda clean --all --yes
    
RUN mamba install --quiet --yes \
    'notebook=6.4.0' \
    'jupyterlab=3.*' \
    'beautifulsoup4=4.9.*' \
    'xarray' \
    'datacube' \
    'conda-forge::blas=*=openblas' \
    'cython=0.29.*' \
    'h5py=3.1.*' \
    'matplotlib-base=3.3.*' \
    'pandas=1.1.*' \
    'protobuf=3.14.*' \
    'scikit-learn=0.24.*' \
    'seaborn=0.11.*' \
    'statsmodels=0.12.*' \
    'geopandas=0.9.*'  \
    'rioxarray=0.4*'  \
    'hvplot=0.7*' \
    'graphviz=2.40*' \
    'dask=2021.4.1' \
    'rasterstats=0.14.*' \
    'cartopy=0.19.*' && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    jupyter notebook --generate-config && \
    jupyter lab clean && \
    rm -rf /home/$NB_USER/.cache/yarn 

RUN pip3 install ciso8601 psycopg2-binary~=2.8.6 odc-algo odc-cloud odc-dscache odc-io odc-stats odc-ui odc-stac
RUN pip3 install --extra-index-url="https://packages.dea.ga.gov.au" odc-apps-dc-tools

USER $USER
RUN mkdir $HOME/products
COPY products $HOME/products
RUN mkdir $HOME/jupyter
WORKDIR $HOME/jupyter

CMD [ "jupyter", "lab", "--no-browser", "--ip", "0.0.0.0" ]
