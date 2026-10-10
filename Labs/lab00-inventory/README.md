# Lab 0 — Inventory your own machine

## Summary table

| What | Value | Where I got it |
| :--- | :--- | :--- |
| **CPU Model & Cores** | Intel(R) Core(TM) 5 210H (8 Cores, 12 Logical Processors) | Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List |
| **Total Memory** | 16 GB (2 modules, Micron Technology, 5600 MT/s) | Get-CimInstance Win32_PhysicalMemory | Select-Object BankLabel, Manufacturer, Capacity, Speed |
| **Disk Size & Free Space** | BIWIN CE980Q41R00-512 (512 GB SSD, NVMe). Disk C: ~385 GB free out of ~476 GB | Get-PhysicalDisk / Get-Volume |
| **Firmware Type** | UEFI | (Get-ComputerInfo).BiosFirmwareType |
| **Hardware Virtualization** | Enabled | Checked via BIOS |

## What did not work
During the lab work, I encountered minor issues with file encodings and paths in PowerShell (which were quickly resolved by using the -Encoding utf8 flag). Additionally, I had to move the project folder from the system directory to the root of the C drive to ensure proper execution of Git commands.
