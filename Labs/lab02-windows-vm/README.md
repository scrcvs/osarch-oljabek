\# Lab 2 — Windows 11 VM, Networking and Memory Overcommitment



\*\*Course:\*\* Operating System Architecture  

\*\*Environment:\*\* VMware Workstation Pro  

\*\*Guest operating systems:\*\* Ubuntu Server 26.04 LTS and Windows 11 Enterprise LTSC Evaluation



\## 1. Objective



The objectives of this lab were to:



\- Install Windows 11 Enterprise Evaluation in VMware.

\- Configure networking between Ubuntu and Windows.

\- Test connectivity in both directions using ping.

\- Configure Windows Firewall to allow ICMP requests.

\- Perform a memory overcommitment experiment.

\- Restore safe memory allocations after the experiment.



\## 2. Virtual Machine Configuration



| Component | Ubuntu Server | Windows 11 |

|---|---|---|

| Virtual machine | Ubuntu-Server-Lab1 | lab02-win11 |

| Network mode | NAT (VMnet8) | NAT (VMnet8) |

| IPv4 address | 192.168.192.130 | 192.168.192.131 |

| Subnet mask | 255.255.255.0 | 255.255.255.0 |

| Gateway | 192.168.192.2 | 192.168.192.2 |

| RAM during experiment | 8 GB | 12 GB |

| RAM after restoration | 6 GB | 4 GB |



Windows 11 was installed using an official Enterprise LTSC Evaluation ISO. VMware Tools were also installed.



\## 3. Network Configuration



I selected \*\*VMware NAT (VMnet8)\*\* for both virtual machines.



NAT was chosen because both guests needed to communicate with each other and access the internet.



VMware NAT allows the virtual machines to communicate through the same virtual network while sharing the host's internet connection.



I did not use Host-only because it does not provide direct internet access. Bridged networking was not selected because it may be restricted by campus network MAC filtering.



\### Network Diagram



```text

&#x20;                Internet

&#x20;                   |

&#x20;            Host Computer

&#x20;            Windows Laptop

&#x20;                   |

&#x20;            VMware NAT Router

&#x20;            192.168.192.2

&#x20;                   |

&#x20;            VMnet8 (NAT)

&#x20;                   |

&#x20;         +---------+---------+

&#x20;         |                   |

&#x20;    Ubuntu Server        Windows 11

&#x20;    192.168.192.130      192.168.192.131

&#x20;    Ubuntu-Server-Lab1   lab02-win11

```



Both virtual machines were connected to the same subnet: `192.168.192.0/24`.



\## 4. Network Connectivity Testing



I checked the IP addresses using:



\*\*Windows:\*\*

```cmd

ipconfig

```



\*\*Ubuntu:\*\*

```bash

ip addr

```



I tested connectivity in both directions.



\*\*Windows to Ubuntu:\*\*

```cmd

ping 192.168.192.130

```



Result: 4 packets sent, 4 received, 0% packet loss.



\*\*Ubuntu to Windows:\*\*

```bash

ping -c 4 192.168.192.131

```



Result: 4 packets transmitted, 4 received, 0% packet loss.



Initially, Ubuntu could not ping Windows because Windows Firewall blocked incoming ICMP echo requests.



I configured a specific inbound firewall rule to allow ICMPv4 echo requests without disabling Windows Firewall.



After this change, both directions worked successfully.



\## 5. Memory Stress Experiment



The purpose of this experiment was to investigate memory overcommitment and observe how VMware handles high memory allocation.



\*\*Host specifications:\*\*

\- Physical RAM: 16 GB DDR5

\- Ubuntu VM allocation: 8 GB

\- Windows 11 VM allocation: 12 GB

\- Total allocated VM memory: 20 GB

\- Memory overcommitment ratio: 125%



\### Experimental Procedure



1\. Recorded the host's initial memory usage using Windows Task Manager.

2\. Configured Ubuntu Server with 8 GB RAM.

3\. Configured Windows 11 with 12 GB RAM.

4\. Started both virtual machines simultaneously.

5\. Monitored host memory usage, available RAM, and committed memory.

6\. Shut down both virtual machines after collecting measurements.



\### Results



| Metric | Before | During Experiment |

|---|---|---|

| RAM usage | 6.4 GB | 15.5 GB |

| Available RAM | 9.3 GB | 150 MB |

| Committed memory | 7.7 GB | 25.2 GB |

| RAM utilization | 41% | 99% |



\### Analysis



The experiment demonstrated significant memory pressure caused by running two virtual machines with a combined allocation exceeding the host's physical RAM.



Both virtual machines successfully started without errors. However, host memory utilization reached 99%, and available RAM decreased to approximately 150 MB.



The results illustrate the risks of memory overcommitment, including potential swapping, increased memory pressure, and reduced system responsiveness.



\### Conclusion



The experiment successfully demonstrated memory overcommitment in VMware Workstation. Although both virtual machines started, the host experienced very high memory utilization.



After the experiment, memory allocations were restored to 6 GB for Ubuntu and 4 GB for Windows 11.



\## 6. Restoring Safe Values



After the experiment, both virtual machines were shut down.



Memory allocations were restored:



\- Ubuntu Server: 6 GB

\- Windows 11: 4 GB



The total allocation was reduced to 10 GB, leaving more physical memory available for the host operating system.



\## 7. Problems and Solutions



\*\*Problem 1: Ubuntu could not ping Windows.\*\*



Cause: Windows Firewall blocked incoming ICMP requests.



Solution: Configured a specific inbound ICMPv4 firewall rule instead of disabling the firewall.



\*\*Problem 2: SSH connection refused.\*\*



Cause: The SSH server was not installed or running on Ubuntu.



Solution: Installed and enabled OpenSSH Server to allow remote connections.



\*\*Problem 3: Memory overcommitment caused high host memory usage.\*\*



Observation: Host RAM usage reached approximately 99% after both guests started.



Solution: Shut down both virtual machines and restored their normal RAM allocations.



\## 8. Evidence



The following files are included in the `evidence` folder:



1\. `ipconfig-windows.txt` — Windows network configuration.

2\. `ip-addr-linux.txt` — Ubuntu network configuration.

3\. `ping-both-ways.txt` — Successful connectivity tests.

4\. `host-memory-before.png` — Host memory before the experiment.

5\. `host-memory-after.png` — Host memory after starting both guests.



\## 9. Conclusion



In this lab, I successfully installed Windows 11 Enterprise Evaluation, configured VMware NAT networking, and established bidirectional connectivity between Ubuntu and Windows.



I also tested memory overcommitment by allocating 20 GB of virtual RAM on a host with 16 GB of physical memory.



Both guests started successfully, but host memory usage increased to approximately 99%, leaving only 150 MB available.



This experiment helped me understand virtual networking, firewall configuration, memory allocation, and the risks of memory overcommitment.

