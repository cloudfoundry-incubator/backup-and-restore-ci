FROM ubuntu:trusty

ENV go_version 1.12.4

RUN apt-get update
RUN apt-get install -y wget openssh-server git build-essential make jq

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN \
  wget https://golang.org/dl/go${go_version}.linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/go${go_version}.linux-amd64.tar.gz -C /usr/local && \
  mkdir ${GOPATH} && \
  rm -rf /tmp/*

RUN wget -O /cf-cli_amd64.deb https://cli.run.pivotal.io/stable?release=debian64
RUN dpkg -i /cf-cli_amd64.deb && rm /cf-cli_amd64.deb

CMD service ssh start
