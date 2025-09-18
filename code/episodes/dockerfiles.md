
## Overview

## SETUP

run some curls

## Lesson

First we need to make the Python file: stats.py
And open a terminal in the location of the file

```python
from __main__ import app
from __main__ import file_path

import pandas as pd
import os

@app.route("/stats", methods=["GET"])
def stats():
    if not os.path.exists(file_path):
        return {"message": "No unicorn sightings yet!"}

    with open(file_path) as f:
        df = pd.read_csv(f)
        df = df.iloc[:, 1:]
        stats = df.describe()
        return stats.to_json()
```

Don't worry about the Python - it should just work and isn't the point of the lesson

Let's remember what we were up to yesterday - we need to load this file

We know the answer to this! Let's use a bind mount

No -d this time as we are debugging

```bash
docker kill spuc_container
docker run --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v ./stats.py:/spuc/plugins/stats.py -e EXPORT=true spuacv/spuc:latest --units iulu
```

Oh! No module named pandas! 
Of course... we need to install it. But if we do it interactively it wont persist?

What we want to do is change the Docker image itself. 
Let's get into how we create our own images!

## Creating Docker Images

So how are images made? With a recipe!

In Docker these recipes are called Dockerfiles and they contain terminal commands.
Each command adds a layer to the image and lets us build up the image that we need.

All Dockerfiles start with a FROM
This is the base image and starting point of the image

You can use any base image, including official ones (e.g. Ubuntu, Python)

The best fit for us right now though is the SPUC image itself! 

Lets start a file called "Dockerfile"

```Dockerfile
FROM spuacv/spuc:latest
```

This is the simplest possible Dockerfile - it is just a recration of the SPUC image

But how do we use this? We need ot build it (and tag it)

```bash
docker build -t spuc-stats ./
```

./ is current context
we didn't need to specify the name of the file because Dockerfile is the default

There we go! We have built our first Docker image ourselves! 
Let's see it listed and give it a run

```bash
docker image ls
```
```bash
docker run --rm spuc-stats
```

Of course, we can still use the old options 

```bash
docker run --rm --name spuc-stats_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v ./stats.py:/spuc/plugins/stats.py -e EXPORT=true spuc-stats --units iulu
```

Ah and yes, we still need to install pandas. 
Let's do that but adding a line to the Dockerfile using RUN

```Dockerfile
RUN pip install pandas
```
```bash
$ docker build -t spuc-stats ./
```
```bash
docker run --rm --name spuc-stats_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v ./stats.py:/spuc/plugins/stats.py -e EXPORT=true spuc-stats --units iulu
```
Success! The plugin is loading. 
Let's try the endpoint we have created
```bash
curl localhost:8321/stats
```

Great progress! We've tailored the SPUC image to our needs and added a feature
But why stop there?

## COPY

It's annoying having to bind mount the plugin file
Fine for dev but annoying to distrbute
Let's add the plugin file to the Dockerfile

For this we use COPY - which copies from the host to the image

```Dockerfile
COPY stats.py /spuc/plugins/stats.py
```
```bash
docker build -t spuc-stats ./
```

## Layers

You might note it now says CACHED[2/3] this is because we're adding layers!
The FROM and RUN were already stored but the new layer has to be built

Now we can run - this time without the bind mount 

```bash
docker run --rm --name spuc-stats_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -e EXPORT=true spuc-stats --units iulu
```

Still working! And again... why stop there?
Let's copy the print config

```Dockerfile
COPY print.config /spuc/config/print.config
```
Build and run and drop the bind mount

```bash
docker build -t spuc-stats ./
docker run --rm --name spuc_container -p 8321:8321 -v spuc-volume:/spuc/output -e EXPORT=True spuc-stats --units iulu
```

OMG a unicorn! Better log it!

```bash
curl -X PUT localhost:8321/unicorn_spotted?location=saturn\&brightness=87
```
```bash
docker logs spuc_container
```

## ENV

What else can we do to improve the run command?
Well... we have environment variables there
They are set in Dockerfiles using ENV

```Dockerfile
ENV EXPORT=True
```

No need for the environment variable when we run now.

```bash
docker build -t spuc-stats ./
docker run --rm --name spuc-stats_container -p 8321:8321 -v spuc-volume:/spuc/output spuc-stats --units iulu
```

Another small win!

## ARG

You can also use the command ARG in Dockerfiles, these are set only during a build

## ENTRYPOINT and CMD

We're on a roll! 
Let's set the units in the Dockerfile too?
Remember the idea of ENTRYPOINT and COMMAND?
Let's set the ENTRYPOINT to be the run command and CMD to be the units

```Dockerfile
ENTRYPOINT ["python", "/spuc/spuc.py"]
CMD ["--units", "iulu"]
```
Now we can ommit the command in the run command

```bash
docker build -t spuc-stats ./
docker run --rm --name spuc-stats_container -p 8321:8321 -v spuc-volume:/spuc/output spuc-stats
```

What an improvement! 

Customising environments for existing image is a valid use of Dockerfiles but not the most common
Usually one is making containers from the group up for applications which are not containerised.

## Building containers from the ground up

To have a look at a more standard Dockerfile. 
Let's do a case study on the SPUC image 

--- Back to slides ---
