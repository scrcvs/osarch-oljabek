# Ticket 2 — "We are kitting out the new office"

**To:** Daniyar K. (Director) **Date of prices:** 15.11.2026 **Budget:** 3,000,000 KZT, monitors included

---

## 1. Short answer to the director

**No, four identical machines is the wrong approach.** The four people do four different jobs, and each job hits a different limit first:

| Role | What limits them first | What we spent on |
|---|---|---|
| Accountant | disk latency (1C), data safety | NVMe SSD; cheapest CPU and one screen |
| Sales manager | memory (40 tabs + video calls) | 6-core CPU; **16 GB, a deliberate compromise** |
| Web developer | memory, then disk I/O, then cores | 8 cores, 32 GB, the fast SSD, a 27" 1440p screen |
| Designer | colour-accurate screen, then RAM, then GPU | calibrated ProArt 4K, 32 GB, strongest integrated graphics |

"Identical" can only mean one of two things, and both are bad:

- **Four copies of the designer's machine** = 4 × 991,337 ≈ **3.97 million KZT**. That is about a million over budget, mostly spent on calibrated monitors and 32 GB kits that the accountant does not need.
- **Four copies of the accountant's machine** = 4 × 535,954 ≈ **2.14 million KZT**. That fits the budget, but the developer and designer get 16 GB, the designer works on a screen that shows colour wrongly, and the developer waits on builds.

What *should* be identical is the **platform**: same socket (AM5), case, cooler, PSU, OS and SSD family. That gives the office common spare parts and one driver set, while the money goes where each job needs it.

**Total: 2,922,684 KZT. Reserve: 77,316 KZT (2.6%).**

**Market note.** DDR5 memory costs about **319,000 KZT per 32 GB kit** at every shop on e-katalog.kz on 15.11.2026, and RAM is **33%** of this whole purchase. That one fact forced the two compromises in this plan: the sales manager has 16 GB, and the designer has no separate graphics card. Both are explained in `builds.md`, and both are designed to be fixed by adding parts later, not replacing them.

---

## 2. The four builds (summary)

Full reasoning (load → bottleneck → trade-off) is in [`builds.md`](builds.md); every line item, shop and date is in [`budget.csv`](budget.csv), and every price has a dated screenshot in [`evidence/vendor-quotes/`](evidence/vendor-quotes/).

| | Accountant | Sales manager | Web developer | Designer |
|---|---|---|---|---|
| CPU | Ryzen 5 8500G | Ryzen 5 7600 | Ryzen 7 7700 | **Ryzen 7 8700G** (Radeon 780M) |
| Board | A620M DS3H | A620M DS3H | PRO B650M-P | PRO B650M-P |
| RAM | 16 GB (2×8) | 16 GB (2×8), 2 free slots | **32 GB** (2×16) | **32 GB** (2×16) |
| SSD | 1 TB NV3 | 1 TB NV3 | **1 TB 990 PRO** | 1 TB NV3 |
| GPU | iGPU | iGPU | iGPU | iGPU (free x16 slot) |
| Monitor | 24" FHD | 24" FHD | 27" 1440p | **27" ProArt 4K, calibrated** |
| OS | Win 11 Pro | Win 11 Pro | Win 11 Pro | Win 11 Pro |
| **Total, KZT** | **535,954** | **577,485** | **817,908** | **991,337** |
| budget.csv rows | 2–10 | 11–19 | 20–28 | 29–37 |

All four meet the hard requirements: ≥16 GB RAM, 1 TB SSD, a licensed OS and a monitor each.

---

## 3. The three questions

### Q1. Which machine will you upgrade first, eighteen months from now, and why?

**The sales manager's: memory, 16 → 32 GB.**

- It is the only machine where I knowingly bought *less* than its bottleneck needs (see Q3). Every other machine was sized to its load.
- It is the cheapest and easiest upgrade in the office: a second 2×8 GB kit goes into the **two empty slots** of the A620M board. There is nothing to remove, the Windows licence is unaffected and it takes ten minutes.
- It is the upgrade most likely to get cheaper. DDR5 is at a price peak in November 2026; waiting 18 months is a reasonable bet, and the Memory Saver mitigations (`builds.md`) cover the gap until then.
- Runner-up: a **graphics card for the designer** (an RTX 5060 is 314,106 KZT today). The B650 board has a free x16 slot and the PF550 PSU can power it. I would do it if the designer's work moves toward video or 3D.

### Q2. Price the same four as pre-built machines from a vendor. What does the company gain, and what does it lose by not building them?

Closest pre-built found: **HP EliteDesk 8 Tower G1i (AJ8S2AV)**: Core Ultra 7 265, 32 GB DDR5, 1 TB SSD, **RTX 5060**, Windows 11 Pro, 1-year warranty. **1,251,050 KZT** at Forcecom.kz (15.11.2026), **without a monitor**, and listed as out of stock.

It is closest to our designer machine, but it includes a graphics card that ours does not. A fair comparison therefore adds the RTX 5060 we priced:

