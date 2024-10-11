---
title: Building our Docker CLI toolkit
teaching: 99
exercises: 99
---

So! We’ve seen some pretty cool functionality from our Unicorn Counter straight out of the box. But really we need to take more control. 

While useful for learning, most Docker users eventually switch from Docker Desktop to the more powerful command line interface (CLI).

In this section we will build up a toolkit of Docker commands that allow us to perform the same tasks we learned to do in Docker Desktop, but with more control and flexibility. Building into more advanced Docker tasks that are only possible in the command line, in the next sections.

::::::::::::::::::::::::::::::::::::::: objectives
- Learn how to use the Docker command line to perform tasks we learned to do in Docker Desktop
- Learn the lifecycle of Docker containers
::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions
- How do I perform the same tasks in Docker Desktop using the Docker CLI?
- What actually happens when I run a container?
::::::::::::::::::::::::::::::::::::::::::::::::::

# Docker command cheat sheet

Before we dive in, here is a quick cheat sheet of the most common Docker commands.

Don't worry about understanding them yet, we will cover them in detail over the next few sections.

| Command                                | Description                                    |
|----------------------------------------|------------------------------------------------|
| `docker pull <image>`                  | Pull an image from a registry                  |
| `docker image ls`                      | List all images on the system                  |
| `docker inspect <image>`               | Show detailed information about an image       |
| `docker run <image>`                   | Run a container from an image                  |
| `docker ps`                            | List all running containers                    |
| `docker logs <container>`              | Show the logs of a container                   |
| `docker exec -it <container> <command>`| Run a command in a running container           |
| `docker stop <container>`              | Stop a running container                       |
| `docker start <container>`             | Start a stopped container                      |
| `docker stats`                         | Show live resource usage of containers         |
| `docker rm <container>`                | Remove a container                             |
| `docker image rm <image>`              | Remove an image                                |
| `docker system prune`                  | Remove all stopped containers and unused images|

# Building our Docker CLI Toolkit 

First things first - we need to cover some basics. What does the Docker CLI look like? What happens when we run commands?

Let’s dive in and start building our toolkit! 

## Pulling and Listing Images

To run an image, first we need to download it. In Docker, this is known as pulling an image.

Let’s start by pulling the SPUC container that we used before:

```bash
$ docker pull ghcr.io/uomresearchit/spuc:latest
latest: Pulling from uomresearchit/spuc
302e3ee49805: Already exists 
6b08635bc459: Pull complete 
18bb7c8edce2: Pull complete 
8341816e3d13: Pull complete 
5582a67fac1b: Pull complete 
0b0420cd5344: Pull complete 
0e3586f9748e: Pull complete 
d52edf8b814c: Pull complete 
eedd735a89e9: Pull complete 
Digest: sha256:bc43ebfe7dbdbac5bc0b4d849dd2654206f4e4ed1fb87c827b91be56ce107f2e
Status: Downloaded newer image for ghcr.io/uomresearchit/spuc:latest
ghcr.io/uomresearchit/spuc:latest
```

Now we have the image! But what how did that command work? The Docker CLI is a large and complex application but the syntaxt is quite predictable when you understand a few principles.

Let's dive into the structure of that command. Here is a diagram which breaks things down:

![](fig/docker_cmd.png){alt='A diagram showing the syntactic structure of a Docker command'}

Every Docker command starts with 'docker'. Next, you specify the type of object to act on, followed by the action to perform and the name of the object. You can also include additional arguments and switches as needed.

The pull command that we ran earlier is a good example of this. We told **Docker** to **pull** the image found at the location **'ghcr.io/uomresearchit/spuc:latest'**.

Now that we have the image, let's check that it is there:

```bash
$ docker image ls
REPOSITORY                                TAG        IMAGE ID       CREATED         SIZE
ghcr.io/uomresearchit/spuc                latest     f03fb04b8bc6   5 hours ago     137MB
```

This command lists (ls is short for list) all the images that we have downloaded. You should see the SPUC image listed here, along with some other information about it.

## Inspecting

It can be hard to guess what an image will do just from its name. To find out more about an image, we can use the inspect command

