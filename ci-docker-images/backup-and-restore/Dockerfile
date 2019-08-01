FROM pcfplatformrecovery/backup-and-restore-minimal

RUN apt-get update
RUN apt-get install apt-transport-https
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" | \
  tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install -y ruby ruby-dev ruby-bundler file libssl-dev wbritish awscli lsb-release openjdk-8-jdk default-mysql-client azure-cli && \
  rm -rf /var/lib/apt/lists/*

RUN \
  apt-get update && \
  apt-get install netcat-openbsd

RUN git clone https://github.com/AGWA/git-crypt.git && \
 cd git-crypt/ && \
 make && sudo make install

RUN git config --global url."git@github.com:".insteadOf "https://github.com/"
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com > ~/.ssh/known_hosts

RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-18.09.0.tgz && \
  tar xvf docker-18.09.0.tgz && \
  chmod +x docker/* && \
  sudo cp docker/* /bin

# fixes error "Error response from daemon: client is newer than server"
ENV DOCKER_API_VERSION 1.23

ENV TERRAFORM_VERSION 0.12.5

RUN (wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_386.zip" && \
     unzip "terraform_${TERRAFORM_VERSION}_linux_386.zip" -d /bin/)

ENV CLOUD_SDK_VERSION 250.0.0

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk=${CLOUD_SDK_VERSION}-0 $INSTALL_COMPONENTS

RUN gem install cf-uaac

RUN \
  wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.2.0/credhub-linux-2.2.0.tgz -P /tmp && \
  tar xzvf /tmp/credhub-linux-2.2.0.tgz -C /usr/local/bin && \
  chmod +x /usr/local/bin/credhub

RUN \
  wget https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 -P /tmp && \
  mv /tmp/yq_linux_amd64 /usr/local/bin/yq && \
  chmod +x /usr/local/bin/yq

RUN \
  wget https://github.com/cloudfoundry/bosh-bootloader/releases/download/v8.1.1/bbl-v8.1.1_linux_x86-64 -P /tmp && \
  mv /tmp/bbl-v8.1.1_linux_x86-64 /usr/local/bin/bbl && \
  chmod +x /usr/local/bin/bbl

#for dig
RUN apt install --yes dnsutils

RUN useradd --create-home --shell /bin/bash test
