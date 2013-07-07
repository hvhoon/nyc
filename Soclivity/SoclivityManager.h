//
//  
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <EventKit/EventKit.h>
@class GetPlayersClass;
@class FilterPreferenceClass;
@protocol SoclivityManagerDelegate <NSObject>

@optional
-(void)LoadCustomTabBar;

@end
@interface SoclivityManager : NSObject{
    id <SoclivityManagerDelegate>delegate;
    GetPlayersClass *registrationObject;
    BOOL basicInfoDone;
    CLLocation *currentLocation;
    GetPlayersClass *loggedInUser;
    FilterPreferenceClass *filterObject;
    BOOL AllowTapAndDrag;
    BOOL localCacheUpdate;
    BOOL editOrNewActivity;
    EKEventStore *eventStore;
   
}
@property (nonatomic,retain)id <SoclivityManagerDelegate>delegate;
@property (nonatomic,retain)GetPlayersClass *registrationObject;
@property (nonatomic,assign)BOOL basicInfoDone;
@property (nonatomic,retain)CLLocation *currentLocation;
@property (nonatomic,retain)GetPlayersClass *loggedInUser;
@property (nonatomic,retain)FilterPreferenceClass *filterObject;
@property (nonatomic,assign)BOOL AllowTapAndDrag;
@property (nonatomic,assign)BOOL localCacheUpdate;
@property (nonatomic,assign)BOOL editOrNewActivity;
@property (nonatomic,retain)EKEventStore *eventStore;
+ (id)SharedInstance;
-(void)deleteAllEvents;
-(void)grantedAccess:(NSMutableArray*)eventArray;
-(void)performCalendarActivity:(NSMutableArray*)array;
-(void)deleteASingleEvent:(NSInteger)activityId;
-(void)deltaUpdateSyncCalendar:(InfoActivityClass*)activity;
-(void)userProfileDataUpdate;
-(void)getUserObjectInAutoSignInMode;
-(NSString*)returnActivityType:(NSInteger)type;
@end
