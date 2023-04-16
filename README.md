# Redirect Experiment

A demonstration of 2-virtual host reverse proxying to the same backend application

## Prerequisite

1. Configure domain for testing

Execute this on the host machine, not the container

```bash
$ echo "127.0.0.1 app1.domain.com app2.domain.com" >> /etc/hosts
```

## Development (Testing Locally)

1. Create Virtual Env

```bash
$ python3 -m venv ./venv
```

2. Activate Virtual Env

From the project directory

```bash
$ source ./venv/bin/activate
```

3. To deactivate Virtual env

```bash
$ deactivate
```

## Explanation

1. `server.py` - Serves as the backend service doing the redirect
2. `Apache Httpd` - The reverse proxy with 2 virtual host proxying to the `server.py`. `httpd-vhosts.conf` contains the virtual hosts configuration for 2 domains, namely: app1.domain.com and app2.domain.com.

    Apache server runs on port 80. Thus, when running the container, there is a need for portmapping.

3. `start.sh` - The startup script. Starts `server.py` in background mode listening on loopback interface at port 8000

## Building the Container

1. Build

From the project directory

```bash
$ docker build -t redir-expr:latest --no-cache .
```

2. Run

```bash
$ docker run -p 9000:80 -it redir-expr:latest
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
serving at port 8000
```

3. Test

    Do this on the host machine. Open terminal:

    ```bash
    $ curl -v -L http://app1.domain.com:9000/login
    *   Trying 127.0.0.1:9000...
    * Connected to app1.domain.com (127.0.0.1) port 9000 (#0)
    > GET /login HTTP/1.1
    > Host: app1.domain.com:9000
    > User-Agent: curl/7.86.0
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 301 Moved Permanently
    < Date: Sun, 16 Apr 2023 09:08:31 GMT
    < Server: SimpleHTTP/0.6 Python/3.9.2
    < Location: /home
    < Transfer-Encoding: chunked
    <
    * Ignoring the response-body
    * Connection #0 to host app1.domain.com left intact
    * Issue another request to this URL: 'http://app1.domain.com:9000/home'
    * Found bundle for host: 0x600003df48a0 [serially]
    * Can not multiplex, even if we wanted to
    * Re-using existing connection #0 with host app1.domain.com
    * Connected to app1.domain.com (127.0.0.1) port 9000 (#0)
    > GET /home HTTP/1.1
    > Host: app1.domain.com:9000
    > User-Agent: curl/7.86.0
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < Date: Sun, 16 Apr 2023 09:08:31 GMT
    < Server: SimpleHTTP/0.6 Python/3.9.2
    < Transfer-Encoding: chunked
    <
    * Connection #0 to host app1.domain.com left intact
    <foo>bar</foo>%

    $ curl -v -L http://app2.domain.com:9000/login
    *   Trying 127.0.0.1:9000...
    * Connected to app2.domain.com (127.0.0.1) port 9000 (#0)
    > GET /login HTTP/1.1
    > Host: app2.domain.com:9000
    > User-Agent: curl/7.86.0
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 301 Moved Permanently
    < Date: Sun, 16 Apr 2023 09:08:50 GMT
    < Server: SimpleHTTP/0.6 Python/3.9.2
    < Location: /home
    < Transfer-Encoding: chunked
    <
    * Ignoring the response-body
    * Connection #0 to host app2.domain.com left intact
    * Issue another request to this URL: 'http://app2.domain.com:9000/home'
    * Found bundle for host: 0x600002b608a0 [serially]
    * Can not multiplex, even if we wanted to
    * Re-using existing connection #0 with host app2.domain.com
    * Connected to app2.domain.com (127.0.0.1) port 9000 (#0)
    > GET /home HTTP/1.1
    > Host: app2.domain.com:9000
    > User-Agent: curl/7.86.0
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < Date: Sun, 16 Apr 2023 09:08:50 GMT
    < Server: SimpleHTTP/0.6 Python/3.9.2
    < Transfer-Encoding: chunked
    <
    * Connection #0 to host app2.domain.com left intact
    <foo>bar</foo>%
    ```

    Alternatively, you can also use a browser to verify the redirect behavior.
