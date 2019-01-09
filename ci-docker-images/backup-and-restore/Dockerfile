FROM cloudfoundrylondon/backup-and-restore-minimal

RUN apt-get update && \
  apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common && \
  rm -rf /var/lib/apt/lists/*

# docker-ce prerequisites
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# azure-cli prerequisites
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" | \
  tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN \
  apt-get update && \
  apt-get install -y \
   ruby \
   ruby-dev \
   ruby-bundler \
   file \
   libssl-dev \
   wbritish \
   awscli \
   lsb-release \
   openjdk-8-jdk \
   default-mysql-client \
   azure-cli \
   netcat-openbsd && \
   rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/AGWA/git-crypt.git && \
 cd git-crypt/ && \
 make && sudo make install

RUN git config --global url."git@github.com:".insteadOf "https://github.com/"
RUN mkdir -p ~/.ssh && ssh-keyscan -H github.com > ~/.ssh/known_hosts

RUN (wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_386.zip && unzip terraform_0.11.7_linux_386.zip -d /bin/)

ENV CLOUD_SDK_VERSION 178.0.0

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y \
    google-cloud-sdk=${CLOUD_SDK_VERSION}-0 $INSTALL_COMPONENTS && \
    rm -rf /var/lib/apt/lists/*

RUN gem install cf-uaac

RUN \
  wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.2.0/credhub-linux-2.2.0.tgz -P /tmp && \
  tar xzvf /tmp/credhub-linux-2.2.0.tgz -C /usr/local/bin && \
  chmod +x /usr/local/bin/credhub
