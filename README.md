# HeySoulbindThis

WoW 3.3.5 addon for **Peloria** that batch-mails class-appropriate weapons and armor to your alts (and friends), with route backups and mythic+ duplicate avoidance for soulbinding.

## Install

1. Copy the `HeySoulbindThis` folder into your client's `Interface\AddOns\` directory.
2. Restart the client (or `/reload` if already loaded once).
3. Enable **HeySoulbindThis** in the addon list.

## Usage

| Command | Action |
|---------|--------|
| `/hst` or `/heysoulbind` | Toggle the panel |
| `/hst stop` | Stop send / open-all |

1. Log each alt once so characters are recorded (or add friends on the **Characters** tab).
2. Open **Routes** — assign primary (+ backup) recipients per category (Cloth, Leather, Mail, Plate, Wildcard, Offhand, Shield, Lockbox).
3. Adjust mailing **priority** with `^` / `v`.
4. Open a mailbox — the panel docks beside it.
5. Review the Send preview (recipient sections are collapsed by default), then **Send All**.
6. **Open All** loots inbox mail, preferring fewer attachments first. Skips COD.

## Features

- Auto-records characters on login; class dropdown overrides; manual friend entries
- Class / armor rules (including pre-40 mail → Warrior / Paladin / DK preference)
- Wildcard jewelry, offhands, lockboxes → Rogue
- Fist weapons and offhand frills via subtype / equipLoc matching
- Primary + backup recipients per route; same item @ same mythic tier rolls to the next backup
- Auto-blacklist legendaries; per-item blacklist button
- Flat UI chrome; batch send (12 attachments); subjects `HeySoulbindThis N/M`

## Requirements

- Interface `30300` (Wrath 3.3.5)
- Standard mailbox APIs (Peloria custom soulbind tier is read from item tooltips when present)
