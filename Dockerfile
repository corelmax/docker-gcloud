FROM docker:stable

RUN apk add --update make ca-certificates openssl python
RUN update-ca-certificates
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz
RUN tar zxvf google-cloud-sdk.tar.gz && ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true
RUN google-cloud-sdk/bin/gcloud --quiet components update
RUN curl -L -o - https://github.com/corelmax/hum/archive/0.0.1.tar.gz | tar -xvzf -
RUN cd hum* && cp bin/hum /hum