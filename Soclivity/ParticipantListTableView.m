//
//  ParticipantListTableView.m
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticipantListTableView.h"
#import "ParticipantClass.h"
#import "SoclivityUtilities.h"
#import "SectionInfo.h"
#import "InfoActivityClass.h"
#define  SWIPE_CELL 0
#pragma mark -

@interface ParticipantListTableView ()

- (void)startIconDownload:(ParticipantClass *)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ParticipantListTableView
@synthesize imageDownloadsInProgress,participantTableView,openSectionIndex=openSectionIndex_,uniformRowHeight=rowHeight_,sectionInfoArray=sectionInfoArray_,noLine,activityLinkIndex,tableActivityInfo;
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
    
#if SWIPE_CELL    
    //Add a left swipe gesture recognizer
	UISwipeGestureRecognizer * swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwiped:)];
	[swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft |
								   UISwipeGestureRecognizerDirectionRight)];
	[self.participantTableView addGestureRecognizer:swipeRecognizer];
	[swipeRecognizer release];
#endif    
    [participantTableView setRowHeight:kCustomRowHeight];
     participantTableView.scrollEnabled=YES;
    participantTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.participantTableView.sectionHeaderHeight = kSectionHeaderHeight;
    participantTableView.separatorColor=[UIColor clearColor];
    rowHeight_ = kCustomRowHeight;
    self.participantTableView.showsVerticalScrollIndicator=YES;
    
     [self setUpArrayWithTableSections];
    /*
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.participantTableView])){
       
    }*/
}


