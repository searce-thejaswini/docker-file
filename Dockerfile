FROM jenkins/jenkins
USER root
RUN apt-get update && apt-get install -y lsb-release wget gnupg software-properties-common
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli awscli
RUN wget -O- https://apt.releases.hashicorp.com/gpg |  gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg  --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
RUN apt-get update -y
RUN apt-get install terraform -y
RUN apt-get update -y
RUN apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev -y
RUN wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz
RUN tar -xf Python-3.8.10.tgz
RUN cd Python-3.8.10 && ./configure --enable-optimizations && make -j 8 && make altinstall
RUN wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64
RUN chmod +x /bin/hadolint
RUN apt-get install wget apt-transport-https gnupg lsb-release
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
RUN echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | tee -a /etc/apt/sources.list.d/trivy.list
RUN apt-get update -y
RUN apt-get install trivy jq -y
