//
//  SoclivityManager.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "FilterPreferenceClass.h"
#import "InfoActivityClass.h"
#import "SoclivityUtilities.h"

@implementation SoclivityManager
@synthesize delegate,registrationObject,basicInfoDone,currentLocation,loggedInUser,filterObject,AllowTapAndDrag,localCacheUpdate,eventStore;
@synthesize editOrNewActivity;

+ (id) SharedInstance {
	static id sharedManager = nil;
	
    if (sharedManager == nil) {
        sharedManager = [[self alloc] init];
    }
	
    return sharedManager;
}
-(id)init{
    
    if(self=[super init]){
        registrationObject=[[GetPlayersClass alloc]init];
        AllowTapAndDrag=TRUE;
        filterObject=[[FilterPreferenceClass alloc]init];
        filterObject.whenSearchType=2;
        filterObject.lastDateString=[NSString stringWithFormat:@"Pick A Date"];

        filterObject.morning=YES;
        filterObject.afternoon=YES;
        filterObject.evening=YES;
        eventStore=[[EKEventStore alloc] init];
        
            NSCalendar* myCalendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit 
                                                         fromDate:[NSDate date]];
        
        
            [components setHour:00];
            [components setMinute:00];
            [components setSecond:01];
            filterObject.startPickDateTime=[myCalendar dateFromComponents:components];

            NSLog(@"weekdayComponentsStart=%@",[myCalendar dateFromComponents:components]);

            [components setHour: 23];
            [components setMinute:59];
            [components setSecond:59];
            filterObject.endPickDateTime=[myCalendar dateFromComponents:components];
            
            NSLog(@"weekdayComponentsEnd=%@",filterObject.endPickDateTime);
            
            
        
    }
    return self;
}
-(void)grantedAccess:(NSMutableArray*)eventArray{
    
    [self deleteAllEvents];
    
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // iOS 6 and later
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted){
                //---- codes here when user allow your app to access theirs' calendar.
                [self performCalendarActivity:eventArray];
            }else
            {
                //----- codes here when user NOT allow your app to access the calendar.
            }
        }];
    }
    else {
        //---- codes here for IOS < 6.0.
        [self performCalendarActivity:eventArray];
    }
    
}
-(void)performCalendarActivity:(NSMutableArray*)array{
    
    for(InfoActivityClass *activity in array){
        if([SoclivityUtilities ValidActivityDate:activity.when]){
            
            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
            event.title = activity.activityName;//title for your remainder
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setTimeZone:gmt];
            event.startDate = [dateFormatter dateFromString:activity.when];
            event.notes= activity.what;
            event.availability=EKEventAvailabilityFree;
            
            switch (activity.relationType) {
                default:
                {
                    NSArray *hashCount=[activity.where_address componentsSeparatedByString:@"#"];
                    NSLog(@"hashCount=%d",[hashCount count]);
                    if([hashCount count]==1){
                        event.location=[NSString stringWithFormat:@"%@",[hashCount objectAtIndex:0]];
                    }
                    else{
                        event.location=[NSString stringWithFormat:@"%@,%@",[hashCount objectAtIndex:0],[hashCount objectAtIndex:1]];
                    }
                    
                    
                }
                    break;
                    
            }
            
            
            
            
            event.endDate = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:event.startDate];//end time of your remainder
            
            NSTimeInterval interval = -(60 *1)* 60;
            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval]; //Create object of alarm
            
            [event addAlarm:alarm]; //Add alarm to your event
            
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            NSString *ical_event_id;
            //save your event
            if([eventStore saveEvent:event span:EKSpanThisEvent error:&err]){
                ical_event_id = event.eventIdentifier;
                NSLog(@"%@",ical_event_id);
                [self setupPlistReadAndWriting:ical_event_id activityid:activity.activityId];
            }
        }
    }
}


-(void)setupPlistReadAndWriting:(NSString*)eventIdentifier activityid:(NSInteger)activityid{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Folder.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Folder" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Folder.plist"];
    
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    if (nil == data) {
        data = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else {
        [data retain];
    }
    
    //here add elements to data file and write data to file
    
    NSMutableDictionary *array = [[NSMutableDictionary alloc]init];
    
    [array setObject:eventIdentifier forKey:@"EventIdentifier"];
    [array setObject:[NSNumber numberWithInt:activityid] forKey:@"ActivityId"];
    
    [data addObject:array];
    [array release];
    [data writeToFile:path atomically:YES];
    
    
    
    
    
}
-(void)deleteAllEvents{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Folder.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Folder" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    
    paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Folder.plist"];
    
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    if (nil == data) {
        data = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else {
        [data retain];
    }
    if([data count]!=0){
        for(id stock in data){
            EKEvent* event2 = [eventStore eventWithIdentifier:[stock objectForKey:@"EventIdentifier"]];
            if (event2 != nil) {
                NSError* error = nil;
                [eventStore removeEvent:event2 span:EKSpanThisEvent error:&error];
            }
        }
    }
    else{
        
    }
    if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
    {
        //TODO: Handle/Log error
        NSLog(@"Some error");
    }
    
}

-(void)deleteASingleEvent:(NSInteger)activityId{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Folder.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Folder" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Folder.plist"];
    
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    if (nil == data) {
        data = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else {
        [data retain];
    }
    
    
    if([data count]!=0){
        int index=0;
        BOOL found=FALSE;
        for(id stock in data){
            if([[stock objectForKey:@"ActivityId"]integerValue]==activityId){
                
                
                EKEvent* event2 = [eventStore eventWithIdentifier:[stock objectForKey:@"EventIdentifier"]];
                if (event2 != nil) {
                    NSError* error = nil;
                    [eventStore removeEvent:event2 span:EKSpanThisEvent error:&error];
                }
                found=TRUE;
                NSLog(@"found a match");
                break;
            }
            index++;
        }
        if(found){
            [data removeObjectAtIndex:index];
            [data writeToFile:path atomically:YES];
        }
    }
    else{
        NSLog(@"Don't do Anything");
    }
}

-(void)deltaUpdateSyncCalendar:(InfoActivityClass*)activity{
    [self deleteASingleEvent:activity.activityId];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = activity.activityName;//title for your remainder
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    event.startDate = [dateFormatter dateFromString:activity.when];
    event.notes= activity.what;
    event.availability=EKEventAvailabilityFree;
    
    switch (activity.relationType) {
        default:
        {
            NSArray *hashCount=[activity.where_address componentsSeparatedByString:@"#"];
            NSLog(@"hashCount=%d",[hashCount count]);
            if([hashCount count]==1){
                event.location=[NSString stringWithFormat:@"%@",[hashCount objectAtIndex:0]];
            }
            else{
                event.location=[NSString stringWithFormat:@"%@,%@",[hashCount objectAtIndex:0],[hashCount objectAtIndex:1]];
            }
            
            
        }
            break;
            
    }
    
    
    
    
    event.endDate = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:event.startDate];//end time of your remainder
    
    NSTimeInterval interval = -(60 *1)* 60;
    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:interval]; //Create object of alarm
    
    [event addAlarm:alarm]; //Add alarm to your event
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    NSString *ical_event_id;
    //save your event
    if([eventStore saveEvent:event span:EKSpanThisEvent error:&err]){
        ical_event_id = event.eventIdentifier;
        NSLog(@"%@",ical_event_id);
        [self setupPlistReadAndWriting:ical_event_id activityid:activity.activityId];
    }
    
    
}

@end
