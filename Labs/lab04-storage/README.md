\# Lab 4 — Partition, Mirror, Fail, Recover



\## Objective

The purpose of this lab was to create and format disk partitions in Windows and Linux, build a RAID 1 mirror, simulate disk failure, verify data integrity, and rebuild the array.



\## Windows Partitioning

I added a 2 GB virtual disk in VMware, initialized it using GPT, created a new partition, formatted it as NTFS, and assigned drive letter E: with the label LAB4.



GPT was chosen because it is a modern partitioning scheme that supports more partitions and larger disks than MBR.



\## Linux RAID 1

I attached three additional 2 GB virtual disks to Ubuntu.



I created GPT partitions on `/dev/sdb` and `/dev/sdc`, then assembled `/dev/sdb1` and `/dev/sdc1` into a RAID 1 array using `mdadm`.



The array was formatted as ext4 and mounted at `/mnt/raid1`.



\## Data Integrity and Failure

I created `test.txt` and recorded its SHA-256 checksum.



I simulated a failure of `/dev/sdc1`. The RAID array entered a degraded state, but the file remained accessible and its checksum matched the original.



\## Recovery

I removed the failed member, prepared `/dev/sdd1`, and added it to the array.



The array returned to a clean state with two active devices and zero failed devices. The test file passed the checksum verification again.



\## RAID 1 vs Backup

RAID 1 does not help recover a file accidentally deleted an hour ago. Deletion is reflected on both disks because RAID 1 mirrors changes, including deletions. A separate backup with file version history is required to recover the deleted file.



\## Evidence

The `evidence/` directory contains disk layout information, RAID states before and after failure, checksum results, recovery details, and Windows partition screenshots.

