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

***Miniconda*** is a base install of Python and a few basic Python packages, including Conda. It is an alternative to installing Python from scratch, e.g. from https://www.python.org/downloads/ and then installing each package - including Conda which itself is a package - manually. 

***Anaconda*** is a custom distribution of Python, one that already includes Conda as well as a number of other widely used Python packages. It too is an alternative to installing Python from scratch. Anaconda, unlike Miniconda, includes a nice graphical user interface (GUI). You may later opt to use Anaconda and it's GUI, but for now we'll stick with the command line interface of Miniconda as it actually allows us faster set up.  

**Anyway, when we installed Miniconda on our virtual machines, we installed Python and a few starter packages all in one go, giving us a good head start in coding!**

### What are Python environments?

A key feature of Conda is its ability to create and manage Python environments. A **Python environment** is a somewhat self contained virtual Python installation, and you can have many of these environments on a single machine. 

Why would you want multiple installations of the same software on a machine? Well, Python packages are constantly evolving and doing so at different paces. This can cause conflicts, e.g. when package "A" is developed to work with a separate package "B" (also called a *dependency*), but updates to package "B" lead to crashes in "A". But you might need the latest version of "B" to work with package "C". To solve this, we create two environments, one with "A" and an older version of "B", and another environment with the latest versions of "B" and "C".  

**Conda** provides capability of creating multiple virtual environments.

---

## ►Creating your personal Python environment with Conda◄

Now that we have the background, let's get started creating our own Python environment on our virtual machine. We'll do this with a set of Conda commands run at the Anaconda prompt. The process we are about to do is well documented on the Conda User Guide: https://conda.io/docs/user-guide/tasks/manage-environments.html. You can also download a Conda cheat sheet here: https://conda.io/docs/_downloads/conda-cheatsheet.pdf, for when you're more comfortable with the process...

* Open the **Anaconda Prompt**.

  * This should be available via the Windows Programs List. You may want to pin it to the Start Menu...

* Create a new **Python v.3.5** environment called "**datadevil**", adding the **SciPy** "stack" to it. Do this by typing the following command at the Anaconda prompt:

  `conda create --name datadevil python=3.5 scipy`

  You'll be asked for confirmation and then off it will go fetching and installing various packages and their dependencies. You may get asked to intervene as administrator to allow installation, which you should do. 

* List the environments on your machine:
  `conda env list`

* Activate your environment:
  `activate datadevil`

* List the packages that were installed in this environment:
  `conda list`

* Install Pandas:
  `conda install pandas`

* Just as you installed pandas, install the following Python packages: <u>jupyter</u>, <u>matplotlib</u>, <u>seaborn</u>, <u>requests</u>, and <u>spyder</u>. 

* Save your configuration to a file:
  `conda list --explicit > datadevils.yml`

\*With this text file, you - or others - can rebuild your environment easily with the following command:
`conda create --name <env> --file datadevils.yml`



**OK, we now have plenty of packages to get us going!**