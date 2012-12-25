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
@implementation NotificationsViewController
@synthesize delegate;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    waitingOnYouLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    waitingOnYouLabel.textColor=[UIColor whiteColor];
    waitingOnYouLabel.backgroundColor=[UIColor clearColor];
    waitingOnYouLabel.shadowColor = [UIColor blackColor];
    waitingOnYouLabel.shadowOffset = CGSizeMake(0,-1);

#if 0
    self.view.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
    notificationImageView.hidden=NO;
    socFadedImageView.hidden=NO;

    
#else
    notificationImageView.hidden=YES;
    socFadedImageView.hidden=YES;
    NSMutableArray *notificationArray=[self SetUpDummyNotifications];
    CGRect waitingOnYouRect;
    if([SoclivityUtilities deviceType] & iPhone5)
        waitingOnYouRect=CGRectMake(0, 44, 320, 377+88);
    
    else
        waitingOnYouRect=CGRectMake(0, 44, 320, 377);
    WaitingOnYouView *notificationView=[[WaitingOnYouView alloc]initWithFrame:waitingOnYouRect andNotificationsListArray:notificationArray];
    notificationView.delegate=self;
    [self.view addSubview:notificationView];
#endif

    // for No Notifications
    // Do any additional setup after loading the view from its nib.
}


-(NSMutableArray*) SetUpDummyNotifications{
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
        [content addObject:play];
        
    }
    
    return content;
    
}
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
