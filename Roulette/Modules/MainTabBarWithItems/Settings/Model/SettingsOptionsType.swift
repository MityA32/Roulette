//
//  SettingsOptions.swift
//  Roulette
//
//  Created by Dmytro Hetman on 17.08.2023.
//

import UIKit

enum SettingsOptionsType: CaseIterable {
    case logOut
    case deleteAccount
    case rateApp
    case shareApp
}

extension SettingsOptionsType {
    var title: String {
        switch self {
            case .logOut:
                return "Log out"
            case .deleteAccount:
                return "Delete Account"
            case .rateApp:
                return "Rate App"
            case .shareApp:
                return "Share App"
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .deleteAccount: return .systemRed
        default: return .systemBlue
        }
    }
}
