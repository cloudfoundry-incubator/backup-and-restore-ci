FROM debian@sha256:964a769b8787349054bda05223fd715dddbb9b3e1abdcb3ebad948e3b71503ef
RUN apt-get -y update && apt-get -y install \
    curl \
    gnupg \
    libdigest-sha-perl

# gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

# kapp
RUN curl -L https://k14s.io/install.sh | bash
