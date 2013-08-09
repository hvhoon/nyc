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
@synthesize delegate,registrationObject,basicInfoDone,currentLocation,loggedInUser,filterObject,AllowTapAndDrag,localCacheUpdate,eventStore,pushStateOn;
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
        loggedInUser=[[GetPlayersClass alloc]init];
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


-(NSString*)returnActivityType:(NSInteger)type{
    FilterPreferenceClass*idObj=self.filterObject;
    
    NSString *activitySelect=nil;
    
    switch (type) {
        case 1:
        {
            for(int i=0;i<5;i++){
                switch (i) {
                    case 0:
                    {
                        if(idObj.playDD){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"1"];
                        }
                    }
                        break;
                        
                    case 1:
                    {
                        if(idObj.eatDD){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"2"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,2",activitySelect];
                                
                            }
                        }
                    }
                        break;
                    case 2:
                    {
                        if(idObj.seeDD){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"3"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,3",activitySelect];
                                
                            }
                        }
                    }
                        break;
                    case 3:
                    {
                        if(idObj.createDD){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"4"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,4",activitySelect];
                                
                            }
                        }
                    }
                        break;
                    case 4:
                    {
                        if(idObj.learnDD){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"5"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,5",activitySelect];
                                
                            }
                        }
                    }
                        break;
                        
                        
                        
                }
                
            }
        }
            break;
            
        case 2:
        {
            for(int i=0;i<5;i++){
                switch (i) {
                    case 0:
                    {
                        if(idObj.playAct){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"1"];
                        }
                    }
                        break;
                        
                    case 1:
                    {
                        if(idObj.eatAct){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"2"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,2",activitySelect];
                                
                            }
                        }
                    }
                        break;
                    case 2:
                    {
                        if(idObj.seeAct){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"3"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,3",activitySelect];
                                
                            }
                        }
                    }
                        break;
                    case 3:
                    {
                        if(idObj.createAct){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"4"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,4",activitySelect];
                                
                            }
                        }
                    }
                        break;
                    case 4:
                    {
                        if(idObj.learnAct){
                            if(activitySelect==nil)
                                activitySelect=[NSString stringWithFormat:@"5"];
                            else{
                                activitySelect=[NSString stringWithFormat:@"%@,5",activitySelect];
                                
                            }
                        }
                    }
                        break;
                        
                        
                        
                }
                
            }
        }
            break;
    }

    return activitySelect;
}


