//
//  NotificationsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NotificationsScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface NotificationsViewController : UIViewController{
    id <NotificationsScreenViewDelegate>delegate;
    IBOutlet UILabel *waitingOnYouLabel;
}
@property (nonatomic,retain)id <NotificationsScreenViewDelegate>delegate;
-(IBAction)profileSliderPressed:(id)sender;

@end
