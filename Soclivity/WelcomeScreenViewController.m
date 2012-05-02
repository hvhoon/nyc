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
#import "SoclivityLoginViewController.h"
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:rootView];
    
    UIImageView *socLogoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo@1x.png"]];
    socLogoImageView.frame=CGRectMake(46.5, 80, 227, 64);
    
    
    
    playImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green_play@1x.png"]];
    playImageView.frame=CGRectMake(0, 0, 320, 460);
    UIImageView*playHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play@1x.png"]];
    playHighlightImage.frame=CGRectMake(27.5, 150, 265, 15);
    [playImageView addSubview:playHighlightImage];
    
    [rootView addSubview:playImageView];
    
    
    
    eatImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"orange_eat@1x.png"]];
    eatImageView.frame=CGRectMake(0, 0, 320, 460);
    UIImageView*eatHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"eat@1x.png"]];
    eatHighlightImage.frame=CGRectMake(27.5, 150, 265, 15);
    [eatImageView addSubview:eatHighlightImage];
    
    [rootView addSubview:eatImageView];
    
    seeImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"purple_see@1x.png"]];
    seeImageView.frame=CGRectMake(0, 0, 320, 460);
    UIImageView*seeHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"see.png"]];
    seeHighlightImage.frame=CGRectMake(27.5, 150, 265, 15);
    [seeImageView addSubview:seeHighlightImage];
    
    [rootView addSubview:seeImageView];
    
    createImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_create@1x.png"]];
    createImageView.frame=CGRectMake(0, 0, 320, 460);
    UIImageView*createHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"create@1x.png"]];
    createHighlightImage.frame=CGRectMake(27.5, 150, 265, 15);
    [createImageView addSubview:createHighlightImage];
    
    [rootView addSubview:createImageView];
    
    learnImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aqua_learn@1x.png"]];
    learnImageView.frame=CGRectMake(0, 0, 320, 460);
    UIImageView*learnHighlightImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"learn@1x.png"]];
    learnHighlightImage.frame=CGRectMake(27.5, 150, 265, 15);
    [learnImageView addSubview:learnHighlightImage];
    
    [rootView addSubview:learnImageView];
    
    
    eatImageView.hidden=YES;
    seeImageView.hidden=YES;
    createImageView.hidden=YES;
    learnImageView.hidden=YES;
    [self.view addSubview:socLogoImageView];
    UIImageView *socSignupImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sign-up@1x.png"]];
    socSignupImageView.frame=CGRectMake(26, 287, 268, 134);
    [self.view addSubview:socSignupImageView];
    
    
    UIButton *signUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.frame=CGRectMake(26,287,268,44.6);
    [signUpButton addTarget:self action:@selector(SignUpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    UIButton *signInUsingFacebbokButton=[UIButton buttonWithType:UIButtonTypeCustom];
    signInUsingFacebbokButton.frame=CGRectMake(26,331.6,268,44.6);
    [signInUsingFacebbokButton addTarget:self action:@selector(SignInUsingFacebookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInUsingFacebbokButton];
    
    UIButton *alreadySignedUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    alreadySignedUpButton.frame=CGRectMake(26,376.2,268,44.6);
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
    
	int rnd = random() % 5;
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
		case 1:
			
			playImageView.hidden = NO;
			eatImageView.hidden = YES;
            seeImageView.hidden=YES;
            createImageView.hidden=YES;
            learnImageView.hidden=YES;
			break;
		case 2:
			
			playImageView.hidden = YES;
			eatImageView.hidden = NO;
            seeImageView.hidden=YES;
            createImageView.hidden=YES;
            learnImageView.hidden=YES;
			break;
        case 3:
			
			playImageView.hidden = YES;
			eatImageView.hidden = YES;
            seeImageView.hidden=NO;
            createImageView.hidden=YES;
            learnImageView.hidden=YES;
			break;
		case 4:
			
			playImageView.hidden = YES;
			eatImageView.hidden = YES;
            seeImageView.hidden=YES;
            createImageView.hidden=NO;
            learnImageView.hidden=YES;
			break;
            
        case 0:
			playImageView.hidden = YES;
			eatImageView.hidden = YES;
            seeImageView.hidden=YES;
            createImageView.hidden=YES;
            learnImageView.hidden=NO;
			break;
            
            
		default:
			break;
	}
	/*/ And so that we will continue to swap between our two images, we swap the instance variables referencing them.
	 UIImageView *tmp = view2;
	 view2 = view1;
	 view1 = tmp;*/
}

-(void)SignUpButtonClicked{
#if 1    
    NSLog(@"SignUpButtonClicked");
    RegistrationViewControler *registrationViewControler=[[RegistrationViewControler alloc] initWithNibName:@"RegistrationViewControler" bundle:nil];
    
	[[self navigationController] pushViewController:registrationViewControler animated:YES];
    
#endif
}
-(void)SignInUsingFacebookButtonClicked{
    NSLog(@"SignInUsingFacebookButtonClicked");
}
-(void)AlreadySignedUpButtonClicked{
     NSLog(@"AlreadySignedUpButtonClicked");
    SoclivityLoginViewController *soclivityLoginViewController=[[SoclivityLoginViewController alloc] initWithNibName:@"SoclivityLoginViewController" bundle:nil];
    
	[[self navigationController] pushViewController:soclivityLoginViewController animated:YES];

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
