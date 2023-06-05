# HomeBuddies
By Pavi Rannulu - Capstone for Ada Developers Academy Cohort 18

## What is HomeBuddies?
This iOS application is intended for people living together in the same house/building to keep track of chores, communicate with each other and share important information (like emergency contact info).

### Getting Started with the app
(1) Each person in the communal living pod will need a create their own account using their email and password.
<br>
*Note: here is currently no way for the user to change their password if they forget it, so they would have to contact the product owner (Pavi) to have it reset password.*

(2) One person from the group will need to create a new House. They will be prompted to set a House ID (which is like a username for your house) and a House Code (which is like a password).
<br>
*Note: The HouseID and Code cannot be changed once the House is created.*

(3) Everyone else in the group will use the House ID and code to join this house.


## Features
Once the user is part of a House (either by creating a new one, or joining an existing one), they will have access to the following features:
* Housemates At A Glance: 
	* The profile pictures of each person in the House will appear at the top of the Home page. 
	* Clicking the icons will take you to another page containing more information about that person.

* House Feed: 
	* Updates from the House. Whenever one of the housemates adds, deletes, edits or completes a task, it will show up here.
	
* Tasks page:
	* Add new tasks using "+" button.
	* Edit notes to keep track of any relevant information for each task.
	* Assign tasks to yourself or others.
	
* Edit Profile Page:
	* Edit name, pronouns, personal information (like birthday, medical information etc), and emergency contact info.
	* Pick a profile picture from custom images.

* Tasks Assigned to you:
	* When a task is assigned to you, it will show up on your profile page. You can work on this, add notes and reassign if needed.
	* Once completed, you can mark it as complete and it will disappear from the Tasks list.

## A list of dependencies/technologies
* Written using SwiftUI (a declarative UI framework from Apple).
* IDE used: XCode (Version 14.2). 
* The data is saved on the Google Firebase Cloud Firestore (which is a NoSQL document database). 
* User authentication was done with the help of Firebase Authentication.

## How to setup on your MacBook/iPhone
HomeBuddies will not be available on the App Store. If you want to use this app, you will have to follow these steps.

1. Download XCode via the App Store: https://developer.apple.com/xcode
<br> *Note: This app takes up a lot of storage (15GB or so), so make sure that your device has this space before starting.*

2. Clone this repo. 

3. Open this project on XCode.

4. Run in simulator by selecting *Product -> Run*.

5. To run it on your iPhone, you will have to enable Developer Mode on your phone. Steps to do this can be found here: https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device
<br> Then select your iphone as the destination to run the app (instead of the simulator).

## Presentation
You can find more information here: https://docs.google.com/presentation/d/1KHWvuRa7Yvwy01abc_K1iBc5Tz9NXdkQ6UpOB9I-uYU

Thank you! Hope you enjoy!
