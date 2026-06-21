# Mind-Seeker

A lean World of Warcraft addon that tracks your progress toward the **Mind-Seeker** secret (you need 17 of 33 secrets to join the cabal) and shows a step-by-step guide for each one.

Toggle the window with **`/mind`**.

## Features

- **Auto-detection** of what you already have — mounts and pets (matched against your journals by name), toys (`PlayerHasToy`), the Waist of Time belt (transmog), and Memory of Scholomance (achievement).
- **Manual checkboxes** for the two with no API (Wan'be's Buried Goods, the Doug Roberts easter egg) — and you can manually mark *anything* if auto-detection ever misses it.
- A **progress bar** toward the 17 needed, turning green once you hit it.
- A **full step-by-step guide** per secret (zone, coordinates, items, NPCs, timing) in a roomy, scrollable, movable window.

## Install

The folder name must match the `.toc`, so keep it named **`MindSeeker`**.

1. Copy the `MindSeeker` folder into your AddOns directory:
   - **macOS:** `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
   - **Windows:** `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
2. It should look like `.../Interface/AddOns/MindSeeker/MindSeeker.toc` (the `.lua` files sit directly inside `MindSeeker/`).
3. Fully restart WoW (a `/reload` won't pick up a brand-new addon).
4. At character select → **AddOns**, make sure **Mind-Seeker** is enabled. If it's greyed out, tick **"Load out of date AddOns"**.
5. In game, type **`/mind`**.

## Commands

| Command | Action |
| --- | --- |
| `/mind` | Toggle the window |
| `/mind scan` | Re-scan your collection and print the count |
| `/mind reset` | Recenter the window |
| `/mind show` / `/mind hide` | Show / hide the window |

## Notes

- The `## Interface:` number in `MindSeeker.toc` may need updating to your live patch. If WoW flags it out of date, either tick "Load out of date AddOns" or run `/run print((select(4,GetBuildInfo())))` in game and paste that number into the `.toc`.
- Collectible IDs are verified, but a few of the long puzzle-chain *steps* are condensed summaries — each guide links to the full walkthrough (warcraft-secrets.com / Wowhead) for exact details.

Thanks to the WoW Secret Finding community for documenting these secrets.
