//
//  FacebookLogin.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@protocol FacebookLoginDelegate <NSObject>

@optional
-(void)pushToRegistration;
@end



@interface FacebookLogin : NSObject<FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>{
    
    NSArray *permissions;
    id <FacebookLoginDelegate>FBdelegate;
}
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic,retain)id <FacebookLoginDelegate>FBdelegate;
- (void)login;
-(void)setUpPermissions;
@end
