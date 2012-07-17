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
}
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)NSMutableArray *DOS1_friendsArray;
@property (nonatomic,retain)NSMutableArray *DOS2_friendsArray;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
@end
