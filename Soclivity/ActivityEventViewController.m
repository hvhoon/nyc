//
//  ActivityEventViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityEventViewController.h"
#import "SoclivityUtilities.h"
#import "InfoActivityClass.h"
@implementation ActivityEventViewController
@synthesize activityInfo,scrollView;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear in slide View Controller Called");
    
    [self.navigationController.navigationBar setHidden:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)]; 
    
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
    
    eventView.delegate=self;

    
    for (int i = 0; i < 2; i++) {
		CGRect frame;
		frame.origin.x = 0;
		frame.origin.y = self.scrollView.frame.size.height* i;
		frame.size = self.scrollView.frame.size;
		
        switch (i) {
            case 0:
            {
                eventView.frame=CGRectMake(0, 0, 320, 329);
                [self.scrollView addSubview:eventView];
                UIImageView *participantBarImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_participantBar.png"]];
                participantBarImgView.frame=CGRectMake(0, 329, 320, 47);
                [self.scrollView addSubview:participantBarImgView];

                
                UIButton *pArrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
                pArrowButton.frame=CGRectMake(16,343,10,18);
                [pArrowButton setBackgroundImage:[UIImage imageNamed:@"S05_participantArrow.png"] forState:UIControlStateNormal];
                [pArrowButton addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
                pArrowButton.tag=234;
                [self.scrollView addSubview:pArrowButton];
                
                CGRect goingCountLabelRect=CGRectMake(36,346,55,12);
                UILabel *goingCountLabel=[[UILabel alloc] initWithFrame:goingCountLabelRect];
                goingCountLabel.textAlignment=UITextAlignmentLeft;
                goingCountLabel.text=[NSString stringWithFormat:@"%@",activityInfo.goingCount];
                goingCountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingCountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingCountLabel.textAlignment = UITextAlignmentCenter;
                goingCountLabel.tag=235;
                goingCountLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:goingCountLabel];
                [goingCountLabel release];
                
                
                CGRect goingLabelTextRect=CGRectMake(36,365,55,12);
                UILabel *goingTextLabel=[[UILabel alloc] initWithFrame:goingLabelTextRect];
                goingTextLabel.textAlignment=UITextAlignmentLeft;
                goingTextLabel.text=[NSString stringWithFormat:@"GOING"];
                goingTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingTextLabel.textAlignment = UITextAlignmentCenter;
                goingTextLabel.tag=235;
                goingTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:goingTextLabel];
                [goingTextLabel release];
                
                
                CGRect DOS_1LabelRect=CGRectMake(101,346,55,12);
                UILabel *DOS_1countLabel=[[UILabel alloc] initWithFrame:DOS_1LabelRect];
                DOS_1countLabel.textAlignment=UITextAlignmentLeft;
                DOS_1countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS1];
                DOS_1countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Medium" size:12];
                DOS_1countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_1countLabel.textAlignment = UITextAlignmentCenter;
                DOS_1countLabel.tag=236;
                DOS_1countLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:DOS_1countLabel];
                [DOS_1countLabel release];
                
                
                UIImageView *DOS_1ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_smallDOS1.png"]];
                DOS_1ImageView.frame=CGRectMake(160, 365, 19, 11);
                DOS_1ImageView.tag=236;
                [self.scrollView addSubview:DOS_1ImageView];
                [DOS_1ImageView release];
 
                
                
                CGRect friendsLabelTextRect=CGRectMake(101,365,55,12);
                UILabel *friendsTextLabel=[[UILabel alloc] initWithFrame:friendsLabelTextRect];
                friendsTextLabel.textAlignment=UITextAlignmentLeft;
                friendsTextLabel.text=[NSString stringWithFormat:@"FRIENDS"];
                friendsTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Medium" size:12];
                friendsTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                friendsTextLabel.textAlignment = UITextAlignmentCenter;
                friendsTextLabel.tag=236;
                friendsTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:friendsTextLabel];
                [friendsTextLabel release];
                
                
                
                
                CGRect DOS_2LabelRect=CGRectMake(181,346,55,12);
                UILabel *DOS_2countLabel=[[UILabel alloc] initWithFrame:DOS_2LabelRect];
                DOS_2countLabel.textAlignment=UITextAlignmentLeft;
                DOS_2countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS2];
                DOS_2countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Medium" size:12];
                DOS_2countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_2countLabel.textAlignment = UITextAlignmentCenter;
                DOS_2countLabel.tag=237;
                DOS_2countLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:DOS_2countLabel];
                [DOS_2countLabel release];
                
                
                UIImageView *DOS_2ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_smallDOS1.png"]];
                DOS_2ImageView.frame=CGRectMake(210, 365, 19, 11);
                DOS_2ImageView.tag=237;
                [self.scrollView addSubview:DOS_2ImageView];
                [DOS_2ImageView release];
                
                
                
                CGRect mayknowLabelTextRect=CGRectMake(181,365,55,12);
                UILabel *mayknowTextLabel=[[UILabel alloc] initWithFrame:mayknowLabelTextRect];
                mayknowTextLabel.textAlignment=UITextAlignmentLeft;
                mayknowTextLabel.text=[NSString stringWithFormat:@"MAY KNOW"];
                mayknowTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Medium" size:12];
                mayknowTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                mayknowTextLabel.textAlignment = UITextAlignmentCenter;
                mayknowTextLabel.tag=236;
                mayknowTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:mayknowTextLabel];
                [mayknowTextLabel release];
                
                
                
                CGRect DOS_3LabelRect=CGRectMake(256,346,55,12);
                UILabel *DOS_3countLabel=[[UILabel alloc] initWithFrame:DOS_3LabelRect];
                DOS_3countLabel.textAlignment=UITextAlignmentLeft;
                DOS_3countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS3];
                DOS_3countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Medium" size:12];
                DOS_3countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_3countLabel.textAlignment = UITextAlignmentCenter;
                DOS_3countLabel.tag=237;
                DOS_3countLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:DOS_3countLabel];
                [DOS_3countLabel release];
                
                
                
                
                
                CGRect othersLabelTextRect=CGRectMake(256,365,55,12);
                UILabel *othersTextLabel=[[UILabel alloc] initWithFrame:othersLabelTextRect];
                othersTextLabel.textAlignment=UITextAlignmentLeft;
                othersTextLabel.text=[NSString stringWithFormat:@"OTHERS"];
                othersTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Medium" size:12];
                othersTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                othersTextLabel.textAlignment = UITextAlignmentCenter;
                othersTextLabel.tag=236;
                othersTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:othersTextLabel];
                [othersTextLabel release];



                
                
                
            }
                break;
            case 1:
            {
                UIView*participanttableView=[[UIView alloc]initWithFrame:CGRectMake(0, 376, 320, 320)];
                participanttableView.backgroundColor=[UIColor grayColor];
                [self.scrollView addSubview:participanttableView];
            }
                break;
                
                
        }		
        
		
	}


    
   activityNameLabel.text=[NSString stringWithFormat:@"%@",activityInfo.activityName];
    activityNameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    activityNameLabel.textColor=[UIColor whiteColor];
    activityNameLabel.backgroundColor=[UIColor clearColor];
    activityNameLabel.shadowColor = [UIColor whiteColor];
    activityNameLabel.shadowOffset = CGSizeMake(0,1);
//    activityNameLabel.layer.shadowColor = [activityNameLabel.textColor CGColor];
//    activityNameLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0); 
    //activityNameLabel.layer.shadowOpacity = 1.0;
    leaveActivityButton.hidden=YES;
    chatButton.hidden=YES;
    [eventView loadViewWithActivityDetails:activityInfo];

    // Do any additional setup after loading the view from its nib.
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)addEventActivityPressed:(id)sender{
    
    chatButton.hidden=NO;
    leaveActivityButton.hidden=NO;
    addEventButton.hidden=YES;
    
}

-(IBAction)leaveEventActivityPressed:(id)sender{
    chatButton.hidden=YES;
    leaveActivityButton.hidden=YES;
    addEventButton.hidden=NO;
    
}
-(IBAction)createANewActivityButtonPressed:(id)sender{
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [eventView release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
