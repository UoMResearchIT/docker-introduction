# Setup

> [!CAUTION]
> run some curls

# Dockerfiles

> [!NOTE]
> We are trying to add a plugin to SPUC
>
> A stats module so we can monitor the unicorns better

> [!CAUTION]
> First we need to make the Python file: stats.py
> 
> And open a terminal in the location of the file

Don't worry about the Python - it should just work and isn't the point of the lesson

```
curl https://raw.githubusercontent.com/UoMResearchIT/docker-introduction/refs/heads/main/code/SPUC-Stats/stats.py > stats.py
curl -L https://tinyurl.com/spuc-stats > stats.py
```

Let's remember what we were up to yesterday - we need this file in the container

We know the answer to this! Let's use a bind mount

No `-d` this time as we are debugging

```
docker kill spuc_container
```

```
docker run --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v ./stats.py:/spuc/plugins/stats.py -e EXPORT=true spuacv/spuc:latest --units iulu
```

Let's try the curl it suggests!

```bash
curl localhost:8321/export
```

Oh! No module named pandas! 

Of course... we need to install it. But if we do it interactively it wont persist?

What we want to do is change the Docker image itself. Let's get into how we create our own images!

## Creating Docker Images

So how are images made? With a recipe!

In Docker these recipes are called Dockerfiles and they contain terminal commands. 

Each command adds a layer to the image and lets us build up the image that we need.

All Dockerfiles start with a FROM This is the base image and starting point of the image

You can use any base image, including official ones (e.g. Ubuntu, Python)

The best fit for us right now though is the SPUC image itself!

> [!CAUTION]
> Lets start a file called "Dockerfile"

```dockerfile
# Dockerfile
FROM spuacv/spuc:latest
```

This is the simplest possible Dockerfile - it is just a recreation of the SPUC image

But how do we use this? We need ot build it (and tag it)

```
docker build -t spuc-stats ./
```

./ is current context we didn't need to specify the name of the file because Dockerfile is the default

There we go! We have built our first Docker image ourselves! Let's see it listed and give it a run

```
docker image ls
docker run --rm spuc-stats
```

Of course, we can still use the old options

```
docker run --rm --name spuc-stats_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v ./stats.py:/spuc/plugins/stats.py -e EXPORT=true spuc-stats --units iulu
```

Ah and yes, we still need to install pandas. 

Let's do that but adding a line to the Dockerfile using RUN

```dockerfile
RUN pip install pandas
```

```
docker build -t spuc-stats ./
docker run --rm --name spuc-stats_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v ./stats.py:/spuc/plugins/stats.py -e EXPORT=true spuc-stats --units iulu
```
Success! The plugin is loading. Let's try the endpoint we have created

```
curl localhost:8321/stats
```

Great progress! We've tailored the SPUC image to our needs and added a feature

But why stop there?

## COPY

It's annoying having to bind mount the plugin file 

Fine for dev but annoying to distribute

Let's add the plugin file to the Dockerfile

For this we use COPY - which copies from the host to the image

```dockerfile
COPY stats.py /spuc/plugins/stats.py
```

```
docker build -t spuc-stats ./
```

## Layers

You might note it now says `CACHED[2/3]` this is because we're adding layers! 

The FROM and RUN were already stored but the new layer has to be built

Now we can run - this time without the bind mount

> [!CAUTION]
> Remove stats bind

```
docker run --rm --name spuc-stats_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -e EXPORT=true spuc-stats --units iulu
```

Still working! And again... why stop there? 

Let's copy the print config

```dockerfile
COPY print.config /spuc/config/print.config
```

Build and run and drop the bind mount

```
docker build -t spuc-stats ./
```

> [!CAUTION]
> Remove print config bind

```
docker run --rm --name spuc_container -p 8321:8321 -v spuc-volume:/spuc/output -e EXPORT=True spuc-stats --units iulu
```

OMG a unicorn! Better log it!

```
curl -X PUT localhost:8321/unicorn_spotted?location=saturn&brightness=87
docker logs spuc_container
```

## ENV

What else can we do to improve the run command? 

Well... we have environment variables there 

They are set in Dockerfiles using ENV  

```dockerfile
ENV EXPORT=True
```

No need for the environment variable when we run now.

```
docker build -t spuc-stats ./
```
 
> [!CAUTION]
> Remove environment variable

```
docker run --rm --name spuc-stats_container -p 8321:8321 -v spuc-volume:/spuc/output spuc-stats --units iulu
```

Another small win!

## ARG

You can also use the command ARG in Dockerfiles, these are set only during a build

## ENTRYPOINT and CMD

We're on a roll! Let's set the units in the Dockerfile too?

Remember the idea of ENTRYPOINT and COMMAND?   
Let's set the ENTRYPOINT to be the run command and CMD to be the units

```dockerfile
ENTRYPOINT ["python", "/spuc/spuc.py"]
CMD ["--units", "iulu"]
```

Now we can omit the command in the run command

> [!CAUTION]
> Remove --units iulu

```
docker build -t spuc-stats ./
docker run --rm --name spuc-stats_container -p 8321:8321 -v spuc-volume:/spuc/output spuc-stats
```

What an improvement!

Customising environments for existing images is a valid use of Dockerfiles

Not the most common 

Usually one is making containers from the ground up 

But... This is how you dockerise your own applications!

## Building containers from the ground up

To have a look at a more standard Dockerfile

Let's do a case study on the SPUC image

> [!CAUTION]
> Back to slides

# Docker Compose

