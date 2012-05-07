//
//  AppDelegate.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeScreenViewController.h"
#import "SocFacebookLogin.h"
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

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
     [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    WelcomeScreenViewController *welcomeScreenViewController=[[WelcomeScreenViewController alloc]initWithNibName:@"WelcomeScreenViewController" bundle:nil];
    navigationController=[[UINavigationController alloc]initWithRootViewController:welcomeScreenViewController];
    
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
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
