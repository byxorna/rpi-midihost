# rpi-midihost

raspberry pi midi host

# Install

1. Install a debian base image to your SD card, make sure to enable ssh and set a password/ssh key for `pi` user
2. Boot up rpi, ensure its on the network
3. Run `./scripts/configure.sh midihost`, replace `midihost` with your hostname
4. Plug in a midi device, and check `journalctl -u midihost -fl`

Setting the system into `ro` mode is not performed for you by this script. Should you want to be able to pull the power and not screw up the sdcard, make sure you enable read-only mode.

1. `sudo raspi-config`
2. `4 - Performance`
3. `P3 - Overlay File System`
4. Reboot

# Sources

- (2022-02-10) https://neuma.studio/rpi-midi-complete.html
- https://neuma.studio/rpi-as-midi-host.html
