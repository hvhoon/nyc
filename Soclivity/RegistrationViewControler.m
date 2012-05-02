//
//  RegistrationViewControler.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegistrationViewControler.h"
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]; 
    
    scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    scrollView.clipsToBounds = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;            
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.alwaysBounceVertical= YES;
    scrollView.delegate = self;
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
                basicSectionFirst.frame=frame;
                [self.scrollView addSubview:basicSectionFirst];
            }
                break;
            case 1:
            {
                activitySectionSecond.frame=frame;
                [self.scrollView addSubview:activitySectionSecond];
            }
                break;

                
            default:
                break;
        }		
        
		
	}

	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height* 2);

    
    //[self.view addSubview:basicSectionFirst];
    

    // Do any additional setup after loading the view from its nib.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
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
	frame.origin.y = self.scrollView.frame.size.height * 1;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];

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
