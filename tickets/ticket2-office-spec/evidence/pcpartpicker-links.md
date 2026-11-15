# PCPartPicker lists (compatibility check)

PCPartPicker has no Kazakhstan store and no prices in tenge, so it is used here **only for the compatibility check** (socket, memory type, PSU wattage). All prices come from Kazakhstan shops, recorded in `../budget.csv` and `vendor-quotes/`.

> Paste each saved list URL below (pcpartpicker.com → "Save list" → copy the `/list/xxxx` link).

| Build | PCPartPicker list | Estimated wattage | Compatibility notes |
|---|---|---|---|
| Accountant | `https://pcpartpicker.com/list/______` | ~120 W | 8500G needs dual-channel RAM for its iGPU → 2×8 GB. 24B31H connects to the board's **HDMI**; the DP output stays free for a second screen later. |
| Sales manager | `https://pcpartpicker.com/list/______` | ~120 W | 7600 has an iGPU → no graphics card needed. 2×8 GB in slots A2/B2; slots A1/B1 free for the Q1 upgrade. 24B3QA2 on board DP or HDMI. |
| Web developer | `https://pcpartpicker.com/list/______` | ~130 W | B650M-P: 4 DIMM slots, 2× M.2. Q27B35S3 (1440p 120 Hz) on board DisplayPort. |
| Designer | `https://pcpartpicker.com/list/______` | ~130 W now, ~280 W with a future GPU | 8700G's Radeon 780M drives the PA279CV at 4K 60 Hz over board DisplayPort. Free PCIe x16 slot; the PF550's single 6+2-pin connector is enough for an RTX 5060-class card later. |

## Checklist run for every build

- [x] CPU socket AM5 = board socket AM5
- [x] DDR5 kit supported by the board; 2 sticks for dual channel
- [x] OEM CPUs have no cooler → AG400 added (AM5 mount included)
- [x] 1 TB NVMe in the board's M.2 slot
- [x] Monitor inputs match the board outputs actually used
- [x] PSU wattage ≥ 2× estimated load
- [x] Windows 11 requirements: TPM 2.0 (AMD fTPM on AM5) + Secure Boot
