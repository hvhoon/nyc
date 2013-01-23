//
//  WelcomeScreenViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RegistrationViewControler.h"
#import "LoginViewController.h"
#import "SoclivityManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "UpComingCompletedEventsViewController.h"
#import "SlidingDrawerViewController.h"
#import "EventShareActivity.h"
#import "SoclivityUtilities.h"
#import "ProfileViewController.h"

@interface WelcomeScreenViewController(Private) <MBProgressHUDDelegate>
@end
@implementation WelcomeScreenViewController

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

-(void)dealloc{
    [super dealloc];
    [playImageView release];
    [eatImageView release];
    [seeImageView release];
    [createImageView release];
    [learnImageView release];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    rootView=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:rootView];

    
    UIImageView *socLogoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    socLogoImageView.frame=CGRectMake(51, 80, 219, 58);
    
    playImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green_play.png"]];
    playImageView.frame=[[UIScreen mainScreen] bounds];
    UIImageView*playHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play.png"]];
    playHighlightImage.frame=CGRectMake(33, 150, 254, 14);
    [playImageView addSubview:playHighlightImage];
    
    [rootView addSubview:playImageView];
    [playHighlightImage release];
    
    eatImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orange_eat.png"]];
    eatImageView.frame=[[UIScreen mainScreen] bounds];
    UIImageView*eatHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"eat.png"]];
    eatHighlightImage.frame=CGRectMake(33, 150, 254, 14);
    [eatImageView addSubview:eatHighlightImage];
    
    [rootView addSubview:eatImageView];
    [eatHighlightImage release];
    
    seeImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"purple_see.png"]];
    seeImageView.frame=[[UIScreen mainScreen] bounds];
    UIImageView*seeHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"see.png"]];
    seeHighlightImage.frame=CGRectMake(33, 150, 254, 14);
    [seeImageView addSubview:seeHighlightImage];
    
    [rootView addSubview:seeImageView];
    [seeHighlightImage release];
    
    createImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_create.png"]];
    createImageView.frame=[[UIScreen mainScreen] bounds];
    UIImageView*createHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"create.png"]];
    createHighlightImage.frame=CGRectMake(33, 150, 254, 14);
    [createImageView addSubview:createHighlightImage];
    
    [rootView addSubview:createImageView];
    [createHighlightImage release];
    
    learnImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aqua_learn.png"]];
    learnImageView.frame=[[UIScreen mainScreen] bounds];
    UIImageView*learnHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"learn.png"]];
    learnHighlightImage.frame=CGRectMake(33, 150, 254, 14);
    [learnImageView addSubview:learnHighlightImage];
    [learnHighlightImage release];
    [rootView addSubview:learnImageView];
    
    
    eatImageView.hidden=YES;
    seeImageView.hidden=YES;
    createImageView.hidden=YES;
    learnImageView.hidden=YES;
    [self.view addSubview:socLogoImageView];
    [socLogoImageView release];
    UIImageView *socSignupImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sign-up.png"]];
    socSignupImageView.frame=CGRectMake(26, [UIScreen mainScreen].bounds.size.height-173, 265, 132);//287
    [self.view addSubview:socSignupImageView];
    [socSignupImageView release];
    
    
    UIButton *signInUsingFacebbokButton=[UIButton buttonWithType:UIButtonTypeCustom];
    signInUsingFacebbokButton.frame=CGRectMake(26,[UIScreen mainScreen].bounds.size.height-173,265,44.6);
    [signInUsingFacebbokButton addTarget:self action:@selector(SignInUsingFacebookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInUsingFacebbokButton];
    
    UIButton *signUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.frame=CGRectMake(26,[UIScreen mainScreen].bounds.size.height-173+44,265,44.6);//331
    [signUpButton addTarget:self action:@selector(SignUpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    UIButton *alreadySignedUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    alreadySignedUpButton.frame=CGRectMake(26,[UIScreen mainScreen].bounds.size.height-173+44+45.2,265,44.6);
    [alreadySignedUpButton addTarget:self action:@selector(AlreadySignedUpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alreadySignedUpButton];

    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(performTransition) userInfo:nil repeats:YES]; 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)performTransition
{
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.75;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	//NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	//NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	NSString *types[5] = {kCATransitionFade, kCATransitionFade,kCATransitionFade,kCATransitionFade,kCATransitionFade};
	NSString *subtypes[5] = {kCATransitionFromTop, kCATransitionFromTop,kCATransitionFromTop,kCATransitionFromTop,kCATransitionFromTop};
    
	
    //rnd=random() % 5;
    rnd =rnd%5;
    
	transition.type = types[rnd];
	if(rnd < 4) // if we didn't pick the fade transition, then we need to set a subtype too
	{
		transition.subtype = subtypes[random() % 5];
	}
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	//transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[rootView.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	
	//NSLog(@"print rnd=%d",rnd);
	switch (rnd) {
		case 0:
			backgroundState=0;
			playImageView.hidden = NO;
			eatImageView.hidden = YES;
            seeImageView.hidden=YES;
            createImageView.hidden=YES;
            learnImageView.hidden=YES;
			break;
		case 1:
			backgroundState=1;
			playImageView.hidden = YES;
			eatImageView.hidden = NO;
            seeImageView.hidden=YES;
            createImageView.hidden=YES;
            learnImageView.hidden=YES;
			break;
        case 2:
			backgroundState=2;
			playImageView.hidden = YES;
			eatImageView.hidden = YES;
            seeImageView.hidden=NO;
            createImageView.hidden=YES;
            learnImageView.hidden=YES;
			break;
		case 3:
			backgroundState=3;
			playImageView.hidden = YES;
			eatImageView.hidden = YES;
            seeImageView.hidden=YES;
            createImageView.hidden=NO;
            learnImageView.hidden=YES;
			break;
            
        case 4:
            backgroundState=4;
			playImageView.hidden = YES;
			eatImageView.hidden = YES;
            seeImageView.hidden=YES;
            createImageView.hidden=YES;
            learnImageView.hidden=NO;
			break;
            
            
		default:
			break;
	}
    rnd++;
	/*/ And so that we will continue to swap between our two images, we swap the instance variables referencing them.
	 UIImageView *tmp = view2;
	 view2 = view1;
	 view1 = tmp;*/
}

-(void)SignUpButtonClicked{
    
    NSLog(@"SignUpButtonClicked");
    RegistrationViewControler *registrationViewControler=[[RegistrationViewControler alloc] initWithNibName:@"RegistrationViewControler" bundle:nil];
    registrationViewControler.facebookTag=FALSE;
	[[self navigationController] pushViewController:registrationViewControler animated:YES];
    [registrationViewControler release];
    
}
-(void)SignInUsingFacebookButtonClicked{
    if([SoclivityUtilities hasNetworkConnection]){
        
    
    [self startFacebookSignup];
    NSLog(@"SignInUsingFacebookButtonClicked");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FacebookLogin *fbLogin=[appDelegate SetUpFacebook];
    fbLogin.FBdelegate=self;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Connect Your Device To Internet" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
    }


}
-(void)userCancelFBRequest{
    [HUD hide:YES];
}
-(void)pushToRegistration{
    
    
#if 1
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"ProfileViewController_iphone5";
    }
    else{
        nibNameBundle=@"ProfileViewController";
    }

    ProfileViewController *registrationViewControler=[[ProfileViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    registrationViewControler.isFirstTime=TRUE;
    [HUD hide:YES];
	[[self navigationController] pushViewController:registrationViewControler animated:YES];
    [registrationViewControler release];
#else
    //check for facebook user Already registered or else redirect to registraion page
    RegistrationViewControler *registrationViewControler=[[RegistrationViewControler alloc] initWithNibName:@"RegistrationViewControler" bundle:nil];
    registrationViewControler.facebookTag=TRUE;
    [HUD hide:YES];
	[[self navigationController] pushViewController:registrationViewControler animated:YES];
    [registrationViewControler release];
#endif
    
}

-(void)pushToHomeViewController{
    [HUD hide:YES];
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"SlideViewController";
    }
    else{
        nibNameBundle=@"SlideViewController_iphone5";
    }
    
    SlidingDrawerViewController *slideViewController = [[SlidingDrawerViewController alloc] initWithNibName:nibNameBundle bundle:nil];
    slideViewController.delegate = slideViewController;
    slideViewController.isFBlogged=TRUE;
    [self.navigationController pushViewController:slideViewController animated:YES];
    [slideViewController release];
    
}


#if 1
-(void)AlreadySignedUpButtonClicked{
     NSLog(@"AlreadySignedUpButtonClicked");
    LoginViewController *loginViewController=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.backgroundState=backgroundState;
	[[self navigationController] pushViewController:loginViewController animated:YES];
    [loginViewController release];

}
#else
-(void)AlreadySignedUpButtonClicked{
    NSLog(@"AlreadySignedUpButtonClicked");
    EventShareActivity *eventShare=[[EventShareActivity alloc]init];
    [eventShare sendEvent];
    //[eventShare deleteAnEvent:@"0311444F-3DCB-4019-8167-B701394C35BD:7A1655C3-CF17-45F6-BA4A-6DC6816AED00"];
}
#endif
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

#pragma mark -
#pragma mark Animation methods

-(void)startFacebookSignup {
    // Setup animation settings
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelFont = [UIFont fontWithName:@"Helvetica-Condensed" size:15.0];
    HUD.labelText = @"Facebook Sign-in";
    
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

@end
