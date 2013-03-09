//
//  UIBubbleTableViewDataSource.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <Foundation/Foundation.h>

@class ActivityChatData;
@class ChatTableView;


@protocol UIBubbleTableViewDataSource <NSObject>

@optional
-(void)removeBubbleDataObjectAtIndex:(NSInteger)objectIndex;
-(void)resignKeyBoard;
-(void)userInteraction:(BOOL)test;
-(void)userScrolledToLoadEarlierMessages;
-(NSInteger)earlierCount;
@required

- (NSInteger)rowsForBubbleTable:(ChatTableView *)tableView;
- (ActivityChatData *)bubbleTableView:(ChatTableView *)tableView dataForRow:(NSInteger)row;


@end
