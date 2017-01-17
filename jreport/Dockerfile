#
# CentOs:JReport
#

FROM centos

# Install wget & X11 libraries
RUN yum install -y \
        wget unzip telnet openssh-clients git\
        && yum -y update; yum clean all

# Define environment variables for product, version, etc.
ARG CLEO_PRODUCT=JReport
ARG CLEO_INSTALL_FOLDER=/opt/jreport
ARG CLEO_PLATFORM=Linux\(64-bit\)
ARG CLEO_VERSION=12.1.3
#ARG CLEO_URL=http://10.10.1.57/nexus/service/local/artifact/maven/content?r=cleo&g=com.cleo.installers&a=$CLEO_PRODUCT&v=$CLEO_VERSION&e=bin&c=$CLEO_PLATFORM
ARG CLEO_URL=http://www.cleo.com/SoftwareUpdate/$CLEO_PRODUCT/release/jre1.7/InstData/$CLEO_PLATFORM/VM/install.bin
ARG MYSQL_JAR_URL=http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.24.zip
ARG RMI_HOST_NAME=jreport

# Download & install the desired product artifact
RUN wget --progress=bar:force $CLEO_URL -O install.bin \
#COPY install.bin install.bin 
  && chmod +x install.bin \
  && ./install.bin \
	-i silent \
	-DUSER_INSTALL_DIR=$CLEO_INSTALL_FOLDER \
  && rm ./install.bin \
# This is required to change RMI hostname lookup from Harmony
  && sed -i -e"s/^\(server.rmi.host=\).*/\1$RMI_HOST_NAME/" $CLEO_INSTALL_FOLDER/bin/server.properties


# Download and install MYSQL jar
WORKDIR /tmp
RUN wget --progress=bar:force $MYSQL_JAR_URL -O mysql-connector-java-5.1.24.zip \
  && unzip mysql-connector-java-5.1.24.zip *.jar \
  && mv mysql-connector-java-5.1.24/mysql-connector-java-5.1.24-bin.jar $CLEO_INSTALL_FOLDER/lib/. \
  && rm -rf mysql-connector-java-5.1.24



WORKDIR $CLEO_INSTALL_FOLDER

ENTRYPOINT ["/opt/jreport/bin/NJRServer.sh"]
