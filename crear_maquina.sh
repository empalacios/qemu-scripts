#!/bin/bash
MINPARAMS=6

if [ $# -lt "$MINPARAMS" ]
then
  echo "Usage $0 vm_name vms_directory disk_size ram_size install_image vnc_port"
  echo "  vm_name:       Virtual machine's name"
  echo "  vms_directory: Base directory where the virtual machine's directory will be created"
  echo "  disk_size:     Capacity of the virtual machine's drive, in Gigabytes"
  echo "  ram_size:      Capacity of the virtual machine's RAM, in Megabytes"
  echo "  install_image: Path to the installation image (ISO)"
  echo "  vnc_port:      VNC Port remote display clients"
  exit 1
fi


vm_name=${1}
qemu_vms_directory=${2}
disk_size=${3}
ram_size=${4}
installation_image=${5}
vnc_port=${6}
vm_directory=$qemu_vms_directory/$vm_name
disk_name=$vm_directory/$vm_name.qcow2


if [ -e "$vm_directory" ]
then
  rm -rf $vm_directory
fi
mkdir $vm_directory

qemu-img create -f qcow2 $disk_name "${disk_size}G"
echo "Created hard drive $disk_name for $vm_name, size $disk_size Gb"

echo 'cdrom <installation_image> parameter is useful only for first'
echo 'time start.'
echo 'Start vm with host display'
echo "  qemu-system-x86_64 \\"
echo "    -m $ram_size \\"
echo "    -nic user,model=virtio \\"
echo "    -drive file=$disk_name,media=disk,if=virtio \\"
echo "    -cdrom $installation_image \\"
echo "    -display gtk"
echo
echo
qemu_vnc_port_parameter=$(expr $vnc_port - 5900)
echo 'Start vm with vnc server for remote display'
echo "  qemu-system-x86_64 \\"
echo "    -m $ram_size \\"
echo "    -nic user,model=virtio \\"
echo "    -drive file=$disk_name,media=disk,if=virtio \\"
echo "    -cdrom $installation_image \\"
echo "    -vnc :$qemu_vnc_port_parameter,password -monitor stdio"
echo "On qemu cli" 
echo "Set vnc password: change vnc password"
echo "Connect VNC Client on <host ip>:$vnc_port with password set."