```bash
$ docker inspect ghcr.io/uomresearchit/spuc:latest
[
    {
        "Id": "sha256:f03fb04b8bc613f46cc1d1915d2f98dcb6e008ae8e212ae9a3dbfaa68c111476",
        "RepoTags": [
            "ghcr.io/uomresearchit/spuc:latest"
        ],
        "RepoDigests": [
            "ghcr.io/uomresearchit/spuc@sha256:bc43ebfe7dbdbac5bc0b4d849dd2654206f4e4ed1fb87c827b91be56ce107f2e"
        ],
        "Parent": "",
        "Comment": "buildkit.dockerfile.v0",
        "Created": "2024-10-10T07:09:05.933695321+01:00",
        "DockerVersion": "",
        "Author": "",
        "Config": {
            "Hostname": "",
            "Domainname": "",
[...]
```

Tells you a **lot** of details about the image. This can be useful for understanding what the image does and how it is configured but can be overwhelming.

One particularly useful refinement of this command makes use of the `-f` flag to specify the output format. This can be used to extract specific information from the image and we will use it here to figure out exactly what the container will do when it is run.

```bash
$ docker inspect alpine -f "Entrypoint: {{.Config.Entrypoint}} Command: {{.Config.Cmd}}"
Entrypoint: [python /code/spuc.py] Command: [--units iuhc]
```

But what do these mean? The entrypoint is the base command for the container, while the command is the parameters for the base command. Together, they form the default command that the container will run when it is started.

In this case, the entrypoint is `python /code/spuc.py` and the command is `--units iuhc`. This means that when the container is run, it will execute the command `python /code/spuc.py --units iuhc`.

This is all we need to know to run the container, but we will come back to this later (and in more detail) when we discuss the lifecycle of a container.

## Running

Now that we have the image, and we know what it will do, let's run it!

