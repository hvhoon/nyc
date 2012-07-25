//
//  ParticipantListTableView.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoActivityClass;
#import "IconDownloader.h"
#import "ParticipantTableViewCell.h"
@interface ParticipantListTableView : UIView<UITableViewDataSource,UITableViewDelegate,IconDownloaderDelegate,ParticipantTableViewCellDelegate>{
    
    IBOutlet UITableView *participantTableView;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray* sectionInfoArray;
    NSMutableArray* otherParticipantsArray;
    InfoActivityClass *tableActivityInfo;
    BOOL noLine;
    int activityLinkIndex;
    BOOL editingOn;
    

}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)UITableView *participantTableView;
@property (nonatomic,assign)BOOL noLine;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic,assign)int activityLinkIndex;
@property (nonatomic,assign)BOOL editingOn;
@property (nonatomic,retain)InfoActivityClass *tableActivityInfo;
-(void)sectionHeaderView:(NSInteger)sectionOpened;
-(void)closeSectionHeaderView:(NSInteger)sectionClosed;
-(void)setUpArrayWithTableSections;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)expandSectionHeaderView:(NSInteger)sectionOpened;
-(void)collapseSectionsExceptOne:(NSInteger)section;
-(void)alternateBetweenSectionsWithCollapseOrExpand:(int)currentSectionIndex;
-(void)openAllSectionsExceptOne;
-(void)setTheSectionHeaderCount:(NSInteger)type changeCountTo:(NSInteger)changeCountTo;
@end
