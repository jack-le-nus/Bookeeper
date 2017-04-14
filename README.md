# Bookeeper

There’re 4 things you need to read and understand before start: 

* We use firebase as server: https://firebase.google.com/docs/auth/ios/password-auth 
* FlatUIKit to theme all the control: https://github.com/Grouper/FlatUIKit 
* Pod to install third-party library: https://cocoapods.org/ 
* SQLite.swift for Database: https://github.com/stephencelis/SQLite.swift

# Work flow and definition of done:

* UI must be exact like wireframe: https://drive.google.com/open?id=0B5aB1Kl7IHQ0WWJpeUZzTWNVWm8
* Color code: https://drive.google.com/open?id=0B5aB1Kl7IHQ0UklUZVZmV3IwNDg
* Font: Default font of iOS (San francisco) https://developer.apple.com/fonts/
* Code Review by another developer (Pull Request)
* Unit test all the functions in Model classes
* Pass all acceptance test cases: https://docs.google.com/spreadsheets/d/1L2L3DOxEQNPewRkRhvdKTaYoyxUH_BVV2y5RAUg3YgQ/edit#gid=1857237395

(Remember to add more acceptance test case if you find any new one, https://medium.com/@Grype/test-your-website-like-a-pro-checklist-to-perform-user-acceptance-testing-uat-7d7c6d6ca53e)

# Utilities:

* Themer and Theme: to avoid duplicate code styling the same controls, remember to create themer before styling the control. Ex: textFieldThemer.applyTheme(view: password, theme: TextFieldTheme())
* ViewControllerExtension: place for all the common functions of viewcontroller

(Remember to add notes if you create any new utility used by others)
