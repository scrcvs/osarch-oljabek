# Ticket 2 — four builds with reasoning

All four machines share one platform (AMD AM5, DDR5, NVMe, Windows 11 Pro OEM, the same case, cooler and PSU). They differ only where the work differs. That keeps spare parts and drivers common while putting the money where each job actually has its bottleneck.

All prices were taken on **15.11.2026** from Kazakhstan shops (Ants.kz, Shop.kz, Flexcom.kz, alfa.kz, satu.kz). Each one has a dated screenshot in `evidence/vendor-quotes/`. Rows refer to `budget.csv`.

> **The constraint that shaped everything: DDR5 memory.** On 15.11.2026 a 32 GB kit (2×16) costs **≈319,000 KZT** at every shop listed on e-katalog.kz, and a 16 GB kit costs ≈167,000. Memory alone is **33%** of this purchase. Every trade-off below is about where memory goes and what we give up to pay for it.

---

### Build 1 — accountant

**Load:** 1C:Enterprise (Accounting for Kazakhstan), Excel with large workbooks, a bank-client in the browser, NCALayer / EDS signing for e-government and tax forms.

**Bottleneck:** not the CPU and not much memory. It is **storage latency and data safety**. 1C in file mode is mostly single-threaded and waits on the disk, and the accountant's data (the 1C database, signed reports) cannot be lost. An NVMe SSD and a backup routine matter more here than the core count.

**Trade-off:** the cheapest sensible CPU with integrated graphics (Ryzen 5 8500G), 16 GB (2×8, dual-channel, because the iGPU needs it) and **one** 24" monitor. I originally planned a second monitor for the accountant (reconciling a bank statement against 1C on two screens is genuinely faster). It was the first thing cut when memory prices went up, because it is a convenience, not a bottleneck. The A620M board has four DIMM slots and an unused DisplayPort output, so a second screen or more RAM can be added later without replacing anything.

**Total:** 535,954 KZT (budget.csv, rows 2–10)

---

### Build 2 — sales manager

**Load:** a CRM in the browser with 30–40 tabs, Excel, WhatsApp Web / Telegram, and several hours of video calls a day (Zoom / Google Meet / Teams), often all at once.

**Bottleneck:** **memory**. Each Chromium tab is its own process. Forty tabs plus a video call with background blur use about 11–13 GB before Windows takes its share, and on 16 GB the machine starts paging to disk.

**Trade-off:** this is the machine where I knowingly **under-spent on its own bottleneck**. 32 GB would cost 318,985 KZT, about 55% of the whole machine, and it would have pushed the office over budget. So the sales manager gets **16 GB in two of the four slots**, with these mitigations:
- Edge / Chrome *Memory Saver* switched on, so idle tabs are frozen and stop using RAM.
- Background-blur effects run on the iGPU, not the CPU.
- A 6-core Ryzen 5 7600 rather than the cheaper 8500G, so that when the system does page, the video call doesn't also stutter on CPU time.

The two empty DIMM slots make this the planned first upgrade (README, Q1). It is also the predicted first complaint (README, Q3). I would rather name that risk than hide it.

**Total:** 577,485 KZT (budget.csv, rows 11–19)

---

### Build 3 — web developer

**Load:** VS Code or a JetBrains IDE indexing a large project, Docker Desktop on WSL2 running a database + backend + frontend dev server, `npm` / `pnpm` builds and test runs, two or three browsers for cross-browser checks.

**Bottleneck:** **memory first, then storage I/O, then cores.** WSL2 reserves a large share of RAM for its VM, the containers run inside it, and the IDE and browsers run outside it. Installs and builds create hundreds of thousands of small files, which is random I/O. Builds and test suites are where 8 cores beat 6.

**Trade-off:** the developer gets the 32 GB kit, the 8-core Ryzen 7 7700 and the only "fast" SSD in the office (**Samsung 990 PRO**: much better random I/O than the budget NV3, at +46,265 KZT). There is no graphics card: the iGPU drives a 27" 1440p screen for code without trouble, and more vertical pixels help a developer more than GPU power does. 64 GB would be ideal, but at today's prices it would cost roughly double the 32 GB kit. The B650 board has four slots, so it stays possible later.

**Total:** 817,908 KZT (budget.csv, rows 20–28)

---

### Build 4 — designer

**Load:** Photoshop and Illustrator with large layered files, Figma in the browser, exporting assets, photo editing.

**Bottleneck:** **the screen**, then memory, then the GPU. A designer whose monitor shows colour wrongly produces wrong work, no matter how fast the PC is. After the screen, Photoshop is limited by RAM (history states, smart objects), and only then by GPU acceleration.

**Trade-off:** the money goes to the bottleneck in that order.
1. **ASUS ProArt PA279CV:** factory-calibrated, 100% sRGB, 27" 4K (261,480 KZT). The 1440p PA278CV I first chose was not in stock anywhere; the 4K model was the only ProArt available.
2. **32 GB RAM** (318,985 KZT).
3. **No graphics card.** An RTX 5060 costs **314,106 KZT** today (screenshot kept as a reference). Instead I took the **Ryzen 7 8700G**, which has the strongest integrated graphics AMD sells (Radeon 780M). It runs Photoshop's GPU features, a 4K display and Figma comfortably. What it won't do well is 3D or long 4K video timelines, which are not this job.

The B650 board has a free PCIe x16 slot and the 550 W PSU can power an RTX 5060-class card, so a graphics card can be added later without other changes.

**Total:** 991,337 KZT (budget.csv, rows 29–37)

---

## Common choices (and why)

| Part | Choice | Reason |
|---|---|---|
| Platform | AMD AM5 | One socket for all four; AMD has kept AM5 for several CPU generations, so a CPU-only upgrade stays possible during the machines' lifetime |
| Storage | 1 TB NVMe each (requirement) | Kingston NV3 everywhere except the developer, whose bottleneck is random I/O (Samsung 990 PRO) |
| OS | Windows 11 Pro OEM | Licensed (requirement); Pro adds BitLocker, Group Policy and domain/Entra join, which an office needs. At 90,067 KZT × 4 it is the third-largest cost after RAM and monitors |
| Case + cooler | Zalman N4 Rev.1 + Deepcool AG400 | OEM CPUs ship without a cooler; one tower cooler type for all four is quiet and easy to keep in stock |
| PSU | Deepcool PF550 ×4 | Enough for 65 W CPUs, and for a future GPU in the designer's machine. Basic 80+ only; a known weak point for a 4-year life (see README, risks) |
