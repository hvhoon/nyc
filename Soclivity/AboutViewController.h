//
//  AboutListViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyAnimationView.h"
#import "DetailedActivityInfoInvocation.h"
@class NotificationClass;
@class MainServiceManager;
@class SoclivityManager;
@protocol AboutViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface AboutViewController : UIViewController<NotifyAnimationViewDelegate,DetailedActivityInfoInvocationDelegate,UIViewControllerRestoration>{
    id <AboutViewDelegate>delegate;
    IBOutlet UIButton *btnnotify;
    NotificationClass *notIdObject;
    MainServiceManager *devServer;
    SoclivityManager *SOC;
}

@property (retain, nonatomic) IBOutlet UITextView *eula;
@property (nonatomic,retain)id <AboutViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UILabel *buildText;
@property(nonatomic,retain)    NotificationClass *notIdObject;
- (IBAction)profileSliderPressed:(id)sender;





@end
