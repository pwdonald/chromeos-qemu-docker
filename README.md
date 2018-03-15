# Termux + QEMU + Alpine Linux = Docker on Stock ChromeOS
## No Developer Mode Needed.
#### Tutorial for running Docker with an Alpine Linux Host inside of QEMU VM on a ChromeOS/Termux host.

![Screenshot](/screenshot/screenshot-alpine-linux.png?raw=true "ChromeOS+qemu+Alpine Linux")

**Why would you choose this method over crouton?**
Crouton requires enabling developer mode on your ChromeOS device which breaks the security model of ChromeOS. This is fine for most developers but you trade security for performance. My goal was instead to trade performance for security.

**Warning: Tested on Samsung Chromebook Pro (Intel m3 x86_64 w/ ChromeOS 63, 64) other hardware results may vary.**
*I would be interested to know about other ChromeOS devices, so please let me know your results via PR or email*

**ARM Processor based ChromeOS Devices will have to use the `qemu-system-x86_64` command which requires modifiying the two scripts in the script directory of this repo.**

* What you will need:
    - An hour of time.
    - A ChromeOS Device with Android Apps support. (Again, Developer Mode is **NOT** needed)
    - The [**Termux App**](https://github.com/termux/termux-app) [Play Store Link](https://play.google.com/store/apps/details?id=com.termux&hl=en)
    - The [**Termux X/GUI Repos**](https://github.com/xeffyr/termux-x-repository)
    - The latest [Alpine **Virutal** ISO (x86_64)](https://alpinelinux.org/downloads/) (NOTE: I could not get the standard Alpine ISO to work, so far I've only managed to get the *Virtual* version to work)
  
### Installation Steps
1. Install Termux.
2. Setup Termux packages:
   ```
   pkg update
   pkg upgrade
   pkg install coreutils
   pkg install termux-tools proot util-linux net-tools openssh git
   pkg install wget
   ```
   **NOTE: It is important to install wget or https will fail due to an older verison that comes with Termux.**
2. Setup storage:
   ```
   termux-setup-storage
   ```
   *For more information about directories in Termux see [this stack overflow post](https://android.stackexchange.com/questions/166538/where-is-the-folder-that-termux-defaults-to).*
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
8. Download the latest version of the *virtual* ISO from the Alpine Linux website.
    1. Rename the iso to alpine_x86_64.iso
    2. Run the command 
        ```
        bash ./chromeos-qemu-docker/scripts/setup_alpine.sh
        ``` 
        * This script should be run in whichever directory your virtual drive exists to start the VM.
        * This may take a few minutes to start, resulting in a black screen with a cursor.
        * If you've been using the Termux session for a while you may see some of your history creep into view instead of a black screen.
9. Once inside the VM:
    1. Login with username root.
    2. Run the following command:
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
    * **Congrats! You've installed Alpine Linux!**
11. Run the command:
    ```
    bash ./chromeos-qemu-docker/scripts/start_persist.sh
    ```
       1. Login with root & the password you setup in step 8.
          * You may have to add your nameservers again.
       2. Run:
          ```
          apk --no-cache update
          apk --no-cache install vim
          ```
          **Or install your favorite editor of choice**
       3. Use vim (or whiehver editor) to modify `/etc/apk/repositories` by uncommenting the line ending with `community`. To uncomment simply delete the leading `#` symbol on the line.
       4. Run 
          ```
          apk --no-cache add docker
          ```
          **Docker is now installed!**
12. Start the docker service with
    ```
    service docker start
    ```
    * You can now use docker as you would in a traditional environment.
    * The `start_persist.sh` script maps ports 22 and 80 from the virtual environment to 10020 and 10080 respectively on the Termux environment. You can utilize these ports from your ChromeOS env by finding the IP address of your Termux session.

### Supported Devices
This is a list of devices with report(s) of successful installation.
* Samsung Chromebook Pro
* Asus C302
