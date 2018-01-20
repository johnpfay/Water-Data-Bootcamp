---
Title: Setting up your Conda Environment
Author: John Fay
Date: Spring 2018
---

# Setting up your Conda Environment in Anaconda

## Some Background...

### What are Conda, MiniConda, and *Anaconda*?

Python, like R, is a base language for which programmers have written and published countless add-ons, or packages. These packages can be simple - a single stand-alone Python script defining a few functions - or quite complex, requiring the installation of C++ libraries and dependent on the installation of several other packages. 

Put simply, **Conda** is a package manager, developed to streamline the installation and update of Python packages. It's a tad more complex that that, but this will do for now. (See https://jakevdp.github.io/blog/2016/08/25/conda-myths-and-misconceptions/ for a more complete explanation. )

***Miniconda*** is a base install of Python and a few basic Python packages, including Conda. By installing it, we avoid the catch-22 of trying to install the Conda package without having Conda installed (to install itself...). 

**Anaconda** is a custom distribution of Python, one that already includes Conda as well as a number of other widely used Python packages. It's an alternative to installing Python from scratch, e.g. from https://www.python.org/downloads/, and then installing each package - including Conda which itself is a package - manually. 

So, when we installed Anaconda on our virtual machines, we installed Python and several packages all in one go, giving us a good head start in coding!

### What is Anaconda Navigator?

**Anaconda Navigator** is a graphical user interface, or GUI, for Conda, which further simplifies Python package management on your machine. It also allows provides an interface for launching some popular graphical Python applications, including **R Studio** and **Jupyter notebooks**, which we will be examining in future sessions. 

### What are Python environments?

Another feature of Anaconda Navigator is to create and manage Python environments. A **Python environment** is a somewhat self contained virtual Python installation and you can have many of these environments on a single machine. 

Why would you want multiple installations of the same software on a machine? Well, Python packages are constantly evolving and doing so at different paces. This can cause conflicts, e.g. when package "A" is developed to work with a separate package "B" (also called a *dependency*), but updates to package "B" lead to crashes in "A". But you might need the latest version of "B" to work with package "C". To solve this, we create two environments, one with "A" and an older version of "B", and another environment with the latest versions of "B" and "C".  

**Conda** provides capability of creating multiple virtual environments. And **Anaconda Navigator** makes creating and managing them easily. 



## Creating your personal Python environment

Now that we have the background, let's get started creating our own Python environment on our virtual machine. 

* Open Anaconda Navigator.
* Select the `Environments` tab on the left.
* Click `Create` at the bottom to create a new environment; name it whatever you wish, and select the **Python 3.6** package. 

### Adding packages to your environment

After it's done, you'll have your own sandbox to play in. It will have a few default packages installed, but we'll add a few more. 

* Select your environment in the lists of environments.
* Toggle the dropdown from `Installed` to `Not installed`
* Search for `pandas` and install it by selecting it and clicking `Apply`. You'll see that it will also install a number of dependencies. 
* Search for and install the following:
  * jupyter
  * matplotlib
  * seaborn
  * requests
  * bokeh

Some packages are served on separate Conda channels, or sub-repositories. Two examples are `ggplot` which is on the `bokeh` channel and `arcgis` which is on the `esri` channel. Here is the process to install those:

* Click the `Channels` button, near where you search for packages to install. 

* Click `Add...`  and add "bokeh" and then "esri".

* Click `Update channels`

* Now search for and install the  `ggplot` package.

* Then search for and install the `arcgis` package.

  ​

**OK, we now have plenty of packages to get us going!**