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
#import "TTTAttributedLabel.h"
#import "NotificationsViewController.h"
#import "SlidingDrawerViewController.h"
#import "JMC.h"
#import "GetPlayersClass.h"
#import "ActivityEventViewController.h"


static NSString* kAppId = @"160726900680967";//kanav
#define kShowAlertKey @"ShowAlert"
#define kRemoteNotificationReceivedNotification @"RemoteNotificationReceivedWhileRunning"
#define kRemoteNotificationBackgroundNotification @"RemoteNotificationReceivedWhileBackground"

static NSRegularExpression *__nameRegularExpression;
static inline NSRegularExpression * NameRegularExpression() {
    if (!__nameRegularExpression) {
        // __nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
        
        __nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"#([^#(#)]+#)" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    return __nameRegularExpression;
}

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
@synthesize menuController;
@synthesize facebook;
@synthesize userPermissions;
@synthesize resetSuccess;
@synthesize responsedata,vw_notification;

@synthesize summaryLabel = _summaryLabel;
UIImageView *imgvw1;

int counter=0;
NSTimer *timer;
NSString *lstrphoto;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

-(void)HideNotification
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.vw_notification setFrame:CGRectMake(0, -20, 320, 58)];
                     }
                     completion:^(BOOL finished){
                       [vw_notification removeFromSuperview];
                     }];
}

- (void)countdownTracker:(NSTimer *)theTimer {
    counter++;
    if (counter ==5)
    {
        [timer invalidate];
        timer = nil;
        counter = 0;
        
        [self HideNotification];
    }//END if (counter ==5)
}

-(void)backgroundtap:(id)sender
{
    [self HideNotification];
}

-(void)DownloadImage:(NSString *)lstrphotourl
{
    self.responsedata=[[NSMutableData alloc] init];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",ProductionServer,lstrphotourl]]] delegate:self];
    
    lstrphoto=@"photo";
    NSLog(@"conn::%@",conn);
}

