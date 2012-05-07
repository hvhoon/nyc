//
//  SocFacebookLogin.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocFacebookLogin.h"
#import "FBStreamDialog.h"

@implementation SocFacebookLogin
@synthesize delegate;
@synthesize facebookAlert;
@synthesize usersession;
@synthesize setFTag;
@synthesize loginDialog = _loginDialog;
@synthesize facebookName = _facebookName;
@synthesize facebookFriendsListArray,_session;;


-(id)initWithApiKeyAndSecret:(NSInteger)faceTag{
	
	if (self = [super init]) {
        kApiKey = @"134272989983748";
        kApiSecret = @"b535c006ef27d4c0905a19a5df714a3d";
        facebookFriendsListArray=[[NSMutableArray alloc]init];
        setFTag=faceTag;
        myManager=[SoclivityManager SharedInstance];
        if (myManager._session == nil){
            _session = [FBSession
                                    sessionForApplication:kApiKey
                                    secret:kApiSecret delegate:self];
            myManager._session=_session;
        }
        [myManager._session resume];
	}
	return self;
}

-(void)ShowFacebookDialog{
    // If we're not logged in, log in first...
	if (![myManager._session isConnected]) {
		self.loginDialog = nil;
		_loginDialog = [[FBLoginDialog alloc] init];
		_loginDialog.delegate=self;
		[_loginDialog show];    
	}
    // If we have a session great do the stuff you want to do
	else {
		
		NSLog(@"Else Case is Initiated");
		
		
	}
	
}
- (void)logoutButtonTapped:(id)sender {
	[myManager._session logout];
}


-(void)setUniqueTagForResults:(NSInteger)fTag{
	setFTag=fTag;
}
-(NSInteger)getUniqueTag{
	return setFTag;
}


//Facebook 
#pragma mark -
#pragma mark Facebook Session Delegate Methods

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
    //	self.usersession =session;
	
	NSLog(@"After Login Called First");
	NSLog(@"User with id %lld logged in.", uid);
	
		[self getFacebookFriends];
		[self getFacebookName];
	    //[delegate facebookPhotoPostedControlBackToShare];
}


-(void)postInviteOnFriendsWall:(NSString*)facebookUid
{
	
    //NSString *FacebookUid=@"1037907114";
    //Check to see if the user is letting us make the post
    //		if( permissionStatusForUser != nil && permissionStatusForUser.userHasPermission )
    
    //Set up the json encoded message as defined by Facebook SDK
	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:4];
	
	[variables setObject:@"Hi.I want to invite You To Join Apertr " forKey:@"message"];
 	[variables setObject:facebookUid forKey:@"target_id"];
	[variables setObject:@"true" forKey:@"auto_publish"];
	NSString *action_links = @"[{\"text\":\"link\",\"href\":\"http://apertr.com/Apertr\"}]";
    [variables setObject:action_links forKey:@"action_links"];
    
    // all of my facebook achievement images are 200, 200
    [[FBRequest requestWithDelegate:self] call:@"facebook.stream.publish" params:variables];
    
}
- (void)session:(FBSession*)session willLogout:(FBUID)uid {
	_facebookName = nil;
}

#pragma mark Get Facebook Name Helper


-(void)getFacebookFriends{
	NSString* fql = [NSString stringWithFormat:@"SELECT name,uid FROM user WHERE uid IN ( SELECT uid2 FROM friend WHERE uid1=%lld )",myManager._session.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
    
}

- (void)publishPhoto{
	UIImage *img=[UIImage imageNamed:@"brolin.jpg"];
    NSMutableDictionary *args = [[[NSMutableDictionary alloc] init] autorelease];
    [args setObject:img forKey:@"image"];  
    FBRequest *uploadPhotoRequest = [FBRequest requestWithDelegate:self];
    [uploadPhotoRequest call:@"photos.upload" params:args];
}

- (void)getFacebookName {
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld",myManager._session.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}

#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)request didLoad:(id)result {
	
	NSLog(@"request didLoad Called");
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		
		
			
            
            NSArray* users = result;
		    NSDictionary* user = [users objectAtIndex:0];
		    NSString* userFaceBookName = [user objectForKey:@"name"];
			[[NSUserDefaults standardUserDefaults] setValue:userFaceBookName forKey:@"facebookAcc"];
            
			NSDictionary *test = result;
 			
			for (NSDictionary *facebookInfo in test)
			{
				NSLog(@"name=%@,uid=%@",[facebookInfo objectForKey:@"name"],[facebookInfo objectForKey:@"uid"]);
				
				
			}
			
        
	}	
}

