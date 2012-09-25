//
//  UpComingCompletedEventsViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpComingCompletedEventsViewController.h"
#import "InfoActivityClass.h"
#import "DetailInfoActivityClass.h"
#import "SectionInfo.h"
#import "SectionHeaderView.h"
#import "SOCTableViewCell.h"
#import "SoclivityUtilities.h"
#import "SoclivitySqliteClass.h"
#define REFRESH_HEADER_HEIGHT 90.0f


@interface UpComingCompletedEventsViewController ()

@property (nonatomic, retain) NSMutableArray* sectionInfoArray;

// Use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously.
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, assign) NSInteger openSectionIndex;
@end

#define DEFAULT_ROW_HEIGHT 114
#define HEADER_HEIGHT 93



@implementation UpComingCompletedEventsViewController
@synthesize delegate,activityListView;
@synthesize plays;
@synthesize sectionInfoArray=sectionInfoArray_, uniformRowHeight=rowHeight_,openSectionIndex=openSectionIndex_;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner, topDivider;

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
    organizedButton.titleLabel.text=[NSString stringWithFormat:@"Organized"];
    organizedButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    organizedButton.titleLabel.textColor=[UIColor blackColor];
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    
    
    goingButton.titleLabel.textAlignment=UITextAlignmentCenter;
    goingButton.titleLabel.text=[NSString stringWithFormat:@"Going"];
    goingButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    goingButton.titleLabel.textColor=[UIColor blackColor];
    [goingButton setBackgroundImage:nil forState:UIControlStateNormal];

    
    
    completedButton.titleLabel.textAlignment=UITextAlignmentCenter;
    completedButton.titleLabel.text=[NSString stringWithFormat:@"Completed"];
    completedButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    completedButton.titleLabel.textColor=[UIColor blackColor];
    [completedButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    
    
    
    filterType=3;
    self.activityListView.sectionHeaderHeight = HEADER_HEIGHT;
	self.activityListView.scrollsToTop=YES;
    self.activityListView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.activityListView.separatorColor = [UIColor clearColor];
    //[self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.activityListView.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
    rowHeight_ = DEFAULT_ROW_HEIGHT;
    openSectionIndex_ = NSNotFound;
    
    
    [self setupStrings];
    [self addPullToRefreshHeader];
    
    self.plays =[SoclivitySqliteClass returnAllValidActivities];
    [self sortingFilterRefresh];





        // Do any additional setup after loading the view from its nib.
}

- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to update..."];
    textRelease = [[NSString alloc] initWithString:@"Release to update..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}


-(IBAction)organizedButtonPressed:(id)sender{
    [organizedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    
    [completedButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [goingButton setBackgroundImage:nil forState:UIControlStateNormal];



}

-(IBAction)goingButtonPressed:(id)sender{
    [organizedButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [goingButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    
    [completedButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    
    
}

-(IBAction)completedButtonPressed:(id)sender{
    
    [organizedButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [goingButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    [completedButton setBackgroundImage:[UIImage imageNamed:@"S10_sectionHighlighted.png"] forState:UIControlStateNormal];
    
    
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
#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return [self.sectionInfoArray count];
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.play quotations] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableViewCell cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"MediaTableCell";
    
    
    SOCTableViewCell *cell = (SOCTableViewCell *)[tableViewCell dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SOCTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate=self;
    InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
    cell.playActivity = play;
    [cell setNeedsDisplay];
    return cell;
    
    
    
}
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
        InfoActivityClass*activityName = sectionInfo.play;
        sectionInfo.headerView = [[[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.activityListView.bounds.size.width, HEADER_HEIGHT) detailSectionInfo:activityName section:section delegate:self sortingPattern:filterType] autorelease];
    }
    
    return sectionInfo.headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}


-(void)tableView:(UITableView*)tableViewIndex didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableViewIndex deselectRowAtIndexPath:indexPath animated:YES];
    [tableViewIndex scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
    
    sectionOpenClose=TRUE;
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.activityListView beginUpdates];
    [self.activityListView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.activityListView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.activityListView endUpdates];
    self.openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
    
    [self.activityListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionOpened] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    sectionOpenClose=FALSE;
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.activityListView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.activityListView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    self.openSectionIndex = NSNotFound;
}


-(void)selectActivityView:(NSInteger)activitySection{
    
    NSLog(@"activitySection=%d",activitySection);
    spinnerIndex=activitySection;
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:activitySection];
    //[delegate PushToDetailActivityView:sectionInfo.play andFlipType:1];
    
}

-(void)BytesDownloadedTimeToHideTheSpinner{
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:spinnerIndex];
    [sectionInfo.headerView spinnerCloseAndIfoDisclosureButtonUnhide];
    
}
#pragma mark Pull To Refresh header
-(void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [SoclivityUtilities returnTextFontColor:7];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30-1, 320, 16)];//REFRESH_HEADER_HEIGHT
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.shadowColor = [SoclivityUtilities returnTextFontColor:7];
    refreshLabel.shadowOffset = CGSizeMake(0,-1);
    refreshLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    refreshLabel.textColor = [SoclivityUtilities returnTextFontColor:1];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    
    lastUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 15)];//REFRESH_HEADER_HEIGHT
    lastUpdateLabel.backgroundColor = [UIColor clearColor];
    lastUpdateLabel.shadowColor = [SoclivityUtilities returnTextFontColor:7];
    lastUpdateLabel.shadowOffset = CGSizeMake(0,-1);
    lastUpdateLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    lastUpdateLabel.textColor = [SoclivityUtilities returnTextFontColor:1];
    lastUpdateLabel.textAlignment = UITextAlignmentCenter;
    NSString *timeStamp=[[NSUserDefaults standardUserDefaults] valueForKey:@"SOCLastTimeUpdate"];
    lastUpdateLabel.text=[SoclivityUtilities lastUpdate:timeStamp];
    
    topDivider=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S04_sectionDivider.png"]];
    topDivider.frame=CGRectMake(0, REFRESH_HEADER_HEIGHT-1, 320, 1);
    
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S04_listrefresh.png"]];
    refreshArrow.frame = CGRectMake(20,(floorf(REFRESH_HEADER_HEIGHT - 60) / 2), 23, 60);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(20, floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:topDivider];
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:lastUpdateLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.activityListView addSubview:refreshHeaderView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.activityListView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.activityListView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        NSString *timeStamp=[[NSUserDefaults standardUserDefaults] valueForKey:@"SOCLastTimeUpdate"];
        lastUpdateLabel.text=[SoclivityUtilities lastUpdate:timeStamp];
        
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.activityListView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    listRefresh=FALSE;
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.activityListView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
    
}

