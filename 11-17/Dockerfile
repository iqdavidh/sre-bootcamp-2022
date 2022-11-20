FROM ubuntu:20.04
ARG APP_ENV
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_REGION

ENV TERM linux
ENV DEVIAN_FRONTEND noninteractive

# Add AWS credentials condition (we can't use COPY in a conditional sentence)
RUN mkdir /.aws &&  mkdir /root/.aws && echo "[default]\nregion=$AWS_REGION\noutput=json" > /.aws/config
RUN echo "[default]\naws_access_key_id=$AWS_ACCESS_KEY_ID\naws_secret_access_key=$AWS_SECRET_ACCESS_KEY" > /.aws/credentials

RUN apt-get update && apt-get install -y gnupg software-properties-common wget apt-get install openssh-client

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

RUN apt update && apt-get install terraform



WORKDIR /usr/data

