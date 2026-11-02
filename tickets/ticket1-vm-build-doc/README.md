# Ticket 1 — New developer starts Monday, needs a test machine

## 1. What was asked

> From: Aigerim T. (Office Manager)  
> Subject: test machine for new dev
>
> Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks

## 2. What was actually needed

The request did not specify an operating system, the number of machines, how much memory or storage the test environment needs, whether it must access the internet, or whether the new developer needs access to the physical office network. It also did not say how to recover after a failed test or what the office manager's technical experience is.

I interpreted "try things without breaking anything" as a need for **isolated, recoverable virtual machines**, not a separate physical computer. I used VMware Workstation and documented an Ubuntu Server guest and a Windows 11 guest. **These are assumptions**, not confirmed requirements from the requester; before deploying this for the real developer I would ask what software they need to test, which OS they require, whether they need inbound network access, and whether a licensed Windows image is available.

The request also asked for instructions a non-technical person can repeat. Therefore the separate [BUILD.md](BUILD.md) explains the wizard, resources, NAT networking, basic verification and snapshots. The captured wizard screens were reopened later for documentation and are **not evidence that the original install was performed during this ticket**.

## 3. What I did

1. Reviewed the host's 16 GB physical RAM and observed that running multiple VMs can put the host under memory pressure ([before](evidence/14-host-memory-before.png), [after](evidence/15-host-memory-after.png)).
2. Inspected the existing Ubuntu Server guest: 6 GB RAM, 2 virtual processors, 20 GB disk, NAT ([settings](evidence/06-ubuntu-settings.png)).
3. Inspected an earlier Windows 11 guest with 4 GB RAM, 2 virtual processors, 64 GB disk and NAT ([earlier Windows settings](evidence/13-windows-settings-previous-vm.png)). This image is **not** a settings capture of the newer `Ticket1-Windows11` guest.
4. Set up and booted the separate `Ticket1-Windows11` guest. The available [Windows ISO selection](evidence/01-new-vm-wizard.png) and [64 GB disk wizard page](evidence/02-disk-settings.png) are later reproductions of wizard settings, not screenshots from the initial creation.
5. Checked Ubuntu RAM using `free -h` ([output](evidence/03-ubuntu-memory.png)); the guest reported 5.2 GiB total usable RAM and 4.7 GiB available at the time.
6. Checked Ubuntu internet access with `ping -c 4 google.com`: four responses, 0% packet loss ([output](evidence/04-ubuntu-internet.png)).
7. Checked guest IP addresses: Ubuntu `192.168.192.130/24` ([output](evidence/05-ubuntu-ip.png)); Windows `192.168.192.132/24` ([output](evidence/12-windows-ip.png)). Both were on VMware NAT.
8. From Windows, pinged Ubuntu with `ping 192.168.192.130`: four replies, 0% loss ([output](evidence/07-windows-to-ubuntu.png)).
9. Initially, Ubuntu-to-Windows ping failed. I enabled the Windows Firewall inbound **File and Printer Sharing (Echo Request - ICMPv4-In)** rule for the applicable profile instead of disabling the firewall. Retesting `ping -c 4 192.168.192.132` gave four replies and 0% loss ([successful retest](evidence/08-ubuntu-to-windows.png)). The initial failed ping was observed but its screenshot is not included.
10. Checked Windows internet access with `ping google.com`: four replies, 0% loss ([output](evidence/09-windows-internet.png)).
11. Verified that VMware Snapshot Manager contains restore points for both guests ([Windows](evidence/10-windows-snapshot.png), [Ubuntu](evidence/11-ubuntu-snapshot.png)). The snapshot names visible in these captures are `Snapshot 1` on Windows and `clean-install` / `Snapshot 2` on Ubuntu.

**Why NAT instead of Bridged?** NAT lets both guests reach the internet through the host and communicate on the VMware virtual network, while avoiding direct exposure as separate devices on the office LAN. Bridged networking could be preferable if other physical machines must reach the guest, but it can be blocked by institutional network rules and adds exposure.

