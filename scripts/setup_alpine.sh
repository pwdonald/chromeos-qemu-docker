qemu -nographic \
	-m 512m \
	-cdrom alpine_x86_64.iso \
	-hda virtual_drive \
	-boot d \
	-net nic \
	-net user \
	-localtime