-(void)setUpArrayWithTableSections{
    
		
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    
    int index;
    switch (activityLinkIndex) {
        case 1:
        case 2:
        case 3:

        {
            index=2; 
        }
            break;
        case 4:
        case 5:
        {
            index=3;
        }
            break;
        case 6:
        {
            index=4;
        }
            break;
    }
		
        for(int i=0;i<index;i++){
			InfoActivityClass *play=[[InfoActivityClass alloc]init];
			SectionInfo *sectionInfo = [[SectionInfo alloc] init];			
			sectionInfo.open = YES;
			sectionInfo.play=play;
            
            
            NSNumber *defaultRowHeight = [NSNumber numberWithInteger:kCustomRowHeight];
            NSInteger countOfQuotations;
            switch (i) {
                case 0:
                {
                    if(activityLinkIndex==6){
                        play.quotations=self.tableActivityInfo.pendingRequestArray;
                        sectionInfo.play.relationType=0;
                    }
                    else{
                        play.quotations=self.tableActivityInfo.friendsArray;
                        sectionInfo.play.relationType=1;
                    }
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;
                    
                case 1:
                {
                    
                    if(activityLinkIndex==6){
                        play.quotations=self.tableActivityInfo.friendsArray;
                        sectionInfo.play.relationType=1;
                    }
                    else{
                        play.quotations=self.tableActivityInfo.friendsOfFriendsArray;
                        sectionInfo.play.relationType=2;
                    }
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;
                    
                    
                case 2:
                {
                    
                    if(activityLinkIndex==6){
                        play.quotations=self.tableActivityInfo.friendsOfFriendsArray;
                        sectionInfo.play.relationType=2;
                    }
                    else{
                        play.quotations=self.tableActivityInfo.otherParticipantsArray;
                        sectionInfo.play.relationType=3;
                    }
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;
                    
                    
                case 3:
                {
                    
                    play.quotations=self.tableActivityInfo.otherParticipantsArray;
                    sectionInfo.play.relationType=3;
                    countOfQuotations = [play.quotations count];
                    for (NSInteger i = 0; i < countOfQuotations; i++) {
                        [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
                    }
                }
                    break;


            }
			switch (i) {
                case 0:
                case 1:
                case 2:
                case 3:

                {
                    if(![play.quotations  count]==0)
                        [infoArray addObject:sectionInfo];
                    
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

-(NSInteger)returnNumberOfSections{
    
    NSMutableArray *checkArray=[NSMutableArray arrayWithCapacity:[self.sectionInfoArray count]];
    for(int z=0;z<[self.sectionInfoArray count];z++){
        SectionInfo*sectionInfo=[self.sectionInfoArray objectAtIndex:z];
        InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:z] play];
        if(![play.quotations  count]==0)
            [checkArray addObject:sectionInfo];
   }
    self.sectionInfoArray=checkArray;
    return [checkArray count];
}
#pragma mark Table view data source and delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    
    //return [self.sectionInfoArray count];
    return [self returnNumberOfSections];
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	NSInteger numStoriesInSection = [[sectionInfo.play quotations] count];
	
    return sectionInfo.open ? numStoriesInSection : 0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    return kCustomRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    InfoActivityClass *play=sectionInfo.play;
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,kSectionHeaderHeight)]autorelease];
    sectionHeaderview.backgroundColor=[SoclivityUtilities returnBackgroundColor:0];
    
    //second section don't draw the first line
    if(!noLine || section==0){
        UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        topDividerLineButton.frame = CGRectMake(0, 0, 320, 1);
        [topDividerLineButton setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_sectionDivider.png"]]];
        topDividerLineButton.tag=[[NSString stringWithFormat:@"777%d",section]intValue];
        [sectionHeaderview addSubview:topDividerLineButton];
    }
    else{
        UIButton *topDividerLineButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        topDividerLineButton.frame = CGRectMake(0, 0, 320, 1);
        [topDividerLineButton setBackgroundColor:[UIColor clearColor]];
        topDividerLineButton.tag=[[NSString stringWithFormat:@"777%d",section]intValue];
        [sectionHeaderview addSubview:topDividerLineButton];
    }
    
    UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 7.5, 19, 11)];
    
    CGRect DOSLabelRect=CGRectMake(38,7.5,140,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];
    
    
    switch (play.relationType) {
            
        case 0:
        {
            [DOSImageView setHidden:YES];
            DOScountLabel.frame=CGRectMake(12, 7.5, 240, 12);
            DOScountLabel.text=[NSString stringWithFormat:@"%d Join Requests",[sectionInfo.play.quotations count]];
        }
            break;

        case 1:
        {
            DOSImageView.image=[UIImage imageNamed:@"smallDOS1.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends",[sectionInfo.play.quotations count]];
        }
            break;
            
        case 2:
        {
            DOSImageView.image=[UIImage imageNamed:@"smallDOS2.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends of friends",[sectionInfo.play.quotations count]];
        }
            break;
            
        case 3:
        {
            [DOSImageView setHidden:YES];
            DOScountLabel.frame=CGRectMake(12, 7.5, 240, 12);
            DOScountLabel.text=[NSString stringWithFormat:@"%d Others",[sectionInfo.play.quotations count]];
        }
            break;

            
    }
    [sectionHeaderview addSubview:DOSImageView];
    [DOSImageView release];
    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];

    
    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,kSectionHeaderHeight-1,320,1)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_sectionDivider.png"]];
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
        cell.relationType=play.relationType;
        cell.cellIndexPath=indexPath;
        cell.delegate=self;
        cell.nameText=appRecord.name;
        if(indexPath.row==[play.quotations count]-1){
            cell.noSeperatorLine=TRUE;
        }
        else{
            cell.noSeperatorLine=FALSE;
        }
    
    if(play.relationType==0 && activityLinkIndex==6){
        
        switch (appRecord.dosConnection) {
            case 1:
            {
                cell.dosConnectionImage=[UIImage imageNamed:@"smallDOS1.png"];
            }
                break;
                
                
            case 2:
            {
                cell.dosConnectionImage=[UIImage imageNamed:@"smallDOS2.png"];
                
            }
                break;
   
                
            default:
                break;
        }
        
        cell.leftCrossImage=[UIImage imageNamed:@"S05_participantRemove.png"];
        cell.rightCrossImage=[UIImage imageNamed:@"S05_participantApprove.png"];

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



#if SWIPE_CELL



- (void)cellWasSwiped:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.participantTableView];
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.participantTableView indexPathForRowAtPoint:location];
        //Check if index path is valid
        if(indexPath)
        {
            
            lastIndexPath=indexPath;
            //Get the cell out of the table view
            ParticipantTableViewCell *cell = (ParticipantTableViewCell*)[self.participantTableView cellForRowAtIndexPath:indexPath];
            
            if(swipeOn && cell.swiped){
                cell.swiped=NO;
                swipeOn=FALSE;
                
            }
            else if(swipeOn && !cell.swiped){
                ParticipantTableViewCell *cell1 = (ParticipantTableViewCell*)[self.participantTableView cellForRowAtIndexPath:lastIndexPath];
                cell1.swiped=NO;
                swipeOn=FALSE;

            }
            else{
                swipeOn=YES;
                cell.swiped=YES;
                
            }
            
            
           
            [participantTableView reloadData];
#if 0           
            //Update the cell or model 
            UIButton *crossButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            crossButton.frame = CGRectMake(12, 15, 18, 17);
            crossButton.tag=((indexPath.section & 0xFFFF) << 16) |
            (indexPath.row & 0xFFFF);
            
            crossButton.backgroundColor = [UIColor clearColor];
            [crossButton setBackgroundImage:[UIImage imageNamed:@"S05_participantRemove.png"] forState:UIControlStateNormal];
            
            
            
            [crossButton addTarget:self action:@selector(participantRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:crossButton];
#endif            
            
        }
}
-(void)removeCrossButton:(NSIndexPath*)indexPath{
    ParticipantTableViewCell *cell = (ParticipantTableViewCell*)[self.participantTableView cellForRowAtIndexPath:indexPath];
    //if([lastIndexPath isEqual:indexPath]){
        cell.swiped=NO;
       
    //}
    [participantTableView reloadData];

}


