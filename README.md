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
```

3. Test

    Do this on the host machine. Open terminal:

    ```bash
    $ curl -v -L http://app1.domain.com:9000/login
    $ curl -v -L http://app2.domain.com:9000/login
    ```

    Alternatively, you can also use a browser to verify the redirect behavior.
