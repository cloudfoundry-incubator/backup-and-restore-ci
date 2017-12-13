FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y wget openssh-server git build-essential make jq

RUN wget https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.9.1.linux-amd64.tar.gz
ENV PATH "$PATH:/usr/local/go/bin"

RUN wget -O /cf-cli_amd64.deb https://cli.run.pivotal.io/stable?release=debian64
RUN dpkg -i /cf-cli_amd64.deb && rm /cf-cli_amd64.deb

CMD service ssh start
