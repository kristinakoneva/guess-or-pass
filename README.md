# Guess or Pass
_Developed by: Kristina Koneva (student index number: 201513)_

## Overview
Guess or Pass is an iOS mobile application developed in Swift as the programming language of choice and SwiftUI as a suitable modern UI framework.

It's a multiplayer game where one lucky individual takes on the role of the guesser, while others act as the clue-givers, providing hints to help the guesser identify the correct word. The objective is to guess as many words as possible from the selected category in the duration of one minute. Users can choose one of the following categories: animals, food, sports, technology, music and nature. There are several options about navigating throughout the game play - users can use button clicks, swipe gestures or phone tilts to guess or pass a certain word. Additionally, users can set reminders for their game nights or similar events and they will recieve a notification with the time and place.

The app supports both portrait and landscape mode.

## Architecture

This app is divided into three layers: data, domain and UI layer. The state management is handled following the MVVM pattern.
### Data Layer

The data layer consists of two data sources:

- remote source (the [Datamuse API](https://www.datamuse.com/api/) source for fetching the words)
- local source ([UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) which locally provide and store the user's name, avatar image, game navigation type and best score).

### Domain Layer

The domain layer serves as a connection between the data and the domain layer. It consists of domain models and repositories. The repositories provide an interface
for communicating with the data sources and they are used in the UI layer. They serve as an abstracted clean link to the data sources (without knowing their implementation and origin) in
the UI layer.

### UI Layer

The UI layer is simply what the user sees on the screen. Each screen consists of a `View` (literally the UI) and a `ViewModel` (which takes care of the business logic). View models do the data fetching and preparation logic and communicate all of that with the views using `@Published` properties. These properties are observed by the views, allowing them to immediately react to changes made to these properties. To ensure that these properties can only be modified by the view model, most of them are defined with private setters.

## Dependency Injection

[Swinject](https://github.com/Swinject/Swinject) is used for dependency injection. [`InjectionContainer`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/di/InjectionContainer.swift) provides all data sources, repositories, view models and the [`CMMotionManager`](https://developer.apple.com/documentation/coremotion/cmmotionmanager).

## Networking

The [Alamofire](https://github.com/Alamofire/Alamofire) HTTP networking library is used for making the API requests towards the [Datamuse API](https://www.datamuse.com/api/). 

## Screens and Features

### Welcome Screen
Description and screenshot to be added.

### Home Screen
Description and screenshot to be added.

### Game Screen
Description and screenshot to be added.

### Settings Screen
Description and screenshot to be added.

- Change name
- Change avatar
- Read instructions
- Change game navigation
- Set reminder

## Navigation
Description to be added.
[`Router`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/navigation/Router.swift)
https://blorenzop.medium.com/routing-navigation-in-swiftui-f1f8ff818937 

## Useful Utils
Description to be added.
[`OrientationInfo`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/utils/OrientationInfo.swift)
https://forums.developer.apple.com/forums/thread/126878 

[`NotificationManager`]

