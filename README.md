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
docker build -t brandondbest/laravel-octane:8 -t brandondbest/laravel-octane:8-php8.1 .
```

## Push the Image

```
docker push brandondbest/laravel-octane
```

Push a tagged Image:
```
docker push brandondbest/laravel-octane:8;
docker push brandondbest/laravel-octane:8-php8.0;
docker push brandondbest/laravel-octane:8-php8.1;

# Laravel 9
docker push brandondbest/laravel-octane:9;
docker push brandondbest/laravel-octane:9-php8.0;
docker push brandondbest/laravel-octane:9-php8.1;
docker push brandondbest/laravel-octane:9-php8.2;

# Laravel 10
docker push brandondbest/laravel-octane:10;
docker push brandondbest/laravel-octane:10-php8.1;
docker push brandondbest/laravel-octane:10-php8.2;

#Laravel 11
docker push brandondbest/laravel-octane:11;
docker push brandondbest/laravel-octane:11-php8.2;
```

For information on the requirements for each Laravel version:
https://laravel.com/docs/10.x/releases

## Create the Image for Additional Processors

```
docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx build --platform linux/amd64,linux/arm64 -t brandondbest/laravel-octane:8 --push .
```