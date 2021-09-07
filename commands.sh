#!/bin/bash -ex

flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=32768 -r dump.bin -c "GD25Q127C/GD25Q128C"
dd if=dump.bin of=squashfs.bin skip=7936 count=21740
mount squashfs.bin /mnt/sqashfs/ -t squashfs -o loop
dd of=my_dump.bin if=my_bootenv.bin bs=16 count=4096 seek=24576 conv=notrunc
rm my_squashfs.bin
mksquashfs /mnt/my_squashfs my_squashfs.bin -comp xz -b 32768
dd if=my_squashfs.bin of=my_dump.bin seek=7936 conv=notrunc
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=32768 -w my_dump.bin -c "GD25Q127C/GD25Q128C"
