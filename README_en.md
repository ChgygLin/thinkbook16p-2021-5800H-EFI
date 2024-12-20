# ThinkBook16p-2021-5800H-EFI
- `main` branch support  **macOS Sequoia** .
- `ventura` branch support **macOS Ventura** .



English (Current)  
[简体中文](README_zh.md)  



## Release Note

- 12-10-2024
  
  - **macOS Sequoia** first version：Geekbench 6: OpenCL/12196, Metal/20427, CPU: 1738/6958。

- ------

  06-26-2024

  - normal update.
  - latest NootedRed：Geekbench 6: OpenCL/11924, Metal/20561, CPU：1693/7141.
  
- 06-26-2024
  - normal update.

  - latest NootedRed：Geekbench 6: OpenCL/11923, Metal/20407, CPU：1728/7032.

- 12-14-2023

  - latest NootedRed。

- 11-11-2023

  - latest NootedRed：Geekbench 6: OpenCL/11751, Metal/19925, CPU：1719/6964.



##  Specifications

CPU: 5800H

GPU: RTX3060

WIFI/BT: AX200

BAT: 71Wh

EC: ITE8296

TP: MSFT0001



## Features

* macOS Monterey/Ventura && system update、Booting macOS/Linux dual system with Grub

* Wifi(work with `HeliPort`)、~~BT~~、Audio(Input、Output)、Integrated camera

* Shortcut（Audio、Display brightness、keyboard backlight）

* Battery（based on SSDT，Battery Percentage、Battery Info、Battery Temperature、Battery Charging/Discharging）

* Touchpad（GPIO interrupt mode，compiled with VoodooI2C master 20230711)

* USB mapping with USBToolBox

* Vega iGPU driver（compiled with NootedRed master 20231214）

* disabled RTX3060（based on SSDT）
* CPU Temperature Sensor（Fix SMCAMDProcessor Temperature Sensor BUG）



## Issues && Workaround

* Chrome hangs, need disable GPU Acceleration（chrome://settings/system： disselect Use hardware acceleration when available ）
* VSCode hangs, need disable GPU Acceleration（shift+cmd+p：Configure Runtime Arguments，add "disable-hardware-acceleration": true）



## Issues

* Flower blocks appear occasionally when opening high-resolution images ，kernel log，"**AMD** ERROR! Failed to allocate size:13107200. There is 52682688 free memory remaining, and 448982976 fixed-free memory remaining."

* Fan sensor/control（To be continued）

