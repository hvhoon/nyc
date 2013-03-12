//
//  ChatTableView.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableViewCell.h"
#import "IconDownloader.h"
typedef enum _NSBubbleTypingType
{
    NSBubbleTypingTypeNobody = 0,
    NSBubbleTypingTypeMe = 1,
    NSBubbleTypingTypeSomebody = 2
} NSBubbleTypingType;


@interface ChatTableView : UITableView<UITableViewDelegate, UITableViewDataSource,UIBubbleTableViewCellDelegate,IconDownloaderDelegate>{
    BOOL isLoading;
    NSMutableDictionary *imageDownloadsInProgress;
}
@property (nonatomic,assign)BOOL isLoading;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain)NSMutableArray *bubbleSection;
@property (nonatomic, assign)id<UIBubbleTableViewDataSource> bubbleDataSource;
@property (nonatomic) NSTimeInterval snapInterval;
@property (nonatomic) NSBubbleTypingType typingBubble;


@end
