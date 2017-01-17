#
# centos:VLProxy. See README.md for usage.
#
FROM centos

# Install wget
RUN yum install -y \
	wget net-tools unzip expect\
	&& yum -y update; yum clean all

# Define environment variables for product, version, etc.
ENV CLEO_PRODUCT=VLProxy \
	CLEO_INSTALL_FOLDER=/opt/vlproxy
ARG CLEO_PLATFORM=linux64-jre18
ARG CLEO_VERSION=5.3-SNAPSHOT
ARG CLEO_URL=http://www.cleo.com/SoftwareUpdate/vlproxy/release_3.5.1.6/jre1.8/InstData/Linux(64-bit)/VM/install.bin
ARG CLEO_CACHE=true
ARG VERSALEX_SERIALS=HY1234-CJ5678

# Download & install the desired product artifact
RUN wget --progress=bar:force $CLEO_URL -O install.bin \
  && chmod +x install.bin \
  && ./install.bin \
	-i silent \
	-DUSER_INSTALL_DIR=$CLEO_INSTALL_FOLDER \
  && rm ./install.bin 

WORKDIR $CLEO_INSTALL_FOLDER

COPY configure.sh configure.sh
RUN ./configure.sh $CLEO_INSTALL_FOLDER $VERSALEX_SERIALS 

COPY change_serial.sh change_serial.sh
RUN chmod +x change_serial.sh

# Define the entry point
ENTRYPOINT ["/opt/vlproxy/VLProxyc"]
