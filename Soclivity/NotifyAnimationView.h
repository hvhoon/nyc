//
//  NotifyAnimationView.h
//  Soclivity
//
//  Created by Kanav Gupta on 17/02/13.
//
//

#import <UIKit/UIKit.h>
@class NotificationClass;
@class TTTAttributedLabel;

@protocol NotifyAnimationViewDelegate <NSObject>

@optional
-(void)backgroundTapToPush:(NotificationClass*)notification;
-(void)notificationViewHide;
@end

@interface NotifyAnimationView : UIView{
    NSTimer *timer;
    NSInteger counter;
    id<NotifyAnimationViewDelegate>delegate;
    NotificationClass *inAppNotif;
}
@property(nonatomic,retain)id<NotifyAnimationViewDelegate>delegate;
@property (nonatomic,retain)TTTAttributedLabel *summaryLabel;
@property (nonatomic,retain)NotificationClass *inAppNotif;
- (id)initWithFrame:(CGRect)frame andNotif:(NotificationClass*)andNotif;
@end
