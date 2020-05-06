FROM debian:stable-slim

RUN apt-get -y update && apt-get -y install \
    curl \
    wget \
    jq \
    gnupg \
    libdigest-sha-perl \
    make


# gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

# kapp
RUN curl -L https://k14s.io/install.sh | bash

# bosh-cli needed to install cf-for-k8s
ENV BOSH_CLI_VERSION="6.0.0"
ADD https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_CLI_VERSION}-linux-amd64 /usr/bin/bosh
RUN chmod +x /usr/bin/bosh

# kubectl
ENV KUBE_VERSION="v1.15.11"
ADD https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod +x /usr/bin/kubectl

ENV VELERO_VERSION v1.3.2
RUN \
  wget https://github.com/vmware-tanzu/velero/releases/download/${VELERO_VERSION}/velero-${VELERO_VERSION}-linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/velero-${VELERO_VERSION}-linux-amd64.tar.gz -C /tmp/ && \
  mv /tmp/velero-${VELERO_VERSION}-linux-amd64/velero /usr/local/bin/velero && \
  chmod +x /usr/local/bin/velero
