FROM ubuntu:16.04
ADD install-zsh.sh second.sh /
RUN /install-zsh.sh