#
# centos:Harmony with license.properties file. See README.md for usage.
#
FROM centos

# Install wget & X11 libraries
RUN yum install -y \
	wget unzip telnet openssh-clients openssl net-tools ntp krb5-workstation krb5-libs krb5-auth-dialog git\
	&& yum -y update; yum clean all

# Define environment variables for product, version, etc.
ARG CLEO_PRODUCT=Harmony
ARG CLEO_INSTALL_FOLDER=/opt/harmony
ARG CLEO_PLATFORM=linux64-jre18
ARG CLEO_OS=Linux\(64-bit\)
ARG CLEO_VERSION=5.3
ARG PATCH=0.16
ARG CLEO_URL="http://www.cleo.com/SoftwareUpdate/harmony/release/jre1.8/InstData/$CLEO_OS/VM/install.bin" 
ARG MYSQL_JAR_URL=http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.24.zip
ARG POWER_TOYS_URL=https://raw.githubusercontent.com/jthielens/versalex-ops/master/tools/cleo-util.sh

# Download & install the desired product artifact
RUN wget --progress=bar:force $CLEO_URL -O install.bin \
  && chmod +x install.bin \
#COPY install.bin install.bin
#RUN chmod +x install.bin \
  && ./install.bin \
	-i silent \
	-DUSER_INSTALL_DIR=$CLEO_INSTALL_FOLDER \
  && ln -s ${CLEO_INSTALL_FOLDER}/${CLEO_PRODUCT}c /opt/VersaLexc \
  && rm ./install.bin 

# Download and install MYSQL jar
WORKDIR /tmp
RUN wget --progress=bar:force $MYSQL_JAR_URL -O mysql-connector-java-5.1.24.zip \
  && unzip mysql-connector-java-5.1.24.zip *.jar \
  && mv mysql-connector-java-5.1.24/mysql-connector-java-5.1.24-bin.jar $CLEO_INSTALL_FOLDER/lib/ext/. \
  && rm -rf mysql-connector-java-5.1.24

# Download and install Power Toys
RUN wget --progress=bar:force $POWER_TOYS_URL -O /usr/local/bin/cleo-util.sh \ 
   && chmod a+x /usr/local/bin/cleo-util.sh \
   && /usr/local/bin/cleo-util.sh githubdownload jthielens/power-toys p \
   && /usr/local/bin/cleo-util.sh githubdownload jthielens/power-toys dump \
   && /usr/local/bin/cleo-util.sh githubdownload jthielens/versalex-ops service/cleo-service \
   && /usr/local/bin/cleo-util.sh githubdownload jthielens/cleo-core shell.sh \
   && /usr/local/bin/shell.sh update

# Copy Bootstrap Script to Home
COPY bootstrap.sh $CLEO_INSTALL_FOLDER/.

# Generate a license using the given properties file
WORKDIR /tmp
COPY $CLEO_PRODUCT-license.properties license.properties 
ARG LICENSE_URL=http://10.10.1.57/nexus/service/local/artifact/maven/redirect?r=snapshots&g=com.cleo&a=LexLicGen&v=$CLEO_VERSION&e=jar
#RUN wget --progress=bar:force $LICENSE_URL -O license.jar \
#	&& if ! $CLEO_INSTALL_FOLDER/jre/bin/java -jar license.jar -f license.properties; \ 
COPY license.jar license.jar 
RUN  if ! $CLEO_INSTALL_FOLDER/jre/bin/java -jar license.jar -f license.properties; \ 
	then \
		mv license_key.txt $CLEO_INSTALL_FOLDER/license_key.txt \
		&& rm /tmp/license*; \ 
	fi

# Download and Install Patch
WORKDIR $CLEO_INSTALL_FOLDER
RUN wget --progress=bar:force "http://www.cleo.com/Web_Install/PatchBase_$CLEO_VERSION/$CLEO_PRODUCT/$PATCH/$PATCH.zip" -O patches.zip \
  && PRODUCT=$(ls *d | sed 's/.$//') \
  && echo $PRODUCT \
  && $CLEO_INSTALL_FOLDER/${PRODUCT}c -i patches.zip -m\
  && rm ./patches.zip

WORKDIR $CLEO_INSTALL_FOLDER
# Define the entry point
ENTRYPOINT ["/opt/VersaLexc"]
