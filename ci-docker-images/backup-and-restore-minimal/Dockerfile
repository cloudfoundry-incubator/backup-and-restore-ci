FROM ubuntu:bionic

ENV go_version 1.11.5

RUN \
  apt-get update && \
  apt-get install -y sudo unzip jq sshuttle parallel vim wget curl git && \
  rm -rf /var/lib/apt/lists/*

ENV GOPATH /go
ENV PATH /go/bin:/usr/local/go/bin:$PATH
RUN \
  wget https://golang.org/dl/go${go_version}.linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/go${go_version}.linux-amd64.tar.gz -C /usr/local && \
  mkdir ${GOPATH} && \
  rm -rf /tmp/*

RUN go get github.com/onsi/ginkgo/ginkgo
RUN go get github.com/onsi/gomega

RUN \
  wget https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 --output-document="/usr/bin/dep" && \
  chmod +x /usr/bin/dep

RUN \
  wget https://github.com/pivotal-cf/om/releases/download/0.42.0/om-linux --output-document="/usr/bin/om" && \
  chmod +x /usr/bin/om

RUN (curl -L "https://cli.run.pivotal.io/stable?version=6.36.1&release=linux64-binary&source=github" | tar -zx) && \
   mv cf /usr/bin && \
   chmod +x /usr/bin/cf

RUN \
  wget https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-5.0.1-linux-amd64 --output-document="/usr/bin/bosh-cli" && \
  cd /usr/bin && \
  echo "f1f1ee58a7eb872568c85db19a17b697990a7452 bosh-cli" | sha1sum -c - && \
  chmod +x bosh-cli

RUN ln -s /usr/bin/bosh-cli /usr/bin/bosh