-(void)userProfileDataUpdate{
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
        NSString *documentsDirectory = [paths objectAtIndex:0]; //2
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"User.plist"]; //3
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path]) //4
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"plist"]; //5
            
            [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
        }
    
        
        NSMutableDictionary *array = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        if (nil == array) {
            array = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        else {
            [array retain];
        }
        
        //here add elements to data file and write data to file
    
    self.loggedInUser.DDActivityTypes=[self returnActivityType:1];
    self.loggedInUser.activityTypes=[self returnActivityType:2];
        if(self.registrationObject.facebookAccessToken != nil && [self.registrationObject.facebookAccessToken class] != [NSNull class])
        [array setObject:self.registrationObject.facebookAccessToken forKey:@"access_token"];
    if(self.loggedInUser.activityTypes != nil && [self.loggedInUser.activityTypes class] != [NSNull class])

        [array setObject:self.loggedInUser.activityTypes forKey:@"atypes"];
    
    if(self.loggedInUser.DDActivityTypes != nil && [self.loggedInUser.DDActivityTypes class] != [NSNull class])
        
        [array setObject:self.loggedInUser.DDActivityTypes forKey:@"DDAtypes"];

        [array setObject:[NSNumber numberWithBool:self.loggedInUser.calendarSync] forKey:@"calendar_status"];
    if(self.registrationObject.email != nil && [self.registrationObject.email class] != [NSNull class])

        [array setObject:self.registrationObject.email forKey:@"email"];
    if(self.registrationObject.facebookUId != nil && [self.registrationObject.facebookUId class] != [NSNull class])

        [array setObject:self.registrationObject.facebookUId forKey:@"fbuid"];
    if(self.registrationObject.first_name != nil && [self.registrationObject.first_name class] != [NSNull class])

            [array setObject:self.registrationObject.first_name forKey:@"first_name"];
    if(self.registrationObject.gender != nil && [self.registrationObject.gender class] != [NSNull class])

            [array setObject:self.registrationObject.gender forKey:@"gender"];
    
    if(self.loggedInUser.idSoc != nil && [self.loggedInUser.idSoc class] != [NSNull class])

    
        [array setObject:self.loggedInUser.idSoc forKey:@"id"];
    if(self.registrationObject.last_name != nil && [self.registrationObject.last_name class] != [NSNull class])

        [array setObject:self.registrationObject.last_name forKey:@"last_name"];
    if(self.currentLocation != nil && [self.currentLocation class] != [NSNull class]){

        [array setObject:[NSNumber numberWithFloat:self.currentLocation.coordinate.latitude] forKey:@"location_lat"];
        [array setObject:[NSNumber numberWithFloat:self.currentLocation.coordinate.longitude] forKey:@"location_lng"];
    }
    if(self.loggedInUser.profileImageUrl != nil && [self.loggedInUser.profileImageUrl class] != [NSNull class])
    [array setObject:self.loggedInUser.profileImageUrl forKey:@"photo_url"];

   [array writeToFile:path atomically:YES];
        
        
        
        
        
    
}
-(void)getUserObjectInAutoSignInMode{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"User.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    
    NSMutableDictionary *array = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (nil == array) {
        array = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    else {
        [array retain];
    }
    
    GetPlayersClass *player=[[GetPlayersClass alloc]init];
    player.fbAccessToken=[array valueForKey:@"access_token"];
    player.activityTypes=[array valueForKey:@"atypes"];
    player.DDActivityTypes=[array valueForKey:@"DDAtypes"];
    player.calendarSync=[[array valueForKey:@"calendar_status"]boolValue];
    player.email=[array valueForKey:@"email"];
    player.facebookUId=[array valueForKey:@"fbuid"];
    player.first_name=[array valueForKey:@"first_name"];
    player.last_name=[array valueForKey:@"last_name"];
    player.gender=[array valueForKey:@"gender"];
    player.idSoc=[array valueForKey:@"id"];
    player.profileImageUrl=[array valueForKey:@"photo_url"];

    self.filterObject.playDD=FALSE;
    self.filterObject.eatDD=FALSE;
    self.filterObject.seeDD=FALSE;
    self.filterObject.createDD=FALSE;
    self.filterObject.learnDD=FALSE;

    self.filterObject.playAct=FALSE;
    self.filterObject.eatAct=FALSE;
    self.filterObject.seeAct=FALSE;
    self.filterObject.createAct=FALSE;
    self.filterObject.learnAct=FALSE;

    self.filterObject.whenSearchType=2;


    NSArray *timeArray = [player.activityTypes componentsSeparatedByString:@","];
    
    for(NSString *actType in timeArray){
        
        int activity=[actType intValue];
        switch (activity) {
            case 1:
            {
                self.filterObject.playAct=TRUE;
            }
                break;
            case 2:
            {
                self.filterObject.eatAct=TRUE;
                
            }
                break;
            case 3:
            {
                self.filterObject.seeAct=TRUE;
                
            }
                break;
            case 4:
            {
                self.filterObject.createAct=TRUE;
                
            }
                break;
            case 5:
            {
                self.filterObject.learnAct=TRUE;
                
            }
                break;
                
        }
    }

timeArray = [player.DDActivityTypes componentsSeparatedByString:@","];

for(NSString *actType in timeArray){
    
    int activity=[actType intValue];
    switch (activity) {
        case 1:
        {
            self.filterObject.playDD=TRUE;
        }
            break;
        case 2:
        {
            self.filterObject.eatDD=TRUE;
            
        }
            break;
        case 3:
        {
            self.filterObject.seeDD=TRUE;
            
        }
            break;
        case 4:
        {
            self.filterObject.createDD=TRUE;
            
        }
            break;
        case 5:
        {
            self.filterObject.learnDD=TRUE;
            
        }
            break;
            
    }
}

   self.loggedInUser=player;
}
@end