- (void)refresh {
    listRefresh=TRUE;
    //time to call the HomeView Controller for cleaning the cache and loading new results
    //[delegate RefreshFromTheListView];
    // Don't forget to call stopLoading at the end.
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}


-(void)sortingFilterRefresh{
    
    NSString *timeStamp=[[NSUserDefaults standardUserDefaults] valueForKey:@"SOCLastTimeUpdate"];
    lastUpdateLabel.text=[SoclivityUtilities lastUpdate:timeStamp];
    
    if(sectionOpenClose){
        sectionOpenClose=FALSE;
        SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:self.openSectionIndex];
        
        sectionInfo.open = NO;
        NSInteger countOfRowsToDelete = [self.activityListView numberOfRowsInSection:self.openSectionIndex];
        
        [self.activityListView beginUpdates];
        if (countOfRowsToDelete > 0) {
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:self.openSectionIndex]];
            }
            [self.activityListView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
            [indexPathsToDelete release];
        }
        self.openSectionIndex = NSNotFound;
        [self.activityListView endUpdates];
        
    }
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (InfoActivityClass *play in self.plays) {
        
        if([SoclivityUtilities ValidActivityDate:play.when]){
            
            if([SoclivityUtilities validFilterActivity:play.type]){
                
                if([SoclivityUtilities DoTheTimeLogic:play.when]){
                    
                    if([SoclivityUtilities DoTheSearchFiltering:play.activityName organizer:play.organizerName]){
                        SectionInfo *sectionInfo = [[SectionInfo alloc] init];
                        
                        sectionInfo.play = play;
                        sectionInfo.open = NO;
                        NSNumber *defaultRowHeight = [NSNumber numberWithInteger:DEFAULT_ROW_HEIGHT];
                        NSInteger countOfQuotations = [[sectionInfo.play quotations] count];
                        for (NSInteger i = 0; i < countOfQuotations; i++) {
                            [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                        }
                        
                        [infoArray addObject:sectionInfo];
                        [sectionInfo release];
                    }
                }
            }
        }
        
    }
    self.sectionInfoArray = infoArray;
    [infoArray release];
    
    if([self.sectionInfoArray count]==0){
        self.activityListView.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_NoActivities.png"]];
        self.activityListView.scrollEnabled=NO;
        self.activityListView.bounces=NO;
        
    }
    else{
        self.activityListView.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
        self.activityListView.scrollEnabled=YES;
        self.activityListView.bounces=YES;
        
    }
    
    [self.activityListView reloadData];
    [self.activityListView beginUpdates];
    [self.activityListView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.activityListView endUpdates];
}

#pragma mark Memory management

-(void)dealloc {
    
    [plays release];
    [sectionInfoArray_ release];
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [topDivider release];
    
    [super dealloc];
    
}


@end
