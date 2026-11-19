# Task 2 — Plan and justify

**Host figures used (from Task 1, `evidence/task1.txt`):**

| Resource | Host total (Task 1) |
|---|---|
| CPU | Intel Core 5 210H — **8 cores / 12 logical processors** (hardware virtualization supported and enabled, checked in BIOS) |
| Memory | **16 GB** RAM (soldered, cannot be upgraded) |
| Disk | 475 GB SSD (GPT), **270 GB free** |
| Hypervisor | VMware Workstation |

## 1. Allocation

| Setting | Ubuntu Server guest (`ubuntu-srv`) | Windows 11 guest (`win11`) |
|---|---|---|
| vCPUs | 2 (1 processor × 2 cores) | 2 (1 processor × 2 cores) |
| Memory | 2 GB (2048 MB) | 4 GB (4096 MB) |
| Disk size | 25 GB | 64 GB |
| Disk type | VMDK, **dynamically allocated** ("Allocate all disk space now" left unchecked) | VMDK, **dynamically allocated** ("Allocate all disk space now" left unchecked) |
| Network adapter | 1 adapter, **NAT** (VMnet8) | 1 adapter, **NAT** (VMnet8) |
| Other | OpenSSH server installed during setup | UEFI + Secure Boot + virtual TPM (Windows 11 requirement; VMware needs the VM encrypted for vTPM, "only the files needed for TPM") |

## 2. Arithmetic

**Assumed host needs** (so the host stays usable — browser, Office, the VMware window):
- CPU: at least **2 logical processors** never given to guests.
- Memory: **4 GB** for Windows host + apps, plus **~0.5 GB** VMware overhead for two running VMs.
- Disk: **30 GB** free kept for host updates, pagefile and temp files.

| Resource | Host total | Ubuntu | Windows 11 | Given to guests | Left for host | Host needs | OK? |
|---|---|---|---|---|---|---|---|
| CPU (logical) | 12 | 2 | 2 | 4 | 12 − 4 = **8** | 2 | ✅ (8 ≥ 2) |
| Memory | 16 GB | 2 GB | 4 GB | 6 GB | 16 − 6 − 0.5 = **9.5 GB** | 4 GB | ✅ (9.5 ≥ 4) |
| Disk (worst case, disks fully grown) | 270 GB free | 25 GB | 64 GB | 89 GB | 270 − 89 = **181 GB** | 30 GB | ✅ (181 ≥ 30) |
| Disk (right after install, approx.) | 270 GB free | ~5 GB | ~20 GB | ~25 GB | ~245 GB | 30 GB | ✅ |

CPU note: guest vCPUs total 4 of 12 logical processors, so the host is never oversubscribed — even if both guests run at 100 %, 8 logical processors stay with the host. (The 210H mixes performance and efficiency cores, so 2 vCPUs per guest is deliberately conservative.)

Memory is the tight resource: 16 GB is soldered and cannot be upgraded (Task 1b), so guest RAM is kept to the minimum each OS needs instead of the ~10 GB I estimated in Task 1b.

## 3. Justification

**vCPUs — 2 each, not 1 or 4.** Windows 11's minimum is 2 cores, so 1 is not allowed. Ubuntu Server would run on 1, but 2 keeps `apt upgrade` and SSH responsive. 4 each would be possible (8 of 12) but leaves only 4 for the host for no test-lab benefit; more than that and the host would stutter under load — the brief says the host must stay usable.

**Memory — Ubuntu 2 GB, Windows 4 GB.** Ubuntu Server (no GUI) runs comfortably in 2 GB; giving it more is wasted while Windows needs it more. Windows 11's minimum is 4 GB, so I set it exactly at the minimum, not below (below 4 GB the installer refuses). 8 GB for Windows would be nicer but would leave the host with 16 − 2 − 8 − 0.5 = 5.5 GB, closer to the limit for no test-lab benefit. Nothing is set below a minimum.

**Disk size — 25 GB and 64 GB.** Ubuntu Server's recommended minimum is ~25 GB including room for logs and updates. Windows 11's minimum is 64 GB; I set exactly that.

**Dynamically allocated, not fixed ("Allocate all disk space now" unchecked).** Pre-allocating would claim 89 GB on the host immediately; growable disks only use what the guests actually write (~25 GB after install). Pre-allocated disks are slightly faster, but on an SSD the difference is small for a test lab, and keeping host disk free matters more. Risk: the disks can grow to the full 89 GB — the arithmetic above already uses that worst case, so it still fits.

