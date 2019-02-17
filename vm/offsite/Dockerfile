FROM centos:7

RUN yum update -y && \
yum install -y git rpm rpm-build vim java-1.8.0-openjdk-devel wget unzip curl nano && \
yum clean all

# Install Maven
RUN wget http://www.eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz && \
tar -xvzf apache-maven-3.6.0-bin.tar.gz -C /opt

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-5.2.1-bin.zip && \
unzip -d /opt gradle-5.2.1-bin.zip

# Add Gradle and Maven to PATH
RUN echo export PATH=/opt/apache-maven-3.6.0/bin:/opt/gradle-5.2.1/bin:\$PATH >> /root/.bashrc

# Install Cloud Foundry CLI
RUN wget -O /etc/yum.repos.d/cloudfoundry-cli.repo https://packages.cloudfoundry.org/fedora/cloudfoundry-cli.repo && \
yum install -y cf-cli && \
yum clean all

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
