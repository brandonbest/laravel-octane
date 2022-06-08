# Laravel Octane

A base Docker image for running Laravel Octane.

## Authenticate with Docker Hub
Create an access token:
https://hub.docker.com/settings/security

Login:
```
docker login -u <username>
```

## Build The Image
```
docker build -t brandondbest/laravel-octane .
```

Tag the image:
```
docker build -t brandondbest/laravel-octane:8 .
```

## Push the Image

```
docker push brandondbest/laravel-octane
```

Push a tagged Image:
```
docker push brandondbest/laravel-octane:8
```

## Create the Image for Additional Processors

```
docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx build --platform linux/amd64,linux/arm64 -t brandondbest/laravel-octane:8 --push .
```