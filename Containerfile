FROM ghcr.io/void-linux/void-linux:latest-full-x86_64

LABEL com.github.containers.toolbox="true" \
      name="alpine-toolbox" \
      version="3.17" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Alpine Linux toolbox containers" \
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

# Installing Mamba Forge
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
RUN bash Mambaforge-$(uname)-$(uname -m).sh -b
