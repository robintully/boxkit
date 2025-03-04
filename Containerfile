FROM quay.io/toolbx-images/archlinux-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="robintully@pm.me"

RUN pacman -Syu --noconfirm

ARG user=makepkg

RUN useradd --system --create-home $user && \
  echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user

USER $user
WORKDIR /home/$user

# Install paru
RUN git clone https://aur.archlinux.org/paru.git && \
  cd paru && \
  makepkg -si --noconfirm && \
  cd && \
  rm -rf .cache paru

# Install my packages
COPY extra-packages .
RUN cat extra-packages | xargs paru -S --noconfirm --removemake
RUN rm extra-packages


# Become root again and do rooty things
USER root

RUN source /opt/asdf-vm/asdf.sh \
    && asdf plugin-add nodejs \
    && asdf plugin-add python


RUN mkdir -p /etc/skel/.local/share \
    && mv /root/.asdf /etc/skel/



RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree



     
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf


RUN echo "source /opt/asdf-vm/asdf.sh" >> /etc/profile ;\
    sed 's/PATH=/PATH=$HOME\/.local\/bin/g' -i /etc/profile