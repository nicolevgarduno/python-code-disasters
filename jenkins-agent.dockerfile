# Base image: Jenkins inbound agent with JDK 17
FROM jenkins/inbound-agent:latest-jdk17

USER root

# Install git, wget, unzip (needed for any downloads or git checkout)
RUN apt-get update && \
    apt-get install -y git wget unzip curl && \
    rm -rf /var/lib/apt/lists/*

# Install SonarScanner CLI using official SonarSource image
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.14.0.42357-linux.zip -O /tmp/sonar-scanner.zip && \
    unzip /tmp/sonar-scanner.zip -d /opt && \
    rm /tmp/sonar-scanner.zip

# Add SonarScanner to PATH
ENV PATH="/opt/sonar-scanner-5.14.0.42357-linux/bin:${PATH}"

# Switch back to jenkins user
USER jenkins
