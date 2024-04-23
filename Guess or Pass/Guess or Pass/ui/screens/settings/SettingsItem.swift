//
//  SettingsItem.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

enum SettingsItem {
    case changeName
    case changeAvatar
    case changeGameNavigation
    case readInstructions
    case setReminder
    
    var iconName: String {
        switch self {
        case .changeName:
            return "person.circle"
        case .changeAvatar:
            return "photo"
        case .changeGameNavigation:
            return "gamecontroller"
        case .readInstructions:
            return "book"
        case .setReminder:
            return "bell.badge.fill"
        }
        
    }
    
    var title: String {
        switch self {
        case .changeName:
            return "Change name"
        case .changeAvatar:
            return "Change avatar"
        case .changeGameNavigation:
            return "Change game navigation"
        case .readInstructions:
            return "Read instructions"
        case .setReminder:
            return "Set reminder"
        }
    }
    
    var action: SettingsAction {
        switch self {
        case .changeName:
            return SettingsAction.changeName
        case .changeAvatar:
            return SettingsAction.changeAvatar
        case .readInstructions:
            return SettingsAction.readInstructions
        case .changeGameNavigation:
            return SettingsAction.changeGameNavigation
        case .setReminder:
            return SettingsAction.setReminder
        }
    }
}
