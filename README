# EVB-Toybrick
EVB-Toybrick RK3399

Toybrick Setup with mainline Uboot & ATF Procedure :

Git Source & Compile ATF
========================
  > git clone https://github.com/ARM-software/arm-trusted-firmware.git
  > cd arm-trusted-firmware
  > make realclean
  > make CROSS_COMPILE=aarch64-linux-gnu- PLAT=rk3399 bl31

  Get bl31.elf in this step, copy it to U-Boot root dir:
  > cp build/rk3399/release/bl31/bl31.elf ../u-boot/

Git Source & Compile Mainline U-Boot
====================================

Copy bl31.elf file to uboot folder before building

  > git clone https://gitlab.denx.de/u-boot/u-boot.git
  > cd ../u-boot
  > export ARCH=arm                                                
  > export CROSS_COMPILE=aarch64-linux-gnu-                                         
  > make evb-rk3399_defconfig                                                                
  > make menuconfig                 /* Optional */                                           
  > make

=============================================================

Toybrick Target Image Flashing Procedure 
========================================

Install Android Tool v2.71

Address Name Path :

0x0000 Miniloader   — ../miniloader.bin
0x0000 Parameter    — ../paramter_toybrick.txt
0x0040 loader1      — ../idbloader.img
0x4000 loader2      — ../uboot.itb
0x8000 SCT          — ../sct.efi
