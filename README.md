# ThinkBook16p-2021-5800H-EFI

本EFI适配ThinkBook16p 2021 ，其他5800H笔记本也可参考。

[English](README_en.md)  
简体中文 (当前语言)  

PS: 20231111更新显卡驱动至NootedRed-20231111。Geekbench 6 OpenCL：11751，Metal：19925，CPU：1719/6964。



##  基本配置信息

CPU: 5800H

GPU: RTX3060

WIFI/BT: AX200

BAT: 71Wh

EC: ITE8296

TP: MSFT0001



## EFI支持情况

* 支持macOS Monterey/Ventura系统，支持grub引导macOS/Linux双系统，支持系统推送更新

* 支持Wifi，蓝牙，声卡(输入、输出)，集成摄像头

* 快捷键（音量、屏幕亮度、键盘背光）

* 支持电池相关功能（基于SSDT，电量显示、电池信息、电池温度Sensor、充放电状态）

* 支持触摸板（GPIO中断模式，基于 VoodooI2C master分支0711编译)

* 定制USB驱动

* Vega集显驱动（基于NootedRed master分支0915编译）

* 关闭RTX3060（基于SSDT，屏蔽以省电）
* CPU温度Sensor（修复了SMCAMDProcessor官方最新代码不支持温度上报的BUG，新版macOS不支持功耗Sensor，如需要请使用**AMD Power Gadget**）



## 已知问题(*Workaround*)

* Chrome首次启动卡顿，需要关闭GPU加速（chrome://settings/system： 反选Use hardware acceleration when available ）
* VSCode首次启动卡顿，需要关闭GPU加速（shift+cmd+p：Configure Runtime Arguments，添加"disable-hardware-acceleration": true）



## 已知问题

* 打开高分辨率图片偶尔会出现花块，系统卡顿时内核日志报错，"**AMD** ERROR! Failed to allocate size:13107200. There is 52682688 free memory remaining, and 448982976 fixed-free memory remaining."（等显卡驱动更新）

* 风扇Sensor监控（搁置）

* <del>麦克风无法使用（[No Mic on AMD](https://dortania.github.io/OpenCore-Post-Install/universal/audio.html#no-mic-on-amd)）</del>

* 外接显示器



## 启动画面

* 将Lenovo目录拷贝至EFI根目录即可修改启动画面。

* 可自定义bmp图片，图片名为mylogo_2560x1600.bmp。



## Grub引导Linux/macOS双系统

主力系统为Ubuntu，使用Grub引导OpenCore（Grub默认支持识别Windows启动分区，可实现3系统引导）。

```shell
# 在ubuntu系统中
sudo cp BOOT/BOOTx64.efi /boot/efi/EFI/BOOT/BOOTx64-OC.efi
sudo cp -rf OC /boot/efi/EFI/

ls -l /dev/disk/by-uuid/
# 找到nvme0n1p1对应的id号0D40-D569

sudo vim /etc/grub.d/40_custom
#添加如下信息
menuentry "OC-0.9.3 && Ventura" {
        insmod chain
        insmod fat
        insmod part_gpt
        insmod search_fs_uuid
        search --fs-uuid --no-floppy --set=root 0D40-D569
        chainloader ($root)/EFI/BOOT/BOOTx64-OC.efi
}

sudo vim /etc/default/grub
# 注释 GRUB_TIMEOUT_STYLE=hidden

sudo update-grub
```



## SomeTips

* 在opencore启动界面，ctrl+enter设置默认启动系统
* appleuserECM进程cpu占用过高
  usb网卡拔掉重插
* mds_stores进程cpu占用过高
  关闭Spotlight，取消所有目录搜索，关闭快捷键
* 关闭拼写纠正
  Settings-Keyboard-Text input-Correct spelling automatically



## EFI使用软件

| SW                                                    | 版本号   | 项目地址                                                    |
| ----------------------------------------------------- | -------- | ----------------------------------------------------------- |
| OpenCore                                              | 0.9.3    | https://github.com/acidanthera/OpenCorePkg                  |
| AMD Kernel Patch                                      | 23/06/14 | https://github.com/AMD-OSX/AMD_Vanilla                      |
| Lilu                                                  | 1.6.7    | https://github.com/acidanthera/Lilu                         |
| VirtualSMC<br />SMCBatteryManager<br />SMCLightSensor | 1.3.2    | https://github.com/acidanthera/VirtualSMC                   |
| AppleMCEReporterDisabler                              | Unknown  |                                                             |
| AMDRyzenCPUPowerManagement<br />SMCAMDProcessor       | 0.7.1    | https://github.com/trulyspinach/SMCAMDProcessor             |
| AmdTscSync                                            | 2.0.0    | https://github.com/naveenkrdy/AmdTscSync                    |
| NootedRed                                             | 23/09/15 | https://github.com/NootInc/NootedRed                        |
| NVMeFix                                               | 1.1.1    | https://github.com/acidanthera/NVMeFix                      |
| RestrictEvents                                        | 1.1.2    | https://github.com/acidanthera/RestrictEvents               |
| DebugEnhancer                                         | 1.0.8    | https://github.com/acidanthera/DebugEnhancer                |
| VoodooI2C<br />VoodooI2CHID                           | 23/07/11 | https://github.com/VoodooI2C/VoodooI2C                      |
| VoodooPS2Controller                                   | 2.3.5    | https://github.com/acidanthera/VoodooPS2                    |
| BrightnessKeys                                        | 1.0.3    | https://github.com/acidanthera/BrightnessKeys               |
| FeatureUnlock                                         | 1.1.5    | https://github.com/acidanthera/FeatureUnlock                |
| ECEnabler                                             | 1.0.4    | https://github.com/1Revenger1/ECEnabler                     |
| NullEthernet                                          | Unknown  | https://github.com/RehabMan/OS-X-Null-Ethernet              |
| AirportItlwm                                          | 2.2.0    | https://github.com/OpenIntelWireless/itlwm                  |
| IntelBluetoothFirmware<br />IntelBTPatcher            | 2.3.0    | https://github.com/OpenIntelWireless/IntelBluetoothFirmware |
| BlueToolFixup                                         | 2.6.8    | https://github.com/acidanthera/BrcmPatchRAM                 |
| RealtekCardReader                                     | 0.9.7    | https://github.com/0xFireWolf/RealtekCardReader             |
| RealtekCardReaderFriend                               | 1.0.4    | https://github.com/0xFireWolf/RealtekCardReaderFriend       |
| AppleALC                                              | 1.8.5    | https://github.com/acidanthera/AppleALC                     |
| USBMap                                                | think16p | https://github.com/USBToolBox/kext                          |



```shell
sh -c "$(curl -fsSL -x http://127.0.0.1:7890 https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

/bin/bash -c "$(curl -fsSL -x http://127.0.0.1:7890 https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```



## 参考资料

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
