//
//  ActivityListView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityListView.h"
#import "InfoActivityClass.h"
#import "DetailInfoActivityClass.h"
#import "SectionInfo.h"
#import "SectionHeaderView.h"
#import "SOCTableViewCell.h"
#import "SoclivityUtilities.h"
#define REFRESH_HEADER_HEIGHT 90.0f
@interface ActivityListView ()

@property (nonatomic, retain) NSMutableArray* sectionInfoArray;

// Use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously.
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, assign) NSInteger openSectionIndex;
@end

#define DEFAULT_ROW_HEIGHT 115
#define HEADER_HEIGHT 94

@implementation ActivityListView
@synthesize plays,tableView,delegate;
@synthesize sectionInfoArray=sectionInfoArray_, uniformRowHeight=rowHeight_,openSectionIndex=openSectionIndex_;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    sortType=1;
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
	self.tableView.scrollsToTop=YES;
    self.tableView.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
    rowHeight_ = DEFAULT_ROW_HEIGHT;
    openSectionIndex_ = NSNotFound;
    [self startPopulatingListView];
}

-(void)LoadTable{
    [self setupStrings];
    [self addPullToRefreshHeader];
}
- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to update..."];
    textRelease = [[NSString alloc] initWithString:@"Release to update..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}
- (void)startPopulatingListView{
    
    self.plays =[SoclivityUtilities getPlayerActivities];
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (InfoActivityClass *play in self.plays) {
			
        if([SoclivityUtilities validFilterActivity:play.type]){
            
            
            if([SoclivityUtilities DoTheTimeLogic:play]){
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
		
		self.sectionInfoArray = infoArray;
		[infoArray release];
	}
    [self.tableView reloadData];
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
        sectionInfo.headerView = [[[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) detailSectionInfo:activityName section:section delegate:self sortingPattern:sortType] autorelease];
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
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionOpened] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    sectionOpenClose=FALSE;
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    self.openSectionIndex = NSNotFound;
}


-(void)selectActivityView:(NSInteger)activitySection{
    
    NSLog(@"activitySection=%d",activitySection);
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:activitySection];
    [delegate PushToDetailActivityView:sectionInfo.play];

}
#pragma mark Pull To Refresh header 
-(void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [SoclivityUtilities returnTextFontColor:7];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:15];
    refreshLabel.textColor = [SoclivityUtilities returnTextFontColor:1];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S04_listrefresh.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT + 20) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 60) / 2),
                                    23, 60);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT + 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
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
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
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
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
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
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
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

    [super dealloc];
    
}

#pragma mark Sorting To Filter 
-(void)SortByDistance{
    
   self.plays = [self.plays sortedArrayUsingComparator: ^(InfoActivityClass *a, InfoActivityClass *b) {
        NSString *s1 = a.distance;
        NSString *s2 = b.distance;
        return [s1 compare:s2];
    }];
    
    sortType=1;
    [self sortingFilterRefresh];
}
-(void)sortByDegree{
    

    self.plays = [self.plays sortedArrayUsingComparator: ^(InfoActivityClass *a, InfoActivityClass *b) {
        NSString *s1 = a.DOS;
        NSString *s2 = b.DOS;
        return [s1 compare:s2];
    }];
    sortType=2;
    [self sortingFilterRefresh];
}
-(void)SortByTime{
    
    
    // how to make the date formatter and send the same to the server
    
    
    self.plays = [self.plays sortedArrayUsingComparator: ^(InfoActivityClass *a, InfoActivityClass *b) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
		NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
		[dateFormatter setTimeZone:gmt];
        NSDate *s1 = [dateFormatter dateFromString:a.dateFormatterString];//add the string
        NSDate *s2 = [dateFormatter dateFromString:b.dateFormatterString];

        return [s1 compare:s2];
    }];
    sortType=3;
    [self sortingFilterRefresh];

}
-(void)sortingFilterRefresh{
    
    if(sectionOpenClose){
        sectionOpenClose=FALSE;
        SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:self.openSectionIndex];
        
        sectionInfo.open = NO;
        NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:self.openSectionIndex];
        
        [self.tableView beginUpdates];
        if (countOfRowsToDelete > 0) {
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:self.openSectionIndex]];
            }
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
            [indexPathsToDelete release];
        }
        self.openSectionIndex = NSNotFound;
        [self.tableView endUpdates];

    }
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    for (InfoActivityClass *play in self.plays) {
        
        if([SoclivityUtilities validFilterActivity:play.type]){
            
        if([SoclivityUtilities DoTheTimeLogic:play]){
            
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
    
    self.sectionInfoArray = infoArray;
    [infoArray release];

    [self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self.tableView endUpdates];
}
#pragma mark Filter Pane Activities
-(void)doFilteringByActivities{
    [self sortingFilterRefresh];    
}

@end