-(void)ShowNotification:(NSNotification*)dict
{
    NSLog(@"dict::%@",dict);
    
    timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTracker:) userInfo:nil repeats:YES];
    
    vw_notification=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    vw_notification.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"InAppAlertBar.png"]];
    
    UIImageView *imgvw=[[UIImageView alloc] init];
    imgvw.frame=CGRectMake(5, 5, 43, 43);
    imgvw.image=[UIImage imageNamed:@"S11_frame.png"];
    
    imgvw1=[[UIImageView alloc] init];
    imgvw1.frame=CGRectMake(10, 10, 32, 32);
    imgvw1.backgroundColor=[UIColor clearColor];
    
    self.summaryLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.summaryLabel.frame=CGRectMake(50, 0, 200, 50);
    self.summaryLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    self.summaryLabel.font =[UIFont fontWithName:@"Helvetica-Condensed" size:12];
    self.summaryLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.highlightedTextColor = [UIColor whiteColor];
    self.summaryLabel.backgroundColor=[UIColor clearColor];
    
    [self setSummaryText:[[dict valueForKey:@"userInfo"] valueForKey:@"message"]];
    
    UIButton *btnclose=[UIButton buttonWithType:UIButtonTypeCustom];
    btnclose.frame=CGRectMake(295, 16, 19, 19);
    [btnclose setBackgroundImage:[UIImage imageNamed:@"InAppRemove.png"] forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(HideNotification) forControlEvents:UIControlEventTouchUpInside];
    
     CGSize imgSize;
    
    if ([[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==1)
    {
        imgvw1.image=[UIImage imageNamed:@"S11_infoChangeIcon.png"];
        imgSize=[imgvw1.image size];
        imgvw1.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
    }//END if ([[[self._notifications objectAtIndex:indexPath
    
    else if([[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==2)
    {
        imgvw1.image=[UIImage imageNamed:@"S11_calendarIcon.png"];
        imgSize=[imgvw1.image size];
        imgvw1.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
    }//END if ([[[self._notifications objectAt
    
    else if([[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==3)
    {
        imgvw1.image=[UIImage imageNamed:@"S11_clockLogo.png"];
        imgSize=[imgvw1.image size];
        imgvw1.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
    }//END if ([[[self._notifications objectAt
    
    else if([[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==4)
    {
        imgvw1.image=[UIImage imageNamed:@"S11_locationIcon.png"];
        imgSize=[imgvw1.image size];
        imgvw1.frame=CGRectMake(18, 18, imgSize.width,imgSize.height);
    }//END if ([[[self._notifications objectAt
    
    UIButton *btnaction=[UIButton buttonWithType:UIButtonTypeCustom];
    btnaction.frame=CGRectMake(0, 0, 285, 55);
    btnaction.backgroundColor=[UIColor clearColor];
    btnaction.tag=[[[[dict valueForKey:@"userInfo"] valueForKey:@"activity"] valueForKey:@"id"] intValue];
    [btnaction addTarget:self action:@selector(backgroundtap:) forControlEvents:UIControlEventTouchUpInside];
    
    [vw_notification addSubview:btnclose];
    [vw_notification addSubview:self.summaryLabel];
    [vw_notification addSubview:imgvw1];
    [vw_notification addSubview:btnaction];
    
    if ([[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==6 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==8 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==9 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==11 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==12 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==13 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==14 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==15 || [[[dict valueForKey:@"userInfo"] valueForKey:@"activity_type"] intValue]==16)
    {
        [vw_notification addSubview:imgvw1];
        [self DownloadImage:(NSString *)[[dict valueForKey:@"userInfo"] valueForKey:@"photo_url"]];
    }//END if ([[[dict valueForKey:@"userInfo"] valueForKey:@"activ
    
    else
    {
        [self.window addSubview:vw_notification];
    }//END Else Statement
    
    [UIView beginAnimations:nil context:@"flipView"];
    [UIView setAnimationDuration:0.5];
    [self.vw_notification setFrame:CGRectMake(0, 18, 320, 60)];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.vw_notification cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)setSummaryText:(NSString *)text {
    
    NSLog(@"setSummaryText");
    
    [self.summaryLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *regexp = NameRegularExpression();
        
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            UIFont *boldSystemFont =[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14.0]; //[UIFont boldSystemFontOfSize:kEspressoDescriptionTextFontSize];
            CTFontRef boldFont = CTFontCreateWithName(( CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
            
            if (boldFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:( id)boldFont range:result.range];
                CFRelease(boldFont);
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor darkGrayColor] CGColor] range:result.range];
            }//END if (boldFont)
        }];
        
        int times = [[text componentsSeparatedByString:@"#"] count]-1;
        
        for (int i=0; i<times; i++)
        {
            NSRange range = [[mutableAttributedString string] rangeOfString:@"#"];
            
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(range.location, 1) withString:@""];
            
        }//END for (int i=0; i<[Splitarray count]; i++)
        
        return mutableAttributedString;
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logged_in_user_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Waiting_On_You_Count"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NotificationActivity"];

    [self IncreaseBadgeIcon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (ShowNotification:) name:@"WaitingonyouNotification" object:nil];
    
    //[self setUpActivityDataList];
    [SoclivitySqliteClass copyDatabaseIfNeeded];
	BOOL openSuccessful=[SoclivitySqliteClass openDatabase:[SoclivitySqliteClass getDBPath]];
	if(openSuccessful)
		
     [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"WelcomeScreenViewControllerIphone5";
    }
    else{
        nibNameBundle=@"WelcomeScreenViewController";
    }
    WelcomeScreenViewController *welcomeScreenViewController=[[WelcomeScreenViewController alloc]initWithNibName:nibNameBundle bundle:nil];
    navigationController=[[UINavigationController alloc]initWithRootViewController:welcomeScreenViewController];
    [welcomeScreenViewController release];
    UINavigationBar *NavBar = [navigationController navigationBar];
    
    if ([NavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        // set globablly for all UINavBars
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"S01.2_blackbar.png"] forBarMetrics:UIBarMetricsDefault];
        // could optionally set for just this navBar
        //[navBar setBackgroundImage:...
    }
    
    [navigationController setNavigationBarHidden:YES];
    [self.window addSubview:navigationController.view];

    [self.window makeKeyAndVisible];
    [self registerForNotifications];
    
    // Adding JIRA monitoring
    [[JMC sharedInstance] configureJiraConnect:@"https://soclivity.atlassian.net/"
                                          projectKey:@"MIA"
                                        apiKey:@"76935221-9c6b-4b40-9f4f-eba47fa7f24b"];
    return YES;
}

-(void)registerForNotifications {
	UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
}

-(void)IncreaseBadgeIcon
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: [[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"] intValue]];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"device_token"];
    
    NSLog(@"device token::%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"didReceiveRemoteNotification");
    
    if (_appIsInbackground)
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Notification_id"]==NULL)
        {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"params"] valueForKey:@"notification_id"]]  forKey:@"Notification_id"];
        }//END if ([[NSUserDefaults standardUserDefaults] valueforKey:@"Notification_Count"]==NULL)
    
        else
        {
        NSString *lstrvalue=[[NSUserDefaults standardUserDefaults] valueForKey:@"Notification_id"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Notification_id"];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@,%@",lstrvalue,[[userInfo valueForKey:@"params"] valueForKey:@"notification_id"]] forKey:@"Notification_id"];
    }//END Else Statement
        
        if (userInfo!=NULL)
        {
            [[NSUserDefaults standardUserDefaults] setValue:[[userInfo valueForKey:@"aps"] valueForKey:@"badge"] forKey:@"Waiting_On_You_Count"];
        }//END if (userInfo!=NULL)
        
        NSDictionary *dictcount=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"],@"Waiting_On_You_Count", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:dictcount];
        
        [self IncreaseBadgeIcon];
    }//END  if (_appIsInbackground)
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingonyouNotification" object:self userInfo:[channel valueForKeyPath:@"data"]];
	/*NSDictionary* notifUserInfo = Nil;
	if (!_appIsInbackground) {
		
		NSArray *notifArray = [NSArray arrayWithObject:kShowAlertKey];
		notifUserInfo = [[NSDictionary alloc] initWithObjects:notifArray forKeys:notifArray];
	}
    else{
        NSNotification* notification = [NSNotification notificationWithName:kRemoteNotificationBackgroundNotification object:userInfo userInfo:notifUserInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [notifUserInfo release];
    }
	NSNotification* notification = [NSNotification notificationWithName:kRemoteNotificationReceivedNotification object:userInfo userInfo:notifUserInfo];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
	[notifUserInfo release];*/
    
}

