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
#pragma mark -

@interface ParticipantListTableView ()

- (void)startIconDownload:(ParticipantClass *)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ParticipantListTableView
@synthesize DOS1_friendsArray,DOS2_friendsArray,imageDownloadsInProgress,participantTableView,openSectionIndex=openSectionIndex_,uniformRowHeight=rowHeight_,sectionInfoArray=sectionInfoArray_,noLine,pendingRequestArray,activityLinkIndex,otherParticipantsArray,editingOn;
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
    self.participantTableView.showsVerticalScrollIndicator=YES;
    
    if ((self.sectionInfoArray == nil) || ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.participantTableView])){
        [self setUpArrayWithTableSections];
    }
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
                        play.quotations=self.pendingRequestArray;
                        sectionInfo.play.relationType=0;
                    }
                    else{
                        play.quotations=self.DOS1_friendsArray;
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
                        play.quotations=self.DOS1_friendsArray;
                        sectionInfo.play.relationType=1;
                    }
                    else{
                        play.quotations=self.DOS2_friendsArray;
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
                        play.quotations=self.DOS2_friendsArray;
                        sectionInfo.play.relationType=2;
                    }
                    else{
                        play.quotations=self.otherParticipantsArray;
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
                    
                    play.quotations=self.otherParticipantsArray;
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
            [DOSImageView setHidden:YES];
            DOScountLabel.frame=CGRectMake(30, 7.5, 240, 12);
            DOScountLabel.text=[NSString stringWithFormat:@"%d Join Requests",[sectionInfo.play.quotations count]];
        }
            break;

        case 1:
        {
            DOSImageView.image=[UIImage imageNamed:@"S05_smallDOS1.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends",[sectionInfo.play.quotations count]];
        }
            break;
            
        case 2:
        {
            DOSImageView.image=[UIImage imageNamed:@"S05_smallDOS2.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends of friends",[sectionInfo.play.quotations count]];
        }
            break;
            
        case 3:
        {
            [DOSImageView setHidden:YES];
            DOScountLabel.frame=CGRectMake(30, 7.5, 240, 12);
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
        cell.indexPath=indexPath;
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
                cell.dosConnectionImage=[UIImage imageNamed:@"S05_smallDOS1.png"];
            }
                break;
                
                
            case 2:
            {
                cell.dosConnectionImage=[UIImage imageNamed:@"S05_smallDOS2.png"];
                
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


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(activityLinkIndex==6 && editingOn){
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InfoActivityClass *play = (InfoActivityClass *)[[self.sectionInfoArray objectAtIndex:indexPath.section] play];
    
    ParticipantClass *delete= [play.quotations objectAtIndex:indexPath.row];
    NSMutableArray *localArray=[NSMutableArray arrayWithArray:play.quotations];
    [localArray removeObjectIdenticalTo:delete];
    play.quotations=localArray;
    [participantTableView reloadData];	
}


#pragma mark -
#pragma mark Table cell View  Delegate Methods

-(void)ApproveRejectSelection:(NSIndexPath*)indexP request:(BOOL)request{
    
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
-(void)closeTwoSections:(NSInteger)section{
    NSMutableArray *indexPathsToDelete1 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete2 = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete3 = [[NSMutableArray alloc] init];
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

    [self.participantTableView endUpdates];
    self.openSectionIndex = section;
}
-(void)alternateBetweenSectionsWithCollapseOrExpand:(int)currentSectionIndex{
    
     NSMutableArray *indexPathsToDelete1 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert1 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToDelete2 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert2 = [[NSMutableArray alloc] init];

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
                    
                    /*
                     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
                     */
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
                    
                    /*
                     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
                     */
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert2 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
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
    if([indexPathsToInsert2 count]>0)
        [self.participantTableView insertRowsAtIndexPaths:indexPathsToInsert2 withRowAnimation:insertAnimation];

    if([indexPathsToDelete1 count]>0)
    [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete1 withRowAnimation:deleteAnimation];
    
    if([indexPathsToDelete2 count]>0)
        [self.participantTableView deleteRowsAtIndexPaths:indexPathsToDelete2 withRowAnimation:deleteAnimation];

    
    [self.participantTableView endUpdates];
    self.openSectionIndex = currentSectionIndex;

}

-(void)openAllSectionsExceptOne{
    
     NSMutableArray *indexPathsToInsert1 = [[NSMutableArray alloc] init];
     NSMutableArray *indexPathsToInsert2 = [[NSMutableArray alloc] init];
    for(int z=0;z<[self.sectionInfoArray count];z++){
        
        switch (z) {
            case 0:
            {
                if(z==self.openSectionIndex)
                    continue;
                else{
                    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:z];
                    
                    sectionInfo.open = YES;
                    
                    /*
                     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
                     */
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
                    
                    /*
                     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
                     */
                    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
                    
                    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                        [indexPathsToInsert2 addObject:[NSIndexPath indexPathForRow:i inSection:z]];
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
    [self.participantTableView endUpdates];
    self.openSectionIndex = -1;

}
@end
