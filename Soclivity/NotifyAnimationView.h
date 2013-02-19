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
-(void)backgroundTapToPush:(NotificationClass*)inAppNotif;
@end

@interface NotifyAnimationView : UIView{
    NSTimer *timer;
    NSInteger counter;
    id<NotifyAnimationViewDelegate>delegate;
    NotificationClass *notification;
}
@property(nonatomic,retain)id<NotifyAnimationViewDelegate>delegate;
@property (nonatomic,retain)TTTAttributedLabel *summaryLabel;
@property (nonatomic,retain)NotificationClass *notification;
- (id)initWithFrame:(CGRect)frame andNotif:(NotificationClass*)andNotif;
@end