-(void)setUpActivityDataList{
     NSLog(@"setUpActivityDataList");
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Activities" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *playsArray = [NSMutableArray arrayWithCapacity:[playDictionariesArray count]];
    
    NSLog(@"playDictionariesArray::%@",playDictionariesArray);
    
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
    
     [self registerForNotifications];
    
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
     NSLog(@"applicationWillResignActive");
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

-(void)PostBackgroundStatus:(int)status
{
    NSLog(@"PostBackgroundStatus");
    
    self.responsedata=[[NSMutableData alloc] init];
    
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://%@/player_app_status.json?id=%@&background_status=%i",ProductionServer,[[NSUserDefaults standardUserDefaults] valueForKey:@"logged_in_user_id"],status] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"url::%@",url);
    
    NSURLResponse *response = nil;
    NSError *error = nil;
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    NSString *lstrnotificationid=[[NSUserDefaults standardUserDefaults] valueForKey:@"Notification_id"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(returnData!=NULL)
    {
        NSString *lstrresponse = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        if (lstrresponse!=NULL)
        {
            if ([[lstrresponse JSONValue] valueForKeyPath:@"badge"]!=NULL)
            {
                [[NSUserDefaults standardUserDefaults] setValue:[[lstrresponse JSONValue] valueForKeyPath:@"badge"] forKey:@"Waiting_On_You_Count"];
                
                NSDictionary *dictcount=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"],@"Waiting_On_You_Count", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingOnYou_Count" object:self userInfo:dictcount];
                [self IncreaseBadgeIcon];
            }//END if ([[lstrresponse JSONValue] valueForKeyPath:@"badge"]!=NULL)
            
            if ([[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"]!=NULL && [[[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"] count]!=0)
            {
                for (int i=0; i<[[[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"] count]; i++)
                {
                    NSLog(@"lstrnotificationid::%@",lstrnotificationid);
                    
                    if (lstrnotificationid!=NULL)
                    {
                         NSArray *SplitArray=[lstrnotificationid componentsSeparatedByString:@","];
                        
                        NSLog(@"SplitArray::%@",SplitArray);
                        
                        if (![SplitArray containsObject:[[[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"] objectAtIndex:i]])
                        {
                            if (lstrnotificationid==NULL || [lstrnotificationid isEqualToString:@""])
                            {
                                [[NSUserDefaults standardUserDefaults] setValue:[[[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"] objectAtIndex:i]  forKey:@"Notification_id"];
                            }//END if ([[NSUserDefaults standardUserDefaults] valueforKey:@"Notification_Count"]==NULL)
                            
                            else
                            {
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Notification_id"];
                                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@,%@",lstrnotificationid,[[[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"] objectAtIndex:i]] forKey:@"Notification_id"];
                            }//END Else Statement
                        }//END if (![SplitArray containsObject:[[[ls
                    }//END if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Notif
                    
                    else
                    {
                        if (lstrnotificationid==NULL || [lstrnotificationid isEqualToString:@""])
                        {
                            [[NSUserDefaults standardUserDefaults] setValue:[[[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"] objectAtIndex:i]  forKey:@"Notification_id"];
                        }//END if ([[NSUserDefaults standardUserDefaults] valueforKey:@"Notification_Count"]==NULL)
                        
                        else
                        {
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Notification_id"];
                            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@,%@",lstrnotificationid,[[[lstrresponse JSONValue] valueForKeyPath:@"unreadnotification"] objectAtIndex:i]] forKey:@"Notification_id"];
                        }//END Else Statement
                    }//END Else Statement
                }//END  for (int i=0; i<[[[lstrresponse JSONValue] value
            }
        }//END if (lstrresponse!=NULL)
    }//END if(returnData!=NULL)
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	 NSLog(@"didReceiveResponse");
    
    [self.responsedata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   
     NSLog(@"didReceiveData");
    
    [self.responsedata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
     NSLog(@"didFailWithError");
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
													message:@"Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

     NSLog(@"connectionDidFinishLoading");
    
    if ([lstrphoto isEqualToString:@"photo"])
    {
        UIImage *image = [[UIImage alloc] initWithData:self.responsedata];
        
        imgvw1.image=image;
        [self.window addSubview:vw_notification];
    }//END if ([lstrphoto isEqualToString:@"photo"])

    [connection release];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
     NSLog(@"applicationDidEnterBackground");
    
    // bgTask is instance variable
    NSAssert(self->bgTask == UIBackgroundTaskInvalid, nil);
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [application endBackgroundTask:self->bgTask];
            self->bgTask = UIBackgroundTaskInvalid;
        });
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _appIsInbackground=TRUE;
        
       // while ([application backgroundTimeRemaining] > 0.5) {   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseSocketRocket" object:self userInfo:nil];
        
    [self PostBackgroundStatus:1];
           /* NSString *friend = [self checkForIncomingChat];
            if (friend) {
                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                if (localNotif) {
                    localNotif.alertBody = [NSString stringWithFormat:
                                            NSLocalizedString(@"%@ has a message for you.", nil), friend];
                    localNotif.alertAction = NSLocalizedString(@"Read Message", nil);
                    localNotif.soundName = @"alarmsound.caf";
                    localNotif.applicationIconBadgeNumber = 1;
                    [application presentLocalNotificationNow:localNotif];
                    [localNotif release];
                    friend = nil;
                    break;
                }
            }
            */ 
    //}
        
        [application endBackgroundTask:self->bgTask];
        self->bgTask = UIBackgroundTaskInvalid;
    });
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    
    _appIsInbackground=FALSE;
    
    [self PostBackgroundStatus:0];
    
    //if([SoclivityUtilities hasNetworkConnection]){
        
        NSLog(@"hasNetworkConnection");
        
    [_objrra fetchPrivatePubConfiguration:[[NSUserDefaults standardUserDefaults] valueForKey:@"Channel"]];
   /* }//END if([SoclivityUtilities hasNetworkConnection])
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }//ENd Else Statement
    */
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    
    [[self facebook] extendAccessTokenIfNeeded];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
     NSLog(@"applicationWillTerminate");
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"handleOpenURL");
    
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"sourceApplication");
    
    return [self.facebook handleOpenURL:url];
}
@end