## Compose file

When using Compose, you make a single yaml file that defines your service

## Running a container

> [!CAUTION]
> First, let's make a file `compose.yml` 

And we write the first and most crucial element: service

```yaml
+ services:
```

And under this we add our first service (named spuc)

```yaml
services:
  spuc:                            # The name of the service  
    image: spuacv/spuc:latest      # The image to use
```

We no longer use docker run

Now we use docker compose

```
docker compose up
```

We can see the container has been automatically named 

A network has been created

It is runing in the foreground

Ctrl-C to exit

### Running in the background

An easy one first! 

Let's set the compose to run in the background

We can add -d to do this (detach)

```
docker compose up -d
docker compose logs
```

And check the logs to see it is running how we imagine

Except... the logs are here twice!

Because we didn't remove before - only stopped

### Removing the container when it stops

To make sure you remove the container we use down

```
docker compose down
```

You don't always need to remove 

Often you can reconfigure by running up

### Naming the container

Previously we could name the container, and we can add this to the compose

```diff
+    container_name: spuc_container            # The name of the container
```

```
docker compose up -d
```

#### Updating the compose file

It updated just fine without a down

### Exporting a port

If we try and record a unicorn sighting using curl

```
curl -X PUT localhost:8321/unicorn_spotted?location=asteroid&brightness=242
```

It fails! Because we haven't exposed the port

Let's add that to compose (as a list)

```diff
+    ports:                          # Starts the list of ports to map  
+      - 8321:8321                   # Maps port 8321 on the host to port 8321 in the container
```

```
docker compose up -d
curl -X PUT localhost:8321/unicorn_spotted?location=asteroid&brightness=242
```

Much better!

### Bind mounts

Now to more complex matters - let's bring in our old config files using bind mounts 

Confusingly, this is under the volumes tag

```diff
+    volumes:                                        # Starts the list of volumes/bind mounts  
+      - ./print.config:/spuc/config/print.config    # Bind mounts the print.config file
```

```
docker compose up -d
```

If you record a sighting - you should see the format change

As with the CLI, the volume command controls if bind or volume

- if path then it is a bind
- if name then it is a volume

### Volumes

And speak of the devil let's add our persistence volume

```diff
    volumes:  
+      - spuc-volume:/spuc/output                  # Mounts the volume named spuc-volume
```

```
docker compose up -d
```

Ah but this failed! 

We forgot to add the declaration of the volume (which doesn't happen automatically)

```diff
+ volumes:                                      # Starts section for declaring   
+  spuc-volume:                                # Declares a volume named 
```

```
docker compose up -d
```

Happier now! And it exposes a cool feature of compose Now we can remove volumes when containers are removed

```
docker volume ls
docker compose down -v
docker volume ls
```

### Setting an environment variable

The next job is adding our export environment variable   
This is done using environment

```diff
+    environment:                      # Starts list of environment variables to set  
+      - EXPORT=true                   # Sets the EXPORT environment variable to true
```
```
docker compose up -d     
docker compose logs
```

And we can see the endpoint has been activated!

### Overriding the default command

Finally, and most seriously, we need to address the units issue   
We can override the command in compose as well

```diff
+    command: ["--units", "iulu"]          # Overrides the default command
```

```
docker compose up -d
docker compose logs
```

And we can see the units have changed

### Enabling the plugin

So we are nearly back where we were! 

But we are missing our plugin 

We can add this back in using another bind mount?

```diff
+      - ./stats.py:/spuc/plugins/stats.py        # Mounts the stats.py plugin
```

```
docker compose up -d
docker compose logs
```

Oh no! That problem again! We still don't have pandas installed.

Not to worry - we can make our own images using compose too!

## Building containers in Docker Compose

We still have the Dockerfile from earlier!

Let's tell compose to use that using build

```diff
services:
  spuc:
  # image: spuacv/spuc:latest  
    build:                        # Instead of using the 'image' key, we u  
      context: .                  # Sets the build context (the directory in w  
      dockerfile: Dockerfile      # Sets the name of the Dockerfile
```

We have to be careful here - we need to instruct compose to rebuild if we have made changes You can do this explicitly or add it to the up command

```
docker compose up --build -d
docker compose logs
```

> [!CAUTION]
> (go to slides)

### Adding SPUCSVi to our Docker Compose file

```
docker compose up -d
docker compose logs
```

Now we're up and running! Let's have a look in the browser!

### Networks

We mentioned networks briefly, and are relying on the default network 

This connects all the containers in the compose together 

Since we are only using the browser we don't need the ports on SPUC any more 

Good for security

```diff
services:
  spuc:
    # ports:                            # We can remove these two lines  
    #   - 8321:8321
```

```
docker compose up -d
```

There we go! And if we try curl it will fail.

There is much more you can do with networks, including defining several 

This lets you isolate some services from others which can be good for security

#### Network names

Let's name a network explicitly

```
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

Here we have only defined one but you can add more this way.

### Depends on

Now, there is an unspoken problem here - what if SPUSVi starts before SPUC? 

Problems! But, we can control the startup sequence with compose 

Let's tell compose that spusvi depends on spuc

```
    depends_on:                     # Starts section for declaring dependencies  
      - spuc                        # Declares that the spucsvi service depends on the spuc service
```

However! This only checks SPUC is *started!* 

not if it is ready! 

To be sure SPUC is ready to answer we need to add a condition. 

Called a healthcheck And also add condition to the depends_on

```
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

> [!CAUTION]
> (slides for summary)
