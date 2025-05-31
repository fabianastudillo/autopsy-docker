FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive

ENV JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64
ENV PATH=/opt/autopsy/bin:${JAVA_HOME}/bin:$PATH

RUN apt -y update && apt -y upgrade

RUN apt install -y apt-utils \
        curl \
        unzip \
        dnsutils \
        libafflib0v5 \
        libafflib-dev \
        libboost-all-dev \
        libboost-dev \
        libc3p0-java \
        libewf2 \
        libewf-dev \
        libpostgresql-jdbc-java \
        libpq5 \
        libpq-dev \
        libsqlite3-dev \
        libvhdi1 \
        libvhdi-dev \
        libvmdk1 \
        libvmdk-dev \
        libtool \
        openjfx \
        testdisk \
        xauth \
        x11-apps \
        x11-utils \
        x11proto-core-dev \
        x11proto-dev \
        xkb-data \
        xorg-sgml-doctools \
        xtrans-dev \
        libcanberra-gtk-module \
    && rm -rf /var/lib/apt/lists/*

RUN RELEASE=`curl -sI https://github.com/sleuthkit/autopsy/releases/latest \ 
    | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}'` \
    && echo ${RELEASE} \ 
    && RELEASE_PATH="sleuthkit/autopsy/releases/download/${RELEASE}/${RELEASE}_v2.zip" \
    && mkdir -p /opt \
    && cd /opt \
    && curl -L https://github.com/${RELEASE_PATH} > autopsy.zip \
    && unzip autopsy.zip \
    && mv ${RELEASE} autopsy
    
RUN cd /opt/autopsy/linux_macos_install_scripts \
    && sed -i  's/sudo //' install_prereqs_ubuntu.sh \
    && bash install_prereqs_ubuntu.sh

ENV TSK_JAVA_LIB_PATH=/usr/share/java

RUN RELEASE=`curl -sI https://github.com/sleuthkit/sleuthkit/releases/latest \
    |awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}'` \
    && ASSETS_PATH="/sleuthkit/sleuthkit/releases/expanded_assets/${RELEASE}" \
    && RELEASE_PATH=`curl -sL https://github.com/${ASSETS_PATH} \
        | grep -Eo 'href=".*\.deb' \
        | grep -v archive \
        | head -1 \
        | cut -d '"' -f 2` \
    && cd /opt \
    && curl -sL https://github.com/${RELEASE_PATH} > tsk_java.deb \
    && dpkg -i tsk_java.deb \
    || apt-get install -fy \
    && cd /opt/autopsy/ \
    && bash ./unix_setup.sh -j ${JAVA_HOME} -n "autopsy"
    
ENTRYPOINT ["autopsy"]
