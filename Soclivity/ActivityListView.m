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

@interface ActivityListView ()

@property (nonatomic, retain) NSMutableArray* sectionInfoArray;

// Use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously.
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, assign) NSInteger openSectionIndex;
@end

#define DEFAULT_ROW_HEIGHT 140
#define HEADER_HEIGHT 100

@implementation ActivityListView
@synthesize plays,tableView;
@synthesize sectionInfoArray=sectionInfoArray_, uniformRowHeight=rowHeight_,openSectionIndex=openSectionIndex_;

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
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    //self.tableView.separatorColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_darkdivider.png"]];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_darkdivider.png"]];
    self.tableView.tableFooterView=v;
	/*
     The section info array is thrown away in viewWillUnload, so it's OK to set the default values here. If you keep the section information etc. then set the default values in the designated initializer.
     */
    rowHeight_ = DEFAULT_ROW_HEIGHT;
    openSectionIndex_ = NSNotFound;

    [self setUpActivityDataList];
}

- (void)setUpActivityDataList{
    
    
//    NSDictionary *dTmp=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Activities" ofType:@"plist"]];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Activities" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *playsArray = [NSMutableArray arrayWithCapacity:[playDictionariesArray count]];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        InfoActivityClass *play = [[InfoActivityClass alloc] init];
        play.activityName = [playDictionary objectForKey:@"activityName"];
        play.organizerName=[playDictionary objectForKey:@"organizerName"];
        NSNumber * n = [playDictionary objectForKey:@"type"];
        play.type= [n intValue];
        play.DOS=[playDictionary objectForKey:@"DOS"];
        play.distance=[playDictionary objectForKey:@"distance"];
        play.goingCount=[playDictionary objectForKey:@"goingCount"];
        NSArray *quotationDictionaries = [playDictionary objectForKey:@"detailQuotations"];
        NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:[quotationDictionaries count]];
        
        for (NSDictionary *quotationDictionary in quotationDictionaries) {
            
            DetailInfoActivityClass *quotation = [[DetailInfoActivityClass alloc] init];
            [quotation setValuesForKeysWithDictionary:quotationDictionary];
            
            [quotations addObject:quotation];
            [quotation release];
        }
        play.quotations = quotations;
        
        [playsArray addObject:play];
        [play release];
    }
    
    self.plays = playsArray;
    [playDictionariesArray release];
    
    
    
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
		for (InfoActivityClass *play in self.plays) {
			
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
		
		self.sectionInfoArray = infoArray;
		[infoArray release];
	}
    [self.tableView reloadData];
}

#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    return [self.plays count];
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
    cell.quotation = [play.quotations objectAtIndex:indexPath.row];
    [cell setNeedsDisplay];
    return cell;
    
    
    
}
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    /*
     Create the section header views lazily.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    if (!sectionInfo.headerView) {
       InfoActivityClass*activityName = sectionInfo.play;
        sectionInfo.headerView = [[[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) detailSectionInfo:activityName section:section delegate:self] autorelease];
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
}


#pragma mark Section header delegate

-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
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
}


-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
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


#pragma mark Memory management

-(void)dealloc {
    
    [plays release];
    [sectionInfoArray_ release];
    [super dealloc];
    
}
@end