| | KZT |
|---|---:|
| Our designer tower (no monitor) | 729,857 |
| + RTX 5060 at today's price (reference screenshot) | +314,106 |
| = Our build with the same GPU | **1,043,963** |
| HP EliteDesk 8 G1i | **1,251,050** |
| **Difference** | **+207,087 (+20%)** |

Even after the 314,000 KZT GPU price spike, building is about 20% cheaper. The pre-built premium on the other three machines is likely similar or higher, since brand business PCs at that level start well above our self-built prices. I could not find exact like-for-like pre-built configurations listed in Kazakhstan for them on 15.11.2026.

**What the company gains with pre-builts:**
- **Warranty and accountability.** One vendor, one phone number, and a whole-machine warranty. When a self-built PC fails, *we* have to diagnose which part failed and return it to whichever shop sold it.
- **A finished machine.** Licensed OS pre-installed, BIOS and driver management tools, keyboard and mouse in the box, nothing to assemble.
- **Fleet features** such as asset tags, remote BIOS management and TPM/vPro-class security.

**What the company loses by not building:**
- **Money.** About +20% on the like-for-like comparison, and that one machine alone would be 42% of the total budget before a monitor.
- **Control over where the money goes.** A pre-built forces a fixed spec. HP gives the designer a graphics card but nothing towards the calibrated monitor, which is what the designer actually needs, and you cannot move that money from one part to another.
- **Upgradeability.** Business PCs often use proprietary boards, PSUs and cases, which limit exactly the upgrades planned in Q1.
- **Availability.** The closest HP model was out of stock on the day of pricing; the individual parts were all in stock.

**My view:** a pre-built is worth considering for the **accountant**, whose machine is light, whose data is critical and who benefits most from a single warranty. For the developer and designer, the premium buys nothing they need.

### Q3. One of these four people will complain about performance within a month. Which one, and about what?

**The sales manager: "the computer freezes during client calls."**

With 16 GB, the load from `builds.md` (a CRM, 30–40 tabs, Excel, a messenger and a video call with background blur) sits right at the limit of the memory. On a quiet day it is fine. On a busy one, when they open a few more tabs mid-call or share their screen, Windows starts paging to disk, and the video freezes or the audio drops *while the client is on the call*. It won't happen in week one. It will happen once their tab habits settle in, which is within a month.

**What we do the day it happens (free):** check that Memory Saver is on in Chrome/Edge; close or pin the CRM to one window; turn off background blur, or let the iGPU handle it; move the pagefile to the NVMe (already the default). These steps buy time until the planned upgrade in Q1. The complaint in month one is the early warning for that upgrade in month eighteen. This is the risk I chose to take in order to stay within budget, rather than one I didn't see coming.

*(Why not the others: the developer and designer got the 32 GB their loads need; the accountant's load is light.)*

---

## 4. Budget

| Machine | KZT |
|---|---:|
| Accountant | 535,954 |
| Sales manager | 577,485 |
| Web developer | 817,908 |
| Designer | 991,337 |
| **Total** | **2,922,684** |
| Reserve | 77,316 |
| **Budget** | **3,000,000** |

Biggest cost drivers:

| Item | KZT | Share |
|---|---:|---:|
| RAM (2× 32 GB + 2× 16 GB) | 972,158 | 33% |
| Monitors | 418,251 | 14% |
| Windows 11 Pro ×4 | 360,268 | 12% |

The reserve (77,316 KZT) is small on purpose. It covers price drift between pricing and ordering, and basic keyboards and mice. A headset with a webcam for the sales manager and a UPS for the accountant should come from a separate peripherals budget.

---

## 5. Risks, assumptions and how to check this

- **Prices are dated 15.11.2026 and are moving fast.** Between the first pricing and the screenshots on the same day, the 32 GB kit went from ≈230,000 to ≈319,000 KZT at the cheapest shop. Re-check `budget.csv` before ordering; anything more than ~3% higher eats the reserve.
- **Every price has a screenshot** with the address bar, product, price and date (taskbar clock) in `evidence/vendor-quotes/`. Mapping of screenshot to row is in that folder's README.
- **Substitutions from the first plan** (forced by stock and price): Crucial E100 → Kingston NV3; WD SN850X → Samsung 990 PRO (SN850X not listed); ASUS PA278CV → PA279CV (PA278CV not in stock); designer RTX 5060 + Ryzen 7 7700 → Ryzen 7 8700G; accountant second monitor removed; sales 32 GB → 16 GB.
- **PSUs are the weak point for a 4-year life.** The Deepcool PF series is basic 80+ (not Bronze/Gold). If prices fall, upgrade the PSU before anything else that isn't already planned.
- **Compatibility checks** (socket, DIMM slots, monitor inputs vs. board outputs, PSU wattage) are in `evidence/pcpartpicker-links.md`.
- **Not included:** keyboard, mouse, headset/webcam, UPS, office suite (Microsoft 365 or similar), and the 1C licence. These are peripherals or operating costs, not part of this hardware purchase.
