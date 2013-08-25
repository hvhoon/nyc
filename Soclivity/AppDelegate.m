//
//  AppDelegate.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeScreenViewController.h"
#import "FacebookLogin.h"
#import "InfoActivityClass.h"
#import "DetailInfoActivityClass.h"
#import "SoclivityUtilities.h"
#import "SoclivitySqliteClass.h"
#import "GetPlayersClass.h"
#import "ActivityEventViewController.h"
#import "SlideViewController.h"
#import "TestFlight.h"
#import "SlidingDrawerViewController.h"
#import "AutoSessionClass.h"

static NSString* kAppId = @"160726900680967";//kanav
#define kShowAlertKey @"ShowAlert"
#define kRemoteNotificationReceivedNotification @"RemoteNotificationReceivedWhileRunning"
#define kRemoteNotificationBackgroundNotification @"RemoteNotificationReceivedWhileBackground"
#define kNotificationForChatPost @"ChatNotification"
@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect {
	UIColor *color = [UIColor clearColor];
	UIImage *img;
    img  = [UIImage imageNamed: @"S01.2_blackbar.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.tintColor  = color;
}

@end
@implementation AppDelegate
@synthesize navigationController;
@synthesize window = _window;
@synthesize facebook;
@synthesize userPermissions;
@synthesize resetSuccess;
@synthesize dict_notification;
@synthesize onlyOnce;
@synthesize listViewController;


- (void)dealloc
{
    [_window release];
    [super dealloc];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TestingFlight SDK
    [TestFlight takeOff:@"fbb407ca-1c4b-46e7-b3a0-dd7f3ee323e6"];
    
    //[self setUpActivityDataList];
    [SoclivitySqliteClass copyDatabaseIfNeeded];
	BOOL openSuccessful=[SoclivitySqliteClass openDatabase:[SoclivitySqliteClass getDBPath]];
	if(openSuccessful)
		
     [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self registerForNotifications];

    [[NSUserDefaults standardUserDefaults] synchronize];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"FacebookLogin"]){
        
        NSString *nibNameBundle=nil;
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"SlideViewController_iphone5";
        }
        
        else{
            nibNameBundle=@"SlideViewController";
        }
        
        SlidingDrawerViewController *slideViewController = [[SlidingDrawerViewController alloc] initWithNibName:nibNameBundle bundle:nil];
        slideViewController.delegate = slideViewController;
        slideViewController.isFBlogged=TRUE;
        self.navigationController=[[UINavigationController alloc]initWithRootViewController:slideViewController];
        [slideViewController release];

    }
    else{
            
            
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"WelcomeScreenViewControllerIphone5";
    }
    else{
        nibNameBundle=@"WelcomeScreenViewController";
    }
    WelcomeScreenViewController *welcomeScreenViewController=[[WelcomeScreenViewController alloc]initWithNibName:nibNameBundle bundle:nil];
    self.navigationController=[[UINavigationController alloc]initWithRootViewController:welcomeScreenViewController];
    [welcomeScreenViewController release];
 }
    UINavigationBar *NavBar = [self.navigationController navigationBar];
    
    if ([NavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        // set globablly for all UINavBars
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"S01.2_blackbar.png"] forBarMetrics:UIBarMetricsDefault];
        // could optionally set for just this navBar
        //[navBar setBackgroundImage:...
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)registerForNotifications {
	UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"token: %@", token);
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"device_token"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
	NSLog(@"Failed to get token, error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"didReceiveRemoteNotification");
    SOC=[SoclivityManager SharedInstance];
    
    if([[[userInfo valueForKey:@"params"] valueForKey:@"notification_type"]isEqualToString:@"17"]){
    
        //[[NSUserDefaults standardUserDefaults]setValue:[[userInfo valueForKey:@"params"] valueForKey:@"message"] forKey:@"message"];
        
        SOC.loggedInUser.badgeCount=[[[userInfo valueForKey:@"aps"] valueForKey:@"badge"]integerValue];
        NSInteger chatid=[[[userInfo valueForKey:@"params"] valueForKey:@"chat_id"]integerValue];
        
        NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://dev.soclivity.com/activity_chats/%d/acparameter.json",chatid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"url=%@",url);
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
        NSHTTPURLResponse *response = NULL;
        NSError *error = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSDictionary* resultsd = [[[NSString alloc] initWithData:returnData
                                                        encoding:NSUTF8StringEncoding] JSONValue];

        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];

        
        NSNotification* notification = [NSNotification notificationWithName:kNotificationForChatPost object:nil userInfo:resultsd];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
    else{
    
        
        NSLog(@"Online");
        
            if([SoclivityUtilities hasNetworkConnection]){
        NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://dev.soclivity.com/rsparameter.json?id=%@",[NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"params"] valueForKey:@"notification_id"]]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"url=%@",url);
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
        NSHTTPURLResponse *response = NULL;
        NSError *error = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSDictionary* resultsd = [[[NSString alloc] initWithData:returnData
                                                        encoding:NSUTF8StringEncoding] JSONValue];
        NSLog(@"badge Value=%d",[[resultsd objectForKey:@"badge"]integerValue]);
        
        SOC.loggedInUser.badgeCount=[[resultsd objectForKey:@"badge"]integerValue];
        
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:SOC.loggedInUser.badgeCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];
        
        
        NSNotification* notification = [NSNotification notificationWithName:kRemoteNotificationReceivedNotification object:nil userInfo:resultsd];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }
}

