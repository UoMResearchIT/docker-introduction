
## Overview

## Compose file

When using Compose, you make a single yaml file that defines your service

## Running a container

First, let's make a file `docker-compose.yml`
And we write the first and most crucial element: service

```yml
services:
```

And under this we add our first service (named spuc)

```yml
services:
  spuc:                            # The name of the service
    image: spuacv/spuc:latest      # The image to use
```

We no longer use docker run however
Now we use docker compose


```bash
docker compose up
```

We can see the container has been automatically named
A network has been created
It is runing in the foreground

### Running in the background

An easy one first! Let's set the compose to run in the background
We can add -d to do this (detach)

```bash
$ docker compose up -d
```

```bash
docker compose logs
```

And check the logs to see it is running how we imagine

Except... the logs are here twice!

Because we didn't remove before - only stopped

### Removing the container when it stops

To make sure you remove the container we use down

```bash
docker compose down
```

You don't always need to remove
Often you can reconfigure by running up

### Naming the container

Previously we could name the container, and we can add this to the compose

```yml
+    container_name: spuc_container            # The name of the container
```
```bash
docker compose up -d
```

#### Updating the compose file

It updated just fine without a down

### Exporting a port

If we try and record a unicorn sighting using curl

```bash
curl -X PUT localhost:8321/unicorn_spotted?location=asteroid\&brightness=242
```

It fails! Because we haven't exposed the port

Let's add that to compose (as a list)

```yml
+    ports:                          # Starts the list of ports to map
+      - 8321:8321                   # Maps port 8321 on the host to port 8321 in the container
```
```bash
docker compose up -d
```
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=asteroid\&brightness=242
```

Much better!

### Bind mounts

Now to more complex matters - let's bring in our old config files using bind mounts
Confusingly, this is under the volumes tag

```yml
+    volumes:                                        # Starts the list of volumes/bind mounts
+      - ./print.config:/spuc/config/print.config    # Bind mounts the print.config file
```
```bash
docker compose up -d
```

If you record a sighting - you should see the format change

As with the CLI, the volume command controls if bind or volume
- if path then it is a bind
- if name then it is a volume

### Volumes

And speak of the devil let's add our persistence volume

```yml
    volumes:
+      - spuc-volume:/spuc/output                  # Mounts the volume named spuc-volume
```
```bash
docker compose up -d
```

Ah but this failed! 
We forgot to add the declaration of the volume (which doesn't happen automatically)

```yml
+ volumes:                                      # Starts section for declaring volumes
+  spuc-volume:                                # Declares a volume named spuc-volume
```
```bash
docker compose up -d
```

Happier now! And it exposes a cool feature of compose 
Now we can remove volumes when containers are removed

```bash
$ docker volume ls
$ docker compose down -v
$ docker volume ls
```
### Setting an environment variable

The next job is adding our export environement variable
This is done using environment 

```yml
+    environment:                      # Starts list of environment variables to set
+      - EXPORT=true                   # Sets the EXPORT environment variable to true
```
```bash
docker compose up -d
docker compose logs
```

And we can see the endpoint has been activated!

### Overriding the default command

Finally, and most serously, we need to address the units issue
We can override the command in compose as well

```yml
+    command: ["--units", "iulu"]          # Overrides the default command
```
```bash
docker compose up -d
docker compose logs
```

And we can see the units have changed

### Enabling the plugin

So we are nearly back where we were! But we are missing our plugin
We can add this back in using another bind mount?

```yml
+      - ./stats.py:/spuc/plugins/stats.py        # Mounts the stats.py plugin
```
```bash
docker compose up -d
```
```bash
docker compose logs
```

Oh no! That problem again! We still don't have pandas installed.

Not to worry - we can make our own images using compose too!

## Building containers in Docker Compose

We still have the Dockerfile from earlier! 
Let's tell compose to use that using build

```yml
services:
  spuc:
  # image: spuacv/spuc:latest
    build:                        # Instead of using the 'image' key, we use the 'build' key
      context: .                  # Sets the build context (the directory in which the Dockerfile is located)
      dockerfile: Dockerfile      # Sets the name of the Dockerfile
```

We have to be careful here - we need to instruct compose to rebiuld if we have made changes
You can do this explicitly or add it to the up command

```bash
docker compose up --build -d
docker compose logs
```

(go to slides)

### Adding SPUCSVi to our Docker Compose file

```bash
docker compose up -d
docker compose logs
```

Now we're up and running! Let's have a look in the browser!

### Networks

We mentioned networks briefly, and are relying on the default network
This connects all the containers in the compose together
Since we are only using the browser we don't need the ports on spuc any more
Good for security

```yml
services:
  spuc:
    # ports:                            # We can remove these two lines
    #   - 8321:8321
```
```bash
docker compose up -d
```

There we go! And if we try curl it will fail.

There is much more you can do with networks, including defining serveral
This lets you isolate some services from others which can be good for security

#### Network names

Let's name a network explicitly

```yml
services:
  spuc:
    networks:                         # Starts list of networks to connect this service to
      - spuc_network                  # Connects to the spuc_network network

  spucsvi:
    networks:                         # Starts list of networks to connect this service to
      - spuc_network                  # Connects to the spuc_network network

networks:                             # Starts section for declaring networks
  spuc_network:                       # Declares a network for spuc
    name: spuc_network                # Specifies the name of the network
```

Here we have ony defined one but you can add more this way.

### Depends on

Now, there is an unspoken problem here - what if SPUSVi starts before SPUC?
Problems!
But, we can control the startup sequence with compose
Let's tell compose that spusvi depends on spuc

```yml
    depends_on:                     # Starts section for declaring dependencies
      - spuc                        # Declares that the spucsvi service depends on the spuc service
```
However! This only checks SPUC is *started!* nto if it is ready!
To be sure SPUC is ready to answer we need to add a condition.
Called a healthcheck
And also add condition to the depends_on

```yml
services:
  spuc:
    healthcheck:                                                  # Starts section for declaring healthchecks
      test: ["CMD", "curl", "--fail", "http://spuc:8321/export"]  # Specifies the healthcheck command (ran from inside the container)
      interval: 3s                                                # Specifies the interval between healthchecks
      timeout: 2s                                                 # Specifies the timeout for the healthcheck
      retries: 5                                                  # Specifies the number of retries before failing completely

  spucsvi:
    depends_on:
      spuc:                                                       # This changed from a list (- spuc) to a mapping (spuc:)
        condition: service_healthy                                # Specifies further conditions for starting the service
```

Now SPUCSVi won't start until SPUC is ready.

There are simulations in the notes to see this in action.

(slides for summary)
