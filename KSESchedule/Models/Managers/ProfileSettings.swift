//
//  ProfileSettings.swift
//  KSE Schedule Beta
//
//  Created by Andrii Klykavka on 11.10.2024.
//

import Foundation

final class ProfileSettings {
    static var shared = ProfileSettings()
    private var storgaKey = "ProfileStudent"
    private var storage = UserDefaults.standard
    
    private func loadStudent() {
        let decoder = JSONDecoder()
        
    }
}