-(void)participantRemoveAction:(UIButton*)sender{
    NSUInteger section = ((sender.tag >> 16) & 0xFFFF);
    NSUInteger row     = (sender.tag & 0xFFFF);
    NSLog(@"Button in section %i on row %i was pressed.", section, row);

}
#else

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(activityLinkIndex==6){
        InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
        
        if(play.relationType!=0){
            return UITableViewCellEditingStyleDelete;
        }
        else{
            return UITableViewCellEditingStyleNone;
        }
        
    }
    else
        return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
#if SWIPE_CELL
    ParticipantTableViewCell *cell = (ParticipantTableViewCell*)[self.participantTableView cellForRowAtIndexPath:indexPath];
    
    if(swipeOn && cell.swiped){
        cell.swiped=NO;
        swipeOn=FALSE;
        [participantTableView reloadData];
        
    }
#endif
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath");
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //service update
    InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];

    
    ParticipantClass *delete= [play.quotations objectAtIndex:indexPath.row];
    NSMutableArray *localArray=[NSMutableArray arrayWithArray:play.quotations];
    [localArray removeObjectIdenticalTo:delete];
    play.quotations=localArray;
#if 1
    switch (play.relationType) {
        case 1:
        {
            int count=tableActivityInfo.DOS1;
            if(count==0){
                count=0;
                
            }
            else
            count=count-1;
            
            if(count==0)
                self.openSectionIndex = -1;
            tableActivityInfo.DOS1=count;
            [self setTheSectionHeaderCount:play.relationType changeCountTo:count];

        }
            break;
        case 2:
        {
            
            int count=tableActivityInfo.DOS2;
            if(count==0){
                count=0;
            }
            else
                count=count-1;
            if(count==0)
                self.openSectionIndex = -1;

            tableActivityInfo.DOS2=count;
            [self setTheSectionHeaderCount:play.relationType changeCountTo:count];

        }
            break;
        case 3:
        {
            int count=tableActivityInfo.DOS3;
            if(count==0){
                count=0;
            }
            else
                count=count-1;

            if(count==0)
                self.openSectionIndex = -1;
            
            tableActivityInfo.DOS3=count;
            [self setTheSectionHeaderCount:play.relationType changeCountTo:count];

        }
            break;
            
    }
#endif

    
    [participantTableView reloadData];	
}
#endif
-(void)setTheSectionHeaderCount:(NSInteger)type changeCountTo:(NSInteger)changeCountTo{
    
    switch (type) {
            
        case 1:
        {
            int count=[self.tableActivityInfo.goingCount intValue];
            
             if(count==0)
                count=0;
             else
            count=count-1;
            
            self.tableActivityInfo.goingCount=[NSString stringWithFormat:@"%d",count];
            if(self.tableActivityInfo.pendingRequestCount==0)
              [(UILabel*)[self viewWithTag:235] setText:self.tableActivityInfo.goingCount];
            [(UILabel*)[self viewWithTag:237] setText:[NSString stringWithFormat:@"%d",changeCountTo]];

            
        }
            break;
        case 2:
        {
            int count=[self.tableActivityInfo.goingCount intValue];
            
            if(count==0)
                count=0;
            else
                count=count-1;
            
            self.tableActivityInfo.goingCount=[NSString stringWithFormat:@"%d",count];
            if(self.tableActivityInfo.pendingRequestCount==0)
            [(UILabel*)[self viewWithTag:235] setText:self.tableActivityInfo.goingCount];
            [(UILabel*)[self viewWithTag:240] setText:[NSString stringWithFormat:@"%d",changeCountTo]];
            
        }
            break;
        case 3:
        {
            int count=[self.tableActivityInfo.goingCount intValue];
            
            if(count==0)
                count=0;
            else
                count=count-1;
            
            self.tableActivityInfo.goingCount=[NSString stringWithFormat:@"%d",count];
            if(self.tableActivityInfo.pendingRequestCount==0)
            [(UILabel*)[self viewWithTag:235] setText:self.tableActivityInfo.goingCount];
            [(UILabel*)[self viewWithTag:243] setText:[NSString stringWithFormat:@"%d",changeCountTo]];
            
        }
            break;

            
    }

}
#pragma mark -
#pragma mark Table cell View  Delegate Methods

