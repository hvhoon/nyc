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
    
    
    scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    scrollView.clipsToBounds = YES;
    
    // Initially disabled scrolling. This is not enabled till all the fields on the basic info page have been filled.
    scrollView.scrollEnabled = YES;
    
    
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.alwaysBounceVertical= YES;
    scrollView.delegate = self;
    scrollView.bounces=NO;
    
    eventView.delegate=self;
    participantListTableView.DOS1_friendsArray=activityInfo.friendsArray;
    
    participantListTableView.DOS2_friendsArray=activityInfo.friendsOfFriendsArray;

    
    for (int i = 0; i < 2; i++) {
		CGRect frame;
		frame.origin.x = 0;
		frame.origin.y = self.scrollView.frame.size.height* i+44.0f;
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
                [pArrowButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                pArrowButton.tag=103;
                [self.scrollView addSubview:pArrowButton];
                
                
                
                UIButton *goingButton=[UIButton buttonWithType:UIButtonTypeCustom];
                goingButton.frame=CGRectMake(34,329,74,47);
                [goingButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                goingButton.tag=104;
                [self.scrollView addSubview:goingButton];

                
                CGRect goingCountLabelRect=CGRectMake(40,340,40,12);
                UILabel *goingCountLabel=[[UILabel alloc] initWithFrame:goingCountLabelRect];
                goingCountLabel.textAlignment=UITextAlignmentCenter;
                goingCountLabel.text=[NSString stringWithFormat:@"%@",activityInfo.goingCount];
                goingCountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingCountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingCountLabel.tag=235;
                goingCountLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:goingCountLabel];
                [goingCountLabel release];
                
                
                CGRect goingLabelTextRect=CGRectMake(46,355,55,12);
                UILabel *goingTextLabel=[[UILabel alloc] initWithFrame:goingLabelTextRect];
                goingTextLabel.textAlignment=UITextAlignmentLeft;
                goingTextLabel.text=[NSString stringWithFormat:@"GOING"];
                goingTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingTextLabel.tag=236;
                goingTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:goingTextLabel];
                [goingTextLabel release];
                
                
                
                UIButton *DOS1Button=[UIButton buttonWithType:UIButtonTypeCustom];
                DOS1Button.frame=CGRectMake(118,329,74,47);
                [DOS1Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS1Button.tag=105;
                [self.scrollView addSubview:DOS1Button];

                
                
                CGRect DOS_1LabelRect=CGRectMake(101,340,40,12);
                UILabel *DOS_1countLabel=[[UILabel alloc] initWithFrame:DOS_1LabelRect];
                DOS_1countLabel.textAlignment=UITextAlignmentCenter;
                DOS_1countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS1];
                DOS_1countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_1countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_1countLabel.tag=237;
                DOS_1countLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:DOS_1countLabel];
                [DOS_1countLabel release];
                
                
                UIImageView *DOS_1ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_smallDOS1.png"]];
                DOS_1ImageView.frame=CGRectMake(130, 340, 19, 11);
                DOS_1ImageView.tag=238;
                [self.scrollView addSubview:DOS_1ImageView];
                [DOS_1ImageView release];
 
                
                
                CGRect friendsLabelTextRect=CGRectMake(111,355,55,12);
                UILabel *friendsTextLabel=[[UILabel alloc] initWithFrame:friendsLabelTextRect];
                friendsTextLabel.textAlignment=UITextAlignmentLeft;
                friendsTextLabel.text=[NSString stringWithFormat:@"FRIENDS"];
                friendsTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                friendsTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                friendsTextLabel.tag=239;
                friendsTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:friendsTextLabel];
                [friendsTextLabel release];
                
                
                UIButton *DOS2Button=[UIButton buttonWithType:UIButtonTypeCustom];
                DOS2Button.frame=CGRectMake(192,329,74,47);
                [DOS2Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS2Button.tag=106;
                [self.scrollView addSubview:DOS2Button];

                
                CGRect DOS_2LabelRect=CGRectMake(186,340,40,12);
                UILabel *DOS_2countLabel=[[UILabel alloc] initWithFrame:DOS_2LabelRect];
                DOS_2countLabel.textAlignment=UITextAlignmentCenter;
                DOS_2countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS2];
                DOS_2countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_2countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_2countLabel.tag=240;
                DOS_2countLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:DOS_2countLabel];
                [DOS_2countLabel release];
                
                
                UIImageView *DOS_2ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_smallDOS2.png"]];
                DOS_2ImageView.frame=CGRectMake(215, 340, 19, 11);
                DOS_2ImageView.tag=241;
                [self.scrollView addSubview:DOS_2ImageView];
                [DOS_2ImageView release];
                
                
                
                CGRect mayknowLabelTextRect=CGRectMake(191,355,70,12);
                UILabel *mayknowTextLabel=[[UILabel alloc] initWithFrame:mayknowLabelTextRect];
                mayknowTextLabel.textAlignment=UITextAlignmentLeft;
                mayknowTextLabel.text=[NSString stringWithFormat:@"MAY KNOW"];
                mayknowTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                mayknowTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                mayknowTextLabel.tag=242;
                mayknowTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:mayknowTextLabel];
                [mayknowTextLabel release];
                
                
                UIButton *DOS3Button=[UIButton buttonWithType:UIButtonTypeCustom];
                DOS3Button.frame=CGRectMake(266,329,74,47);
                [DOS3Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS2Button.tag=107;
                [self.scrollView addSubview:DOS3Button];

                
                CGRect DOS_3LabelRect=CGRectMake(266,340,40,12);
                UILabel *DOS_3countLabel=[[UILabel alloc] initWithFrame:DOS_3LabelRect];
                DOS_3countLabel.textAlignment=UITextAlignmentCenter;
                DOS_3countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS3];
                DOS_3countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_3countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_3countLabel.tag=243;
                DOS_3countLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:DOS_3countLabel];
                [DOS_3countLabel release];
                
                
                
                
                
                CGRect othersLabelTextRect=CGRectMake(266,355,55,12);
                UILabel *othersTextLabel=[[UILabel alloc] initWithFrame:othersLabelTextRect];
                othersTextLabel.textAlignment=UITextAlignmentLeft;
                othersTextLabel.text=[NSString stringWithFormat:@"OTHERS"];
                othersTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                othersTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                othersTextLabel.tag=244;
                othersTextLabel.backgroundColor=[UIColor clearColor];
                [self.scrollView addSubview:othersTextLabel];
                [othersTextLabel release];



                
                
                
            }
                break;
            case 1:
            {
                [participantListTableView setFrame:CGRectMake(0, 376, 320, 376)];
                [self.scrollView addSubview:participantListTableView];
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
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,705);


    // Do any additional setup after loading the view from its nib.
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ButtonTapped:(UIButton*)sender{
    
    int tag=sender.tag;
    NSLog(@"tag=%d",tag);
    if(page==0){
        [self scrollViewToTheTopOrBottom];
        
        return;
    }
    
    
    switch (sender.tag) {
        case 103:
        {
            if(page==1){
                
                [self scrollViewToTheTopOrBottom];
                
            }
        }
            break;
        case 104:
        {
            
        }
            break;
        case 105:
        {
            
        }
            break;
        case 106:
        {
            
        }
            break;
        case 107:
        {
            
        }
            break;

            
        default:
            break;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    //NSLog(@"scrollViewDidScroll");
    
    
    if (!pageControlBeingUsed) {
		
        // Switch the indicator when more than 50% of the previous/next view is visible
		CGFloat pageWidth = self.scrollView.frame.size.height;
		page = floor((self.scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        
        switch (page) {
            case 1:
            {
                [(UIButton*)[self.scrollView viewWithTag:103] setFrame:CGRectMake(16, 343, 19, 10)];
                [(UIButton*)[self.scrollView viewWithTag:103] setBackgroundImage:[UIImage imageNamed:@"S05_participantDownArrow.png"] forState:UIControlStateNormal];

            }
                break;
                
                
            case 0:
            {
                [(UIButton*)[self.scrollView viewWithTag:103] setFrame:CGRectMake(16,343,10,18)];
                [(UIButton*)[self.scrollView viewWithTag:103] setBackgroundImage:[UIImage imageNamed:@"S05_participantArrow.png"] forState:UIControlStateNormal];

            }
                break;

                
        }
        //NSLog(@"page=%d",page);
        
        
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

-(void)scrollViewToTheTopOrBottom{
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = self.scrollView.frame.size.height;
    frame.size = self.scrollView.frame.size;
    
    switch (page) {
        case 0:
        {
            frame.origin.y = 376;
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
