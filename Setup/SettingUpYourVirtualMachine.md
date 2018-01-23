---
Title: Setting up your VM
Author: John Fay
Date: Spring 2018
---

# Setting up your virtual machine

All Duke students are allowed to create one virtual machine. For all intents and purposes, this is a PC that lives in a remote location that you can access via Remote Desktop software from anywhere on the Duke network (including via VPN). You have full administrative access on this machine making it perfect for installing the software we'll be using in our sessions.  

## 1. Creating your new virtual machine (VM)

* Open https://vcm.duke.edu in a browser and log in. 
* Select `Reserve a VM`.
* From the "Application and Operating System" dropdown, select `Windows Office 2016` and click `Reserve`.
* When your VM is ready:
  * Make a note of your machine's Hostname.
  * Optionally, create an easy to remember alias for your machine.
  * Click the `Remote Desktop` button and open the .`rdp` file in the Remote Desktop Connection app. 
  * Optionally, you can chose to download the `.rdb` file and you should be able to double-click it in any Windows machine to open your Remote Desktop connection. 

You now essentially have a new desktop at your disposal. This machine will remain active for the entire semester and you can access it from any PC using Remote Desktop software and entering your hostname or alias. You can also manage your VM via the https://vcm.duke.edu web site, though usually there's no need to actively manage it. 



## 2. Installing patches and applications 

### • Installing windows updates

When you first open your VM, you may need to install Windows updates. This may take a while, but you should do so. It may require a restart, which will bump you out of your Remote Desktop session, but that's ok. And the machine may not be immediately available after the restart, and that's ok too. Just wait a few minutes and you should be able to connect again. 

\* If after several minutes (e.g. > 10), you still can't connect to your VM, go to the management page (https://vcm.duke.edu > Virtual Machines) and `Power Off` then `Power On` your VM. 

### • Installing apps via the Software Center

The Software Center allows you to bulk-install several applications. Double-click the icon on your desktop to open it and install the following apps. 

* 7-zip
* Google Chrome (Also, set it as your default browser...)
* Notepad ++
* R
* RStudio

### • Installing and configuring other apps

#### ♦ GitHub Desktop

* Open Chrome (on your VM!) and Google for "GitHub Desktop"; or go straight to https://desktop.github.com/
* Download  and run the Windows installer file: `GitHubDesktop.exe`
* Sign into GitHub (create an account, if necessary)
* Enter your name and email
* Finish! That's it, for now...

#### ♦ Miniconda

* In Chrome, navigate to https://conda.io/miniconda.html and download the [64-bin Python 3.6 installer](https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe) .
* Run the installer, selecting all the default options when asked.


<END>