-(void)ApproveRejectSelection:(NSIndexPath*)indexPath request:(BOOL)request{
 
    
    //service update
    InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
    
    
    ParticipantClass *delete= [play.quotations objectAtIndex:indexPath.row];
    NSMutableArray *localArray=[NSMutableArray arrayWithArray:play.quotations];
    [localArray removeObjectIdenticalTo:delete];
    play.quotations=localArray;
    [participantTableView reloadData];
    
    int count=self.tableActivityInfo.pendingRequestCount;
    if(count==0)
        count=0;
    else
        count=count-1;
    
    if(count==0){
         self.tableActivityInfo.pendingRequestCount=count;
         self.openSectionIndex = -1;
         [(UILabel*)[self viewWithTag:235] setText:self.tableActivityInfo.goingCount];
        [(UILabel*)[self viewWithTag:235] setTextColor:[SoclivityUtilities returnTextFontColor:5]];
        
        [(UILabel*)[self viewWithTag:236] setText:@"GOING"];
        [(UILabel*)[self viewWithTag:236] setTextColor:[SoclivityUtilities returnTextFontColor:5]];

   }else{
    self.tableActivityInfo.pendingRequestCount=count;
    NSString*requestCount=[NSString stringWithFormat:@"%d",count];
    [(UILabel*)[self viewWithTag:235] setText:requestCount];
    }


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
        [(UIButton*)[self viewWithTag:7771]setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_sectionDivider.png"]]];
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
    
    [self.participantTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionOpened] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    
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

-(void)expandSectionHeaderView:(NSInteger)sectionOpened {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:sectionOpened];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToInsert = [self.participantTableView numberOfRowsInSection:sectionOpened];
    
    [self.participantTableView beginUpdates];
    if (countOfRowsToInsert > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
        }
        UITableViewRowAnimation insertAnimation;
        if(sectionOpened==0){
            insertAnimation=UITableViewRowAnimationBottom;
        }
        else{
            insertAnimation=UITableViewRowAnimationTop;
        }
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToDelete withRowAnimation:insertAnimation];
    }
    [self.participantTableView endUpdates];
    self.openSectionIndex = NSNotFound;
}

