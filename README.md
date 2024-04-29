# Guess or Pass
_Developed by: Kristina Koneva (student index number: 201513)_

## Overview
Guess or Pass is a native iOS mobile application developed in [Swift](https://developer.apple.com/swift/) as the programming language of choice and [SwiftUI](https://developer.apple.com/xcode/swiftui/) as a suitable modern UI framework.

It's a multiplayer game where one lucky individual takes on the role of the guesser, while others act as the clue-givers, providing hints to help the guesser identify the correct word. The objective is to guess as many words as possible from the selected category in the duration of one minute. Users can choose one of the following categories: animals, food, sports, technology, music and nature. There are several options about navigating throughout the game play - users can use button clicks, swipe gestures or phone tilts to guess or pass a certain word. Additionally, users can set reminders for their game nights or similar events and they will receive a notification with the time and place.

The app supports both portrait and landscape mode (except for the game screen which is locked in landscape mode).

## Architecture

This app is divided into three layers: data, domain and UI layer. The state management is handled following the MVVM pattern.
### Data Layer

The data layer consists of two data sources:

- remote source (the [Datamuse API](https://www.datamuse.com/api/) source for fetching the words)
- local source ([`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults) which locally provide and store the user's name, avatar image, game navigation type and best score).

### Domain Layer

The domain layer serves as a connection between the data and the domain layer. It consists of domain models and repositories. The repositories provide an interface
for communicating with the data sources and they are used in the UI layer. They serve as an abstracted clean link to the data sources (without knowing their implementation and origin) in
the UI layer.

### UI Layer

The UI layer is simply what the user sees on the screen. Each screen consists of a `View` (literally the UI) and a `ViewModel` (which takes care of the business logic). View models do the data fetching and preparation logic and communicate all of that with the views using `@Published` properties. These properties are observed by the views, allowing them to immediately react to changes made to these properties. To ensure that these properties can only be modified by the view model, most of them are defined with private setters.

## Dependency Injection

[Swinject](https://github.com/Swinject/Swinject) is used for dependency injection. [`InjectionContainer`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/di/InjectionContainer.swift) provides all data sources, repositories, view models and several managers and classes wicha re provided as singletons, such as: [`CMMotionManager`](https://developer.apple.com/documentation/coremotion/cmmotionmanager), [`CLLocationManager`](https://developer.apple.com/documentation/corelocation/cllocationmanager), [`CLGeocoder`](https://developer.apple.com/documentation/corelocation/clgeocoder), [`NotificationManager`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/utils/NotificationManager.swift).

## Networking

The [Alamofire](https://github.com/Alamofire/Alamofire) HTTP networking library is used for making the API requests towards the [Datamuse API](https://www.datamuse.com/api/). 

## Screens and Features

### Welcome Screen
The first screen users see when they open the app for the first time is the welcome screen. They are required to enter their name/nickname and choose their avatar. They can pick the image for their avatar either form their photo gallery or instantly take the photo by opening their camera. Once they have provided both things and have clicked on the "Let's play 🥳" button, they will be navigated to the game screen and their choices (name and avatar) will be saved locally in the `UserDefaults`.

_TODO: Add screenshots._

### Home Screen
On the home screen, users can see their name, avatar and best score. The best score represents how many correct guesses they have made in one minute and the initial for this score is 0 words/min. 

Below the user information, the avaialble word categories are listed. Once the user has chosen their category of choice, they can proceed with playing the game by clicking the "Play" button.

If users click on the "Play" button, but haven't chosen a category yet, an alret dialog will be shown.

On the top right of the screen, there is a settings icon button whcih navigates to the settings screen when clicked.

_TODO: Add screenshots._

### Game Screen
_TODO: Add description and screenshots._

### Settings Screen
_TODO: Add description and screenshots._

- Change name
- Change avatar
- Read instructions
- Change game navigation
- Set reminder

## Navigation
The [`Router`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/navigation/Router.swift) class is used for navigating through the different screens (views). It is inspired by the [following article](https://blorenzop.medium.com/routing-navigation-in-swiftui-f1f8ff818937) and contains several useful methods. The `Router` is provided as an environment object and it is available in each view defined in the `Guess_or_PassApp`. 

## Useful Utils
- [`OrientationInfo`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/utils/OrientationInfo.swift) - inspired by the following (thread)[https://forums.developer.apple.com/forums/thread/126878] and used for obtaining device orientation information. It is primarily used for determining the device orientation when a user opens some action sheet - when the orientation sheet is landscape, a "Close" button is displayed on the action sheet because the user cannot dismiss it otherwise.
- [`NotificationManager`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/utils/NotificationManager.swift) - uses the [`UNUserNotificationCenter`](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter) to check and request notification permissions and schedule local notifications.
 



