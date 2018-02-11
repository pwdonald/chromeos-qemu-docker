# Termux + QEMU + Alpine Linux = Docker on ChromeOS w/o Developer Mode
## No Developer Mode Needed.
#### Tutorial for running Docker with an Alpine Linux Host inside of QEMU VM on a ChromeOS/Termux host.

**Warning: Tested on Samsung Chromebook Pro (Intel m3 x86_64 w/ ChromeOS 63, 64) other hardware results may vary.**
*I would be interested to know about other ChromeOS devices, so please let me know your results via PR or email*

What you will need:
* An hour of time.
* A ChromeOS Device with Android Apps support. (Again, Developer Mode is **NOT** needed)
* The [**Termux App**](https://github.com/termux/termux-app) [Play Store Link](https://play.google.com/store/apps/details?id=com.termux&hl=en)
* The [**Termux X/GUI Repos**](https://github.com/xeffyr/termux-x-repository)
* The latest [Alpine **Virutal** ISO (x86_64)](https://alpinelinux.org/downloads/)
  (NOTE: I could not get the standard Alpine ISO to work, so far I've only managed to get the *Virtual* version to work)
  
### Installation Steps
1. Install Termux.
2. Setup Termux packages:
   ```
   pkg update
   pkg upgrade
   pkg install coreutils
   pkg install termux-tools proot util-linux net-tools openssh git
   ```
2. Setup storage:
   ```
   termux-setup-storage
   ```
4. Add the X/GUI Repos:
   ```
   wget https://raw.githubusercontent.com/xeffyr/termux-x-repository/master/enablerepo.sh
   bash enablerepo.sh
   ```
5. Install QEMU
    ```
    pkg install qemu-system
    ```
6. Clone this repo:
   ```
   git clone https://github.com/pwdonald/chromeos-qemu-docker.git
   ```
7. Create Virtual Storage Device: 
   (NOTE: make sure you're aware of what directory you're in i.e. /storage/emulated/0/Download can be wiped by ChromeOS periodically as space is needed so backup often!)
   * This command will create a 4GB dynamically allocated (qcow2) virtual drive.
   ```
   qemu-img create -f qcow2 virtual_drive 4G
   ```
8. Run the `setup_alpine.sh` script in whichever directory your virtual drive exists to start the VM.
   * This may take a few minutes to start, resulting in a black screen with a cursor.
   * If you've been using the Termux session for a while you may see some of your history creep into view instead of a black screen.
9. Once inside the VM:
   * Login with username root.
   * Run the following command:
   ```
   setup-alpine
   ```
   Answer the questions as you see fit. You may encounter errors when trying to setup the alpine package repos. If this happens you will need to exit the script (Ctrl + C) and run the following:
   ```
   echo "nameserver 8.8.8.8" > /etc/resolv.conf
   ```
   Then attempt to run the `alpine-setup` command again.
10. Once the `alpine-setup` script is complete--it will instruct you to restart the machine.
   * To exit the VM Press **Ctrl + A, X**.
11. Congrats! You've installed Alpine Linux!
   * Use the `start_persist.sh` script from this repo in the directory with your virtual drive to start the VM.
   * Login with root & the password you setup in step 8.
   * You may have to add your nameservers again.
   * Run `apk --no-cache update`
   * Run `apk --no-cache add docker`
11. Docker is now installed!
   * Start the docker service with
     ```
     service docker start
     ```
   * You can now use docker as you would in an traditional environment.
   * The `start_persist.sh` script maps ports 22 and 80 from the virtual environment to 10020 and 10080 respectively on the Termux environment. You can utilize these ports from your ChromeOS env by finding the IP address of your Termux session. (ADD INSTRUCTIONS)
   
