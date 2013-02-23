//
//  GetPlayersClass.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPlayersClass : NSObject
@property(nonatomic,retain)NSString *birth_date;
@property(nonatomic,retain)NSString *created_at;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *first_name;
@property(nonatomic,retain)NSNumber *idSoc;
@property(nonatomic,retain)NSString *last_name;
@property(nonatomic,retain)NSString *updated_at;
@property(nonatomic,retain)NSString *password;
@property(nonatomic,retain)NSString *password_confirmation;
@property (nonatomic,retain)NSData *profileImageData;
@property (nonatomic,retain)NSString *gender;
@property (nonatomic,retain)NSString*activityTypes;
@property (nonatomic,retain)NSString *password_status;
@property (nonatomic,assign)BOOL status;
@property (nonatomic,retain)NSString*statusMessage;
@property (nonatomic,retain) UIImage *FBProfileImage;
@property (nonatomic,retain)NSString *fullName;
@property (nonatomic,retain)NSString *current_location;
@property (nonatomic,retain)NSString *facebookUId;
@property (nonatomic,retain)NSString *facebookAccessToken;
@property (nonatomic,assign)BOOL registered;
@property (nonatomic,retain)NSString*profileImageUrl;
@property (nonatomic,retain)NSString *channel;
@property (nonatomic,assign)NSInteger badgeCount;

@end
