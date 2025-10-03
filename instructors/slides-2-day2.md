---
marp: true
theme: gaia
class:
    - lead
    - invert
paginate: false
backgroundImage: url('./fig/purple-space-background-dark.jpg')
backgroundColor: rgba(0,0,0,0.5)
---

![bg left:35% w:120%](./fig/docker-SPU.png)

# **Introduction to Docker**

The adventures of Docker and the
Space Purple Unicorn Association


<p style="font-size: 1.5rem;">uomresearchit.github.io/docker-introduction/</p>

<h1> Day 2! </h1>

---

## The plan

<div style="display: flex; font-size: 1.8rem;">
<div style="flex: 1; padding: 10px;">

* Day 2
  - Creating your own container images
  --- Break ---
  - Using Docker Compose
  --- Lunch Break ---
  - Microservices
</div>
</div>

---

## Creating your own container images

Let's squash that run command!

#### Questions 
- How can I create my own container images?

#### Objectives
- Learn how to create your own container images using a `Dockerfile`.
- Learn the syntax used in a `Dockerfile`.
- Learn how to run your own container images

---

## But how does this help the unicorns?

- SPUC has something of a glaring omission... we have no statistics of our sightings!
- SPUC allows us to add plugins (see the SPUC container docs)
- Let's add a stats plugin

### Recap: Our previous run command

```bash
    docker run -d --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v stats.py:/spuc/plugins/stats.py -e EXPORT=true spuacv/spuc:latest --units iulu
 ```

---
<style scoped>
table {
    height: 100%;
    width: 100%;
    font-size: 18px;
}
</style>

### Our previous run command

 
| Flag                                          | Description                                             |
|-----------------------------------------------|---------------------------------------------------------|
| `-d`                                          | Run the container in the background                     |
| `--rm`                                        | Remove the container when it stops                      |
| `--name spuc_container`                       | Name the container `spuc_container`                     |
| `-p 8321:8321`                                | Map port 8321 on the host to port 8321 in the container |
| `-v ./print.config:/spuc/config/print.config` | Bind mount the `./print.config` file into the container |
| `-v spuc-volume:/spuc/output`                 | Persist the `/spuc/output` directory in a volume        |
| `-v ./stats.py:/spuc/plugins/stats.py`        | Bind mount the `./stats.py` plugin into the container   |
| `-e EXPORT=true`                              | Set the environment variable `EXPORT` to `true`         |
| `--units iulu`                                | Set the units to Imperial Unicorn Length Units          |

---

## To the material! 

Note: I'm going to use some blocks of code 
I'll paste them in teams (no need to type)

---

## Dockerfile for SPUC

```Dockerfile
FROM python:3.12-slim

RUN apt update
RUN apt install -y curl

WORKDIR /spuc

COPY ./requirements.txt /spuc/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /spuc/requirements.txt

COPY ./*.py /spuc/
COPY ./config/*.config /spuc/config/
RUN mkdir /spuc/output

EXPOSE 8321

ENTRYPOINT ["python", "/spuc/spuc.py"]
CMD ["--units", "iuhc"]
```

Let's break it down!

---

```Dockerfile
FROM python:3.12-slim
```
Sets the base image. In this case the official Python image with the tag 3.12-slim.

```Dockerfile
RUN apt update
RUN apt install -y curl
```
Installs the `curl` package after updating the package list.

---

```Dockerfile
WORKDIR /spuc
```

This is a new one! It sets the working directory for the rest of the commands in the Dockerfile.

---

```Dockerfile
COPY ./requirements.txt /spuc/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /spuc/requirements.txt
```

This copies the requirements file into the container and installs the Python packages.

```Dockerfile
COPY ./*.py /spuc/
COPY ./config/*.config /spuc/config/
RUN mkdir /spuc/output
```

This copies the Python scripts and configuration files into the container and creates an output directory.

---

```Dockerfile
EXPOSE 8321
```
Another new one! This exposes port 8321 on the container to the host machine, but doesn't specify where it will appear on the host!

