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
#define kCustomRowHeight    60.0
#define kSectionHeaderHeight    35.0
#pragma mark -

@interface ParticipantListTableView ()

- (void)startIconDownload:(ParticipantClass *)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ParticipantListTableView
@synthesize DOS1_friendsArray,DOS2_friendsArray,imageDownloadsInProgress;
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
    [participantTableView reloadData];
    participantTableView.separatorColor=[UIColor clearColor];

}
#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)


#pragma mark -
#pragma  mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


// customize the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            
            if([DOS1_friendsArray count]==0)
                return 1;
            
            return [DOS1_friendsArray count];
        }
            break;
            
        case 1:
        {
            
            if([DOS2_friendsArray count]==0)
                return 1;

            return [DOS2_friendsArray count];
        }
            break;
   
            
            
        default:
        {
            return 0;
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
  return kSectionHeaderHeight;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCustomRowHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionHeaderview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,30)]autorelease];
    sectionHeaderview.backgroundColor=[SoclivityUtilities returnTextFontColor:7];
    
    UIView *topDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,0,320,2)]autorelease];
    topDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
    [sectionHeaderview addSubview:topDividerLineview];
    
    UIImageView *DOSImageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 19, 11)];
    

    CGRect DOSLabelRect=CGRectMake(55,10,140,12);
    UILabel *DOScountLabel=[[UILabel alloc] initWithFrame:DOSLabelRect];
    DOScountLabel.textAlignment=UITextAlignmentLeft;
    
    DOScountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
    DOScountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    DOScountLabel.backgroundColor=[UIColor clearColor];
    
    
    switch (section) {
        case 0:
        {
            DOSImageView.image=[UIImage imageNamed:@"S05_smallDOS1.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends",[self.DOS1_friendsArray count]];
        }
            break;
            
        case 1:
        {
            DOSImageView.image=[UIImage imageNamed:@"S05_smallDOS2.png"];
            DOScountLabel.text=[NSString stringWithFormat:@"%d Friends of friends",[self.DOS2_friendsArray count]];
        }
            break;
            
            
            
    }
    
    
    [sectionHeaderview addSubview:DOSImageView];
    [DOSImageView release];
    [sectionHeaderview addSubview:DOScountLabel];
    [DOScountLabel release];

    UIView *bottomDividerLineview=[[[UIView alloc]initWithFrame:CGRectMake(0,33,320,2)]autorelease];
    bottomDividerLineview.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"S05_descriptionLine.png"]];
     [sectionHeaderview addSubview:bottomDividerLineview];
        
    return sectionHeaderview;  
    
    
}	


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"MediaTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    int nodeCount;
    switch (indexPath.section) {
        case 0:
        {
            nodeCount = [self.DOS1_friendsArray count];
        }
            break;
            
        case 1:
        {
            nodeCount = [self.DOS2_friendsArray count];
        }
            break;
    }
    
    if (nodeCount == 0 && indexPath.row == 0)
        {
            ParticipantTableViewCell *cell = (ParticipantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
            if (cell == nil)
            {
                cell = [[[ParticipantTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                          reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if(indexPath.section==0)
            cell.textLabel.text = @"No friends have joined yet…";
            else{
                cell.textLabel.text = @"No friends of friends have joined yet…";
            }
            
            return cell;
        }
        
        ParticipantTableViewCell *cell =  (ParticipantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[ParticipantTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                      reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        }
        
        // Leave cells empty if there's no data yet
        if (nodeCount > 0)
        {
            // Set up the cell...
            ParticipantClass *appRecord=nil;
            switch (indexPath.section) {
                case 0:
                {
                    appRecord = [self.DOS1_friendsArray objectAtIndex:indexPath.row];
                }
                    break;
                    
                case 1:
                {
                    appRecord = [self.DOS2_friendsArray objectAtIndex:indexPath.row];
                }
                    break;
            }
            
            cell.nameText=appRecord.name;
            
            
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
            
        }
        
        [cell setNeedsDisplay];
        return cell;
        
    
}


#pragma mark -
#pragma mark Table cell image support

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selection Made");
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
    if ([self.DOS1_friendsArray count] > 0)
    {
        NSArray *visiblePaths = [participantTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ParticipantClass *appRecord = [self.DOS1_friendsArray objectAtIndex:indexPath.row];
            
            if (!appRecord.profilePhotoImage) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
    
    
    if ([self.DOS2_friendsArray count] > 0)
    {
        NSArray *visiblePaths = [participantTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ParticipantClass *appRecord = [self.DOS2_friendsArray objectAtIndex:indexPath.row];
            
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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



- (void)dealloc {
    [super dealloc];
}


@end
