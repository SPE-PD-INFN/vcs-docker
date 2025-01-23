# Use AlmaLinux as the base image
FROM centos:7

# Set environment variables
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=UTC

# Replace the yum repository configuration with the CentOS Vault repository
RUN rm -f /etc/yum.repos.d/CentOS-Base.repo && \
    cat <<EOF > /etc/yum.repos.d/CentOS-Base.repo
[base]
name=CentOS-7 - Base
baseurl=http://vault.centos.org/7.9.2009/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-7 - Updates
baseurl=http://vault.centos.org/7.9.2009/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-7 - Extras
baseurl=http://vault.centos.org/7.9.2009/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

###############################
# Install required dependencies
###############################
RUN yum update -y && \
    yum install -y \
    gcc \
    gcc-c++ \
    make \
    libX11 \
    libXext \
    libXtst \
    libXft \
    glibc-devel \
    perl \
    tcl \
    tk \
    tar \
    which \
    ncurses-libs \
    util-linux-user \
    zsh \
    git \
    curl \
    expect \
    time \
    redhat-lsb-core \
    libtool \
    libXScrnSaver \
    numactl \
    xauth && \
    yum clean all

#################
# Install ZSH/OMZ
#################
# Set Zsh as the default shell for the root user
RUN chsh -s /bin/zsh root
# Install Oh My Zsh
RUN curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \
    RUNZSH=no bash install.sh && \
    rm install.sh
# Add custom zsh
COPY aliases.zsh /root/.oh-my-zsh/custom
# Make eda directory
RUN mkdir -p /eda/synopsys

################
# Install LibZMQ
################
# Copy sources
COPY libzmq-v4.3.5.tar.gz /tmp/libzmq/
WORKDIR /tmp/libzmq
# Extract
RUN tar zxf libzmq-v4.3.5.tar.gz
WORKDIR /tmp/libzmq/libzmq-4.3.5
# Install
RUN ./autogen.sh
RUN ./configure --prefix=/usr
RUN make
RUN make install

#############
# Install VCS
#############
# Copy installer
COPY vcs-installer.tar /tmp/installer/
# Set up working directory
WORKDIR /tmp/installer/
# untar installer
RUN tar -xf vcs-installer.tar
# rm installer
RUN rm vcs-installer.tar
# Install
COPY accept_license.exp /tmp/accept_license.exp

ARG base_dir=/usr/synopsys
ARG tool=vcs
ARG version=V-2023.12
ARG installer_version=v5.7

RUN mkdir -p ${base_dir}
RUN /tmp/installer/SynopsysInstaller_${installer_version}.run -dir ${base_dir}/installer_${installer_version}
# Run installation script
RUN /usr/bin/expect /tmp/accept_license.exp

RUN rm -rf /tmp/installer/
RUN rm -rf ${base_dir}/installer_${installer_version}

WORKDIR /home/docker

# Define an entry point or default shell
CMD ["/bin/zsh"]

