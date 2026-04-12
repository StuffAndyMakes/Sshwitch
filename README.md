# Sshwitch

> Because life's too short to `vim ~/.ssh/config` every time you switch GitHub accounts.

Sshwitch is a tiny macOS menubar app that lets you swap between SSH configurations with a single click. No windows. No dock icon. No drama. Just click, pick, and `git push`.

## How It Works

Sshwitch looks for profile files in `~/.ssh/` named `config.<profile>`. When you select a profile from the menubar, it copies that file to `~/.ssh/config`. That's it. That's the whole app.

```
~/.ssh/
├── config              ← the active config (managed by Sshwitch)
├── config.personal     ← your personal GitHub setup
├── config.work         ← your work GitHub setup
└── config.freelance    ← that side gig you definitely pay taxes on
```

Each profile is a **complete, standalone SSH config** — not a fragment. This means you can have entirely different hosts, keys, and settings per profile. No comment-toggling gymnastics.

## Adding a Profile

1. Create a file at `~/.ssh/config.whatever`
2. Put your full SSH config in it
3. There is no step 3. Sshwitch auto-discovers it.

## The Menu

```
┌──────────────────┐
│ Personal      ✓  │
│ Work             │
│──────────────────│
│ Refresh      ⌘R  │
│ Quit         ⌘Q  │
└──────────────────┘
```

## Verifying It Worked

```bash
ssh -T git@github.com
# Hi your-username! You've successfully authenticated...
```

If the wrong name comes back, you picked the wrong profile. Click again. We won't judge.

## Requirements

- macOS 26 (Tahoe) or later
- At least two GitHub accounts (otherwise, why are you here?)
- SSH keys that actually exist on disk (Sshwitch swaps configs, not miracles)

## Building

Open `Sshwitch.xcodeproj` in Xcode 26 and hit Run. The app appears in your menubar, not the Dock.

## Security Notes

- Sshwitch **never modifies your profile files** — it only reads them and copies the selected one to `~/.ssh/config`
- File permissions are preserved at `600` on every write
- Writes are atomic (temp file + rename) so you'll never end up with a half-written config
- The app runs outside the sandbox to access `~/.ssh/`. It does not phone home, track analytics, or do anything besides read and copy files in that directory

## License

MIT — do whatever you want with it. If you use it to manage SSH configs for your fleet of evil robot overlords, that's between you and your conscience.
