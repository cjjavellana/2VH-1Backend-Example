FROM httpd

RUN apt update && \
  apt install -y curl python3 procps less && \
  mkdir /app 

COPY ./server.py /app
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY ./start.sh /app

WORKDIR /app

CMD [ "./start.sh" ]