* <del>Microphone unavailable（[No Mic on AMD](https://dortania.github.io/OpenCore-Post-Install/universal/audio.html#no-mic-on-amd)）</del>

* external display (The hardware doesn't support  iGPU display output)



## BootLogo

* Copy the Lenovo directory to the EFI root directory to modify the boot logo

* Customized image，rename it to mylogo_2560x1600.bmp。



## Booting macOS/Linux dual system with Grub

Booting OpenCore with Grub（Grub can identify Windows boot partition，means 3 systems booting）

```shell
# In ubuntu
sudo cp BOOT/BOOTx64.efi /boot/efi/EFI/BOOT/BOOTx64-OC.efi
sudo cp -rf OC /boot/efi/EFI/

# Find the ID number 0D40-D569 corresponding to nvme0n1p1(EFI partition)
ls -l /dev/disk/by-uuid/

sudo vim /etc/grub.d/40_custom
#add the configuration
menuentry "OC-1.0.3 && Sequoia" {
        insmod chain
        insmod fat
        insmod part_gpt
        insmod search_fs_uuid
        search --fs-uuid --no-floppy --set=root 0D40-D569
        chainloader ($root)/EFI/BOOT/BOOTx64-OC.efi
}

sudo vim /etc/default/grub
# maybe need comment "GRUB_TIMEOUT_STYLE=hidden"

sudo update-grub
```



## SomeTips

* When OpenCore appears ，you can set the default booting system with ctrl+enter
* appleuserECM causing high cpu usage, maybe reinsert the usb network card
* mds_stores causing high cpu usage, you can close Spotlight, cancel all directory searches, and turn off shortcut keys
* Turn off spelling correction
  Settings-Keyboard-Text input-Correct spelling automatically



## **Star**

[![Star History Chart](https://api.star-history.com/svg?repos=ChgygLin/thinkbook16p-2021-5800H-EFI&type=Date)



## Buy me a coffee

<table>
<tr>
<td style="text-align: center;"><img width="80%" src="https://pica.zhimg.com/v2-bbda9b88c354a2074b26ba4746c4a2bd_100w.jpg" title="alipay"><br>Alipay</td>
<td style="text-align: center;"><img width="85%" src="https://picx.zhimg.com/v2-6abdd4264bf5c066fe1acd46b7e5cac1_100w.jpg" title="wechat"><br>Wechat</td>
</tr>
</table>



## Credits

| Project                                               | Version  | Repository                                                  |
| ----------------------------------------------------- | -------- | ----------------------------------------------------------- |
| OpenCore                                              | 1.0.3    | https://github.com/acidanthera/OpenCorePkg                  |
| AMD Kernel Patch                                      | 24/12/10 | https://github.com/AMD-OSX/AMD_Vanilla                      |
| Lilu                                                  | 1.7.0    | https://github.com/acidanthera/Lilu                         |
| VirtualSMC<br />SMCBatteryManager<br />SMCLightSensor | 1.3.4    | https://github.com/acidanthera/VirtualSMC                   |
| AppleMCEReporterDisabler                              | Unknown  |                                                             |
| AMDRyzenCPUPowerManagement<br />SMCAMDProcessor       | 0.7.2    | https://github.com/trulyspinach/SMCAMDProcessor             |
| AmdTscSync                                            | 2.0.0    | https://github.com/naveenkrdy/AmdTscSync                    |
| NootedRed                                             | 24/12/08 | https://github.com/NootInc/NootedRed                        |
| NVMeFix                                               | 1.1.2    | https://github.com/acidanthera/NVMeFix                      |
| RestrictEvents                                        | 1.1.5    | https://github.com/acidanthera/RestrictEvents               |
| DebugEnhancer                                         | 1.1.0    | https://github.com/acidanthera/DebugEnhancer                |
| VoodooI2C<br />VoodooI2CHID                           | 23/07/11 | https://github.com/VoodooI2C/VoodooI2C                      |
| VoodooPS2Controller                                   | 2.3.7    | https://github.com/acidanthera/VoodooPS2                    |
| BrightnessKeys                                        | 1.0.3    | https://github.com/acidanthera/BrightnessKeys               |
| FeatureUnlock                                         | 1.1.7    | https://github.com/acidanthera/FeatureUnlock                |
| ECEnabler                                             | 1.0.5    | https://github.com/1Revenger1/ECEnabler                     |
| NullEthernet                                          | Unknown  | https://github.com/RehabMan/OS-X-Null-Ethernet              |
| AirportItlwm                                          | 2.3.0    | https://github.com/OpenIntelWireless/itlwm                  |
| IntelBluetoothFirmware<br />IntelBTPatcher            | 2.4.0    | https://github.com/OpenIntelWireless/IntelBluetoothFirmware |
| BlueToolFixup                                         | 2.6.9    | https://github.com/acidanthera/BrcmPatchRAM                 |
| RealtekCardReader                                     | 0.9.7    | https://github.com/0xFireWolf/RealtekCardReader             |
| RealtekCardReaderFriend                               | 1.0.4    | https://github.com/0xFireWolf/RealtekCardReaderFriend       |
| AppleALC                                              | 1.9.3    | https://github.com/acidanthera/AppleALC                     |
| USBMap                                                | think16p | https://github.com/USBToolBox/kext                          |



```shell
sh -c "$(curl -fsSL -x http://127.0.0.1:7890 https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

/bin/bash -c "$(curl -fsSL -x http://127.0.0.1:7890 https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```



## Reference

* [MacKernelSDK](https://github.com/acidanthera/MacKernelSDK)
* [编译触控板驱动](https://apple.sqlsec.com/6-实用姿势/6-2/)
* [SSDTTime](https://github.com/corpnewt/SSDTTime)

* [台式机黑苹果如何屏蔽不支持的NVIDIA独立显卡和PM981](https://heipg.cn/tutorial/block-nv-dgpu-or-pm981.html)

* [无法接收到系统更新推送的解决方法](https://heipg.cn/tutorial/macos-monterey-delta-update-fixup.html)

* [Disabling laptop dGPUs (SSDT-dGPU-Off/NoHybGfx)](https://dortania.github.io/Getting-Started-With-ACPI/Laptops/laptop-disable.html)
* [Battery Status](https://dortania.github.io/OpenCore-Post-Install/laptop-specific/battery.html#dual-battery)

* [Battery Information Supplement](https://github.com/acidanthera/VirtualSMC/blob/master/Docs/Battery%20Information%20Supplement.md)

* [ACPI_Spec_6_5_Aug29](https://uefi.org/sites/default/files/resources/ACPI_Spec_6_5_Aug29.pdf)

* [ThinkBook_16p_G2_ACH_Spec](https://psref.lenovo.com/syspool/Sys/PDF/ThinkBook/ThinkBook_16p_G2_ACH/ThinkBook_16p_G2_ACH_Spec.pdf)
* [GRUB 与 OpenCore 互相引导](https://zhuanlan.zhihu.com/p/631627635)
