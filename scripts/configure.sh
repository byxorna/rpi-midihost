#!/bin/bash
set -e

rpi_host="${1:-midihost}"
rpi_user="pi"

if ! nmap -p 22 --open $rpi_host ; then
  echo "port 22 is not open on $rpi_host, aborting setup"
  exit 1
fi

echo -en "\n\nStart to configure midi host service on $rpi_host\n\ntype 'yes' without quotes to continue: "
read resp
if [[ $resp != yes ]] ; then
  echo "Aborting" >&2
  exit 2
fi

do_remote(){
  ssh $rpi_user@$rpi_host "$@"
}

do_remote uname -a
do_remote sudo apt-get update -y
do_remote sudo apt-get upgrade -y
do_remote sudo apt-get -y install ruby git curl jq vim

# TODO: rpi-update
scp -r config $rpi_user@$rpi_host:
do_remote sudo cp config/udev/rules.d/33-midiusb.rules /etc/udev/rules.d/
do_remote sudo cp config/systemd/system/midihost.service /etc/systemd/system/
do_remote sudo cp config/bin/connectall.rb /usr/local/bin/
do_remote rm -rf config/

do_remote sudo udevadm control --reload
do_remote sudo service udev restart

do_remote sudo systemctl daemon-reload
do_remote sudo systemctl enable midihost.service
do_remote sudo systemctl start midihost.service

do_remote journalctl -u midihost.service -xb

echo -e "\n\nAll complete - you can try to plug midi devices into $rpi_host now. Don't forget to shut the rpi down safely"

