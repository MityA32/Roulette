//
//  Tabs.swift
//  Roulette
//
//  Created by Dmytro Hetman on 16.08.2023.
//

import Foundation

enum Tabs: CaseIterable {
    case game
    case rating
    case settings
}

extension Tabs {
    var title: String {
        switch self {
            case .game:
                return "Game"
            case .rating:
                return "Rating"
            case .settings:
                return "Settings"
        }
    }
}
