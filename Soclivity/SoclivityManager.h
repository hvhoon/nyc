//
//  SoclivityManager.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class GetPlayersClass;
@protocol SoclivityManagerDelegate <NSObject>

@optional
-(void)LoadCustomTabBar;

@end
@interface SoclivityManager : NSObject{
    id <SoclivityManagerDelegate>delegate;
    GetPlayersClass *registrationObject;
    BOOL basicInfoDone;
    CLLocation *currentLocation;
    GetPlayersClass *fbObject;
   
   
}
@property (nonatomic,retain)id <SoclivityManagerDelegate>delegate;
@property (nonatomic,retain)GetPlayersClass *registrationObject;
@property (nonatomic,retain)GetPlayersClass *fbObject;
@property (nonatomic,assign)BOOL basicInfoDone;
@property (nonatomic,retain)CLLocation *currentLocation;
+ (id)SharedInstance;
@end