**Why these resource limits?** The host has 16 GB RAM, so assigning large amounts to both guests simultaneously risks exhausting host memory. The observed 6 GB Ubuntu allocation and earlier 4 GB Windows allocation were usable for the tests shown, but the new Windows guest's current allocation must be checked separately. The 64 GB Windows disk follows the VMware wizard recommendation; splitting the virtual disk into files improves portability, with a potential performance trade-off. A 20 GB Ubuntu disk is adequate for a minimal demonstration, but should be increased if the developer needs more packages or project data.

**Issue and resolution:** Windows initially did not answer incoming ICMP echo requests. I enabled the narrow inbound echo rule and verified bidirectional reachability. A separate older lab screenshot records a hostname-file issue ([screenshot](evidence/16-ubuntu-hostname-issue.png)), but it is not claimed as an issue resolved in this ticket.

## 4. Evidence

Each linked file below has a specific purpose; command output is shown as text where possible.

| File | What it proves |
|---|---|
| [`evidence/01-new-vm-wizard.png`](evidence/01-new-vm-wizard.png) | Windows 11 ISO detected in a reopened VMware creation wizard (illustrative) |
| [`evidence/02-disk-settings.png`](evidence/02-disk-settings.png) | Reopened VMware disk-capacity screen shows 64 GB and split-file option (illustrative) |
| [`evidence/03-ubuntu-memory.png`](evidence/03-ubuntu-memory.png) | Ubuntu `free -h` output reports usable/available memory |
| [`evidence/04-ubuntu-internet.png`](evidence/04-ubuntu-internet.png) | Ubuntu receives four Google ping replies, 0% loss |
| [`evidence/05-ubuntu-ip.png`](evidence/05-ubuntu-ip.png) | Ubuntu `ens33` is up at `192.168.192.130/24` |
| [`evidence/06-ubuntu-settings.png`](evidence/06-ubuntu-settings.png) | Ubuntu VM has 6 GB RAM, two processors, 20 GB disk, NAT |
| [`evidence/07-windows-to-ubuntu.png`](evidence/07-windows-to-ubuntu.png) | Windows reaches Ubuntu with 0% ping loss |
| [`evidence/08-ubuntu-to-windows.png`](evidence/08-ubuntu-to-windows.png) | Ubuntu reaches Windows after firewall rule change, 0% loss |
| [`evidence/09-windows-internet.png`](evidence/09-windows-internet.png) | Windows reaches Google with 0% ping loss |
| [`evidence/10-windows-snapshot.png`](evidence/10-windows-snapshot.png) | Windows Snapshot Manager shows `Snapshot 1` |
| [`evidence/11-ubuntu-snapshot.png`](evidence/11-ubuntu-snapshot.png) | Ubuntu Snapshot Manager shows `clean-install` and `Snapshot 2` |
| [`evidence/12-windows-ip.png`](evidence/12-windows-ip.png) | Windows `ipconfig` shows `192.168.192.132/24` |
| [`evidence/13-windows-settings-previous-vm.png`](evidence/13-windows-settings-previous-vm.png) | Earlier `lab02-win11` VM configuration, not the new ticket VM |
| [`evidence/14-host-memory-before.png`](evidence/14-host-memory-before.png) | Host reports 16 GB RAM and baseline memory usage |
| [`evidence/15-host-memory-after.png`](evidence/15-host-memory-after.png) | Host memory pressure during earlier concurrent VM testing |
| [`evidence/16-ubuntu-hostname-issue.png`](evidence/16-ubuntu-hostname-issue.png) | Earlier lab hostname-file error; background only |

## 5. What I would do differently

Next time I would confirm the developer's OS and software requirements before building anything, and record screenshots during the **actual** installation rather than reopening the wizard later. I would also test the complete BUILD.md on a different host with a classmate, and capture the exact new Windows guest hardware settings and an explicit snapshot rollback test. This would make the build more reproducible and the evidence stronger.

### Verification still outstanding

The guests worked on my host, but **the build has not yet been independently reproduced by another person or on a different machine**. For the rubric's full reproducibility score, another student should follow BUILD.md without verbal help, record where they get stuck, and save feedback in `review/feedback-from-<surname>.md` during week 5. Do not mark this complete until it happens.