-(void)setUpActivityDataList{
     NSLog(@"setUpActivityDataList");
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Activities" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *playsArray = [NSMutableArray arrayWithCapacity:[playDictionariesArray count]];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        InfoActivityClass *play = [[InfoActivityClass alloc] init];
        play.activityName = [playDictionary objectForKey:@"activityName"];
        play.organizerName=[playDictionary objectForKey:@"organizerName"];
        NSNumber * n = [playDictionary objectForKey:@"type"];
        play.type= [n intValue];
        NSNumber * DOS = [playDictionary objectForKey:@"DOS"];
        play.DOS= [DOS intValue];
        play.distance=[playDictionary objectForKey:@"distance"];
        play.goingCount=[playDictionary objectForKey:@"goingCount"];
        play.where_lat=[playDictionary objectForKey:@"Latitude"];
        play.where_lng=[playDictionary objectForKey:@"Longitude"];
        play.when=[playDictionary objectForKey:@"Date"];
        if([SoclivityUtilities ValidActivityDate:play.when]){
        NSString *message=[SoclivityUtilities NetworkTime:play];
        NSLog(@"message=%@",message);
        NSArray *quotationDictionaries = [playDictionary objectForKey:@"detailQuotations"];
        NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:[quotationDictionaries count]];
        
        for (NSDictionary *quotationDictionary in quotationDictionaries) {
            
            DetailInfoActivityClass *quotation = [[DetailInfoActivityClass alloc] init];
            [quotation setValuesForKeysWithDictionary:quotationDictionary];
            
            [quotations addObject:quotation];
            [quotation release];
        }
        play.quotations = quotations;
        
        [playsArray addObject:play];
        [play release];
        }
    }
    
    [SoclivityUtilities setPlayerActivities:playsArray];
    [playDictionariesArray release];

}


-(FacebookLogin*)SetUpFacebook{
    
     NSLog(@"SetUpFacebook");
    
    
    FacebookLogin *login=[[FacebookLogin alloc]init];

    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:login];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    
    // Initialize user permissions
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    [login setUpPermissions];
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
        [alertView release];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
            [alertView release];
        }
    }
    return login;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

-(void)IntimateServerForAPNSOrRocketSocket{
    
    if([SoclivityUtilities hasNetworkConnection]){
        
    SOC=[SoclivityManager SharedInstance];
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://dev.soclivity.com/player_app_status.json?id=%d&background_status=%i",[SOC.loggedInUser.idSoc intValue],status] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"url=%@",url);
    
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSHTTPURLResponse *response = NULL;
	NSError *error = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary* resultsd = [[[NSString alloc] initWithData:returnData
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    SOC.loggedInUser.badgeCount=[[resultsd objectForKey:@"badge"]integerValue];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
        NSLog(@"applicationDidEnterBackground");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSString  *currentTime=[dateFormatter stringFromDate:[NSDate date]];
    
    [[NSUserDefaults standardUserDefaults] setValue:currentTime forKey:@"ChatTimeStamp"];

    

#if 0
    NSAssert(self->bgTask == UIBackgroundTaskInvalid, nil);
    
    currentBackgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    self->bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(currentBackgroundQueue, ^{
            [application endBackgroundTask:self->bgTask];
            self->bgTask = UIBackgroundTaskInvalid;
        });
    }];
     
    
    dispatch_async(currentBackgroundQueue, ^{
        status=1;
        
           // [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseSocketRocket" object:self userInfo:nil];
            [self IntimateServerForAPNSOrRocketSocket];

            [application endBackgroundTask:self->bgTask];
             self->bgTask = UIBackgroundTaskInvalid;
    });
    
    dispatch_release(currentBackgroundQueue);
        
    
#endif
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    

    SOC=[SoclivityManager SharedInstance];
    SOC.loggedInUser.badgeCount=[[UIApplication sharedApplication]applicationIconBadgeNumber];
    NSLog(@"SOC.loggedInUser.badgeCount=%d",SOC.loggedInUser.badgeCount);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:nil];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatDeltaUpdate" object:self userInfo:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RandomFetch" object:self userInfo:nil];
    
    

#if 0
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"]){
        
        [application endBackgroundTask:self->bgTask];
        self->bgTask = UIBackgroundTaskInvalid;
        
        if([SoclivityUtilities hasNetworkConnection]){
                status=0;

                [self IntimateServerForAPNSOrRocketSocket];
                
                //[_objrra fetchPrivatePubConfiguration];
            }
        }
#endif
}

-(void)ShowNotification:(NSNotification*)dict
{
    
    NSString *notif=[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"];
    NSLog(@"notif=%@",notif);
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[[self facebook] extendAccessTokenIfNeeded];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"FacebookLogin"]){
        
        [self extendToken];
//    [NSThread detachNewThreadSelector:@selector(extendToken) toTarget:self withObject:nil];
    }
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}
-(void)extendToken{
    AutoSessionClass *session=[[AutoSessionClass alloc]init];
    [session isFacebookTokenValid];
    session.delegate=self;

}

-(void)pushSlidingViewController{
    NSLog(@"Test in app Delegate");
}
-(void)sessionLogout{
        NSLog(@"sessionLogout");
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FacebookLogin"];
    [[self facebook] logout];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

@end
