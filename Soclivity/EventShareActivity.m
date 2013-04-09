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

-(void)test{
    EKEventStore *eventStore =[[EKEventStore alloc] init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted){
                //---- codes here when user allow your app to access theirs' calendar.
                [self performCalendarActivity:eventStore];
            }else
            {
                //----- codes here when user NOT allow your app to access the calendar.
            }
        }];
    }
    else {
        //---- codes here for IOS < 6.0.
        [self performCalendarActivity:eventStore];
    }

}

-(void)performCalendarActivity:(EKEventStore*)eventStore{
    // EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    NSDate *date = [[NSDate alloc ]init];//today,s date
    event.title = @"remainder";//title for your remainder
    
    event.startDate=date;//start time of your remainder
    event.endDate = [[NSDate alloc] initWithTimeInterval:1800 sinceDate:event.startDate];//end time of your remainder
    
    NSTimeInterval interval = (60 *60)* 3;
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval]; //Create object of alarm
    
    [event addAlarm:alarm]; //Add alarm to your event
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    NSString *ical_event_id;
    //save your event
    if([eventStore saveEvent:event span:EKSpanThisEvent error:&err]){
        ical_event_id = event.eventIdentifier;
        NSLog(@"%@",ical_event_id);
    }
    
}


-(void)sendEvent{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = @"EVENT Test TO Delete TITLE";
    event.location  = @"Miami";
    event.notes     = @"yaar please comes to my event";
    event.URL=[NSURL URLWithString:@"htttp://www.google.com"];
    event.startDate = [NSDate date];
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
