# Docker Desktop

Just to get concept right.
Not available for Linux.
Freemium.


## Dashboard
We will look at **Containers** and **Images** only.  
**Search** bar at the top to search for images.


## Getting images
Search and pull of SPUC container: **spuacv-spuc**  
Click on image to see **docs**.  
Show how to select a **tag**.  
Option to ***run*** or ***pull***.

also pull **hello-world** and **alpine** images.


## Inspecting images
Images tab shows list showing spuc, alpine and hello-world.

Click on image name to inspect.
Go to **vulnerabilities** and start analysis.

Important to check, but this is ok, verified image **python:3-slim**.

## Running 

Images are **immutable snapshots** of an environment, to be used as **templates**.

Containers are **executions of images**, they are running, and become **mutable**.

Run the **hello-world** image using the button from Images tab - confirm Run on prompt.

We are on the **Containers tab** now.  
Look at the **random name**.  
Look at Logs, Inspect, Bind mounts, Exec, Files, Stats tabs.  
It seems like the container has **already stopped**.  
Status says "Exited 0".  
Run again, **from the container**.  
Look at repeated output.

Run again, but **from the images** tab.
Look at new random name.

Nature of containers is usually **ephemeral**.  
Look at container list on Containers tab. They are both stopped.  
Why 2 and not 1 or 3?  
Run another hello-world container form the images tab to see a third.


## Interacting with containers

Not all containers are short lived. Run the **spuc** container.  
Docs say we need to **expose 8321**, so do that on **optional settings**.  
Container is still running. Confirm this on Containers tab.  
Click on name of the container to go back to its logs.

Image: Containers list, spuc still running.

### Spot a unicorn!
From a terminal:
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100
```

The docs mention we can configure the print with the `print.config` file.
Open the terminal tab in the container.
```bash
pwd
ls
apt update
apt install nano
nano config/print.config
```
chango to
```
::::: {time} Unicorn number {count} spotted at {location}!! Brightness: {brightness} {units}
```
Then try another curl:
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=200
```
Confirm change in the printed logs.

The container is **like a VM**... but it is **not meant to**... it is meant to be ephemeral.  
Lets stop the container.  
Confirm the status is exited.

Run another spuc image **from the images** tab (**no port**).  
Try to cat the `config/print.config` file.  
Look for nano in the terminal.  
This is a new container, not the same we modified.  
Check container list.


## Reviving containers

Go back to containers list and click on start on the first spuc container.  
It is running again, and we can see the config and we have nano.


## Naming containers

Lets try adding a name to the container.  
Run a new spuc container **from the images** tab, and name it **SPUC** (**no port**).

In the container list, it is easier to find... but we didn't map the port!  
Try to use same name again, it fails.  
We cannot reuse names, we need to clean up.


## Cleaning up

From container list, delete container called **SPUC**.

From image list, try to delete `hello-world`.  
It says it is **in use**.

Delete all the containers.  
Make sure it says **unused** now. Try again.


## Limitations - Why not Docker Desktop?

Limited in how you can run the containers.

Run **alpine**. Nothing happens.


## Show keypoints slide


--------------------------------------------------
--------------------------------------------------

# Building our Docker CLI toolkit


## Pulling and Listing Images
```bash
docker pull spuacv/spuc:latest
```

## The structure of a Docker command
**Image:** A diagram showing the syntactic structure of a Docker command

## Listing Images
```bash
docker image ls
```

## Inspecting
```bash
docker inspect spuacv/spuc:latest
```
```bash
docker inspect spuacv/spuc:latest -f "Command: {{.Config.Cmd}}"
```
```bash
docker inspect spuacv/spuc:latest -f "Entrypoint: {{.Config.Entrypoint}}"
```
```bash
docker inspect spuacv/spuc:latest -f $'Command: {{.Config.Cmd}}\nEntrypoint: {{.Config.Entrypoint}}'
```

## Default Command
**Image:** A diagram representing the lifecycle of a container

### Further examples of container lifecycle
**Image:** Further details and examples of the lifecycle of a container


## Running
```bash
docker run spuacv/spuc:latest
```
Use `Ctrl+C` to stop the container.
```bash
docker run -d spuacv/spuc:latest
```

## Listing Containers
```bash
docker ps
```
```bash
docker ps -a
```

## Logs
Use *container name*, not image name:
```bash
docker logs ecstatic_nightingale
```
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100
```
*Error!* port was not exposed.

## Exposing ports
```bash
docker run -d -p 8321:8321 spuacv/spuc:latest
```
```bash
docker ps
```
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100
```
```bash
docker logs unruffled_noyce
```

## Setting the name of a container
```bash
docker run -d --name spuc_container -p 8321:8321 spuacv/spuc:latest
```
*Error!* **port** already in use, we need to **stop and delete**.
```bash
docker stop unruffled_noyce
docker rm unruffled_noyce
```

### Killing containers
```bash
docker kill ecstatic_nightingale
```

