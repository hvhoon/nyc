//
//  ParticipantListTableView.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "ParticipantTableViewCell.h"
@interface ParticipantListTableView : UIView<UITableViewDataSource,UITableViewDelegate,IconDownloaderDelegate,ParticipantTableViewCellDelegate>{
    
    IBOutlet UITableView *participantTableView;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray *DOS1_friendsArray;
    NSMutableArray *DOS2_friendsArray;
    NSMutableArray* sectionInfoArray;
    NSMutableArray* pendingRequestArray;
    NSMutableArray* otherParticipantsArray;
    BOOL noLine;
    int activityLinkIndex;
    

}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)NSMutableArray *DOS1_friendsArray;
@property (nonatomic,retain)NSMutableArray *DOS2_friendsArray;
@property (nonatomic,retain)UITableView *participantTableView;
@property (nonatomic,assign)BOOL noLine;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic, retain) NSMutableArray* pendingRequestArray;
@property (nonatomic, retain)NSMutableArray* otherParticipantsArray;
@property (nonatomic,assign)int activityLinkIndex;
-(void)sectionHeaderView:(NSInteger)sectionOpened;
-(void)closeSectionHeaderView:(NSInteger)sectionClosed;
-(void)setUpArrayWithTableSections;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)expandSectionHeaderView:(NSInteger)sectionOpened;
-(void)closeTwoSections:(NSInteger)section;
-(void)alternateBetweenSectionsWithCollapseOrExpand:(int)currentSectionIndex;
-(void)openAllSectionsExceptOne;
@end
