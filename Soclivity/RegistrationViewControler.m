//
//  RegistrationViewControler.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrationViewControler.h"
#import "MainServiceManager.h"
#import "GetPlayersDetailInvocation.h"
#import "HomeViewController.h"
#import "DDMenuController.h"
#import "SettingsViewController.h"
#import "UpComingEventsViewController.h"
#import "AppDelegate.h"
#import "GetPlayersClass.h"

#define kDatePicker 123
#define kRegisterSucces 2
@interface RegistrationViewControler (private)<GetPlayersDetailDelegate,RegistrationDetailDelegate>
@end


@implementation RegistrationViewControler
@synthesize basicSectionFirst,activitySectionSecond,scrollView,facebookTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)BackButtonClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    devServer=[[MainServiceManager alloc]init];
    SOC=[SoclivityManager SharedInstance];
    //SOC.basicInfoDone=FALSE;

    pageControlBeingUsed = NO;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]; 
    
    scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    scrollView.clipsToBounds = NO;
    
    // Initially disabled scrolling. This is not enabled till all the fields on the basic info page have been filled.
    scrollView.scrollEnabled = NO;
    
    // Enable or Disable scrolling
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableScrolling) name:kStartScrolling object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableScrolling) name:kStopScrolling object:nil];
    
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.alwaysBounceVertical= YES;
    scrollView.delegate = self;
    scrollView.bounces=NO;
    [self.view addSubview:scrollView];
    basicSectionFirst.delegate=self;
    basicSectionFirst.facebookTag=facebookTag;
    basicSectionFirst.playerObj=SOC.registrationObject;
    activitySectionSecond.delegate=self;
    activitySectionSecond.playerObj=SOC.registrationObject;
    activitySectionSecond.facebookTag=facebookTag;
    for (int i = 0; i < 2; i++) {
		CGRect frame;
		frame.origin.x = 0;
		frame.origin.y = self.scrollView.frame.size.height* i;
		frame.size = self.scrollView.frame.size;
		
        switch (i) {
            case 0:
            {
                basicSectionFirst.frame=CGRectMake(0, 0, 320, 414);
                [self.scrollView addSubview:basicSectionFirst];
                UIImageView *activeType=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S02_blackbar.png"]];
                activeType.frame=CGRectMake(0, 414, 320, 46);
                
                UIImageView *letsSelectActiveType=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S02_pickactivity.png"]];
                letsSelectActiveType.frame=CGRectMake(68, 14, 184, 18);
                letsSelectActiveType.tag=237;
                UIButton *crossPickerButton=[UIButton buttonWithType:UIButtonTypeCustom];
                crossPickerButton.frame=CGRectMake(6,428,19,18);
                [crossPickerButton setBackgroundImage:[UIImage imageNamed:@"S02_cross_emb.png"] forState:UIControlStateNormal];
                [crossPickerButton addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
                crossPickerButton.tag=234;
                [crossPickerButton setHidden:YES];
                
                
                UIButton *tickPickerButton=[UIButton buttonWithType:UIButtonTypeCustom];
                tickPickerButton.frame=CGRectMake(286,428,19,18);
                [tickPickerButton setBackgroundImage:[UIImage imageNamed:@"S02_tick_emb.png"] forState:UIControlStateNormal];
                [tickPickerButton addTarget:self action:@selector(doneSelectDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
                tickPickerButton.tag=235;
                [tickPickerButton setHidden:YES];
                
                
                
                UIButton *scrollUpDownButton=[UIButton buttonWithType:UIButtonTypeCustom];
                scrollUpDownButton.frame=CGRectMake(276,422,29,30);
                [scrollUpDownButton setBackgroundImage:[UIImage imageNamed:@"S02_downarrow.png"] forState:UIControlStateNormal];
                [scrollUpDownButton addTarget:self action:@selector(timeToScrollDown) forControlEvents:UIControlEventTouchUpInside];
                scrollUpDownButton.tag=236;
                
                [activeType addSubview:letsSelectActiveType];
                [self.scrollView addSubview:activeType];
                [self.scrollView addSubview:crossPickerButton];
                [self.scrollView addSubview:tickPickerButton];
                [self.scrollView addSubview:scrollUpDownButton];
                [letsSelectActiveType release];
                [activeType release];

                
            }
                break;
            case 1:
            {
                
                activitySectionSecond.frame=CGRectMake(0, 460, 320, 460);
                [self.scrollView addSubview:activitySectionSecond];
            }
                break;

                
            default:
                break;
        }		
        
		
	}

    
    birthDayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,480, 320, 216)];
    birthDayPicker.datePickerMode = UIDatePickerModeDate;
    birthDayPicker.tag=kDatePicker;
    [self.scrollView addSubview:birthDayPicker];
    [birthDayPicker setHidden:YES];
    
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,874);

    
    

    // Do any additional setup after loading the view from its nib.
}

