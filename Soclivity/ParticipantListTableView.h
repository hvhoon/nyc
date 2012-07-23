//
//  ParticipantListTableView.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
@interface ParticipantListTableView : UIView<UITableViewDataSource,UITableViewDelegate,IconDownloaderDelegate>{
    
    IBOutlet UITableView *participantTableView;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray *DOS1_friendsArray;
    NSMutableArray *DOS2_friendsArray;
    NSMutableArray* sectionInfoArray;
    BOOL noLine;

}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)NSMutableArray *DOS1_friendsArray;
@property (nonatomic,retain)NSMutableArray *DOS2_friendsArray;
@property (nonatomic,retain)UITableView *participantTableView;
@property (nonatomic,assign)BOOL noLine;
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, assign) NSInteger uniformRowHeight;
@property (nonatomic, retain) NSMutableArray* sectionInfoArray;
-(void)sectionHeaderView:(NSInteger)sectionOpened;
-(void)closeSectionHeaderView:(NSInteger)sectionClosed;
-(void)setUpArrayWithBothSectionsClosed;
-(void)setUpArrayWithBothSectionsOpen;
-(void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)expandSectionHeaderView:(NSInteger)sectionOpened;
@end
