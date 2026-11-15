# Lab 5 — Encoding forensics

## 1. What I was given (diagnosis made BEFORE any change)

`file staff-broken.csv` (saved in `evidence/file-before.txt`):

```
staff-broken.csv: Non-ISO extended-ASCII text, with CRLF line terminators
```

First sixteen bytes (`evidence/hexdump-before.txt`):

```
000000 d2 e0 e1 2e b9 3b d4 c8 ce 3b c4 ee eb e6 ed ee  >.....;...;......<
```

Reading the bytes:

- **No BOM.** The file starts with `d2`, not `EF BB BF` (UTF-8 BOM) or `FF FE` (UTF-16LE BOM).
- **Not UTF-8.** Every Cyrillic letter is a single byte (`d2 e0 e1` = "Таб"). In UTF-8 Cyrillic takes two bytes (`d0 a2 ...`).
- **Not UTF-16.** There are no `00` bytes between characters.
- `b9` = "№" and `3b` = ";" (the delimiter is a semicolon).

## 2. Encoding: KZ-1048 (also called RK1048 / STRK1048-2002)

KZ-1048 is the Kazakh single-byte code page. It is Windows-1251 with Kazakh letters added in place of Serbian/Macedonian ones. I tested each candidate:

| Tried as | Russian names | Kazakh names |
|---|---|---|
| CP866 / KOI8-R | garbage | garbage |
| Windows-1251 | correct | wrong: `Ќасымова Јлия`, `Нўрланов Єалымжан`, `Ґтебаев` |
| **KZ-1048** | correct | **correct: `Қасымова Әлия`, `Нұрланов Ғалымжан`, `Өтебаев`, `Іңкәр`, `Һашимов`** |

Proof bytes: `8D`=Қ, `9D`=қ, `A3`=Ә, `BC`=ә, `A2`=ұ, `AA`=Ғ, `A5`=Ө, `BE`=ң, `8E`=Һ, `AF`=Ү, `BF`=ү. Windows-1251 maps these to Ќ ќ Ј ј ў Є Ґ ѕ Ћ Ї ї, which is exactly the garbage seen. That is why Russian-only names looked fine but Kazakh names broke.

Why each program showed something different:

- **Excel** has no BOM to read, so it guesses the system ANSI code page.
- **LibreOffice** guesses its own default in the import dialog.
- **Linux terminal** expects UTF-8, so invalid bytes come out as `?`/`�`.

## 3. Line ending: CRLF (Windows, `\r\n`)

`file` reports "with CRLF line terminators". All 26 lines end in `0d 0a`. On Linux the `\r` stays glued to the last field (`12.03.2019\r`), which breaks `cut`, `awk`, comparisons and scripts. **Converted to LF.**

## 4. Byte order mark: none in source. Decision: ADD a UTF-8 BOM

- **Excel** only auto-detects a UTF-8 CSV on double-click when the file starts with `EF BB BF`. Without it Excel falls back to ANSI and the names break again.
- **LibreOffice** and **`cat`** handle the UTF-8 BOM without problems (it is invisible).
- **Trade-off:** a script that reads the header with a strict parser can see `﻿` glued to "Таб.№". If the file were only for scripts, I would drop the BOM. The brief requires it to open correctly in Excel too, so the BOM stays.

## 5. The fix (one command — `scripts/fix.sh`)

```bash
{ printf '\xEF\xBB\xBF'; iconv -f RK1048 -t UTF-8 staff-broken.csv | sed 's/\r$//'; } > staff-fixed.csv
```

This does three things: decodes KZ-1048 to UTF-8, strips CR (CRLF → LF), and prepends the UTF-8 BOM. `iconv` exited without errors, so every byte was a valid KZ-1048 character.

## 6. After

`file staff-fixed.csv` (`evidence/file-after.txt`):

```
staff-fixed.csv: Unicode text, UTF-8 (with BOM) text
```

First bytes are now `ef bb bf d0 a2 d0 b0 d0 b1 2e e2 84 96 3b`: the BOM, then "Таб.№;" in UTF-8. There are 0 CR bytes left, and all 25 records plus the header are intact.

## 7. Verification

`evidence/opens-correctly.png` shows `staff-fixed.csv` opened in:

- **Excel**: double-click; names like Қасымова Әлия Серікқызы are correct.
- **LibreOffice Calc**: Character set = Unicode (UTF-8), separator = semicolon.
- **Terminal**: `cat staff-fixed.csv` in WSL / Git Bash.