-(void)doneSelectDatePickerView:(id)sender{
    [basicSectionFirst dateSelected:[birthDayPicker date]];
}

-(void)DateisFineNoNeedToWorry{
    UIButton *crossBtn = (UIButton *)[self.scrollView viewWithTag:234];
    [crossBtn setHidden:YES];
    
    UIButton *tickBtn = (UIButton *)[self.scrollView viewWithTag:235];
    [tickBtn setHidden:YES];
    
    UIButton *downArrow = (UIButton *)[self.scrollView viewWithTag:236];
    [downArrow setHidden:NO];
    
    UIImageView *selectActivityType = (UIImageView *)[self.scrollView viewWithTag:237];
    [selectActivityType setHidden:NO];
    
    self.scrollView.scrollEnabled = YES;
}
-(void)hidePickerView:(id)sender{
    [basicSectionFirst hideBirthdayPicker];
    
    if (footerActivated) {
        CGRect dateTopFrame = birthDayPicker.frame;
        dateTopFrame.origin.y = +dateTopFrame.size.height;
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        birthDayPicker.frame=CGRectMake(0, 480, 320, 260);
        [UIView commitAnimations];
        footerActivated=NO;
    }
    UIButton *crossBtn = (UIButton *)[self.scrollView viewWithTag:234];
    [crossBtn setHidden:YES];
    
    UIButton *tickBtn = (UIButton *)[self.scrollView viewWithTag:235];
    [tickBtn setHidden:YES];
    
    UIButton *downArrow = (UIButton *)[self.scrollView viewWithTag:236];
    [downArrow setHidden:NO];
    
    UIImageView *selectActivityType = (UIImageView *)[self.scrollView viewWithTag:237];
    [selectActivityType setHidden:NO];
    
    self.scrollView.scrollEnabled = YES;
}
-(void)setPickerSettings{
    UIButton *crossBtn = (UIButton *)[self.scrollView viewWithTag:234];
    [crossBtn setHidden:NO];
    UIButton *tickBtn = (UIButton *)[self.scrollView viewWithTag:235];
    [tickBtn setHidden:NO];

    UIButton *downArrow = (UIButton *)[self.scrollView viewWithTag:236];
    [downArrow setHidden:YES];
    
    UIImageView *selectActivityType = (UIImageView *)[self.scrollView viewWithTag:237];
    [selectActivityType setHidden:YES];
    
    birthDayPicker.hidden=NO;
    
    if (!footerActivated) {
        
        CGRect dateTopFrame = birthDayPicker.frame;
        dateTopFrame.origin.y = -dateTopFrame.size.height;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        birthDayPicker.frame=CGRectMake(0, 199, 320, 260);
        [UIView commitAnimations];
        footerActivated = YES;
    }
    self.scrollView.scrollEnabled = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    //NSLog(@"scrollViewDidScroll");
    
    [birthDayPicker setHidden:YES];

    if (!pageControlBeingUsed) {
		
        // Switch the indicator when more than 50% of the previous/next view is visible
		CGFloat pageWidth = self.scrollView.frame.size.height;
		page = floor((self.scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        //NSLog(@"page=%d",page);

        if(!SOC.basicInfoDone)
        {
            switch (page) {
                case 0:
                    break;
                case 1:
                    pageControlBeingUsed=TRUE;
                    [self timeToScrollDown];
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
    [basicSectionFirst BasicInfoFields];
    //NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	//pageControlBeingUsed = NO;
    //NSLog(@"scrollViewDidEndDecelerating");
}


-(void)presentModal:(UIImagePickerController*)picker{
    [self presentModalViewController:picker animated:YES];
    
}

-(void)dismissPickerModalController{
    
    [self dismissModalViewControllerAnimated:YES];
    
}

// Disable scrolling
-(void) disableScrolling {
    [self.scrollView setScrollEnabled:NO];
    
}

// Enable scrolling
-(void) enableScrolling {
    [self.scrollView setScrollEnabled:YES];
}

-(void)timeToScrollDown{
    
    NSLog(@"timeToScrollDown");
    [birthDayPicker setHidden:YES];

    [basicSectionFirst BasicInfoFields];
    if(SOC.basicInfoDone){
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = self.scrollView.frame.size.height;
    frame.size = self.scrollView.frame.size;
    
    switch (page) {
        case 0:
        {
            frame.origin.y = 460;
        }
            break;
            
        case 1:
        {
            frame.origin.y = 0;

        }
            break;
    }
   
	[self.scrollView scrollRectToVisible:frame animated:YES];
    }
    //pageControlBeingUsed = YES;

}

-(void)pushHomeMapViewController{
    
    [self RegisterUserForTheFirstTime];
    
}

-(void)RegisterUserForTheFirstTime{
    
    
    if(facebookTag){
     //implememt different registration procedure for facebook.
        [activitySectionSecond startAnimation];
        [devServer registrationDetailInvocation:self isFBuser:YES];
        
    }
    else{
        [activitySectionSecond startAnimation];
       [devServer registrationDetailInvocation:self isFBuser:NO];
    }
    // Start the animation
    
    
    //[devServer GetPlayersInvocation:self];
}

-(void)GetPlayersDetailInvocationDidFinish:(GetPlayersDetailInvocation*)invocation 
                                withResult:(NSArray*)result
                                 withError:(NSError*)error{
    NSLog(@"GetPlayersDetailInvocationDidFinish");
    
}

-(void)RegistrationDetailInvocationDidFinish:(RegistrationDetailInvocation*)invocation 
                                  withResult:(NSArray*)result
                                   withError:(NSError*)error{
    // Stop the animation
    [activitySectionSecond stopAnimation];
    
    NSLog(@"RegistrationDetailInvocationDidFinish called");
    GetPlayersClass *obj=[result objectAtIndex:0];
    NSLog(@"SOC ID=%d",[obj.idSoc intValue]);
    
    if([obj.idSoc intValue]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                    message:@"Sorry we couldn't register you."
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    
        [alert show];
        [alert release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Successful"
                                                        message:@"Welcome to Soclivity!"
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    
        alert.tag=kRegisterSucces;
        [alert show];
        [alert release];

    }
    return;
    
}


#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[alertView resignFirstResponder];
    
        if (buttonIndex == 0) {
            
            switch (alertView.tag) {
                case kRegisterSucces:
                {
                    HomeViewController *homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                    
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                    
                    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
                    
                    
                    SettingsViewController *leftController = [[SettingsViewController alloc] init];
                    rootController.leftViewController = leftController;
                    
                    UpComingEventsViewController *rightController = [[UpComingEventsViewController alloc] init];
                    rootController.rightViewController = rightController;
                    
                    
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    appDelegate.menuController=rootController;
                    [self.navigationController pushViewController:rootController animated:YES];

                    //[leftController release];
                    //[rightController release];
                    //[rootController release];
                    //[navController release];
                    
                }
                    break;
                default:
                    break;
            }
        }
        else
            NSLog(@"Clicked Cancel Button");
    
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
