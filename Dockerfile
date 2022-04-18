FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing
RUN apt-get install -y ubuntu-server \
	build-essential \
	zsh \
	python3-pip


ARG UNAME=ubuntu
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} ${UNAME}
RUN useradd -m -u ${UID} -g ${GID} -s /bin/bash ${UNAME}
RUN echo "${UNAME} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

RUN chsh -s $(which zsh) ${UNAME}

USER $UNAME
WORKDIR /home/${UNAME}
RUN git clone https://github.com/Homebrew/brew .linuxbrew
RUN .linuxbrew/bin/brew update --force --quiet
ENV PATH="/home/${UNAME}/.linuxbrew/bin:${PATH}"

RUN git clone https://github.com/DE0CH/dotfiles.git
RUN chmod +x dotfiles/setup.sh
RUN sh dotfiles/setup.sh
RUN rm .zshrc || true
RUN rm .p10k.zsh || true
RUN ln -s dotfiles/.zshrc .zshrc
RUN ln -s dotfiles/.p10k.zsh .p10k.zsh
