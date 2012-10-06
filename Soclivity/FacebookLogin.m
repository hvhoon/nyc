//
//  FacebookLogin.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookLogin.h"
#import "AppDelegate.h"
#import "FBConnect.h"
#import "SoclivityManager.h"
#import "GetPlayersClass.h"
#import "MainServiceManager.h"
#import "SoclivityUtilities.h"
@interface FacebookLogin(private)<FBSignInInvocationDelegate>
@end

@implementation FacebookLogin
@synthesize permissions,FBdelegate;

- (void)dealloc {
    [permissions release];
    [super dealloc];
}

-(id)init{
    
   if (self = [super init]) {

   }
    return self;

}
-(void)setUpPermissions{
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"user_likes", 
                   @"read_stream",@"email",@"user_subscriptions",@"friends_subscriptions", nil];//nice bit of research kanav got user's email id also..//subscribe
    [self login];
    
}
#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name,sex,email,birthday_date,current_location,first_name,last_name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    //https://graph.facebook.com/19292868552
    //kanav test this URL AGAIN
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)apiGraphUserPermissions {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}
- (void)showLoggedIn {
    [self apiFQLIMe];
}

/**
 * Show the logged in menu
 */

- (void)showLoggedOut {
    NSLog(@"showLoggedOut");
}


- (void)login {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        [[delegate facebook] authorize:permissions];
    } else {
        [self showLoggedIn];
    }
}
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.registrationObject.facebookAccessToken=accessToken;
    [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"facebookId"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}
#pragma mark - FBSessionDelegate Methods
- (void)fbDidLogin {
    [self showLoggedIn];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self storeAuthData:[[delegate facebook] accessToken] expiresAt:[[delegate facebook] expirationDate]];
    
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.registrationObject.facebookAccessToken=accessToken;
    [[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:@"facebookId"];
    [self storeAuthData:accessToken expiresAt:expiresAt];
}


/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
     NSLog(@"fbDidNotLogin ");
    [FBdelegate userCancelFBRequest];
}
/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
     NSLog(@"fbDidLogout");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        devServer=[[MainServiceManager alloc]init];
        // If basic information callback, set the UI objects to
        // display this.
        if([result objectForKey:@"first_name"]){
            SOC.registrationObject.first_name=[result objectForKey:@"first_name"];
        }
        if([result objectForKey:@"email"]){
            SOC.registrationObject.email=[result objectForKey:@"email"];
        }
        if([result objectForKey:@"sex"]){
            SOC.registrationObject.gender=[result objectForKey:@"sex"];
        }
        if([result objectForKey:@"current_location"]){
            SOC.registrationObject.current_location=[result objectForKey:@"current_location"];
        }
        if([result objectForKey:@"last_name"]){
            SOC.registrationObject.last_name=[result objectForKey:@"last_name"];
        }
        if([result objectForKey:@"birthday_date"]){
            SOC.registrationObject.birth_date=[result objectForKey:@"birthday_date"];
        }
        
        if([result objectForKey:@"uid"]){
            
            SOC.registrationObject.facebookUId=[result objectForKey:@"uid"];

             NSLog(@"uid=%@",[result objectForKey:@"uid"]);
        }

        NSLog(@"firstName=%@",[result objectForKey:@"first_name"]);
        NSLog(@"email=%@",[result objectForKey:@"email"]);
        NSLog(@"sex=%@",[result objectForKey:@"sex"]);
        NSLog(@"current_location=%@",[result objectForKey:@"current_location"]);
        NSLog(@"last_name=%@",[result objectForKey:@"last_name"]);
        NSLog(@"birthday_date=%@",[result objectForKey:@"birthday_date"]);


        // Get the profile image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        SOC.registrationObject.FBProfileImage=image;
        if(SOC.registrationObject.FBProfileImage.size.height != SOC.registrationObject.FBProfileImage.size.width)
            SOC.registrationObject.FBProfileImage = [SoclivityUtilities autoCrop:SOC.registrationObject.FBProfileImage];
        
        // If the image needs to be compressed
        if(SOC.registrationObject.FBProfileImage.size.height > 100 || SOC.registrationObject.FBProfileImage.size.width > 100)
            SOC.registrationObject.FBProfileImage = [SoclivityUtilities compressImage:SOC.registrationObject.FBProfileImage size:CGSizeMake(100,100)];
        
        SOC.registrationObject.profileImageData=UIImagePNGRepresentation(SOC.registrationObject.FBProfileImage);

        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
        
        [self apiGraphUserPermissions];
        if([SoclivityUtilities hasNetworkConnection]){
        [devServer postFBSignInInvocation:SOC.registrationObject.email facebookUid:SOC.registrationObject.facebookUId fbAccessToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"facebookId"] delegate:self];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil 
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            [alert release];
            return;
            
        }

        
         
    }
    
    else {
        // Processing permissions information
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}
-(void)FBSignInInvocationDidFinish:(FBSignInInvocation*)invocation
                      withResponse:(NSArray*)responses
                         withError:(NSError*)error{
    
    GetPlayersClass *obj=[responses objectAtIndex:0];
    NSLog(@"SOC ID=%d",[obj.idSoc intValue]);
    if(!obj.registered)
        [FBdelegate pushToRegistration];
    else{
        //redirect him to homeView Controller
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
        SOC.loggedInUser=obj;

        [FBdelegate pushToHomeViewController];
    }
}

@end
