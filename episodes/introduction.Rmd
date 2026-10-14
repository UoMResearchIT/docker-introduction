---
title: The adventures of Docker and the Space Purple Unicorn Association
teaching: 20
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives
- Learn what Docker is and why it is useful
- Introduce the Space Purple Unicorn Association
::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions
- What are containers, and why might they be useful to me?
- How can I join the community effort to count the number of purple unicorns in space?
::::::::::::::::::::::::::::::::::::::::::::::::::

## Docker

> **Junior Developer**: `"But it works on my machine!"`
>
> **Senior Developer**: `"Then we'll ship your machine!"`
<!-- ![](fig/ship.png){alt="- But it works on my machine! - Then we'll ship your machine!"} -->

Once upon a time this was just a joke, but now it's a reality!

Docker is a tool that allows you to create, deploy, and run applications using *"containers"*.

Containers are a way to package software so others can use it more easily.

### Why Containers?

There are two major motivations for using containers:

- **Reliable Software**.
  A container packages all the necessary libraries with their correct versions.
  It also ensures the environment remains consistent wherever it runs.
  Finally, it encapsulates the recipe for running the software correctly.  
  Essentially, containers allow you to ship your machine!

- **Microservices**.
  Containers make it very easy to use *microservices*.
  These are small, independent programs that work together, and provide similar advantages to using libraries in your code:
  they make your *software stack* more modular, more powerful, and easier to understand.
  We will cover more on microservices in the last chapter.

### Why Docker?

There are other ways to make containers, but Docker is the most popular and probably the most mature.

On some specialised environments (such as HPC), you might use a different container system (i.e. Apptainer).
However, there are usually ways to convert from Docker to the other system.
The reverse doesn't always hold.

If you learn only one container system, learn Docker! As it has become the Rosetta Stone of containers.

## The Space Purple Unicorn Association

<div class="columns" style="display: flex; flex-wrap: wrap;">
<div class="column" style="flex: 3; padding: 10px; box-sizing: border-box; min-width: 300px;">

The Space Purple Unicorn Association is a community effort to count the number of purple unicorns in space.

We are a friendly group of developers, data scientists, and unicorn enthusiasts,
who are passionate about surveying and conserving the purple unicorn population.

We're delighted to have you join us!
To support the community's efforts, we have created a set of tools and resources to help count the number of purple unicorns in space.
These tools are distributed via Docker.

Please help us preserve this keystone species by running your own Space Purple Unicorn Counting service,
and encouraging your local community to join in the count!

</div>
<div class="column" style="flex: 2; padding: 10px; box-sizing: border-box; min-width: 300px;">

![](fig/SPUA/SPUA_logo.png){alt="SPUA logo"}

</div>
</div>

You can use the *Space Purple Unicorn Counter* (**SPUC**) container image for your service,
which you can find on [Docker Hub](https://hub.docker.com/r/spuacv/spuc).

This image runs a web app that can be used to record sightings using `curl`.
The `location` and `brightness` of the unicorn need to be specified.
For example:
```
curl -X PUT localhost:8321/unicorn_spotted?location=moon\&brightness=100
```
will register a unicorn sighting on the moon with a brightness of 100 iuhc.

Remember to allow access to the container from the host machine by **configuring a port** to forward requests to the container.

To change the format of the sightings report, you may edit the `print.config` file.