Now we can re-run with the name:
```bash
docker run -d --name spuc_container -p 8321:8321 spuacv/spuc:latest
```
We can also follow the logs:
```bash
docker logs -f spuc_container
```

## Executing commands in a running container
We can execute commands in a running container:
```bash
docker exec spuc_container cat config/print.config
```
Or run an interactive session:
```bash
docker exec -it spuc_container bash
```
```bash
apt update
apt install tree
tree
```
We can get out with `Ctrl+D` or `exit`.


## Interactive sessions
```bash
docker run -it alpine:latest
```

## Reviving Containers
```bash
docker kill spuc_container
docker ps
```
```bash
docker start spuc_container
```
```bash
docker ps
docker stats
```
And exit with `Ctrl+C`.

## Cleaning up
```bash
docker kill spuc_container
```
```bash
docker rm spuc_container
```
```bash
docker image rm alpine:latest
```
```bash
docker system prune
```

### Automatic cleanup
```bash
docker run -d --rm --name spuc_container -p 8321:8321 spuacv/spuc:latest
```
This is a relatively standard command.  
It will get worse.

Already ahead of Docker Desktop, but lets do more, like persist data.


## Show keypoints slide


--------------------------------------------------
--------------------------------------------------


# Sharing information with containers


Containers are ephemeral, but we want our unicorn sightings to persist.

## Volumes
Managed by Docker, hidden away in file system.  
They are declared with `name:path`:
**-v spuc-volume:/spuc/output**

```bash
docker kill spuc_container
docker run -d --rm --name spuc_container -p 8321:8321 -v spuc-volume:/spuc/output spuacv/spuc:latest
```
```bash
docker volume ls
```

### Inspecting the volume
```bash
docker volume inspect spuc-volume
```

Now let's spot some unicorns!
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100
curl -X PUT localhost:8321/unicorn_spotted?location=earth\&brightness=10
curl -X PUT localhost:8321/unicorn_spotted?location=mars\&brightness=400
```
```bash
docker exec spuc_container cat /spuc/output/unicorn_sightings.txt
```
Kill the container and make sure it was removed:
```bash
docker kill spuc_container
docker ps -a
```
And run it again, using **the same volume**, and check for the sightings:
```bash
docker run -d --rm --name spuc_container -p 8321:8321 -v spuc-volume:/spuc/output spuacv/spuc:latest
docker exec spuc_container cat /spuc/output/unicorn_sightings.txt
```


## Bind mounts
Managed by the user, can be handy, can be dangerous.  
They are declared with `path:path`:
**-v ./spuc/output:/spuc/output**

```bash
docker kill spuc_container
docker run -d --rm --name spuc_container -p 8321:8321 -v ./spuc/output:/spuc/output spuacv/spuc:latest
```
Now let's spot some unicorns!
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=mercury\&brightness=400
cat spuc/output/unicorn_sightings.txt
```
Kill the container and make sure it was removed:
```bash
docker kill spuc_container
ls spuc/output
```
The directory is now in our current wd.
If we use the same bind mount, we can see the sightings:
```bash
docker run -d --rm --name spuc_container -p 8321:8321 -v ./spuc/output:/spuc/output spuacv/spuc:latest
cat spuc/output/unicorn_sightings.txt
```
```bash
ls -l spuc/unicorn_sightings.txt
```
In some versions of docker, this might be owned by root!


### Bind mount files
We can bind mount individual files, like the print config.
First we create the file:
```bash
echo "::::: {time} Unicorn number {count} spotted at {location}! Brightness: {brightness} {units}" > print.config
```
Then we kill the running container and mount it in:
```bash
docker kill spuc_container
docker run -d --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output spuacv/spuc:latest
```
Register a sighting:
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=jupyter\&brightness=210
docker logs spuc_container
```

This file can be edited while the container runs. For example:
```bash
echo "::::: Unicorn number {count} spotted at {location}! Brightness: {brightness} {units}" > print.config
```
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=venus\&brightness=148
docker logs spuc_container
```

**Warning:** We replaced the file in the container with the file from the host filesystem.  
We could do the same with a whole directory, but be careful not to overwrite important files in the container!

## ! Challenge: Common mistakes with volumes
```bash
docker run -v spuc-vol spuacv/spuc:latest
```
**Problem:** Missing path to mount volume. It uses /spuc-vol in the container, but it wont persist!  
**Fix:** You only messed up the container, nothing to worry about. Stop it and try again.

```bash
docker run -v ./spucs/output:/spuc/output spuacv/spuc:latest
```
**Problem:** You misspelled the path! This will create a new directory called **spucs** and mount it.  
**Fix:** Use sudo rm -rf ./spucs to remove the directory and try again.

```bash
ocker run -v ./spuc-vol:/spuc/output spuacv/spuc:latest
```
**Problem:** `path:path` Therefore, bind mount, and will create **spuc-vol**.  
**Fix:** Use sudo rm -rf ./spuc-volume to remove the directory and try again.

