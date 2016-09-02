# RXSwiftTest

RXSwift Test App

The higher level purpose of this app is to demonstrate an understanding of various parts of mobile app development. Some of these include:

FRP (Functional Reactive Programming)
MVVM (Model View ViewModel)
Storyboards
Table Views/Collection Views

The specific function of the app is to ping the Giphy API for the currently trending 25 Gifs and display them in a collection view on the main view controller of the app. Additionally, the user can use the search bar
to search Giphy for gifs by name, with the attached table view populating with the search results through reactive programming. Subsequent improvements to the app will include pushing a secondary view controller featuring the selected gif from search as well as reformatting the collection view to allow for a more natural spacing between cells of different sizes.

Requirements

This project requires Cocoapods. To install cocoapods run sudo gem install cocoapods or refer to the document below

https://guides.cocoapods.org/using/getting-started.html

Installation

To access the project:

git clone or unzip the app to desktop

If you have not installed cocoapods yet, run sudo gem install cocoapods

cd into the Genome folder from Terminal

Run pod install. The .gitignore of the app contains the Pods directory, so only the Podfile will be available. I recommend keeping it this way. Future developers can decide the merits of checking in the Pods directory or not.