**Ubuntu network: NAT, not Bridged or Host-only.**
- *NAT (VMnet8)* gives the guest internet through the host. In VMware Workstation the host also has its own adapter on VMnet8 ("VMware Network Adapter VMnet8"), so the host can `ssh` straight to the guest's NAT address. One adapter meets both requirements.
- *Why not Host-only (VMnet1):* the host can reach the guest, but the guest has no internet, so on its own it fails the "still reach the internet" requirement.
- *Why not Bridged:* it would also give SSH + internet, but it puts a test server directly on the office network, needs an address from the office DHCP, and often breaks on Wi-Fi. A test lab should not be exposed to the office.
- *Why not two adapters (NAT + Host-only):* it works, but in VMware it adds nothing, because NAT already allows host → guest.

**Windows 11 network — NAT only.** The brief only requires internet for Windows; no inbound access is needed, so NAT is the simplest and most isolated option.

### Can this computer run both guests? (Key idea)
Yes. With 16 GB RAM the plan leaves 9.5 GB for the host, so no fallback is needed. RAM is the limit, though: Windows 11 cannot go below 4 GB, so if the office wanted more memory for the guests (e.g. Windows at 8 GB and Ubuntu at 4 GB), the host would be left with 16 − 12 − 0.5 = 3.5 GB, which is below the 4 GB I assumed it needs. Because the RAM is soldered, that would mean replacing the laptop rather than upgrading it, as I noted in Task 1b.

## 4. Verification plan

`192.168.X` below is the VMnet8 subnet. VMware picks it at install, so I read it from row 2 first.

| # | Where | Command | Expected output | Proves |
|---|---|---|---|---|
| 1 | Host (cmd) | `vmrun list` | `Total running VMs: 2` followed by the paths to `ubuntu-srv.vmx` and `win11.vmx` | Both guests run at the same time |
| 2 | Host | `ipconfig` | `Ethernet adapter VMware Network Adapter VMnet8:` with `IPv4 Address . . : 192.168.X.1` | Host is on the NAT network, gives the subnet |
| 3 | Host | `findstr /i "numvcpus memsize ethernet0.connectionType" "%USERPROFILE%\Documents\Virtual Machines\ubuntu-srv\ubuntu-srv.vmx"` | `numvcpus = "2"`, `memsize = "2048"`, `ethernet0.connectionType = "nat"` | Ubuntu settings applied as planned |
| 4 | Host | same `findstr` on `win11.vmx` | `numvcpus = "2"`, `memsize = "4096"`, `ethernet0.connectionType = "nat"` | Windows settings applied as planned |
| 5 | Ubuntu | `nproc` | `2` | Guest sees 2 vCPUs |
| 6 | Ubuntu | `free -h` | `Mem: total ≈ 1.9Gi` (a little under 2 GB, kernel reserves some) | Guest sees 2 GB RAM |
| 7 | Ubuntu | `lsblk` | `sda  25G  disk` | Guest sees 25 GB disk |
| 8 | Ubuntu | `ip -br a` | `ens33  UP  192.168.X.128/24` (from VMware DHCP, usually .128 or higher) | Guest has a NAT address |
| 9 | Ubuntu | `systemctl is-active ssh` | `active` | SSH server running |
| 10 | Host | `ssh <user>@192.168.X.128` then `hostname` | password prompt, then `ubuntu-srv` | Ubuntu reachable by SSH from host |
| 11 | Ubuntu | `ping -c 3 8.8.8.8` | `3 packets transmitted, 3 received, 0% packet loss` | Internet (IP) works |
| 12 | Ubuntu | `curl -I https://ubuntu.com` | `HTTP/2 200` (or `301`) | DNS + HTTPS work |
| 13 | Windows guest (PowerShell) | `(Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors` | `2` | Guest sees 2 vCPUs |
| 14 | Windows guest | `[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1)` | `≈ 4.0` | Guest sees 4 GB RAM |
| 15 | Windows guest | `Get-Disk \| Select Number, Size` | `0  68719476736` (64 GB) | Guest sees 64 GB disk |
| 16 | Windows guest | `Test-NetConnection microsoft.com -Port 443` | `TcpTestSucceeded : True` | Windows has internet |
| 17 | Host | Task Manager → Performance while both VMs run (or `Get-Counter '\Memory\Available MBytes'`) | ≈ 9,000 MB or more available, CPU not pinned at 100 % | Host stays usable, matches arithmetic |
| 18 | Host | `dir "%USERPROFILE%\Documents\Virtual Machines" /s` (look at the `.vmdk` sizes) | `.vmdk` files much smaller than 25 / 64 GB | Disks are dynamically allocated |

If row 10 times out, I would check that the VMnet8 adapter is enabled on the host (`ipconfig`, row 2) and that the Ubuntu firewall allows SSH (`sudo ufw status` → `inactive` or `22/tcp ALLOW`).
