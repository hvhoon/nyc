//
//  EventShareActivity.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
@interface EventShareActivity : NSObject{
    
    NSString *localIdentifier;
}
-(void)deleteAllEvents;
-(void)grantedAccess:(NSMutableArray*)eventArray;
-(void)performCalendarActivity:(EKEventStore*)eventStore andList:(NSMutableArray*)array;
@end
