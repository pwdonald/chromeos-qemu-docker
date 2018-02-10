qemu -nographic \
	-hda virtual_drive \
	-boot c \
	-net user,hostfwd=tcp::10022-:22,hostfwd=tcp::10080-:80 \
	-net nic \
	-m 512M \
	-smp 3 \
	-localtime