---

```Dockerfile
ENTRYPOINT ["python", "/spuc/spuc.py"]
CMD ["--units", "iuhc"]
```

This sets the entrypoint for the container to run the `spuc.py` script with the `--units iuhc` argument.

---

```dockerfile
FROM python:3.12-slim

RUN apt update
RUN apt install -y curl

WORKDIR /spuc

COPY ./requirements.txt /spuc/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /spuc/requirements.txt

COPY ./*.py /spuc/
COPY ./config/*.config /spuc/config/
RUN mkdir /spuc/output

EXPOSE 8321

ENTRYPOINT ["python", "/spuc/spuc.py"]
CMD ["--units", "iuhc"]
```

---

### Keypoints

- You can make your own images
- Dockerfiles are image recipies 
- You can build an image with `docker build`
- You can run a container from an image with `docker run`

---

# Docker Compose

Let's start exploring Docker Compose and see how it helps us.

### Questions 
- What is Docker Compose? Why use it?
- How can I run multiple containers without pain?
- How can I translate my `docker run` commands into a `docker-compose.yml` file?

### Objectives
- Learn how to run multiple containers together.
- Clean up our run command for once and for all.

---

## Unicorns Oli!

This isn't really about Docker Compose.
*This is about the **unicorns**.*

- Curl isn't very user friendly!
- SPUA are ahead of this, they have a web UI we can use!
- How can we run this alongside SPUC?

Introducting: the SPUCSVi

---

## The plan

1. Work through our run command and convert it to Docker Compose
2. Spin up the SPUCSVi

---

### Recap: Our previous run command

```bash
    docker run -d --rm --name spuc_container -p 8321:8321 -v ./print.config:/spuc/config/print.config -v spuc-volume:/spuc/output -v stats.py:/spuc/plugins/stats.py -e EXPORT=true spuacv/spuc:latest --units iulu
 ```
 
---
<style scoped>
table {
    height: 100%;
    width: 100%;
    font-size: 18px;
}
</style>

### Our previous run command

 
| Flag                                          | Description                                             |
|-----------------------------------------------|---------------------------------------------------------|
| `-d`                                          | Run the container in the background                     |
| `--rm`                                        | Remove the container when it stops                      |
| `--name spuc_container`                       | Name the container `spuc_container`                     |
| `-p 8321:8321`                                | Map port 8321 on the host to port 8321 in the container |
| `-v ./print.config:/spuc/config/print.config` | Bind mount the `./print.config` file into the container |
| `-v spuc-volume:/spuc/output`                 | Persist the `/spuc/output` directory in a volume        |
| `-v ./stats.py:/spuc/plugins/stats.py`        | Bind mount the `./stats.py` plugin into the container   |
| `-e EXPORT=true`                              | Set the environment variable `EXPORT` to `true`         |
| `--units iulu`                                | Set the units to Imperial Unicorn Length Units          |

---

## Let's get going

---

## Simpler Dockerfile

Of course, most of what we did in the Dockerfile is now redundant
We could have used this instead:

```Dockerfile
FROM spuacv/spuc:latest
RUN pip install pandas
```
---

## Docker Compose advantages

- Easier to write
- Versionable
- Sharable

In my opinion: simply better

---

## I was promised a Unicorn GUI.

Yes you were! Let's add it.

```yml
 spucsvi:                             # Declare a new service named spucsvi
    image: spuacv/spucsvi:latest      # Specify the image to use
    container_name: spucsvi_container # Name the container spucsvi
    ports:                            
      - "8322:8322"                   # Map port 8322 on the host to port 8322 in the container
    environment:                      
      - SPUC_URL=http://spuc:8321     # Specify the SPUC_URL environment variable``
```

The URL comes for free with compose! 
We can refer to containers by name.

--- 

## Let's get that running and have a look at a few more features

---

## Key points

<style>
ul {
    font-size: 0.75rem;
}
</style>

