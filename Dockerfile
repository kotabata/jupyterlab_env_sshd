####################################
# jupyterlab
# ngc pytorch + jax
# python 3.8 pytorch 1.9.0 cuda 11.2
####################################

FROM nvcr.io/nvidia/pytorch:21.03-py3

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
# timezone setting
ENV TZ=Asia/Tokyo

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    jq \
    ca-certificates \
    supervisor \
    libjpeg-dev \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    language-pack-ja \
    openssh-server \
    ufw \
    curl \
    vim \
    git \
    wget \
    unzip \
    tmux \
    sqlite3 \
    graphviz \
    libpng-dev \
    gnupg \
    gosu \
    graphviz \
    libjpeg-dev \
    libpng-dev \
    bzip2 \
    tree \
    nodejs \
    npm \
    sudo \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# install nodejs
RUN conda install -c conda-forge nodejs && \
    conda install -c conda-forge/label/gcc7 nodejs && \
    conda install -c conda-forge/label/cf201901 nodejs && \
    conda install -c conda-forge/label/cf202003 nodejs

# upgrade libralies
RUN /opt/conda/bin/pip install --no-cache-dir --upgrade \
    pip \
    jupyter-client \
    jupyter-core \
    jupyterlab \
    notebook \
    jupyterlab-server \
    jupyterlab \
    && rm -rf ~/.cache/pip

# install librarlies
ADD requirements.txt /tmp/requirements.txt
RUN /opt/conda/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    /opt/conda/bin/pip install --no-cache-dir numpyro[cuda111] -f https://storage.googleapis.com/jax-releases/jax_releases.html && \
    /opt/conda/bin/pip install --no-dependencies pyro-ppl \
    && rm -rf ~/.cache/pip

# add jupyter extensions
RUN /opt/conda/bin/jupyter lab build

# add user
RUN echo "root:root" | chpasswd
RUN mkdir /var/run/sshd

# SSHで使用する公開鍵をここでコピーする
COPY ./.ssh/authorized_keys /root/.ssh/authorized_keys
RUN chown root /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys
# SSHポートを公開する(Docker Composeで別のポートにバインドするので22番ポートのまま)
EXPOSE 22

# ssh設定ファイルの書換え
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV CONDA_PATH=/opt/conda
ENV JUPYTER_PATH=/opt/conda/envs/jupyter_env
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# add path
RUN echo "PATH=$PATH:/opt/conda/bin" >> /root/.bashrc && \
    echo "PATH=$PATH:/opt/cmake-3.14.6-Linux-x86_64/bin/" >> /root/.bashrc && \
    echo "PATH=$PATH:/opt/tensorrt/bin/" >> /root/.bashrc && \
    echo "PATH=$PATH:/usr/local/mpi/bin/" >> /root/.bashrc && \
    echo "PATH=$PATH:/usr/local/nvidia/bin/" >> /root/.bashrc && \
    echo "PATH=$PATH:/usr/local/cuda/bin/" >> /root/.bashrc && \
    echo "PATH=$PATH:/usr/local/ucx/bin/" >> /root/.bashrc

CMD ["/usr/sbin/sshd", "-D"]
