FROM pcfplatformrecovery/backup-and-restore-minimal

ENV YQ_VERSION 2.4.0
ENV CLOUD_SDK_VERSION 250.0.0
ENV TERRAFORM_VERSION 0.12.16

ENV CREDHUB_CLI_VERSION 2.5.2
ENV BBL_VERSION v8.2.12

# fixes error "Error response from daemon: client is newer than server"
ENV DOCKER_API_VERSION 1.23

ENV DEBIAN_FRONTEND=noninteractive

# update mirrors
RUN ["/bin/bash", "-c", "set -o pipefail && \
  echo \"deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main\" | \
  tee /etc/apt/sources.list.d/azure-cli.list"]
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
RUN ["/bin/bash", "-c", "set -o pipefail && \
  curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -"]

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  awscli \
  azure-cli \
  default-mysql-client \
  dnsutils \
  file \
  libssl-dev \
  lsb-release \
  netcat-openbsd \
  openjdk-8-jdk \
  ruby \
  ruby-bundler \
  ruby-dev \
  wbritish \
  && rm -rf /var/lib/apt/lists/*

# gcloud
RUN ["/bin/bash", "-c", "set -o pipefail && \
  export CLOUD_SDK_REPO=\"cloud-sdk-$(lsb_release -c -s)\" && \
  echo \"deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main\" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update && apt-get install -y google-cloud-sdk=${CLOUD_SDK_VERSION}-0 && rm -rf /var/lib/apt/lists/*"]

# git-crypt
RUN git clone https://github.com/AGWA/git-crypt.git && \
  cd git-crypt/ && \
  make && sudo make install

RUN git config --global url."git@github.com:".insteadOf "https://github.com/" && \
  mkdir -p ~/.ssh && ssh-keyscan -H github.com > ~/.ssh/known_hosts

RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-18.09.0.tgz && \
  tar xvf docker-18.09.0.tgz && \
  chmod +x docker/* && \
  sudo cp docker/* /bin

RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_386.zip" && \
  unzip "terraform_${TERRAFORM_VERSION}_linux_386.zip" -d /bin/

# uaac
RUN gem install cf-uaac

# credhub
RUN \
  wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_CLI_VERSION}/credhub-linux-${CREDHUB_CLI_VERSION}.tgz -P /tmp && \
  tar xzvf /tmp/credhub-linux-${CREDHUB_CLI_VERSION}.tgz -C /usr/local/bin && \
  chmod +x /usr/local/bin/credhub

# yq
RUN \
  wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -P /tmp && \
  mv /tmp/yq_linux_amd64 /usr/local/bin/yq && \
  chmod +x /usr/local/bin/yq

# bbl
RUN \
  wget https://github.com/cloudfoundry/bosh-bootloader/releases/download/${BBL_VERSION}/bbl-${BBL_VERSION}_linux_x86-64 -P /tmp && \
  mv /tmp/bbl-${BBL_VERSION}_linux_x86-64 /usr/local/bin/bbl && \
  chmod +x /usr/local/bin/bbl

RUN useradd --create-home --shell /bin/bash --home-dir /home/test test