#if 0
-(void)FindContactsInFacebook
{
	
	NSMutableArray *content = [NSMutableArray new];
	
	for(int i = 0 ; i < [facebookFriendsListArray count] ; i++) {
		
		SocialNetworkUserInvite *facebookInvite=[facebookFriendsListArray objectAtIndex:i];
		
		
		NSString *name=[facebookInvite userName];
		NSString *facebookUserId=[facebookInvite facebookId];
        //NSLog(@"the facebook ID is=%@",facebookUserId);
		NSString *status=[facebookInvite statusMessage];
		NSMutableArray *contactNames = [[[NSMutableArray alloc] init] autorelease];
		NSMutableDictionary *row = [[[NSMutableDictionary alloc] init] autorelease];
		NSMutableDictionary *elements=[[[NSMutableDictionary alloc] init] autorelease];
		NSMutableArray *entries=[[[NSMutableArray alloc]init] autorelease];
		bool insertNewElement = TRUE;
        //			char currentLetter[2] =  {toupper([name characterAtIndex:0]), '\0'}; 
		unichar *buffer = calloc([name length], sizeof(unichar));
		[name getCharacters:buffer];
		*buffer = toupper(*buffer);
		NSUInteger length = 1;
		NSString *headerLetter = [[NSString alloc] initWithCharacters:(const unichar *)buffer length:length];
        //NSString *headerLetter=[name characterAtIndex:0];
		[row setValue:[NSString stringWithString:headerLetter] forKey:@"headerTitle"];
		
		if(name!=nil)
			[contactNames addObject:name];
		
		for(NSDictionary *dict in content) {
			NSString *headerKey = [dict objectForKey:@"headerTitle"];
			unichar firstCharOfName = toupper([name characterAtIndex:0]);
			if ([headerKey characterAtIndex:0] == firstCharOfName) {
				NSMutableArray *oldEntries = [dict objectForKey:@"Elements"];
				[elements setValue:name forKey:@"ContactNames"];
				[elements setValue:status forKey:@"StatusMessage"];
				[elements setValue:facebookUserId forKey:@"Id"];
				[oldEntries addObject:elements];
				insertNewElement = FALSE;
				break;
			}
			else {
				insertNewElement = TRUE;
			}
		}					
		if (insertNewElement) {
			[elements setValue:name forKey:@"ContactNames"];
			[elements setValue:status forKey:@"StatusMessage"];
			[elements setValue:facebookUserId forKey:@"Id"];
			[entries addObject:elements];
			[row setValue:entries forKey:@"Elements"];
			[content addObject:row];
		}
		
		
	}
	
	
	
	
	NSSortDescriptor * headerDescriptor =
	[[[NSSortDescriptor alloc] initWithKey:@"headerTitle"
								 ascending:YES] autorelease];
	
	
	NSArray * descriptors =[NSArray arrayWithObjects:headerDescriptor, nil];
	NSArray * sortedArray =[content sortedArrayUsingDescriptors:descriptors];
	
    [delegate LoadArrayFB2:sortedArray];
	
}	
#endif

#pragma mark Post to Wall Helper

- (void)postToWall {
	
	FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.userMessagePrompt = @"Enter your message:";
	dialog.attachment = [NSString stringWithFormat:@"{\"name\":\"Listening to %@\",\"href\":\"\",\"caption\":\"\",\"description\":\"\",\"media\":[{\"type\":\"image\",\"src\":\"\",\"href\":\"\"}]}",
						 @"message"];
	[dialog show];
	
}

- (void)uploadPhoto:(UIImage*)facebookPhoto photoComment:(NSString*)photoComment{
	
    
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    UIImage *img = facebookPhoto;
    NSData *data = UIImageJPEGRepresentation(img, 1);
    //NSData *data = UIImagePNGRepresentation(img);
    NSString *imgstr = [data base64EncodedString];
    //NSString *imgstr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    //[args setObject:[UIImage imageNamed:@"antartica1.png"] forKey:@"image"];   
    [args setObject:imgstr forKey:@"image"];    // 'images' is an array of 'UIImage' objects
	NSString *photoMessage=[NSString stringWithFormat:@"has shared a photo from"];
    //NSString *photoMessage=[NSString stringWithFormat:@"<user> has shared a photo from<Apertr>"];	
	[args setObject:[NSString stringWithFormat:@"%@",photoMessage] forKey:@"caption"];
	
    FBRequest *uploadimgrequest = [FBRequest requestWithDelegate:self];
    [uploadimgrequest call:@"photos.upload" params:args dataParam:data];
    //[uploadimgrequest call:@"photos.upload" params:args];
	
    
	
	
    
}

- (void)dialogDidCancel:(FBDialog*)dialog{
	NSLog(@"dialogDidCancel called");
		//[delegate facebookPhotoPostedControlBackToShare];
}

-(void)dealloc{
	[super dealloc];
}


@end
