//
//  NotificationsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationsViewController.h"
#import "SoclivityUtilities.h"
#import "NotificationClass.h"
#import <QuartzCore/QuartzCore.h>

@implementation NotificationsViewController
@synthesize delegate,responsedata,arrnotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)GetNotifications
{
    NSURL *url=[NSURL URLWithString:[[NSString stringWithFormat:@"http://%@/myactivities.json?logged_in_user_id=%@",ProductionServer,[[NSUserDefaults standardUserDefaults] valueForKey:@"logged_in_user_id"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.responsedata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responsedata appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
													message:@"Try Again Later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
	return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
    
    self.arrnotification=[[NSMutableArray alloc] init];
    self.arrnotification = [[[NSString alloc] initWithData:self.responsedata
                                                    encoding:NSUTF8StringEncoding] JSONValue];
    
    [self.responsedata release];

    if ([self.arrnotification count]==0) {
            
        self.view.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
        notificationImageView.hidden=NO;
        socFadedImageView.hidden=NO;
    }//END if ([[[self.arrnotification objectAtIndex:i] valueForKey:@
        
    else{
        notificationImageView.hidden=YES;
        socFadedImageView.hidden=YES;
            
        //NSMutableArray *notificationArray=[self SetUpDummyNotifications];
        CGRect waitingOnYouRect;
        if([SoclivityUtilities deviceType] & iPhone5)
            waitingOnYouRect=CGRectMake(0, 44, 320, 377+88);
            
        else
            waitingOnYouRect=CGRectMake(0, 44, 320, 377);
            
        WaitingOnYouView *notificationView=[[WaitingOnYouView alloc]initWithFrame:waitingOnYouRect andNotificationsListArray:self.arrnotification];
        notificationView.delegate=self;
        [self.view addSubview:notificationView];
            
    }//END Else Statement
    
    [self performSelector:@selector(hideMBProgress) withObject:nil afterDelay:1.0];
 }

-(void)startAnimation{
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = -40.0;
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    HUD.labelText = @"Loading...";
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
}

-(void)hideMBProgress{
    [HUD hide:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.responsedata=[[NSMutableData alloc] init];
    
    self.view.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
    notificationImageView.hidden=YES;
    socFadedImageView.hidden=YES;
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        [self startAnimation];
         [self GetNotifications];
    }//END if([SoclivityUtilities hasNetworkConnection])
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }//END Else Statement
    
    waitingOnYouLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    waitingOnYouLabel.textColor=[UIColor whiteColor];
    waitingOnYouLabel.backgroundColor=[UIColor clearColor];
    waitingOnYouLabel.shadowColor = [UIColor blackColor];
    waitingOnYouLabel.shadowOffset = CGSizeMake(0,-1);
}


/*-(NSMutableArray*) SetUpDummyNotifications{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Notifications" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *content = [NSMutableArray new];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        NotificationClass *play = [[NotificationClass alloc] init];
        play.notificationString = [playDictionary objectForKey:@"Notification"];
        NSNumber * n = [playDictionary objectForKey:@"type"];
        play.type= [n intValue];
        play.date = [playDictionary objectForKey:@"Date"];
        play.profileImage = [playDictionary objectForKey:@"ImageName"];
        play.count = [playDictionary objectForKey:@"Count"];
        
        NSLog(@"Value=%d",[n intValue]);
        
        /*switch (play.type) {
            case 0:
            {
            }
                break;
            case 1:
            {
                
            }
                break;
                
            case 2:
            {
                
            }
                break;
                
        }*/
/*[content addObject:play];
    }//END for (NSDictionary *playDictionary in playDictionariesArray)
    
    return content;
    
}*/

-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