```bash
$ docker run ghcr.io/uomresearchit/spuc:latest

            \\
             \\
              \\
               \\
                >\/7
            _.-(6'  \
           (=___._/` \            ____  ____  _    _  ____
                )  \ |           / ___||  _ \| |  | |/ ___|
               /   / |           \___ \| |_) | |  | | |
              /    > /            ___) |  __/| |__| | |___
             j    < _\           |____/|_|    \____/ \____|
         _.-' :      ``.
         \ r=._\        `.       Space Purple Unicorn Counter
        <`\\_  \         .`-.
         \ r-7  `-. ._  ' .  `\
          \`,      `-.`7  7)   )
           \/         \|  \'  / `-._
                      ||    .'
                       \\  (
                        >\  >
                    ,.-' >.'
                   <.'_.''
                     <'
    
::::: Initializing SPUC...
::::: Units set to Imperial Unicorn Hoove Candles [iuhc].

Welcome to the Space Purple Unicorn Counter!
::::: Try 'curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100' to record a unicorn sighting!
::::: Or 'curl localhost:8321/export' to download the unicorn sightings file!
```

And there we have it! The SPUC container is running and ready to count unicorns. Let's try out one of the commands that it suggests!

Only... it's quite hard to do this without another terminal window. Let's try running the container in the background instead, 'detached' from the terminal using the `-d` flag:

```bash
[Ctrl+C]
$ docker run -d ghcr.io/uomresearchit/spuc:latest
4d58ddad6ae33226ab30e8d7852b9b2166f214c462dabcecb65ef7a50518b0ec
```

But what is happening? We can't see the output of the container anymore! To see what is happening, we can use the `docker ps` command:

```bash
$ docker ps
CONTAINER ID   IMAGE                                              COMMAND                  CREATED         STATUS                  PORTS                                                                                                           NAMES
4d58ddad6ae3   ghcr.io/uomresearchit/spuc:latest                  "python /code/spuc.p…"   3 minutes ago   Up 3 minutes                                                                                                                            peaceful_archimedes
```

This command lists all the containers that are currently running. You can see that the SPUC container is running, and that it has been (randomly) given the name `peaceful_archimedes`.

### Exposing the service

Now that we know the container is running okay, we can try out the commands that it suggests:

```bash
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100
curl: (7) Failed to connect to localhost port 8321 after 0 ms: Could not connect to server
```

Oh no! It looks like the container is not listening on the port that we expected. This is because the container is running in its own isolated environment, and we need to tell Docker to expose the port to the host machine.

This can be done using the `-p` flag, which specifies the port to expose on the host machine and the port to expose on the container. In this case we want to expose port 8321 on the host machine to port 8321 on the container:

```bash
$ docker run -d -p 8321:8321 ghcr.io/uomresearchit/spuc:latest
$ curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100
{"message":"Unicorn sighting recorded!"}
```

Great! The container is now listening on port 8321, and we can interact with it using the `curl` command. But what if we want to see what is happening inside the container?

### Logs

To see the output of the detached container, we can use the `docker logs` command:

```bash
$ docker logs peaceful_archimedes

            \\
             \\
              \\
               \\
                >\/7
            _.-(6'  \
           (=___._/` \            ____  ____  _    _  ____
                )  \ |           / ___||  _ \| |  | |/ ___|
               /   / |           \___ \| |_) | |  | | |
              /    > /            ___) |  __/| |__| | |___
             j    < _\           |____/|_|    \____/ \____|
         _.-' :      ``.
         \ r=._\        `.       Space Purple Unicorn Counter
        <`\\_  \         .`-.
         \ r-7  `-. ._  ' .  `\
          \`,      `-.`7  7)   )
           \/         \|  \'  / `-._
                      ||    .'
                       \\  (
                        >\  >
                    ,.-' >.'
                   <.'_.''
                     <'
    
::::: Initializing SPUC...
::::: Units set to Imperial Unicorn Hoove Candles [iuhc].

Welcome to the Space Purple Unicorn Counter!
::::: Try 'curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100' to record a unicorn sighting!
::::: Or 'curl localhost:8321/export' to download the unicorn sightings file!

::::: (2024-10-10 16:05:35.263119) Unicorn spotted at moon!! Brightness: 100 iuhc
```

Now we can see the output of the container! Including the unicorn sighting that we just recorded.

Notice that we had to use the name of the container, `peaceful_archimedes`, to get the logs. This is because the `docker logs` command requires the name of the **container** not the **image**.

It can be quite inconvenient to have to find out the name of the container every time we want to see the logs. To make this easier, we can name the container when we run it using the `--name` flag:

```bash
$ docker run -d --name spuc_container -p 8321:8321 ghcr.io/uomresearchit/spuc:latest
4696d5301a792451f9954ba10cc42604a904fa1a811362733050ba04270c02eb
docker: Error response from daemon: driver failed programming external connectivity on endpoint spuc_container (67e075648d16fafdf086573169d891bee9b33bec0c1cb5535cf82c715241bb32): Bind for 0.0.0.0:8321 failed: port is already allocated.
```

Oops! It looks like we already have a container running on port 8321. Of course, it is the container that we ran earlier, peaceful_archimedes, and we can't have two containers running on the same port!

To fix this, we can stop the container that is running on port 8321 using the `docker stop` command:

```bash
$ docker stop peaceful_archimedes
peaceful_archimedes
```

Right, now we can try running the container again:

```bash
$ docker run -d --name spuc_container -p 8321:8321 ghcr.io/uomresearchit/spuc:latest
bf9b2abc95a7c7f25dc8c1c4c334fcf4ce9642754ed7f6b5586d82f9e9e45ac7
```

And now we can see the logs using the name of the container, and even follow the logs in real time using the `-f` flag:

```bash
$ docker logs -f spuc_container
[... SPUC OUTPUT ...]
[Crtl+C]
```

## Executing commands in a running container

But what if we want to run a command inside the container? We can do this using the `docker exec` command:

```bash
$  docker exec spuc_container ls output
unicorn_sightings.txt
```

This command runs the `ls` command inside the container, and lists the contents of the `output` directory. This can be useful for debugging and troubleshooting, or for running commands that are not available on the host machine.

If we want to interact with the container we can use the `-it` flag to run an interactive terminal session.

Let's try launching an interactive terminal session inside the container, running the bash shell:

```bash
$ docker exec -it spuc_container /bin/bash
root@bf9b2abc95a7:/code# cat output/unicorn_sightings.txt 
time,brightness,unit
2024-10-10 16:15:58.284557,100,iuhc
```

This command starts an interactive terminal session inside the container, and we can now run commands as if we were inside the container itself. In this case we are using the `/bin/bash` command to start a bash shell.

::::::::::::::::::::::::::::::::::::::: callout
Some contianers do not provide services and simply run once and then exit. These cannot be exec'ed into as they have exited by the time you try to do this!

Instead you can modify the run command to include the `-it` flag:

```bash
$ docker run -it alpine:latest
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
43c4264eed91: Pull complete 
Digest: sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d
Status: Downloaded newer image for alpine:latest
/ # 
```

**Note** if you recall, the Alpine container is a very small container that does not run a service. Instead it runs a shell and then exits. This is why we need to use the `-it` flag to run an interactive terminal session.
:::::::::::::::::::::::::::::::::::::::::::::::

## Reviving

It is probably a good idea to stop the container when we are done with it. We can do this using the `docker stop` command:

```bash
$ docker stop spuc_container
spuc_container
```

But what if we wanted to restart a container that we had stopped? We can do this using the `docker start` command:

```bash
$ docker start spuc_container
spuc_container
```

We could check that the container is running again using the `docker ps` command, however, we can also use the `docker stats` command to see the live resource usage of the container (similar to the task manager on Windows or top on Linux):

```bash
$ docker stats
CONTAINER ID   NAME                          CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
bf9b2abc95a7   spuc_container               0.01%     23.61MiB / 15.29GiB   0.15%     23.6kB / 589B     5.1MB / 201kB    5
[Crtl+C]
```

## Cleaning up

The last thing we need to know is how to clean up after ourselves. We can do this using the `docker rm` command to remove a container, and the `docker image rm` command to remove an image:

```bash
$ docker stop spuc_container # will take ~10 seconds!
spuc_container
$ docker rm spuc_container
spuc_container
$ docker image rm ghcr.io/uomresearchit/spuc:latest
Untagged: ghcr.io/uomresearchit/spuc:latest
Deleted: sha256:a1bc13eca67e7c1e8e1f506f2352e3621ce6c648b0d77ce7cbb095a95da6d5da
```

To do a full clean up, we can also remove all stopped containers and unused images using the `docker system prune` command:

```bash
$ docker system prune
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all dangling images
  - unused build cache

Are you sure you want to continue? [y/N] y
Deleted Containers:
90d006980a999176dd82e95119556cdf62431c26147bdbd3513e1733be1a5897

Deleted Images:
untagged: ghcr.io/uomresearchit/spuc@sha256:bc43ebfe7dbdbac5bc0b4d849dd2654206f4e4ed1fb87c827b91be56ce107f2e
deleted: sha256:f03fb04b8bc613f46cc1d1915d2f98dcb6e008ae8e212ae9a3dbfaa68c111476

Total reclaimed space: 13.09MB
```

There is one more point to make, it is nice not to have to clean up containers manually all the time. Luckily Docker has a flag that will remove the container when it is stopped. This is the `--rm` flag:

```bash
$ docker run -d --rm --name spuc_container -p 8321:8321 ghcr.io/uomresearchit/spuc:latest
```

This will automatically remove the container when it is stopped, so you don't have to worry about cleaning up afterwards.

We will use the command going forward, as it is a good practice to keep your system clean and tidy.

And if you are thinking "wow, that command is getting pretty long...", you are right! Things will get worse before they get better but we will cover how to manage this later in the course.

## Summary

We have now covered the basics of the Docker CLI, building up a powerfull toolkit of commands!

We are now equipped with everything we saw we could do in Docker Desktop, but with the added power of the command line interface. Which we will use for move advanced tasks in the next sections.

::::::::::::::::::::::::::::::::::::::: keypoints
- The Docker CLI can perform all the tasks that Docker Desktop can (and more - coming up!)
- The Docker CLI is structured around a base command, a specialising command, an action command, and the name of the object to act on
- With a few core commands, and a cheatsheet, we can build a powerful toolkit for working with Docker containers
::::::::::::::::::::::::::::::::::::::::::::::::::