```bash
docker run -v ./spuc:/spuc spuacv/spuc:latest
```
**Problem:** Replaced everything in the container with empty! Could not find /spuc/spuc.py.  
**Fix:** You only messed up the container, nothing to worry about. Try again.

```bash
docker run -v print.config:/spuc/config/print.config spuacv/spuc:latest
```
**Problem:** `name:path`, so volume... However, print.config is not a directory.  
**Fix:** Use docker volume rm print.config to remove the volume and try again.


## Show keypoints slide


--------------------------------------------------
--------------------------------------------------


# Docker Hub

Is there anything else we could do?
Let's look at the docs... but where?


## Introducing the Docker Hub
Docs live in Dockerhub, a container image repository.  
You do not *need* dockerhub to be able to docker.

Open your web browser to https://hub.docker.com  
In the search bar type “spuc” and hit enter.  
Select the spuacv/spuc container image.

**Top:** Name, endorsements, creator, a short description, tags, and popularity

**Top-right:** command to pull.

**Two tabs:**
- Overview - contains the documentation.
- Tags - contains the list of versions, indicated by “tags”.

Name structure:
`OWNER/REPOSITORY:TAG`

Click the version tag for latest of this image to "inspect".

**Note:** The latest tag is not always the most recent version of the software.  
Tags are actually just labels, and the latest tag is just a convention.


## Official images
In the search box, type “python” and hit enter.
The “official” badge is shown on the top of the repository.


## Choosing Container Images on Docker Hub
- Updated regularly.
- Established company, community...
- Dockerfile or other.
- Good documentation.
- Use by the wider community. The graph on the right at the search page can help with this.


## Other sources of Container Images

- GHCR from Github.
- Quay from Red Hat.
- Artifact Registry from Google.
- GLR from GitLab.
- ECR from Amazon.
- ACR from Azure, Microsoft.


## Show keypoints slide


--------------------------------------------------
--------------------------------------------------


# Configuring containers


Explore the docs we found on Docker Hub.
We can:
- Set an environment variable **EXPORT** to **True** to export the logs to a file.
- Pass a parameter to change the units.


## Setting the environment
We set environment variables with `-e name=value`:
```bash
docker stop spuc_container
docker run -d --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -e EXPORT=true spuacv/spuc:latest
docker logs spuc_container
```
And we can now try it:
```bash
curl localhost:8321/export
```
So we no longer need a bind mount, a volume would work just fine.

Defaulting to network style connections is very common in Docker containers.

Environment variables are a very common tool for configuring containers.


## Passing parameters (overriding the command)

SPUC is recording the brightness of the unicorns in **Imperial Unicorn Hoove Candles** (iuhc)!  
We must change it to the much more standard **Intergalactic Unicorn Luminosity Units** (iulu).

Parameters are passed on the command. Remember:
```bash
docker inspect spuacv/spuc:latest -f "Entrypoint: {{.Config.Entrypoint}}\nCommand: {{.Config.Cmd}}"
```
To override it, we write the command we want at the end:
```bash
docker stop spuc_container
docker run -d --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -e EXPORT=true spuacv/spuc:latest --units iulu
```
```bash
curl -X PUT localhost:8321/unicorn_spotted?location=pluto\&brightness=66
curl localhost:8321/export
```
This worked, but now we have a mix of units!
We have to remove the volume to fix this:
```bash
docker stop spuc_container
docker volume rm spuc-volume
docker run -d --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -e EXPORT=true spuacv/spuc:latest --units iulu
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=177
curl -X PUT localhost:8321/unicorn_spotted?location=earth\&brightness=18
curl -X PUT localhost:8321/unicorn_spotted?location=mars\&brightness=709
curl -X PUT localhost:8321/unicorn_spotted?location=jupyter\&brightness=372
curl -X PUT localhost:8321/unicorn_spotted?location=venus\&brightness=262
curl -X PUT localhost:8321/unicorn_spotted?location=pluto\&brightness=66
curl localhost:8321/export
```

Overriding the command is a very common way to configure containers.


## Overriding the entrypoint
This is less common, but it can also be done:
```bash
docker run -it --rm --entrypoint /bin/sh spuacv/spuc:latest
```

## Challenge: Entrypoint + Command combinations

|     | Entrypoint                          | Command                             |
| --- | ----------------------------------- | ----------------------------------- |
| A   | `python /spuc/spuc.py --units iuhc` |                                     |
| B   | `python /spuc/spuc.py`              | `--units iuhc`                      |
| C   | `python`                            | `/spuc/spuc.py --units iuhc`        |
| D   |                                     | `python /spuc/spuc.py --units iuhc` |

All valid combinations, but with different implications:
- **A:** Ok if unlikely to change (although more may be appended).
- **B:** program baked in, arguments easily changed -- STANDARD.
- **C:** Python script can be changed easily, which is more likely to be bad than good!
- **D:** Maximum flexibility, but re-write the whole command to modify even the parameters.


## Show keypoints slide

