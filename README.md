# Sshwitch

> Because life's too short to `vim ~/.ssh/config` every time you switch GitHub accounts.

Sshwitch is a tiny macOS menubar app that lets you swap between SSH configurations with a single click. No windows. No dock icon. No drama. Just click, pick, and `git push`.

## Why?

Got multiple GitHub accounts? Welcome to SSH key roulette.

The "official" solution is to give each account a Host alias in your SSH config and rewrite every git remote URL to match. Forget once? Congrats, you just pushed your weekend side project with your corporate identity.

You could set `GIT_SSH_COMMAND` per terminal session — if you enjoy forgetting environment variables. Or configure `core.sshCommand` on every single repo — if you enjoy tedium. Load multiple keys into the SSH agent? GitHub takes the first one it likes, not the one you meant.

The root problem is that GitHub identifies you solely by your SSH key, and SSH's key selection is first-match, not intent-based. There is no native way to say "use this identity right now."

Sshwitch fixes this with the most brutal possible approach: one config to rule them all. Your profiles live as standalone files in `~/.ssh/`, and switching is a single click from the menubar. No host aliases, no per-repo config, no environment variables, no guessing. Standard `git@github.com` URLs just work — always pointing at whichever account you chose last.

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
┌──────────────────────┐
│ Personal          ✓  │
│ Work                 │
│──────────────────────│
│ Refresh          ⌘R  │
│ About Sshwitch       │
│ Quit             ⌘Q  │
└──────────────────────┘
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
