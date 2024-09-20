FROM --platform=linux/amd64 python:3.8.6-slim 

# Arguments
ARG DEFAULT_USER
ARG HOST_GID
ARG SUDO_PASSWORD
ARG HTTPS_PROXY

# Binary release versions
ARG VERSION_NERDFONTS=3.2.1
ARG VERSION_NEOVIM=0.10.1

# ------------------------


# Replace sources, APT over HTTPS
#COPY pkgs/sources.list /etc/apt/sources.list

# HTTPS
#ENV HTTPS_PROXY=${HTTPS_PROXY}

# Update
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    bash \
    curl \
    fontconfig \
    git \
    ripgrep \
    sudo \
    unzip \
    wget \
    zsh

# User
RUN  useradd ${DEFAULT_USER} && \ 
  usermod -aG sudo ${DEFAULT_USER} && \
  echo ${DEFAULT_USER}:${SUDO_PASSWORD} | chpasswd && \
  mkdir /home/${DEFAULT_USER} && \
  mkdir -p /home/${DEFAULT_USER}/.config && \
  chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER} && \
  echo "${DEFAULT_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudoers

# Nerdfonts
RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v${VERSION_NERDFONTS}/FiraCode.zip && \
  unzip FiraCode.zip -d /usr/share/fonts && \
  fc-cache -fv

# ZSH and oh-my-zsh
USER root
RUN chsh -s /bin/zsh

USER $DEFAULT_USER
WORKDIR /home/$DEFAULT_USER
RUN echo "Setting up ohMyZsh..." && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  ZSH_CUSTOM="/home/${DEFAULT_USER}/.oh-my-zsh/custom" && \
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" && \
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" && \
  cd /home/${DEFAULT_USER}/.oh-my-zsh/plugins && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git && \
  git clone https://github.com/zsh-users/zsh-completions.git && \
  git clone https://github.com/zsh-users/zsh-history-substring-search.git && \
  git clone https://github.com/zsh-users/zsh-autosuggestions.git

RUN echo "Applying dotfiles..." && \
  git clone https://github.com/hoentschrode/dotfiles && \
  rm /home/${DEFAULT_USER}/.zshrc && \
  ln -s /home/${DEFAULT_USER}/dotfiles/zsh/.zshrc /home/${DEFAULT_USER}/.zshrc && \
  ln -s /home/${DEFAULT_USER}/dotfiles/nvim /home/${DEFAULT_USER}/.config/nvim

# NeoVim
USER root
WORKDIR /tmp
RUN apt-get -y install ninja-build gettext cmake unzip curl build-essential && \
  git clone https://github.com/neovim/neovim.git && \
  cd neovim && \
  git checkout v${VERSION_NEOVIM}
RUN cd neovim && \ 
  make CMAKE_BUILD_TYPE=Release && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local/nvim install && \
  ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim && \
  rm -rf /tmp/neovim

# Cleanup
USER root
RUN apt clean all

# Permissions
USER root
RUN chown -R ${DEFAULT_USER} /home/${DEFAULT_USER}/ && \
    chown -R ${DEFAULT_USER} /usr/local/sbin

# Expose runtime ports
EXPOSE 8080 8081 8082 8083 8084 8085

# Entrypoint
USER $DEFAULT_USER
WORKDIR /home/$DEFAULT_USER
CMD [ "zsh" ] 
