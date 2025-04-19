# Berghain Browser Validator

Berghain is a browser validator application based on the [DropMorePackets/berghain](https://github.com/DropMorePackets/berghain) project. It uses HAProxy and integrates with a custom SPOE (Stream Processing Offload Engine) for request validation. This repository provides a Dockerized implementation of the application, making it easy to deploy and start validating HTTP requests in your environment.

## Features

- Browser-based request validation using HAProxy and SPOE.
- Rate-limiting and custom logic based on request attributes.
- Lightweight deployment using Docker.
- Pre-configured with default validation rules.

## Prerequisites

- Docker must be installed on your system.

## Getting Started


### 1. Set Environment Variables

The application uses several environment variables to configure its behavior. These variables can be passed to the container through an `.env` file or by using the `--env` flag during `docker run`. Below is an explanation of each environment variable:

| Environment Variable | Description                                                                                      | Default Value |
|-----------------------|--------------------------------------------------------------------------------------------------|---------------|
| `ALLOW_GIT`          | Set this to `true` to allow requests with User-Agent `git/`                                     | `false`       |
| `X_FORWARD_FOR`      | Set this to `true` to respect the `X-Forwarded-For` header in requests                          | `false`       |
| `BACKEND_PORT`       | The port number of the backend application to which valid requests are forwarded                | `80`          |
| `BACKEND_HOST`       | The hostname or IP address of the backend application to which valid requests are forwarded     | N/A           |

**Note:** Replace `env.list` with your respective `.env` file containing the above variables:

Example `env.list`:

```
ALLOW_GIT=true
X_FORWARD_FOR=true
BACKEND_PORT=8081
BACKEND_HOST=backend-service
```

### 2. Deploy

#### Use the Pre-built Docker Container (Recommended)

To quickly deploy the application, you can use the pre-built Docker image available on GitHub Container Registry:

```bash
docker run -d -p 8080:8080 --env-file=env.list ghcr.io/fionera/berghain-proxy:master
```

---

#### Build and Run the Docker Container Locally

If you wish to customize or inspect the Dockerfile, you can also build the container locally and deploy it:

```bash
docker build -t berghain-browser-validator .
docker run -d -p 8080:8080 --env-file=env.list berghain-browser-validator
```


### 4. Access the Service

Once the container is running, you can access the Berghain browser validator via:

```
http://<docker-host>:8080
```

### 5. Backend Configuration

Make sure your backend application is running and accessible using the `BACKEND_HOST` and `BACKEND_PORT` values. If these are not set correctly, Berghain will respond with a `503 Service Unavailable` error for unresolved backends.

## Customization

You can modify the proposed behavior of request handling by editing the `haproxy.cfg` file. Common modifications include:

- Adjusting the request rate limits.
- Modifying backend configuration.
- Adding custom rules for User-Agent access.

Once changes are made, rebuild the Docker image and restart the container to apply updates.

## Exposed Port

The container exposes port **8080** by default, which is configured in the `Dockerfile` and HAProxy.

## Disclaimer

This implementation is a Dockerized wrapper of the original [Berghain](https://github.com/DropMorePackets/berghain) project. Please visit the official repository for more details on how the core system works.
