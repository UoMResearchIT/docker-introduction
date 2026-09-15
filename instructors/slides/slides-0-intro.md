---
marp: true
theme: gaia
class:
    - lead
    - invert
paginate: false
backgroundImage: url('../fig/purple-space-background-dark.jpg')
backgroundColor: rgba(0,0,0,0.5)
---

![bg left:35% w:120%](../fig/docker-SPU.png)

# **Introduction to Docker**

The adventures of Docker and the
Space Purple Unicorn Association


<p style="font-size: 1.5rem;">uomresearchit.github.io/docker-introduction/</p>

---

## The plan

<div style="display: flex; font-size: 1.8rem;">

<div style="flex: 1; padding: 10px;">

* Day 1
    - Introduction
    - Docker Desktop
    - Building our Docker CLI toolkit
    - --- Break ---
    - Sharing information with containers
    - --- Lunch Break ---
    - The Docker Hub
    - Configuring containers

</div>

<div style="flex: 1; padding: 10px;">

* Day 2
  - Creating your own container images
  - --- Break ---
  - Using Docker Compose
  - --- Lunch Break ---
  - Conclusion

</div>

</div>

---

![bg right:50% w:90%](../fig/ship.png)

* ## Why containers?
  * Reliable Software
  * Microservices

* ## Why Docker?

  * Most popular/mature
  * Easy to convert from docker to others

---

### The Space Purple Unicorn Association

<div style="display: flex; align-items: flex-start; margin-top:40px">

<div style="flex: 2; margin-top:40px">

![w:400](../../episodes/fig/SPUA/SPUA_logo_transparent.png)

</div>

<div style="flex: 3; font-size: 1.5rem; text-align: left;">

<p style="text-align: left;">
The Space Purple Unicorn Association is a community effort to count the number of purple unicorns in space.
<p style="text-align: left;">
We are a friendly group of developers, data scientists, and unicorn enthusiasts, who are passionate about surveying and conserving the purple unicorn population.
<p style="text-align: left;">
We're delighted to have you join us! To support the community's efforts, 
we've created a set of tools and resources that will both help count purple unicorns and introduce you to fundamental Docker concepts.
<p style="text-align: left;">
Over this course, you'll run your own Space Purple Unicorn Counting service, 
and encourage your local community to join in the count!

</div>

</div>

---

### Start helping now!

<div style="display: flex; align-items: flex-start; margin-top:40px">

<div style="flex: 2; margin-top:40px">

![w:400](../../episodes/fig/SPUA/SPUA_logo_transparent.png)

</div>

<div style="flex: 3; font-size: 1.5rem; text-align: left;">

<p style="text-align: left;">
We will use the <i>Space Purple Unicorn Counter</i> (<strong>SPUC</strong>) container image for our service,
which can found on Docker Hub.
<p style="text-align: left;">
This image provides an API, which can be hit to add an event to the sightings record.
<p style="text-align: left;">
To register a sighting, we'll send a PUT request to the API,
with the unicorn's location and brightness.
<p style="text-align: left;">
Before we start counting unicorns, we'll need to complete a few setup steps.
Let's get started!
</div>

</div>
