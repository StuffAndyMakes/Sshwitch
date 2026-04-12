//
//  SSHConfigManager.swift
//  Sshwitch
//
//  Created by Andy Frey on 4/12/26.
//

import Foundation

@Observable
class SSHConfigManager {
    private(set) var accounts: [SSHAccount] = []

    private let sshDir: String
    private let configPath: String

    init() {
        let home = FileManager.default.homeDirectoryForCurrentUser.path()
        sshDir = home + "/.ssh"
        configPath = sshDir + "/config"
        reload()
    }

    func reload() {
        let fm = FileManager.default
        guard let entries = try? fm.contentsOfDirectory(atPath: sshDir) else {
            accounts = []
            return
        }

        let activeContent = try? String(contentsOfFile: configPath, encoding: .utf8)

        accounts = entries
            .filter { $0.hasPrefix("config.") }
            .sorted()
            .map { filename in
                let label = String(filename.dropFirst("config.".count))
                let profilePath = sshDir + "/" + filename
                let profileContent = try? String(contentsOfFile: profilePath, encoding: .utf8)
                let isActive = activeContent != nil
                    && profileContent != nil
                    && activeContent == profileContent
                return SSHAccount(
                    label: label.capitalized,
                    profilePath: profilePath,
                    isActive: isActive
                )
            }
    }

    func activate(_ account: SSHAccount) {
        let fm = FileManager.default
        do {
            // Copy profile to config (atomic via temp file + rename)
            let profileContent = try String(contentsOfFile: account.profilePath, encoding: .utf8)
            try profileContent.write(toFile: configPath, atomically: true, encoding: .utf8)

            // Preserve proper permissions: 600 on config
            try fm.setAttributes([.posixPermissions: 0o600], ofItemAtPath: configPath)

            reload()
        } catch {
            print("Sshwitch: Failed to activate profile: \(error)")
        }
    }

    var activeAccount: SSHAccount? {
        accounts.first(where: \.isActive)
    }
}
