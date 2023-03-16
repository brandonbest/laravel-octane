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

Tag the image to the top level:
```
docker build -t brandondbest/laravel-octane:8 .
```

Tag the image to a lower version:
```
docker build -t brandondbest/laravel-octane:8.1 .
```

## Push the Image

```
docker push brandondbest/laravel-octane
```

Push a tagged Image:
```
docker push brandondbest/laravel-octane:8;
docker push brandondbest/laravel-octane:8.1;
```

## Create the Image for Additional Processors

```
docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx build --platform linux/amd64,linux/arm64 -t brandondbest/laravel-octane:8 --push .
```