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

@interface RegistrationViewControler (private)<GetPlayersDetailDelegate,SubmitLoginDetailDelegate>
@end


@implementation RegistrationViewControler
@synthesize basicSectionFirst,activitySectionSecond,scrollView;
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


-(void)SetUpServices{
    server=[[MainServiceManager alloc]init];
    
    [server submitLoginDetailInvocation:@"1213" Pass:@"1213" delegate:self];
    
    //[server GetPlayersInvocation:self];
}

-(void)GetPlayersDetailInvocationDidFinish:(GetPlayersDetailInvocation*)invocation 
                                withResult:(NSArray*)result
                                 withError:(NSError*)error{
    
}

-(void)BackButtonClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self SetUpServices];
    pageControlBeingUsed = NO;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]; 
    
    scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    scrollView.clipsToBounds = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;            
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.alwaysBounceVertical= YES;
    scrollView.delegate = self;
    scrollView.bounces=NO;
    [self.view addSubview:scrollView];
    basicSectionFirst.delegate=self;
    activitySectionSecond.delegate=self;
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
                UIImageView *activeType=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S02_pickactivity.png"]];
                activeType.frame=CGRectMake(0, 414, 320, 46);
                UIButton *scrollUpDownButton=[UIButton buttonWithType:UIButtonTypeCustom];
                scrollUpDownButton.frame=CGRectMake(276,422,29,30);
                [scrollUpDownButton setBackgroundImage:[UIImage imageNamed:@"S02_downarrow.png"] forState:UIControlStateNormal];
                [scrollUpDownButton addTarget:self action:@selector(timeToScrollDown) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:activeType];
                [self.scrollView addSubview:scrollUpDownButton];
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

	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,874);

    
    //[self.view addSubview:basicSectionFirst];
    

    // Do any additional setup after loading the view from its nib.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.height;
		page = floor((self.scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        //NSLog(@"page=%d",page);
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}


-(void)presentModal:(UIImagePickerController*)picker{
    [self presentModalViewController:picker animated:YES];
    
}

-(void)dismissPickerModalController{
    
    [self dismissModalViewControllerAnimated:YES];
    
}
-(void)timeToScrollDown{
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
    
    //pageControlBeingUsed = YES;

}
-(void)timeToScrollUp{
    CGRect frame;
	frame.origin.x = 0;
	frame.origin.y = self.scrollView.frame.size.height * 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];
    
}
-(void)pushHomeViewCntrlr{
    
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
