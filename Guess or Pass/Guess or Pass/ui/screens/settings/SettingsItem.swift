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
        }
    }
}

enum SettingsAction {
    case changeName
    case changeAvatar
    case changeGameNavigation
    case readInstructions
}

