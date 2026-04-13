# Sshwitch — Website Copy

*Use this as the content for StuffAndyMakes.com/sshwitch. Sections are labeled for layout purposes.*

---

## [HERO]

### One Click SSH Account Switching for macOS

Stop editing `~/.ssh/config` by hand. Sshwitch lives in your menubar and swaps your entire SSH configuration with a single click.

[Download for macOS] [View on GitHub]

---

## [THE PROBLEM]

### Multiple GitHub accounts. Zero good solutions.

If you've ever used more than one GitHub account on the same Mac, you know the pain. Host aliases that break your clone URLs. Environment variables you forget to set. SSH agents that silently pick the wrong key.

GitHub identifies you by your SSH key — and SSH doesn't care which account you *meant* to use. It sends the first key that works. You find out you pushed with the wrong identity when it's already too late.

---

## [THE SOLUTION]

### The fix is almost stupidly simple.

Sshwitch keeps a separate, complete SSH config file for each of your accounts. When you click a name in the menubar, it copies that config into place. Done.

No host aliases. No per-repo configuration. No environment variables. Your standard `git@github.com` URLs work every time — always pointing at whichever account you chose.

---

## [HOW IT WORKS]

### Set up in 60 seconds.

**1. Create your profiles**
Drop a file in `~/.ssh/` for each account: `config.personal`, `config.work`, `config.whatever`. Each one is a complete SSH config — your keys, your hosts, your settings.

**2. Click the menubar icon**
Sshwitch auto-discovers your profiles and lists them in a clean dropdown. The active one gets a checkmark.

**3. That's it. Push your code.**
Run `ssh -T git@github.com` to confirm which account is live. Or just trust it and get back to work.

---

## [FEATURES]

### Small app. No nonsense.

- **Menubar only** — no dock icon, no windows cluttering your workspace
- **Auto-discovery** — drop a config file in `~/.ssh/` and it shows up. Remove it and it's gone.
- **Full config swap** — not just GitHub keys. Each profile is a complete SSH ecosystem: keys, hosts, proxy settings, the works.
- **Atomic writes** — your config is never half-written. Sshwitch writes to a temp file and renames it in one shot.
- **Permissions preserved** — file permissions stay at 600 on every write. Your SSH config stays locked down.
- **No telemetry** — Sshwitch reads and copies files in `~/.ssh/`. That is literally all it does.

---

## [SECURITY]

### Your keys. Your machine. Nothing leaves the building.

Sshwitch never modifies your profile files — it only reads them. It never phones home, collects data, or talks to the network. It runs with hardened runtime, is signed with a Developer ID certificate, and is notarized by Apple.

The source code is MIT licensed and available on GitHub. Read every line if you want. There aren't many.

---

## [REQUIREMENTS]

- macOS 26 (Tahoe) or later
- SSH keys already set up for your accounts
- At least two accounts (otherwise, why are you here?)

---

## [DOWNLOAD]

### Get Sshwitch

**[Download DMG — v1.0]**
Signed and notarized. Open it, drag to Applications, done.

Prefer to build from source?
**[View on GitHub → github.com/StuffAndyMakes/Sshwitch]**

---

## [FAQ]

**Does Sshwitch work with GitLab / Bitbucket / other SSH hosts?**
Yes. Each profile is a full SSH config. You can put whatever hosts and keys you want in each one.

**Can I have more than two profiles?**
As many as you want. Every `config.*` file in `~/.ssh/` becomes a menu item.

**Does it modify my SSH keys?**
No. Sshwitch only touches `~/.ssh/config`. Your keys are never read, copied, or modified.

**What happens if I edit `~/.ssh/config` manually?**
Nothing breaks. Sshwitch will just overwrite it the next time you switch profiles. Your profile source files are never changed.

**Is it free?**
Yes. MIT license. Free to use, free to modify, free to distribute.

---

## [FOOTER]

Made by Andy at StuffAndyMakes.com
