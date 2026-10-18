\# Lab 01 — First Virtual Machine



\## Objective

Install Ubuntu Server in VMware Workstation, allocate appropriate resources, and demonstrate snapshot recovery.



\## VM Configuration

\- \*\*Hypervisor:\*\* VMware Workstation

\- \*\*Operating System:\*\* Ubuntu Server 26.04.1 LTS

\- \*\*CPU:\*\* 2 vCPUs

\- \*\*RAM:\*\* 6 GB

\- \*\*Disk:\*\* 20 GB

\- \*\*Network:\*\* NAT



\## Resource Allocation Justification

My host computer has an Intel Core 5 210H processor with 12 logical processors, 16 GB of RAM, and a 477 GB NVMe SSD.



According to Windows Task Manager, approximately 8.5 GB of RAM was in use, leaving around 7.1 GB available. I allocated 6 GB to the VM to provide sufficient memory for Ubuntu Server while retaining memory for Windows. I assigned 2 vCPUs to avoid overloading the host processor. The 20 GB virtual disk is sufficient for this basic server installation, and my host had approximately 363 GB of free disk space.



\## Snapshot and Recovery

I created a snapshot named `clean-install` before making changes to the virtual machine.



I intentionally deleted `/etc/hostname` to demonstrate a configuration failure.



After confirming the file was missing, I restored the virtual machine using the `clean-install` snapshot.



I verified the recovery by running `cat /etc/hostname`, which returned `ubuntu-lab1`.



\## Evidence

\- `evidence/vm-settings.png` — VM resource configuration

\- `evidence/guest-release.txt` — Ubuntu version, memory, and disk information

\- `evidence/broken.png` — Deleted hostname file

\- `evidence/snapshot-list.png` — VMware snapshot manager

