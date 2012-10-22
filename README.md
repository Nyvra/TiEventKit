# TiEventKit

Titanium Appcelerator module that implements iOS Event Kit framework.

## Supports

* iOS 4.0+
* Titanium SDK 2.1.3.RC

## What can I do with this module?

For moment, you can create Events in user default calendar. In iOS 6, the user will be asked by permissions to access her calendar. In iOS 5, you don't need user permissions.

Each event have this attributes:

* title (STRING)
* location (STRING)
* notes (STRING)
* begin (DATE)
* end (DATE)
* allDay (BOOL)

NOTE: The date format is: *"yyyy-MM-dd hh:mm:ss Z"*.

## Creating an Event

For compatibilty, you first need to ask authorization by user before create an Event. If user have granted the permission to access her Calendar, it will always return TRUE in event callback method. So, here is a simple usage of method:

	var EK = require("ti.eventkit");
	
	// Request authorization to user
	EK.requestAuthorization(function(e) {
	
		// If user have authorized this application…
		if (e.authorized == true) {
		
			// Create the Event
			EK.createCalendarEvent({
				title: "Codestrong",
				notes: "We will hack a lot.",
				location: "San Francisco",
				begin: "2012-10-21 08:00:00 GMT",
				end: "2012-10-23 18:00:00 GMT"
			});

			Ti.UI.createAlertDialog({
				title: "Calendar",
				message: "This event will be AWESOME!",
				buttonNames: ["YEAH!", "OK"]
			}).show();
			
		} else {
			Ti.UI.createAlertDialog({
				title: "Calendar",
				message: "You have to allow this application to access your Calendar",
				buttonNames: ["OK"]
			}).show();
		}
	});

## Future supports

1. **Reminders** support.
2. Create a method to verify if application is allowed to access the Calendar.
