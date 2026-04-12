//
//  SSHAccount.swift
//  Sshwitch
//
//  Created by Andy Frey on 4/12/26.
//

import Foundation

struct SSHAccount: Identifiable, Equatable {
    let id: String
    let label: String
    let profilePath: String
    var isActive: Bool

    init(label: String, profilePath: String, isActive: Bool) {
        self.id = label
        self.label = label
        self.profilePath = profilePath
        self.isActive = isActive
    }
}
