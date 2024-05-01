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

<br/>
<br/>

<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/aa196ff4-aeaa-43a5-8ebc-18eee8ea36e7" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/a4b357e0-9e09-4484-a897-b07b3a550f80" width=30% height=30%/>

<br/>
<br/>

For accessing the gallery, the app doesn't need to ask for permissions because it only needs private access to the user's gallery (the app can access only the images the user selects), however, for the camera, the app has to request the permission in case the user wants to take a photo which will be their avatar.

<br/>
<br/>

<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/33e332cf-d182-4319-a6a4-0c34188d76d3" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/4c2d5000-3596-4e5a-a3f6-e7b2d87f2bd4" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/14920b3c-d7ad-440c-a324-e57845b96ba2" width=30% height=30%/>


### Home Screen
On the home screen, users can see their name, avatar and best score. The best score represents how many correct guesses they have made in one minute and the initial for this score is 0 words/min. 

Below the user information, the avaialble word categories are listed. Once the user has chosen their category of choice, they can proceed with playing the game by clicking the "Play" button.
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/608922fa-623d-450f-b5ea-ead24f359de0" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/e2c2e860-8ec0-4d09-baa0-93978bfc1566" width=30% height=30%/>
<br/>
<br/>
If users click on the "Play" button, but haven't chosen a category yet, an alert dialog will be shown.
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/4881d918-98b5-49a4-b854-35de03993db1" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/902f1c4c-a09e-4244-9767-66389854cd8f" width=30% height=30%/>
<br/>
<br/>
On the top right of the screen, there is a settings icon button which navigates to the settings screen when clicked.

### Game Screen
_TODO: Add description._
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/19e31f1b-7893-4c64-826e-966a09de3ac3" width=50% height=50%/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/5b751579-acd2-4a32-b44b-e2322eade80f" width=50% height=50%/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/a56f13af-7eec-4974-8434-4137ff58bbd7" width=50% height=50%/>

### Settings Screen
_TODO: Add description._
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/a9592df4-b609-49fb-a839-4ff108ef1028" width=30% height=30%/>
<br/>
<br/>
- Change name
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/7e96f0ef-2150-4332-84bc-f5e30a5e0804" width=30% height=30%/>
<br/>
<br/>
- Change avatar
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/3f85ebb3-2d25-433c-a104-4c8190a29fce" width=30% height=30%/>
<br/>
<br/>
- Read instructions
<br/>
<br/>
 <img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/0dfb85ac-a656-4cc0-8dcc-bd83df3b797a" width=30% height=30%/>
 <img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/b9b80f6f-9f24-41ff-a153-052846877f2d" width=30% height=30%/>
<br/>
<br/>
- Change game navigation
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/34970e9e-e67b-4307-b34a-99c41606adfc" width=30% height=30%/>
<br/>
<br/>
- Set reminder
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/b9e4431e-e618-4ff7-be3e-a4a5897735e9" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/d8cb8865-d1c5-428c-8108-1085fd3cd75f" width=30% height=30%/>
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/3d1690f0-4229-49ab-a233-7b8a133d9719" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/d24542a2-0bd5-4b14-88eb-118b1b2a0f1a" width=30% height=30%/>
<br/>
<br/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/60044d03-9c5a-4212-bf75-0d1cbc087841" width=30% height=30%/>
<img src="https://github.com/kristinakoneva/guess-or-pass/assets/83497391/2015b384-e528-4b4f-bac6-9420fd495628" width=30% height=30%/>


## Navigation
The [`Router`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/navigation/Router.swift) class is used for navigating through the different screens (views). It is inspired by the [following article](https://blorenzop.medium.com/routing-navigation-in-swiftui-f1f8ff818937) and contains several useful methods. The `Router` is provided as an environment object and it is available in each view defined in the `Guess_or_PassApp`. 

## Useful Utils
- [`OrientationInfo`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/utils/OrientationInfo.swift) - inspired by the following [thread](https://forums.developer.apple.com/forums/thread/126878) and used for obtaining device orientation information. It is primarily used for determining the device orientation when a user opens some action sheet - when the orientation sheet is landscape, a "Close" button is displayed on the action sheet because the user cannot dismiss it otherwise.
- [`NotificationManager`](https://github.com/kristinakoneva/guess-or-pass/blob/main/Guess%20or%20Pass/Guess%20or%20Pass/ui/shared/utils/NotificationManager.swift) - uses the [`UNUserNotificationCenter`](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter) to check and request notification permissions and schedule local notifications.
 



