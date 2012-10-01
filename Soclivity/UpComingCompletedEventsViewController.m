//
//  UpComingCompletedEventsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpComingCompletedEventsViewController.h"
#import "SoclivityUtilities.h"
#import "SoclivityManager.h"
#import "MainServiceManager.h"
#import "GetPlayersClass.h"
#import "ActivityEventViewController.h"
#import "DetailedActivityInfoInvocation.h"
#import "SocPlayerClass.h"
#import "SOCProfileViewController.h"
@interface UpComingCompletedEventsViewController(Private) <DetailedActivityInfoInvocationDelegate>
@end


@implementation UpComingCompletedEventsViewController
@synthesize delegate,activityListView,isNotSettings;

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
    activititesLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    activititesLabel.textColor=[UIColor whiteColor];
    activititesLabel.backgroundColor=[UIColor clearColor];
    activititesLabel.shadowColor = [UIColor blackColor];
    activititesLabel.shadowOffset = CGSizeMake(0,-1);
    
    organizedButton.titleLabel.textAlignment=UITextAlignmentCenter;
    organizedButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    organizedButton.titleLabel.textColor=[UIColor blackColor];
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateHighlighted];
    [organizedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [organizedButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];


    
    goingButton.titleLabel.textAlignment=UITextAlignmentCenter;
    goingButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    goingButton.titleLabel.textColor=[UIColor blackColor];
    [goingButton setBackgroundImage:nil forState:UIControlStateNormal];
    [goingButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [goingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goingButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    completedButton.titleLabel.textAlignment=UITextAlignmentCenter;
    completedButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    completedButton.titleLabel.textColor=[UIColor blackColor];
    [completedButton setBackgroundImage:nil forState:UIControlStateNormal];
    [completedButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [completedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [completedButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    activityListView.delegate=self;
    [activityListView LoadTable];
    activityListView.isOrganizerList=TRUE;
    
    [self performSelector:@selector(RefreshFromTheListView) withObject:nil afterDelay:1.0];
    
    
    if(isNotSettings){
        profileButton.hidden=YES;
        backActivityButton.hidden=NO;
    }

        // Do any additional setup after loading the view from its nib.
}


-(IBAction)organizedButtonPressed:(id)sender{
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateHighlighted];

    
    [completedButton setBackgroundImage:nil forState:UIControlStateNormal];
    [completedButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [goingButton setBackgroundImage:nil forState:UIControlStateNormal];
    [goingButton setBackgroundImage:nil forState:UIControlStateHighlighted];


}

-(IBAction)goingButtonPressed:(id)sender{
    [organizedButton setBackgroundImage:nil forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateHighlighted];
    
    [completedButton setBackgroundImage:nil forState:UIControlStateNormal];
    [completedButton setBackgroundImage:nil forState:UIControlStateHighlighted];    
    
    
}

-(IBAction)completedButtonPressed:(id)sender{
    
    [organizedButton setBackgroundImage:nil forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:nil forState:UIControlStateHighlighted];    
    [goingButton setBackgroundImage:nil forState:UIControlStateNormal];
    [goingButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateHighlighted];
    
    
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)profileSliderPressed:(id)sender{
    [delegate showLeft:sender];
}

-(void)PushToProfileView:(InfoActivityClass*)detailedInfo{
    
    if([SOC.loggedInUser.idSoc intValue]==detailedInfo.organizerId){
        NSString*nibNameBundle=nil;
        
        if([SoclivityUtilities deviceType] & iPhone5){
            nibNameBundle=@"UpComingCompletedEventsViewController_iphone5";
        }
        else{
            nibNameBundle=@"UpComingCompletedEventsViewController";
        }
        
        UpComingCompletedEventsViewController *upComingCompletedEventsViewController=[[UpComingCompletedEventsViewController alloc] initWithNibName:nibNameBundle bundle:nil];
        
        [[self navigationController] pushViewController:upComingCompletedEventsViewController animated:YES];
        [upComingCompletedEventsViewController release];
        
    }
    else{
        SocPlayerClass *myClass=[[SocPlayerClass alloc]init];
        myClass.playerName=detailedInfo.organizerName;
        myClass.DOS=detailedInfo.DOS;
        myClass.activityId=detailedInfo.activityId;
        myClass.latestActivityName=detailedInfo.activityName;
        myClass.activityType=detailedInfo.type;
        myClass.profilePhotoUrl=detailedInfo.ownerProfilePhotoUrl;
        myClass.distance=[detailedInfo.distance floatValue];
        SOCProfileViewController*socProfileViewController=[[SOCProfileViewController alloc] initWithNibName:@"SOCProfileViewController" bundle:nil];
        socProfileViewController.playerObject=myClass;
        [[self navigationController] pushViewController:socProfileViewController animated:YES];
        [socProfileViewController release];
    }
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



-(void)RefreshFromTheListView{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSString  *currentTime=[dateFormatter stringFromDate:[NSDate date]];
    
    [[NSUserDefaults standardUserDefaults] setValue:currentTime forKey:@"SOCActivityTimeUpdate"];
    
    activityListView.sortType=3;
    [activityListView startPopulatingListView];
    

}
-(void)PushToDetailActivityView:(InfoActivityClass*)detailedInfo andFlipType:(NSInteger)andFlipType{
    NSLog(@"PushToDetailActivityView");
    
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];

    
    if(![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    
    if([SoclivityUtilities hasNetworkConnection]){
        
        //[self loadingActivityMonitor];
        [devServer getDetailedActivityInfoInvocation:[SOC.loggedInUser.idSoc intValue]    actId:detailedInfo.activityId  latitude:SOC.currentLocation.coordinate.latitude longitude:SOC.currentLocation.coordinate.longitude delegate:self];
    }
    else{
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
}
#pragma mark -
#pragma mark DetailedActivityInfoInvocationDelegate Method

-(void)DetailedActivityInfoInvocationDidFinish:(DetailedActivityInfoInvocation*)invocation
                                  withResponse:(InfoActivityClass*)responses
                                     withError:(NSError*)error{

    
    
    NSString*nibNameBundle=nil;
    
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"ActivityEventViewController_iphone5";
    }
    else{
        nibNameBundle=@"ActivityEventViewController";
    }

        ActivityEventViewController *activityEventViewController=[[ActivityEventViewController alloc] initWithNibName:nibNameBundle bundle:nil];

        activityEventViewController.activityInfo=responses;
        [[self navigationController] pushViewController:activityEventViewController animated:YES];
        [activityEventViewController release];

        if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

        [activityListView BytesDownloadedTimeToHideTheSpinner];
                
                
}

@end
