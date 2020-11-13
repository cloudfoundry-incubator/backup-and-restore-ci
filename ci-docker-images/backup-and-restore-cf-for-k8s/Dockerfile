FROM debian:stable-slim

RUN apt-get -y update && apt-get -y install \
    curl \
    wget \
    jq \
    gnupg \
    libdigest-sha-perl \
    make \
    git \
    dnsutils \
    gcc

# om
RUN wget -q -O - https://raw.githubusercontent.com/starkandwayne/homebrew-cf/master/public.key | apt-key add - && \
  echo "deb http://apt.starkandwayne.com stable main" | tee /etc/apt/sources.list.d/starkandwayne.list && \
  apt-get update && apt-get install om -y

# gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

# kapp
RUN curl -L https://k14s.io/install.sh | bash

# bosh-cli needed to install cf-for-k8s
ENV BOSH_CLI_VERSION="6.0.0"
ADD https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_CLI_VERSION}-linux-amd64 /usr/bin/bosh
RUN chmod +x /usr/bin/bosh

RUN \
  wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/kubeval-linux-amd64.tar.gz -C /tmp/ && \
  mv /tmp/kubeval /usr/local/bin/kubeval && \
  chmod +x /usr/local/bin/kubeval && \
  rm -rf /tmp/kubeval*


# kubectl
ENV KUBE_VERSION="v1.15.11"
ADD https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod +x /usr/bin/kubectl

ENV VELERO_VERSION v1.3.2
RUN \
  wget https://github.com/vmware-tanzu/velero/releases/download/${VELERO_VERSION}/velero-${VELERO_VERSION}-linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/velero-${VELERO_VERSION}-linux-amd64.tar.gz -C /tmp/ && \
  mv /tmp/velero-${VELERO_VERSION}-linux-amd64/velero /usr/local/bin/velero && \
  chmod +x /usr/local/bin/velero && \
  rm -rf /tmp/velero*

ENV PIVNET_VERSION 2.0.2
ADD https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} /usr/bin/pivnet
RUN chmod +x /usr/bin/pivnet

ENV GO_VERSION="1.14.2"
ENV GOPATH /go
ENV PATH /go/bin:/usr/local/go/bin:$PATH
RUN \
  wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local && \
  mkdir ${GOPATH} && \
  rm -rf /tmp/go*

RUN go get github.com/progrium/basht
RUN go get github.com/onsi/ginkgo/ginkgo

ENV YQ_VERSION 3.0.1
# yq
RUN \
  wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -P /tmp && \
  mv /tmp/yq_linux_amd64 /usr/local/bin/yq && \
  chmod +x /usr/local/bin/yq
