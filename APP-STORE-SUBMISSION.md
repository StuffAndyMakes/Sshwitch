# Distributing Sshwitch Outside the App Store (Developer ID)

This is the step-by-step process for signing, notarizing, and distributing Sshwitch
directly to users — no App Store involved.

---

## Prerequisites

- [ ] **Apple Developer Program membership** ($99/year) — [enroll here](https://developer.apple.com/programs/enroll/)
- [ ] **Xcode 26** (latest) installed from the Mac App Store
- [ ] **Developer ID Application certificate** (see Step 1 below)
- [ ] **Apple ID with app-specific password** for notarization (see Step 2 below)

---

## Step 1: Create a Developer ID Application Certificate

You only need to do this once.

1. Open **Xcode → Settings → Accounts**
2. Select your Apple ID and your team
3. Click **Manage Certificates**
4. Click the **+** button and choose **Developer ID Application**
5. Xcode generates the certificate and installs it in your Keychain

**Verify it worked:**
```bash
security find-identity -v -p codesigning | grep "Developer ID Application"
```

You should see something like:
```
"Developer ID Application: Andy Frey (L7649VVVC4)"
```

If the Xcode method doesn't show the option, create it manually:
1. Go to [developer.apple.com/account/resources/certificates](https://developer.apple.com/account/resources/certificates/list)
2. Click **+** → choose **Developer ID Application**
3. Follow the CSR (Certificate Signing Request) process
4. Download and double-click to install in Keychain

---

## Step 2: Set Up Notarization Credentials

Apple's notary service needs authentication. The easiest way is to store credentials
in your Keychain so you don't have to type them every time.

1. Generate an **app-specific password** at [appleid.apple.com](https://appleid.apple.com/) → Sign-In and Security → App-Specific Passwords
2. Store the credentials in your Keychain:

```bash
xcrun notarytool store-credentials "Sshwitch-Notarize" \
  --apple-id "your-apple-id@email.com" \
  --team-id "L7649VVVC4" \
  --password "your-app-specific-password"
```

This creates a Keychain profile named `Sshwitch-Notarize` that you'll reference later.

---

## Step 3: Update Xcode Signing Settings

1. Open **Sshwitch.xcodeproj** in Xcode
2. Select the **Sshwitch** target → **Signing & Capabilities**
3. Uncheck **Automatically manage signing**
4. For **Signing Certificate**, choose **Developer ID Application**
5. For **Team**, make sure your team is selected
6. Confirm **Hardened Runtime** is enabled (it already is)

---

## Step 4: Archive the App

1. In Xcode, set the scheme to **Any Mac (Apple Silicon, Intel)** if you want a universal build
2. **Product → Archive**
3. Wait for the build to complete — the Organizer window opens automatically

**Or from the command line:**
```bash
xcodebuild archive \
  -scheme Sshwitch \
  -archivePath ./build/Sshwitch.xcarchive \
  -configuration Release
```

---

## Step 5: Export with Developer ID Signing

### Option A: Xcode Organizer (Recommended)

1. In the **Organizer** (Window → Organizer), select your archive
2. Click **Distribute App**
3. Choose **Developer ID** distribution
4. Choose **Export** (not Upload)
5. Select your Developer ID certificate when prompted
6. Xcode signs the app and exports it to a folder

### Option B: Command Line

Create an `ExportOptions.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>developer-id</string>
    <key>teamID</key>
    <string>L7649VVVC4</string>
</dict>
</plist>
```

Then export:
```bash
xcodebuild -exportArchive \
  -archivePath ./build/Sshwitch.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./build/export
```

---

## Step 6: Notarize the App

This sends your signed app to Apple for automated security scanning. Usually takes
1–5 minutes.

### Option A: Xcode Does It Automatically

If you chose "Distribute App" in the Organizer and selected Developer ID, Xcode can
handle notarization automatically — it will upload, wait, and staple the ticket for you.
This is the easiest path.

### Option B: Command Line

First, create a ZIP of the app for upload:
```bash
ditto -c -k --keepParent ./build/export/Sshwitch.app ./build/Sshwitch.zip
```

Submit for notarization:
```bash
xcrun notarytool submit ./build/Sshwitch.zip \
  --keychain-profile "Sshwitch-Notarize" \
  --wait
```

The `--wait` flag blocks until Apple responds (usually 1–5 minutes). You'll see:
```
  status: Accepted
```

If it fails, check the log:
```bash
xcrun notarytool log <submission-id> \
  --keychain-profile "Sshwitch-Notarize"
```

---

## Step 7: Staple the Notarization Ticket

Stapling attaches the notarization ticket directly to the app so Gatekeeper can
verify it even offline.

```bash
xcrun stapler staple ./build/export/Sshwitch.app
```

**Verify it worked:**
```bash
spctl --assess --type execute --verbose ./build/export/Sshwitch.app
```

You should see:
```
./build/export/Sshwitch.app: accepted
source=Notarized Developer ID
```

---

## Step 8: Create a DMG

### Option A: Simple DMG with hdiutil

```bash
hdiutil create -volname "Sshwitch" \
  -srcfolder ./build/export/Sshwitch.app \
  -ov -format UDZO \
  ./build/Sshwitch-1.0.dmg
```

### Option B: Pretty DMG with create-dmg (Recommended)

Install the tool:
```bash
brew install create-dmg
```

Create the DMG with an Applications symlink for drag-to-install:
```bash
create-dmg \
  --volname "Sshwitch" \
  --window-size 500 320 \
  --icon-size 80 \
  --icon "Sshwitch.app" 150 150 \
  --app-drop-link 350 150 \
  ./build/Sshwitch-1.0.dmg \
  ./build/export/Sshwitch.app
```

**Important:** Notarize the DMG too:
```bash
xcrun notarytool submit ./build/Sshwitch-1.0.dmg \
  --keychain-profile "Sshwitch-Notarize" \
  --wait

xcrun stapler staple ./build/Sshwitch-1.0.dmg
```

---

## Step 9: Create a GitHub Release

```bash
gh release create v1.0 ./build/Sshwitch-1.0.dmg \
  --title "Sshwitch 1.0" \
  --notes "Initial release. One-click SSH account switching for macOS."
```

---

## Quick Reference: The Whole Flow in One Shot

For future releases, once everything above is set up, the process is:

```bash
# 1. Archive
xcodebuild archive \
  -scheme Sshwitch \
  -archivePath ./build/Sshwitch.xcarchive \
  -configuration Release

# 2. Export with Developer ID signing
xcodebuild -exportArchive \
  -archivePath ./build/Sshwitch.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./build/export

# 3. Notarize
ditto -c -k --keepParent ./build/export/Sshwitch.app ./build/Sshwitch.zip
xcrun notarytool submit ./build/Sshwitch.zip \
  --keychain-profile "Sshwitch-Notarize" --wait

# 4. Staple
xcrun stapler staple ./build/export/Sshwitch.app

# 5. Package DMG
create-dmg \
  --volname "Sshwitch" \
  --window-size 500 320 \
  --icon-size 80 \
  --icon "Sshwitch.app" 150 150 \
  --app-drop-link 350 150 \
  ./build/Sshwitch-1.0.dmg \
  ./build/export/Sshwitch.app

# 6. Notarize + staple the DMG
xcrun notarytool submit ./build/Sshwitch-1.0.dmg \
  --keychain-profile "Sshwitch-Notarize" --wait
xcrun stapler staple ./build/Sshwitch-1.0.dmg

# 7. Release
gh release create v1.0 ./build/Sshwitch-1.0.dmg \
  --title "Sshwitch 1.0" \
  --notes "Initial release."
```

---

## Troubleshooting

**"No Developer ID certificate found"**
→ You need a paid Apple Developer Program membership. The free tier doesn't include Developer ID certificates.

**Notarization rejected**
→ Run `xcrun notarytool log <submission-id> --keychain-profile "Sshwitch-Notarize"` to see exactly what failed. Common issues: missing hardened runtime, unsigned frameworks, or private API usage.

**"App is damaged and can't be opened"**
→ The app wasn't notarized or the ticket wasn't stapled. Re-run Steps 6 and 7.

**Gatekeeper still blocks the app**
→ Users on older macOS may need to right-click → Open the first time. Once opened once, Gatekeeper remembers.

---

## Sources

- [Developer ID overview](https://developer.apple.com/developer-id/)
- [Notarizing macOS software](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [Resolving notarization issues](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution/resolving_common_notarization_issues)
- [Preparing your app for distribution](https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution)
- [Create Developer ID certificates](https://developer.apple.com/help/account/create-certificates/create-developer-id-certificates/)
