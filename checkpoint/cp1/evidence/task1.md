1a.

CPU Model	                                                        Intel(R) Core(TM) 5 210H	                                             Get-CimInstance Win32_Processor

Cores / logical processors                                              8 Cores, 12 Logical Processors                                               Get-CimInstance Win32_Processor

Hardware virtualization: supported? enabled in firmware?                Supported and enabled

Memory: total / available now                                           16gb                                                                         Get-CimInstance Win32_PhysicalMemory                                          

System disk: size, free space, SSD or HDD                               475GB, 270GB, ssd                                                            Get-PhysicalDisk / Get-Volume

Partition style of the system disk                                      GPT                                                                          Get-Disk



i cannot check if virtualization is enabled or supported using command, but i checked it using BIOS.

1b.

Short answer yes, but without any pressure.
Ubuntu and windows clients both using around 10gb of RAM, 86gb of disk and 4 cores.
Firstly it will hardly even work. Secondly for the safety of the users device
It seems like anything on this laptop cannot be upgraded because of they soldered to the board, so nothing can be upgraded. I would change this laptop to better laptop, at least with 16gb of ram, 512gb of ssd NVMe disk and 6-8 cores processor. Also it must be upgradable.