//
//  AboutView.swift
//  Sshwitch
//
//  Created by Andy Frey on 4/12/26.
//

import SwiftUI

struct AboutView: View {
    private let appVersion: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }()

    private let buildNumber: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }()

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.triangle.swap")
                .font(.system(size: 48))
                .foregroundStyle(.primary)

            Text("Sshwitch")
                .font(.title)
                .fontWeight(.bold)

            Text("Version \(appVersion) (\(buildNumber))")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Switch between SSH configs\nwith a single click.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundStyle(.secondary)

            Divider()
                .frame(width: 200)

            Text("Made by Andy Frey")
                .font(.callout)

            Link("github.com/StuffAndyMakes/Sshwitch",
                 destination: URL(string: "https://github.com/StuffAndyMakes/Sshwitch")!)
                .font(.caption)
        }
        .padding(32)
        .frame(width: 300)
    }
}
