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

@class InfoActivityClass;
@class ParticipantClass;
@protocol ParticipantListDelegate <NSObject>

@optional
-(void)confirm_RejectPlayerToTheEvent:(BOOL)request playerId:(NSInteger)playerId;
-(void)removeParticipantFromEvent:(NSInteger)playerId;
-(void)pushToprofileOfThePlayer:(ParticipantClass*)player;
@end

@interface ParticipantListTableView : UIView<UITableViewDataSource,UITableViewDelegate,IconDownloaderDelegate,ParticipantTableViewCellDelegate,UIGestureRecognizerDelegate>{
    
    IBOutlet UITableView *participantTableView;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray* sectionInfoArray;
    NSMutableArray* otherParticipantsArray;
    InfoActivityClass *tableActivityInfo;
    BOOL noLine;
    int activityLinkIndex;
    NSIndexPath *lastIndexPath;
    BOOL swipeOn;
    id <ParticipantListDelegate>delegate;
    NSIndexPath *playerAprRejIndexpath;
    NSIndexPath *removePlayerIndexPath;
    ParticipantClass *tempParticipantObj;

}
@property (nonatomic,retain)  id <ParticipantListDelegate>delegate;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)UITableView *participantTableView;
@property (nonatomic,assign)BOOL noLine;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
@property (nonatomic,assign)int activityLinkIndex;
@property (nonatomic,retain)InfoActivityClass *tableActivityInfo;
@property (nonatomic,retain)NSIndexPath *removePlayerIndexPath;
@property (nonatomic,retain)NSIndexPath *playerAprRejIndexpath;
@property (nonatomic,retain)ParticipantClass *tempParticipantObj;
-(void)sectionHeaderView:(NSInteger)sectionOpened;
-(void)closeSectionHeaderView:(NSInteger)sectionClosed;
-(void)setUpArrayWithTableSections;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)expandSectionHeaderView:(NSInteger)sectionOpened;
-(void)collapseSectionsExceptOne:(NSInteger)section;
-(void)alternateBetweenSectionsWithCollapseOrExpand:(int)currentSectionIndex;
-(void)openAllSectionsExceptOne;
-(void)updateParticipantListView:(BOOL)response;
-(void)updatePlayerListWithSectionHeaders;
-(void)setTheSectionHeaderCount:(NSInteger)type changeCountTo:(NSInteger)changeCountTo increment:(BOOL)increment;
@end
