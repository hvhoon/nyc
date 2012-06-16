//
//  EventShareActivity.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventShareActivity.h"
#import <EventKit/EventKit.h>
@implementation EventShareActivity



-(void)sendEvent{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = @"EVENT Test TO Delete TITLE";
    event.location  = @"Miami";
    event.notes     = @"yaar please comes to my event";
    event.URL=[NSURL URLWithString:@"htttp://www.google.com"];
    event.startDate = [[NSDate alloc] init];
    event.endDate   = [[NSDate alloc] initWithTimeInterval:1600 sinceDate:event.startDate];
    
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    localIdentifier = [[NSString alloc] initWithFormat:@"%@", event.eventIdentifier];
    NSLog(@"eventIdentifier=%@",localIdentifier);
}

-(void)deleteAnEvent:(NSString*)valueId{
    EKEventStore* store = [[[EKEventStore alloc] init] autorelease];
    EKEvent* event2 = [store eventWithIdentifier:valueId];
    if (event2 != nil) {  
        NSError* error = nil;
        [store removeEvent:event2 span:EKSpanThisEvent error:&error];
    } 
}
@end
