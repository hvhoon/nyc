//
//  SocFacebookLogin.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSession.h"
#import "FBRequest.h"
#import "FBLoginDialog.h"
#import "SoclivityManager.h"
@protocol FacebookObjectDelegate <NSObject>

@optional
-(void)LoadArrayFB2:(NSArray*)facebookFollowersArray;
-(void)facebookPhotoPostedControlBackToShare;
-(void)PostPhotoOnFacebookWall;
@end

@interface SocFacebookLogin : NSObject<FBDialogDelegate,FBSessionDelegate, FBRequestDelegate>{
    id <FacebookObjectDelegate> delegate;
    FBLoginDialog	*_loginDialog;
	UIAlertView		*facebookAlert;
	FBSession		*usersession;
	NSString		*_facebookName;
	NSString		*kApiKey;
	NSString		*kApiSecret;
	NSInteger        setFTag;
	NSMutableArray *facebookFriendsListArray;
   FBSession* _session;
    SoclivityManager *myManager;

}
@property (nonatomic,retain)id <FacebookObjectDelegate> delegate;
@property(nonatomic,retain) UIAlertView *facebookAlert;
@property(nonatomic,retain)  FBSession *usersession;
@property (nonatomic, copy) NSString *facebookName;
@property (nonatomic, retain) FBLoginDialog *loginDialog;
@property (nonatomic,assign)	NSInteger   setFTag;
@property (nonatomic,retain) NSMutableArray *facebookFriendsListArray;
@property (nonatomic,retain) FBSession* _session;
-(void)getFacebookName;
-(void)postToWall;
-(void)setUniqueTagForResults:(NSInteger)fTag;
-(NSInteger)getUniqueTag;
-(id)initWithApiKeyAndSecret:(NSInteger)faceTag;
-(void)ShowFacebookDialog;
-(void)getFacebookFriends;
-(void)postInviteOnFriendsWall:(NSString*)facebookUid;
- (void)uploadPhoto:(UIImage*)facebookPhoto photoComment:(NSString*)photoComment;

@end
