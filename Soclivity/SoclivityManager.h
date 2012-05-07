//
//  SoclivityManager.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSession.h"

@class SocFacebookLogin;
@protocol SoclivityManagerDelegate <NSObject>

@optional
-(void)LoadCustomTabBar;

@end
@interface SoclivityManager : NSObject{
    id <SoclivityManagerDelegate>delegate;
    FBSession *_session;
    SocFacebookLogin *FacebookLogin;
   
   
}
@property (nonatomic,retain)id <SoclivityManagerDelegate>delegate;
@property (nonatomic,retain) FBSession *_session;
@property (nonatomic,retain)SocFacebookLogin *FacebookLogin;
+ (id)SharedInstance;
-(void)SetFacebookConnectObject:(id)parentDelegate fTag:(NSInteger)fTag;
@end
