FROM relintdockerhubpushbot/cf-deployment-concourse-tasks:v5.19.0

# kubectl
ENV KUBE_VERSION="v1.11.2"
ADD https://storage.googleapis.com/kubernetes-release/release/$KUBE_VERSION/bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod +x /usr/bin/kubectl