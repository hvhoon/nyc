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
@interface NotifyAnimationView : UIView{
    NSTimer *timer;
    NSInteger counter;
}
@property (nonatomic,retain)TTTAttributedLabel *summaryLabel;
- (id)initWithFrame:(CGRect)frame andNotif:(NotificationClass*)andNotif;
@end