-(void)collapseSectionsExceptOne:(NSInteger)section{
    NSMutableArray *indexPathsToDelete1 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete2 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete3 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete4 = [[NSMutableArray alloc] init];
    
#if 0    
    if(section==1){
        noLine=TRUE; 
        [(UIButton*)[self viewWithTag:7771] setHidden:YES];
        
    }
    else{
        [(UIButton*)[self viewWithTag:7771] setHidden:NO];
        [(UIButton*)[self viewWithTag:7771]setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S04_sectionDivider.png"]]];
        noLine=FALSE;
    }
#endif
    
    
    
    for(int z=0;z<[self.sectionInfoArray count];z++){
        switch (z) {
            case 0:
            {
                if(z==section)
                  continue;
                else{
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete1 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
            }
                break;
                
            case 1:
            {
                if(z==section)
                    continue;
                else{
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        
                            [indexPathsToDelete2 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
            }
                break;
            case 2:
            {
                if(z==section)
                    continue;
                else{
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete3 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
            }
                break;
                
                
            case 3:
            {
                if(z==section)
                    continue;
                else{
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete4 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
            }
                break;

        }
    }
    UITableViewRowAnimation deleteAnimation;
    deleteAnimation = UITableViewRowAnimationBottom;
    [self.participantTableView beginUpdates];
      if([indexPathsToDelete1 count]>0)   
    [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete1 withRowAnimation:deleteAnimation];
     if([indexPathsToDelete2 count]>0)
    [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete2 withRowAnimation:deleteAnimation];
        
    if([indexPathsToDelete3 count]>0)   
            [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete3 withRowAnimation:deleteAnimation];
    
    if([indexPathsToDelete4 count]>0)   
        [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete4 withRowAnimation:deleteAnimation];


    [self.participantTableView endUpdates];
    self.openSectionIndex = section;
}
-(void)alternateBetweenSectionsWithCollapseOrExpand:(int)currentSectionIndex{
    
     NSMutableArray *indexPathsToDelete1 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert1 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToDelete2 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert2 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete3 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToInsert3 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete4 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToInsert4 = [[NSMutableArray alloc] init];

    for(int z=0;z<[self.sectionInfoArray count];z++){
        switch (z) {
            case 0:
            {
                if(z==self.openSectionIndex){
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete1 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                }
                else if(z==currentSectionIndex){
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert1 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }

                }
                
            }
                break;
                
            case 1:
            {
                if(z==self.openSectionIndex){
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete2 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                }
                else if(z==currentSectionIndex){
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert2 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
                
            }
                break;
                
            case 2:
            {
                if(z==self.openSectionIndex){
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete3 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                }
                else if(z==currentSectionIndex){
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert3 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
                
            }
                break;

            case 3:
            {
                if(z==self.openSectionIndex){
                    SectionInfo *previousOpenSection = [self.sectionInfoArray objectAtIndex:z];
                    previousOpenSection.open = NO;
                    NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
                    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                        [indexPathsToDelete4 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                }
                else if(z==currentSectionIndex){
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert4 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
                
            }
                break;

        }
    }
    
    [self.participantTableView beginUpdates];
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;

    insertAnimation = UITableViewRowAnimationTop;
    deleteAnimation = UITableViewRowAnimationBottom;

    if([indexPathsToInsert1 count]>0)
    [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert1 withRowAnimation:insertAnimation];

    if([indexPathsToDelete1 count]>0)
    [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete1 withRowAnimation:deleteAnimation];
    
    if([indexPathsToInsert2 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert2 withRowAnimation:insertAnimation];

    
    if([indexPathsToDelete2 count]>0)
        [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete2 withRowAnimation:deleteAnimation];
    
    if([indexPathsToInsert3 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert3 withRowAnimation:insertAnimation];
    
    
    if([indexPathsToDelete3 count]>0)
        [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete3 withRowAnimation:deleteAnimation];

    if([indexPathsToInsert4 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert4 withRowAnimation:insertAnimation];
    
    
    if([indexPathsToDelete4 count]>0)
        [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete4 withRowAnimation:deleteAnimation];


    
    [self.participantTableView endUpdates];
    self.openSectionIndex = currentSectionIndex;

}

-(void)openAllSectionsExceptOne{
    
     NSMutableArray *indexPathsToInsert1 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert2 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert3 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert4 = [[NSMutableArray alloc] init];

    
     for(int z=0;z<[self.sectionInfoArray count];z++){
        
        switch (z) {
            case 0:
            {
                if(z==self.openSectionIndex)
                    continue;
                else{
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert1 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
                
            }
                break;
                
            case 1:
            {
                if(z==self.openSectionIndex)
                    continue;
                else{
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert2 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
                
            }
                break;
                
            case 2:
            {
                if(z==self.openSectionIndex)
                    continue;
                else{
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert3 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
                
            }
                break;
            case 3:
            {
                if(z==self.openSectionIndex)
                    continue;
                else{
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert4 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
                    }
                    
                }
                
            }
                break;

        }
    }
    
    [self.participantTableView beginUpdates];
    UITableViewRowAnimation insertAnimation;
    insertAnimation = UITableViewRowAnimationTop;
    if([indexPathsToInsert1 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert1 withRowAnimation:insertAnimation];
    if([indexPathsToInsert2 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert2 withRowAnimation:insertAnimation];
    if([indexPathsToInsert3 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert3 withRowAnimation:insertAnimation];

    if([indexPathsToInsert4 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert4 withRowAnimation:insertAnimation];

    [self.participantTableView endUpdates];
    self.openSectionIndex = -1;

}
@end
