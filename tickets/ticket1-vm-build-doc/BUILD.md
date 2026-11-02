# BUILD — Rebuild an Ubuntu Server and Windows 11 test environment in VMware Workstation

This guide is for someone who has never used a hypervisor. It describes the settings and checks demonstrated for Ticket 1. **The two existing machines were tested; this guide has not yet been independently reproduced from scratch.** Screenshots of the wizard were captured by reopening it after setup.

## Before you begin

- A Windows host with VMware Workstation installed, at least 16 GB RAM and enough free disk space for two virtual disks plus operating-system files.
- A legitimate Ubuntu Server ISO and a properly licensed Windows 11 ISO. The Windows VM tested here displays an **expired evaluation license**; do not treat that as a valid long-term developer deployment.
- Administrator permission to create VMs and change Windows Firewall inbound rules.
- Close memory-heavy applications. Avoid assigning the full host RAM to guests.

## Part A — Create Ubuntu Server

1. In VMware Workstation choose **File > New Virtual Machine > Typical (recommended) > Next**.
2. Select the Ubuntu Server installer ISO. If VMware's automated installation behaves differently, select **I will install the operating system later** and attach the ISO in **VM > Settings > CD/DVD**.
3. Select **Linux > Ubuntu 64-bit**, name the VM `Ubuntu-Server-Lab1`, and choose a folder with adequate free disk space.
4. Choose a **20 GB** virtual disk for this minimal server demonstration. More may be needed for a real developer's workload.
5. Before finishing, choose **Customize Hardware**. Set **Memory: 6144 MB (6 GB)**, **Processors: 2 virtual CPUs**, **Network Adapter: NAT**. Check these values against your host resources. [Observed Ubuntu settings](evidence/06-ubuntu-settings.png).
6. Finish, start the VM and follow the Ubuntu installer. Create a local username and a strong unique password. Do not publish credentials in the repository. When installation finishes, reboot and log in.
7. In the Ubuntu terminal run:

   ```bash
   free -h
   ip -br addr
   ping -c 4 google.com
   ```

   The first command shows usable RAM ([example](evidence/03-ubuntu-memory.png)); the second shows the guest's IP ([example](evidence/05-ubuntu-ip.png)); the third checks internet and DNS ([example](evidence/04-ubuntu-internet.png)). Your IP and memory readings may differ.

## Part B — Create Windows 11

1. Choose **File > New Virtual Machine > Typical (recommended) > Next**.
2. Select a legitimate Windows 11 ISO. VMware should recognize Windows 11 x64. [Illustrative wizard screenshot](evidence/01-new-vm-wizard.png).
3. Follow the guest OS and naming pages. Name the new VM `Ticket1-Windows11`; choose a folder with sufficient free space. Do **not** overwrite an existing VM.
4. On **Specify Disk Capacity**, choose **64 GB** and **Split virtual disk into multiple files**. [Illustrative wizard screenshot](evidence/02-disk-settings.png). This is easier to move between file systems, although a single file may have a small performance advantage.
5. In **Customize Hardware**, choose **NAT** networking and a conservative RAM/CPU allocation that leaves enough memory for the host. For comparison, an **older** `lab02-win11` VM used 4 GB RAM and 2 virtual processors ([older VM settings](evidence/13-windows-settings-previous-vm.png)); **these values have not been verified for the new `Ticket1-Windows11` guest**. Capture the new guest's actual hardware settings before claiming them.
6. Start the VM and complete the Windows setup using a valid license. Create a local user or other account as permitted by your organization, and keep credentials private.
7. In Windows press **Win + R**, type `cmd`, press Enter and run:

   ```cmd
   ipconfig
   ping google.com
   ```

   Check for an IPv4 address ([observed example](evidence/12-windows-ip.png)) and four successful internet replies ([observed example](evidence/09-windows-internet.png)).

## Part C — Verify guest-to-guest networking

1. Keep both guests powered on. NAT was selected because it provides outbound connectivity without bridging the guests directly onto the physical network. Both guests must be connected to the **same VMware NAT network** for the examples below.
2. On Ubuntu, run `ip -br addr`. On Windows, run `ipconfig`. In the observed run Ubuntu was `192.168.192.130` and Windows was `192.168.192.132`. **Use your own addresses**, not these example IPs.
3. From Windows CMD run `ping <UBUNTU_IP>`. The observed run received four replies with 0% loss ([output](evidence/07-windows-to-ubuntu.png)).
4. From Ubuntu run `ping -c 4 <WINDOWS_IP>`. If the Windows guest does not respond, check the Windows network profile and open **Win + R > wf.msc > Inbound Rules**. Enable the **File and Printer Sharing (Echo Request - ICMPv4-In)** rule for the applicable profile, ideally limited to the private VMware NAT subnet. **Do not disable the entire firewall.** Retry. The observed retest returned four replies, 0% loss ([output](evidence/08-ubuntu-to-windows.png)).
5. If connectivity still fails, check the guests' VMware adapter settings, IP addresses and NAT segment. Ping can be blocked by firewall policy even when other networking works.

## Part D — Create restore points

1. With each guest in a stable state, select the VM and choose **VM > Snapshot > Take a Snapshot**.
2. Give each snapshot a descriptive name, for example `working-after-install`, and record the purpose. The observed screenshots show an Ubuntu snapshot chain ([manager](evidence/11-ubuntu-snapshot.png)) and one Windows snapshot ([manager](evidence/10-windows-snapshot.png)); their existing names were not descriptive.
3. Do not delete snapshots just to capture a screenshot. Snapshots are short-term restore points, **not backups**. For important data, also keep separate backups.
4. To test restoration later, follow organizational policy, save any important work first, and use **Snapshot Manager > Go To**. **Restoration was not tested as part of this ticket.**

## Part E — Final acceptance checklist

- [x] Ubuntu booted and reported memory and IP.
- [x] Ubuntu reached the internet.
- [x] Windows booted and reported IP.
- [x] Windows reached the internet.
- [x] Windows pinged Ubuntu successfully.
- [x] Ubuntu pinged Windows successfully after a narrow firewall rule change.
- [x] Snapshot Manager showed restore points for both VMs.
- [ ] Confirm the **new** Windows guest's exact RAM, CPU, disk and NAT settings with a screenshot.
- [ ] Capture screenshots of a **real** installation sequence for each guest if required by the instructor; the current wizard screenshots are later recreations.
- [ ] Have another student or another machine reproduce this guide and record results in `review/`.
