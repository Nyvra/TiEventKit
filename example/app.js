var EK = require("ti.eventkit");

EK.requestAuthorization(function(e) {
	if (e.authorized == true) {
		EK.createCalendarEvent({
			title: "Foo bar Event",
			notes: "Hacking. A lot.",
			location: "B385 - Foo",
			begin: "2012-10-05 01:00:00 GMT",
			end: "2012-10-05 03:00:00 GMT"
		});
	} else {
		alert("You haven't permissions to add Events");
	}
});