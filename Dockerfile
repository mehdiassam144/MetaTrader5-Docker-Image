from ghcr.io/linuxserver/baseimage-kasmvnc:debianbullseye-8446af38-ls104 as base

# set version label
arg BUILD_DATE
arg version
label build_version="Metatrader Docker:- ${VERSION} Build-date:- ${BUILD_DATE}"
label maintainer="gmartin"

env TITLE=Metatrader5
env WINEPREFIX="/config/.wine"

# Update package lists and upgrade packages
run apt-get update && apt-get upgrade -y

# Install required packages
run apt-get install -y \
    python3-pip \
    wget \
    && pip3 install --upgrade pip

# Add WineHQ repository key and APT source
RUN wget -q https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' \
    && rm winehq.key

# Add i386 architecture and update package lists
RUN dpkg --add-architecture i386 \
    && apt-get update

# Install WineHQ stable package and dependencies
RUN apt-get install --install-recommends -y \
    winehq-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


COPY /Metatrader /Metatrader
RUN chmod +x /Metatrader/start.sh
COPY /root /

EXPOSE 3000 8001
VOLUME /config
