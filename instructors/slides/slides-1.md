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

* Morning
    - Introduction
    - Docker Desktop
    - Building our Docker CLI toolkit
    - --- Break ---
    - Sharing information with containers
    - The Docker Hub
    - Configuring containers
    - --- Lunch Break ---

</div>

<div style="flex: 1; padding: 10px;">

* Afternoon
  - Creating your own container images
  - --- Break ---
  - Using Docker Compose
  - Microservices
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
We're delighted to have you join us!
To support the community's efforts, we have created a set of tools and resources to help count the number of purple unicorns in space.
These tools are distributed via Docker.
<p style="text-align: left;">
Please help us preserve this keystone species by running your own Space Purple Unicorn Counting service,
and encouraging your local community to join in the count!

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
You can use the <i>Space Purple Unicorn Counter</i> (<strong>SPUC</strong>) container image for your service,
which you can find on Docker Hub.
<p style="text-align: left;">
This image runs a web app that can be used to record sightings.
<p style="text-align: left;">
Remember to allow access to the container from the host machine by <strong>configuring a port</strong> to forward requests to the container.
<p style="text-align: left;">
To change the format of the sightings report, you may edit the `print.config` file.

</div>

</div>

---
<span style="font-size: 1.2rem;"  >

### Docker Desktop

The next ~20 minutes will be demonstrative, but are a useful introduction to the concepts.

If you have Docker Desktop, we encourage you to <span style="font-size: 1.5rem;"> **not** </span> try to follow along, and instead focus on absorbing ideas.
</span>

---

![height:300](../fig/stamp_analogy/00_stamp.png)

---

![height:300](../fig/stamp_analogy/01_print.png)

---

![height:300](../fig/stamp_analogy/02_container.png)

---

![height:300](../fig/stamp_analogy/03_alive.png)

---

![height:300](../fig/stamp_analogy/04_copies.png)

---

![height:300](../fig/stamp_analogy/05_bottomline.png)

---

![width:1000](../fig/Docker_Desktop_keypoints.png)

---

<div style="background-color: white; padding: 10px;">

  ![width:1000](../../episodes/fig/docker_cmd.png)

</div>

---

![width:1000](../../episodes/fig/docker_life_0.png)

---

![width:1000](../../episodes/fig/docker_life_1.png)

---

![width:1000](../../episodes/fig/docker_life_2.png)

---

![width:1000](../fig/run_command/run_command_00_run.png)

---

![width:1000](../fig/run_command/run_command_01_detach.png)

---

![width:1000](../fig/run_command/run_command_02_port.png)

---

![width:1000](../fig/run_command/run_command_03_name.png)

---

![width:1000](../fig/run_command/run_command_04_rm.png)

---
<div style="display: flex; font-size: 1.8rem;">

<div style="flex: 1; padding: 10px;">

![width:600](../fig/docker_cli_keypoints_1.png)

</div>

<div style="flex: 1; padding: 10px; margin-top:145px;">

![width:550](../fig/docker_cli_keypoints_2.png)

</div>

</div>

---

<h1> Break! </h1>

---

![width:1000](../fig/run_command/run_command_05_volume.png)

---

![width:1000](../fig/run_command/run_command_06_bind_dir.png)

---

![width:1000](../fig/run_command/run_command_07_bind_file.png)

---


![width:1000](../fig/common_mistakes_with_volumes.png)

---

![width:1000](../fig/docker_volumes_keypoints.png)

---

![width:1000](../fig/docker_hub_keypoints.png)

---

![width:1000](../fig/run_command/run_command_08_env.png)

---

![width:1000](../fig/run_command/run_command_09_command.png)

---

![width:1000](../fig/run_command/run_command_10_entrypoint.png)

---

![width:1000](../fig/entrypoint_command_combination.png)

---

![width:1000](../fig/docker_run_configuration_keypoints.png)

---

<h1> Lunch! </h1>
