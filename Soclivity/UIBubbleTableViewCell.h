//
//  UIBubbleTableViewCell.h
//  Soclivity
//
//  Created by Kanav Gupta on 05/03/13.
//
//

#import <UIKit/UIKit.h>
#import "ActivityChatData.h"

@protocol UIBubbleTableViewCellDelegate <NSObject>

@optional
-(void)deleteThisSection:(NSInteger)sectionIndex;
-(void)tellToStopInteraction:(BOOL)tell;

-(void)showMenu:(ActivityChatData*)type tapTypeSelect:(NSInteger)tapTypeSelect;
@end

@interface UIBubbleTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>{
id <UIBubbleTableViewCellDelegate>delegate;
}


@property (nonatomic, strong) ActivityChatData *data;
@property (nonatomic) BOOL showAvatar;
@property (nonatomic,retain)id<UIBubbleTableViewCellDelegate>delegate;
@property (nonatomic,assign)NSInteger section;

@end

@interface CHDemoView : UIView
- (void)singleTapAction:(UITapGestureRecognizer*)ges;
@property (nonatomic,assign)CGRect originRect;
@end