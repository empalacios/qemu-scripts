#!/bin/bash
vm_name=alpine2
vm_directory=/home/user/qemu/$vm_name
disk_name=$vm_directory/$vm_name.qcow2
disk_size=16G
ram_size=2048
installation_image=/home/user/qemu/alpine/alpine-standard-3.8.0-x86_64.iso
vnc_port=5900

mkdir $vm_directory
qemu-img create -f qcow2 $disk_name $disk_size
echo "Created hard drive $disk_name for $vm_name, size $disk_size"

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
