/**
 * Author: Rafael Kellermann Streit
 * Twitter: rafaelks
 * Company: Nyvra Software (@nyvra)
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiEventkitModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <EventKit/EventKit.h>

@implementation TiEventkitModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"651197ae-0c27-4dc8-8a0e-d2ef727ee20e";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.eventkit";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
    NSLog(@"[INFO] %@ loaded",self);
    
    // Create an EKEventStore instance
    eventStore = [[EKEventStore alloc] init];
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)requestAuthorization:(id)callback
{
    ENSURE_SINGLE_ARG(callback, KrollCallback);
	ENSURE_UI_THREAD(requestAuthorization, callback);
    
    // Verify if iOS version needs authentication to use EventStore
    // iOS 6 or later needs
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (callback != nil) {
                [self _fireEventToListener:@"authorized"
                                withObject:@{@"authorized" : [NSNumber numberWithBool:granted] }
                                  listener:callback
                                thisObject:nil];
            }
        }];
        
    } else {
        if (callback != nil) {
            [self _fireEventToListener:@"authorized"
                            withObject:@{@"authorized" : [NSNumber numberWithBool:TRUE] }
                              listener:callback
                            thisObject:nil];
        }
    }
    
}


-(BOOL)createCalendarEvent:(id)args
{
    // Separate parameters
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString *title = [TiUtils stringValue:@"title" properties:args def:@""];
    NSString *notes = [TiUtils stringValue:@"notes" properties:args def:@""];
    NSString *location = [TiUtils stringValue:@"location" properties:args def:@""];
    NSString *begin = [TiUtils stringValue:@"begin" properties:args];
    NSString *end = [TiUtils stringValue:@"end" properties:args];
    BOOL allDay = [TiUtils boolValue:@"allDay" properties:args def:NO];
    
    // This code is just for Date formatting
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss Z"];
    
    // Create event
    NSError *err;
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    EKCalendar *calendar = [eventStore defaultCalendarForNewEvents];
    
    if (calendar != nil && calendar.allowsContentModifications) {
        event.calendar = calendar;
        event.startDate = [dateFormatter dateFromString:begin];
        event.endDate = [dateFormatter dateFromString:end];
        event.title = title;
        event.location = location;
        event.notes = notes;
        event.allDay = allDay;
        
        BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        
        if (result) {
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        return TRUE;
    }
    
}

@end
