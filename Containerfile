FROM frolvlad/alpine-glibc:alpine-3.17 as base-alpine

LABEL com.github.containers.toolbox="true" \
      name="alpine-toolbox" \
      version="3.17" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Alpine Linux toolbox containers" \
      maintainer="Robin Tully <robin.tully@pm.me>"

# Install extra packages
COPY extra-packages /
RUN apk update && \
    apk upgrade && \
    cat /extra-packages | xargs apk add
RUN rm /extra-packages

# Enable password less sudo
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox

# Copy the os-release file
RUN cp -p /etc/os-release /usr/lib/os-release

# Clear out /media
RUN rm -rf /media

RUN   ln -fs /bin/sh /usr/bin/sh && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
      ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
     