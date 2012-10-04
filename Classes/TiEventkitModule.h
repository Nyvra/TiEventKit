/**
 * Author: Rafael Kellermann Streit
 * Twitter: rafaelks
 * Company: Nyvra Software (@nyvra)
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import <EventKit/EventKit.h>

@interface TiEventkitModule : TiModule 
{
    EKEventStore *eventStore;
}

@end
