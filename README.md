# standalone-apache-felix
A script to start a standalone Apache Felix instance, and lets you pick specific bundles to install from the apache Felix mirror or from a maven repository!

There is also a docker container, see below!

> This is tested on MacOS only.

Demo running locally from shell script:

![Demo](https://raw.githubusercontent.com/ahmed-musallam/standalone-apache-felix/master/doc/demo.gif)


## Running

### Running locally without docker
> Tested on MacOs Only

```sh
./start.sh
```

### Running with Docker

##### From Docker Hub

```sh
docker run -it -p 8080:8080 ahmedmusallam/standalone-apache-felix:latest
```

Docker will download the image from docker hub and run for you!

##### From Source

Clone this repo then:

1. Build image: 

  ```sh
  docker build -t local-standalone-felix -f "Dockerfile" .
  ```

2. Run image you've just built:
  
  ```sh
  docker run -it -p 8080:8080 local-standalone-felix
  ```


> I've created a utility shell script to make the above commands easier. You can run `./container.sh build run` which is effectively the same as the above. There is also `./container.sh kill` which kills the container.



## Configuring

The `start.sh` shell script has a few configurable variables in the `CONFIG VARIABLES` section.
Take a look at that file, everything is commented there.

If using docker, you must build the image after you make changes.