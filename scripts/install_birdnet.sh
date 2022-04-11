#!/usr/bin/env bash
# Install BirdNET script
set -x
exec > >(tee -i installation-$(date +%F).txt) 2>&1
set -e # exit installation if anything fails
my_dir=$(realpath $(dirname $0))
trap '${my_dir}/dump_logs.sh && echo -e "\n\nExiting the installation. Goodbye!" && exit 1' SIGINT
cd $my_dir || exit 1

if [ "$(uname -m)" != "aarch64" ];then
  echo "BirdNET-Pi requires a 64-bit OS.
It looks like your operating system is using $(uname -m), 
but would need to be aarch64.
Please take a look at https://birdnetwiki.pmcgui.xyz for more
information"
  exit 1
fi

#Install/Configure /etc/birdnet/birdnet.conf
./install_config.sh || exit 1
sudo ./install_services.sh || exit 1
source /etc/birdnet/birdnet.conf

install_birdnet() {
  cd ~/BirdNET-Pi || exit 1
  echo "Establishing a python virtual environment"
  python3 -m venv birdnet
  source ./birdnet/bin/activate
  pip3 install -U -r $HOME/BirdNET-Pi/requirements.txt
}

[ -d ${RECS_DIR} ] || mkdir -p ${RECS_DIR} &> /dev/null

install_birdnet 
exit 0