- Docker Compose lets you define a run command as a **config file**
- Docker Compose lets you run **multiple services**
- We use `docker compose up` to bring up the stack.
- They can be stopped using the `docker compose down` command.
- Container images can be built as the services are spun up by using the `--build` flag.

---
# Microservices

Let's talk about microservices and how Docker Compose can help you make your projects, better, faster.

### Questions
- How do I get the most out of Docker Compose?
- What is a microservices architecture?

### Objectives
- Learn how combinations of microservices can achieve complex tasks with no or low code.
- Dissect a real world example of a microservices architecture.

---

## Microservice architecture

**Traditional development can result in monolithic applications**
*All services in one codebase and environment*

**Microservices breaks this up**
*Each service runs seperately, in their own environments, communicating over the network*

---
## Example - a IoT web app 

In an application like this you might have:

- A web server
- Front end
- Back end
- An API
- A file store
- A message queue

You can put all of these in one codebase and use libraries

But by breaking it up...

---

## Benefits of Microservices

- You can use off the shelf tools
- You can write less boilerplate library code
- You do less maintainance 
- The tooling is expertly (and enthusiastically) maintained
- The services are easy to orchestrate
- Teams can work on different services

**You get to focus more on the unique, fun, bits of your project!**

--- 

### "What did you do today?"

## I wrote 5 lines of config and now my project has a dashboard!

---

## Case study (Apperture)

Apperture is a secure web portal with user management tools
**It is simply a docker compose file!**

Let's dive into the docker compose file - service by service

--- 

## Case study (Apperture)

```yml
services:
  proxy:
    image: 'jc21/nginx-proxy-manager:latest'
    ports:
      - '80:80'
      - '443:443'
    depends_on:
      - authelia
    healthcheck:
      test: ["CMD", "/bin/check-health"]
```
```yml
  whoami:
    image: docker.io/traefik/whoami
```

---

```yml
  authelia:
    image: authelia/authelia
    depends_on:
      lldap:
        condition: service_healthy
    volumes:
      - ${PWD}/config/authelia/config:/config
    environment:
      AUTHELIA_DEFAULT_REDIRECTION_URL: https://whoami.${URL}
      AUTHELIA_STORAGE_POSTGRES_HOST: authelia-postgres
      AUTHELIA_AUTHENTICATION_BACKEND_LDAP_URL: ldap://apperture-ldap:3890
```
---
```yml
  lldap:
    image: nitnelave/lldap:stable
    depends_on:
      lldap-postgres:
        condition: service_healthy
    environment:
      LLDAP_LDAP_BASE_DN: dc=example,dc=com
      LLDAP_DATABASE_URL: postgres://user:pass@lldap-postgres/dbname
    volumes:
      - lldap-data:/data
```
```yml
  lldap-postgres:
    image: postgres
    volumes:
      - lldap-postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U lldap"]
```
---
```yaml
volumes:
  lldap-data:
  lldap-postgres-data:
```

---

## What that all does

As you can see - there are no self written tools!
All the services are **off the shelf** tools
But what happens when they are put together?

---

![](../episodes/fig/docker_compose_apperture.png)

---

**Without writing a single line of code, we have a secure web portal!**

---

## Combining stacks

- Docker compose isn't isolated to a single stack
- We can combine stacks to create more complex applications
- We could add Apperture to our SPUC stack!
- **Now poachers cannot falsify our unicorn measurements!**

```yaml
networks:
  apperture:
    external: true
    name: apperture_default
```

---

![height:600](../episodes/fig/docker_compose_spuc.png)

--- 
## Rapid extension

With Docker Compose, you can easily add new services to your stack

For example maybe SPUC would benefit from :

- A propert database (rather than a file)
- Support for unicorn sensors via a message queue 
- Allowing users to upload images of their sightings

---
![height:600](../episodes/fig/docker_compose_full.png)

## Keypoints

- Docker Compose lets us use a microservices architecture
- We can use off the shelf tools to easily build complex applications

This is *fun*! You get to spend more time in the interesting parts of your project!

---
![height:600](../episodes/fig/SPUA/spua_thanks_you.png)
