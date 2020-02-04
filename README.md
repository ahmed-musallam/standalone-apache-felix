# standalone-apache-felix
A script to start a standalone Apache Felix instance, and lets you pick specific bundles to install from the apache felix mirror or from a maven repository!

There is also a docker container, see below!

> This is tested on MacOS only.

Demo running locally:
![Demo](doc/demo.gif)


## Running

### Locally without docker
> Tested on MacOs Only

```sh
./start.sh
```

### With Docker

#### MacOs (shortcut shell script)
build and run image

```sh
./container.sh build run
```

kill running image

```sh
./container.sh kill
```

#### Windows (or anywhere else):

build and run image

```sh
docker build -t standalone-felix -f "Dockerfile" .
docker run -it -p 8080:8080 standalone-felix
```


## Configuring

The `start.sh` shell script has a few configurable variables in the `CONFIG VARIABLES` section.
Take a look at that file, everything is commented there.

If using docker, you must build the image after you make changes