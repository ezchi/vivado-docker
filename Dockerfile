FROM ubuntu:18.04 as base

MAINTAINER Enze Chi <Enze.Chi(at)Gmail.com>

# Install dependences for:
# * downloading Vivado (wget)
# * xsim (gcc build-essential to also get make)
# * MIG tool (libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig)
RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > \
  /etc/apt/apt.conf.d/01norecommend && \
  apt-get update && apt-get install -y \
  build-essential \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  lsb-release \
  wget && \
  apt-get clean


COPY install_config.txt /
COPY vivado /tmp

RUN echo "Installing vivado"
RUN echo "${PWD}"
RUN ls
RUN /tmp/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config install_config.txt
RUN rm -rf /tmp/*


# make a Vivado user
RUN adduser --disabled-password --gecos '' vivado
USER vivado
WORKDIR /home/vivado
# add vivado tools to path
RUN echo "source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh" >> /home/vivado/.bashrc

# Copy in the license file
RUN mkdir /home/vivado/.Xilinx
# COPY Xilinx.lic /home/vivado/.Xilinx/
