//
//  SshwitchApp.swift
//  Sshwitch
//
//  Created by Andy Frey on 4/12/26.
//

import SwiftUI

@main
struct SshwitchApp: App {
    @State private var configManager = SSHConfigManager()
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        MenuBarExtra {
            if configManager.accounts.isEmpty {
                Text("No profiles found")
                    .foregroundStyle(.secondary)
                Text("Add config.* files to ~/.ssh/")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            } else {
                ForEach(configManager.accounts) { account in
                    Button {
                        configManager.activate(account)
                    } label: {
                        HStack {
                            Text(account.label)
                            Spacer()
                            if account.isActive {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .disabled(account.isActive)
                }
            }

            Divider()

            Button("Refresh") {
                configManager.reload()
            }
            .keyboardShortcut("r")

            Button("About Sshwitch") {
                openWindow(id: "about")
                NSApplication.shared.activate()
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")

        } label: {
            Image(systemName: "arrow.triangle.swap")
        }

        Window("About Sshwitch", id: "about") {
            AboutView()
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }
}
