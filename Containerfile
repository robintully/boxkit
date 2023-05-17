FROM ghcr.io/void-linux/void-linux:latest-full-x86_64

LABEL com.github.containers.toolbox="true" \
      name="void-toolbox" \
      version="3.17" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Void Linux toolbox containers" \
      maintainer="Robin Tully <robin.tully@pm.me>"


# Install extra packages
COPY extra-packages /
RUN xbps-install -Syu  $(cat extra-packages)

# Enable password less sudo
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox

# Copy the os-release file
# RUN cp -p /etc/os-release /usr/lib/os-release

# Clear out /media
RUN rm -rf /media

# Void Only Stuff
ENV TEMP_DIR=/var/home/robin/.local/bin
RUN mkdir -p $TEMP_DIR
WORKDIR $TEMP_DIR



# Installing Mamba Forge
ENV MAMBAFORGE_DIR=$TEMP_DIR/mambaforge
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
RUN bash Mambaforge-$(uname)-$(uname -m).sh -b -p $MAMBAFORGE_DIR/mambaforge

# Install NVM
ENV NODE_VERSION=16.17.1
ENV NVM_DIR=$TEMP_DIR/nvm
WORKDIR $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules

WORKDIR /