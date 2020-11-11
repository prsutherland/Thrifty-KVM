# Thrifty-KVM
Scripts to switch monitor source based on USB keyboard plug/unplug events.

## Overview
My home office for work and personal computing and I need to be able to
switch back-and-forth between my work and personal computers.

[3-Monitor KVM switches](https://amzn.to/2K2V1zv) can be really pricey!

So I settled on just a basic [USB-only KVM switch](https://amzn.to/3pjzjHk).

Monitors have multiple source inputs anyways, so why not just switch the
source when I switch the KVM?

To do that, we either need to manually change the monitor source (ugh.) or,
we need to get one of the computers to change the source for the monitors.

I have three [Dell U2415s](https://amzn.to/2GXp0aQ) which support MCCS
(Monitor Control Command Set) which video drivers (on Linux) will expose as
an I2C bus at /dev/i2c-N.

[ddcutil](https://www.ddcutil.com/) can be used to read/write and explore
the settings exposed by the monitors.

_Note:_ If you are using this repo to jury-rig your own KVM, your settings
will likely be different. The first step to installing this is figuring
out what your settings should be and editing the scripts.

Now, to run the monitor switching scripts, we need to know when the usb KVM
switch is toggled. To do that, [udev](https://en.wikipedia.org/wiki/Udev) to
listen for the events fired when our usb keyboard is plugged in or unplugged.

## Configuration
1.  Install ddcutil. On Ubuntu 20.04:

    ```
    sudo apt install ddcutil
    ```

2.  Find your monitor(s) serial numbers:
    ```
    sudo ddcutil detect
    ```

    Your output will look something like:
    ```
    Display 1
       I2C bus:             /dev/i2c-1
       EDID synopsis:
          Mfg id:           DEL
          Model:            DELL U2415
          Serial number:    CFV9N6B8058L
          Manufacture year: 2016
          EDID version:     1.3
       VCP version:         2.1

    Display 2
       I2C bus:             /dev/i2c-3
       EDID synopsis:
          Mfg id:           DEL
          Model:            DELL U2415
          Serial number:    CFV9N6B80KEL
          Manufacture year: 2016
          EDID version:     1.3
       VCP version:         2.1

    Display 3
       I2C bus:             /dev/i2c-5
       EDID synopsis:
          Mfg id:           DEL
          Model:            DELL U2415
          Serial number:    CFV9N7BO103L
          Manufacture year: 2017
          EDID version:     1.3
       VCP version:         2.1
    ```

    Save the `Serial number:    CFV9N6B8058L` for later.

3.  Find the capabilities of your monitors

    ```
    sudo ddcutil capabilities --sn=[YOUR SERIAL NUMBER]
    ```

    Look for `Input Source` in the output e.g.

    ```
       Feature: 60 (Input Source)
          Values:
             0f: DisplayPort-1
             10: DisplayPort-2
             11: HDMI-1
             12: HDMI-2
    ```

4.  Edit `src/on-keyboard-plug.sh` and `src/on-keyboard-unplug.sh` to set the
    `[SERIAL]`, `[FEATURE]` and `[VALUE]` you want the monitor to be in when the
    keyboard is plugged in or unplugged.

    _Note #1:_ ddcutil lists the values as hexidecimal, but requires a leading
    `x` to interpret command line arguments as hex. So, changing to HDMI-2 on my
    monitors, I edit the script to use `x12` as the value.

    _Note #2:_ Remove the square brackets on `[FEATURE]` and `[VALUE]`

    _Note #3:_ Add / remove commands depending on how many monitors / serial
    numbers you have.

5.  Figure out your keyboard's vendor ID:

    ```
    sudo udevadm monitor
    ```

    Now unplug your keyboard and plug it back in. You should see a bunch of
    events logged to the console like.

    ```
    UDEV  [2520806.444432] add      /devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1.2/3-1.2:1.0/0003:045E:00DB.0034 (hid)
    ```

    Stop the monitoring with ctrl-C. The part that matches `045E` in the output
    above is likely the vendor ID. To confirm, take the `3-1.2` equivalent from
    the device path in the output above and find the device in your `sys`
    filesystem.
    
    For example my keyboard's `sys` path is `/sys/bus/usb/devices/3-1.2`

    ```
    sudo udevadm info  /sys/bus/usb/devices/3-1.2 | grep -e "DEVPATH" -e "ID_VENDOR_ID"
    ```

    Outputs:
    ```
    E: DEVPATH=/devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1.2
    E: ID_VENDOR_ID=045e
    ```

6.  Edit `src/80-thrifty-kvm.rules` to set your `[VENDOR_ID]`.

    _Note #1:_ Remove the square brackets replacing all of `[VENDOR_ID]`.
    
    _Note #2:_ `[VENDOR_ID]` is in `src/80-thrifty-kvm.rules` twice.

## Installation

```
make PREFIX=/usr/local
sudo make install PREFIX=/usr/local
```

## Removal

```
sudo make uninstall PREFIX=/usr/local
```
