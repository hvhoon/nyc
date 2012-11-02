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
#import "GetUpcomingActivitiesInvocation.h"
@interface UpComingCompletedEventsViewController(Private) <DetailedActivityInfoInvocationDelegate,GetUpcomingActivitiesInvocationDelegate>
@end


@implementation UpComingCompletedEventsViewController
@synthesize delegate,activityListView,isNotSettings,myActivitiesArray,invitedToArray,compeletedArray,goingToArray;

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
    
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];


    activititesLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    activititesLabel.textColor=[UIColor whiteColor];
    activititesLabel.backgroundColor=[UIColor clearColor];
    activititesLabel.shadowColor = [UIColor blackColor];
    activititesLabel.shadowOffset = CGSizeMake(0,-1);
    
    
    
    
    organizedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    organizedButton.frame = CGRectMake(29.6, 50, 71, 27);
    [organizedButton setImage:[UIImage imageNamed:
                                @"S10_organizedHighlighted.png"] forState:UIControlStateNormal];
    [organizedButton setImage:[UIImage imageNamed:@"S10_organizedHighlighted.png"] forState:UIControlStateSelected];
    [organizedButton addTarget:self action:@selector(organizedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:organizedButton];

    
    invitedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    invitedButton.frame = CGRectMake(59.2+71, 58, 37, 12);
    [invitedButton setImage:[UIImage imageNamed:
                               @"S10_invited.png"] forState:UIControlStateNormal];
    [invitedButton setImage:[UIImage imageNamed:@"S10_invited.png"] forState:UIControlStateSelected];
    [invitedButton addTarget:self action:@selector(invitedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invitedButton];



    
    goingButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    goingButton.frame = CGRectMake(196.8, 56.5, 32, 15);
    [goingButton setImage:[UIImage imageNamed:
                             @"S10_going.png"] forState:UIControlStateNormal];
    [goingButton setImage:[UIImage imageNamed:@"S10_going.png"] forState:UIControlStateSelected];
    [goingButton addTarget:self action:@selector(goingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goingButton];
    
    
    completedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    completedButton.frame = CGRectMake(257.4, 56, 32, 15);
    [completedButton setImage:[UIImage imageNamed:
                           @"S10_completed.png"] forState:UIControlStateNormal];
    [completedButton setImage:[UIImage imageNamed:@"S10_completed.png"] forState:UIControlStateSelected];
    [completedButton addTarget:self action:@selector(completedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completedButton];



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

-(void)organizedButtonPressed:(id)sender{
    
    [activityListView populateEvents:myActivitiesArray];
    
    organizedButton.frame=CGRectMake(29.6, 50, 71, 27);
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organizedHighlighted.png"] forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organizedHighlighted.png"] forState:UIControlStateHighlighted];
    
    invitedButton.frame=CGRectMake(130.2, 58, 37, 12);
    
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invited.png"] forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invited.png"] forState:UIControlStateHighlighted];
    
    goingButton.frame=CGRectMake(196.8, 56, 32, 15);
    
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_going.png"] forState:UIControlStateNormal];
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_going.png"] forState:UIControlStateHighlighted];
    
    completedButton.frame=CGRectMake(258.4, 56, 32, 15);
    
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completed.png"] forState:UIControlStateNormal];
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completed.png"] forState:UIControlStateHighlighted];
    
}

-(void)invitedButtonPressed:(id)sender{
    
    [activityListView populateEvents:invitedToArray];
    
    organizedButton.frame=CGRectMake(26.2, 56, 57, 15);
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organized.png"] forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organized.png"] forState:UIControlStateHighlighted];
    
    invitedButton.frame=CGRectMake(109.4, 50, 68, 27);
    
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invitedHighlighted.png"] forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invitedHighlighted.png"] forState:UIControlStateHighlighted];
    
    goingButton.frame=CGRectMake(203.6, 56, 32, 15);
    
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_going.png"] forState:UIControlStateNormal];
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_going.png"] forState:UIControlStateHighlighted];
    
    completedButton.frame=CGRectMake(261.8, 56, 32, 15);
    
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completed.png"] forState:UIControlStateNormal];
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completed.png"] forState:UIControlStateHighlighted];
    
}


-(void)goingButtonPressed:(id)sender{
    
    
    [activityListView populateEvents:goingToArray];
    
    organizedButton.frame=CGRectMake(27.2, 56, 57, 15);
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organized.png"] forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organized.png"] forState:UIControlStateHighlighted];
    
    invitedButton.frame=CGRectMake(111.4, 58, 37, 12);
    
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invited.png"] forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invited.png"] forState:UIControlStateHighlighted];
    
    goingButton.frame=CGRectMake(175.6, 50, 58, 27);
    
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_goingHighlighted.png"] forState:UIControlStateNormal];
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_goingHighlighted.png"] forState:UIControlStateHighlighted];
    
    completedButton.frame=CGRectMake(260.8, 56, 32, 15);
    
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completed.png"] forState:UIControlStateNormal];
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completed.png"] forState:UIControlStateHighlighted];

}

-(void)completedButtonPressed:(id)sender{
    
    [activityListView populateEvents:compeletedArray];
    
    organizedButton.frame=CGRectMake(23.8, 56, 57, 15);
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organized.png"] forState:UIControlStateNormal];
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_organized.png"] forState:UIControlStateHighlighted];
    
    invitedButton.frame=CGRectMake(104.6, 58, 37, 12);
    
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invited.png"] forState:UIControlStateNormal];
    [invitedButton setBackgroundImage:[UIImage imageNamed:@"S10_invited.png"] forState:UIControlStateHighlighted];
    
    goingButton.frame=CGRectMake(165.4, 56, 32, 15);
    
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_going.png"] forState:UIControlStateNormal];
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_going.png"] forState:UIControlStateHighlighted];
    
    completedButton.frame=CGRectMake(221.2, 56, 75, 27);
    
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completedHighlighted.png"] forState:UIControlStateNormal];
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_completedHighlighted.png"] forState:UIControlStateHighlighted];
    
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
    
    [devServer getUpcomingActivitiesForUserInvocation:[SOC.loggedInUser.idSoc intValue] player2:[SOC.loggedInUser.idSoc intValue] delegate:self];
    
    
    

}

-(void)UpcomingActivitiesInvocationDidFinish:(GetUpcomingActivitiesInvocation*)invocation
                                withResponse:(NSArray*)responses
                                   withError:(NSError*)error{
    
    if([responses count]>0){
        
        for(int i=0;i<[responses count];i++){
        NSNumber *activityType=[[responses objectAtIndex:i] objectForKey:@"activityType"];
        switch ([activityType intValue]) {
            case 1:
            {
                NSLog(@"The user has got Organizing Activities");
                myActivitiesArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];
                [activityListView populateEvents:myActivitiesArray];

            }
                break;
                
            case 2:
            {
                NSLog(@"The user has got invitedToArray Activities");
                invitedToArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];
                
            }
                break;
            case 3:
            {
                NSLog(@"The user has got compeletedArray Activities");
                compeletedArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];
                
            }
                break;
            case 4:
            {
                NSLog(@"The user has got goingToArray Activities");
                goingToArray=[[responses objectAtIndex:i] objectForKey:@"Elements"];
                
            }
                break;
        }
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;

    }
}


-(void)PushToDetailActivityView:(InfoActivityClass*)detailedInfo andFlipType:(NSInteger)andFlipType{
    NSLog(@"PushToDetailActivityView");
    

    
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
