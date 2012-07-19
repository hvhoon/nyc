//
//  ParticipantListTableView.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticipantListTableView.h"
#import "ParticipantClass.h"
#import "ParticipantTableViewCell.h"
#import "SoclivityUtilities.h"
#import "SectionInfo.h"
#pragma mark -

@interface ParticipantListTableView ()

- (void)startIconDownload:(ParticipantClass *)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ParticipantListTableView
@synthesize DOS1_friendsArray,DOS2_friendsArray,imageDownloadsInProgress,participantTableView,openSectionIndex=openSectionIndex_,uniformRowHeight=rowHeight_,sectionInfoArray=sectionInfoArray_,noLine;
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
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    [participantTableView setRowHeight:kCustomRowHeight];
     participantTableView.scrollEnabled=YES;
    participantTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.participantTableView.sectionHeaderHeight = kSectionHeaderHeight;
    participantTableView.separatorColor=[UIColor clearColor];
    rowHeight_ = kCustomRowHeight;
    self.participantTableView.showsVerticalScrollIndicator=NO;
    
    
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.participantTableView])){
        [self setUpArrayWithBothSectionsOpen];
    }
}


-(void)setUpArrayWithBothSectionsOpen{
    
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
        for(int index=0;index<2;index++){
			InfoActivityClass *play=[[InfoActivityClass alloc]init];
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.open = YES;
			sectionInfo.play=play;
            
            
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:kCustomRowHeight];
            NSInteger countOfQuotations;
            switch (index) {
                case 0:
                {
                    play.quotations=self.DOS1_friendsArray;
                    sectionInfo.play.relationType=0;
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;
                    
                case 1:
                {
                    play.quotations=self.DOS2_friendsArray;
                    sectionInfo.play.relationType=1;
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;
            }
			switch (index) {
                case 0:
                {
                    if([self.DOS1_friendsArray count]==0){
                        
                    }
                    else{
                        [infoArray addObject:sectionInfo];
                    }
                }
                    break;
                case 1:
                {
                    if([self.DOS2_friendsArray count]==0){
                        
                    }
                    else{
                        [infoArray addObject:sectionInfo];
                    }

                    
                }
                    break;
            }
			
		}
		
        
		self.sectionInfoArray = infoArray;
	
    openSectionIndex_ = NSNotFound;
    [self.participantTableView reloadData];
}

-(void)setUpArrayWithBothSectionsClosed{
    
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		
        for(int index=0;index<2;index++){
			InfoActivityClass *play=[[InfoActivityClass alloc]init];
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.open = NO;
			sectionInfo.play=play;
            
            

            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:kCustomRowHeight];
            NSInteger countOfQuotations;
            switch (index) {
                case 0:
                {
                    play.quotations=self.DOS1_friendsArray;
                    sectionInfo.play.relationType=0;
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;
                    
                case 1:
                {
                    play.quotations=self.DOS2_friendsArray;
                    sectionInfo.play.relationType=1;
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;
            }
			
			switch (index) {
                case 0:
                {
                    if([self.DOS1_friendsArray count]==0){
                        
                    }
                    else{
                        [infoArray addObject:sectionInfo];
                    }
                }
                    break;
                case 1:
                {
                    if([self.DOS2_friendsArray count]==0){
                        
                    }
                    else{
                        [infoArray addObject:sectionInfo];
                    }
                    
                    
                }
                    break;
            }
			
		
		}
		
		self.sectionInfoArray = infoArray;
	
     openSectionIndex_ = NSNotFound;
     [self.participantTableView reloadData];
}
- (void)dealloc {
    
    [super dealloc];
    
    // To reduce memory pressure, reset the section info array if the view is unloaded.
	self.sectionInfoArray = nil;
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


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    InfoActivityClass *play=sectionInfo.play;
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,27)]autorelease];
    sectionHeaderview.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
    
    
    //second section don't draw the first line
    if(!noLine || section==0){
        
        
        UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        topDividerLineButton.frame = CGRectMake(0, 0, 320, 2);
        [topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_descriptionLine.png"]]];
        topDividerLineButton.tag=[[NSString stringWithFormat:@"777%d",section]intValue];
        [sectionHeaderview addSubview:topDividerLineButton];

//        UIView *topDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,2)]autorelease];
//        topDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
//        topDividerLineview.tag=777;
//        [sectionHeaderview addSubview:topDividerLineview];
    }
    else{
        UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        topDividerLineButton.frame = CGRectMake(0, 0, 320, 2);
        [topDividerLineButton setBackgroundColor:[UIColor clearColor]];
        //[topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_descriptionLine.png"]]];
        topDividerLineButton.tag=[[NSString stringWithFormat:@"777%d",section]intValue];
        [sectionHeaderview addSubview:topDividerLineButton];
    }
    UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 7.5, 19, 11)];
    

    CGRect DOSLabelRect=CGRectMake(55,7.5,140,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];
    
    
    switch (play.relationType) {
        case 0:
        {
            DOSImageView.image=[UIImage imageNamed:@"S05_smallDOS1.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends",[sectionInfo.play.quotations count]];
        }
            break;
            
        case 1:
        {
            DOSImageView.image=[UIImage imageNamed:@"S05_smallDOS2.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends of friends",[sectionInfo.play.quotations count]];
        }
            break;
            
            
            
    }
    
    
    [sectionHeaderview addSubview:DOSImageView];
    [DOSImageView release];
    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];

    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,25,320,2)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
     [sectionHeaderview addSubview:bottomDividerLineview];
        
    return sectionHeaderview;  
    
    
}	


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"MediaTableCell";
    
        
        
 ParticipantTableViewCell *cell =  (ParticipantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[ParticipantTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                      reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        }
        
        // Leave cells empty if there's no data yet
            // Set up the cell...
            
            
            InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
            ParticipantClass *appRecord = [play.quotations objectAtIndex:indexPath.row];

            cell.nameText=appRecord.name;
           if(indexPath.row==[play.quotations count]-1){
                cell.noSeperatorLine=TRUE;
             }
          else{
                cell.noSeperatorLine=FALSE;
            }
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!appRecord.profilePhotoImage)
            {
                if (participantTableView.dragging == NO && participantTableView.decelerating == NO)
                {
                    [self startIconDownload:appRecord forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.profileImage = [UIImage imageNamed:@"picbox.png"];                
            }
            else
            {
                cell.profileImage = appRecord.profilePhotoImage;
            }
            
        
        
        [cell setNeedsDisplay];
        return cell;
        
    
}


#pragma mark -
#pragma mark Table cell image support

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(ParticipantClass*)appRecord forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows{
    if ([self.sectionInfoArray count] > 0)
    {
        NSArray *visiblePaths = [participantTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
            ParticipantClass *appRecord = [play.quotations objectAtIndex:indexPath.row];

            
            if (!appRecord.profilePhotoImage) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
    
    
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        ParticipantTableViewCell *cell = (ParticipantTableViewCell*)[participantTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        // Display the newly loaded image
        cell.profileImage = iconDownloader.appRecord.profilePhotoImage;
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
  if (!decelerate)
        {
            [self loadImagesForOnscreenRows];
        }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
        [self loadImagesForOnscreenRows];
}

#pragma mark Section header delegate

-(void)sectionHeaderView:(NSInteger)sectionOpened{
    
    
    if(sectionOpened==1){
        noLine=TRUE; 
        [(UIButton*)[self viewWithTag:7771] setHidden:YES];
        
    }
    else{
        [(UIButton*)[self viewWithTag:7771] setHidden:NO];
        [(UIButton*)[self viewWithTag:7771]setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_descriptionLine.png"]]];
        noLine=FALSE;
    }
	
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
        //[previousOpenSection.headerView toggleOpenWithUserAction:NO];
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
    [self.participantTableView beginUpdates];
    [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.participantTableView endUpdates];
    self.openSectionIndex = sectionOpened;
    
}


-(void)closeSectionHeaderView:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.participantTableView numberOfRowsInSection:sectionClosed];
    
    [self.participantTableView beginUpdates];
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        UITableViewRowAnimation deleteAnimation;
        if(sectionClosed==1){
            deleteAnimation=UITableViewRowAnimationBottom;
        }
        else{
            deleteAnimation=UITableViewRowAnimationTop;
        }
        [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    }
    [self.participantTableView endUpdates];
    self.openSectionIndex = NSNotFound;
}

@end
