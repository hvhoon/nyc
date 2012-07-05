//
//  ActivityEventViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventView.h"
@class InfoActivityClass;
@interface ActivityEventViewController : UIViewController<AddEventViewDelegate>{
    
    IBOutlet AddEventView *eventView;
    InfoActivityClass *activityInfo;
    IBOutlet UIButton *chatButton;
    IBOutlet UIButton *addEventButton;
    IBOutlet UIButton *leaveActivityButton;
    IBOutlet UIImageView *bottomBarImageView;

}
@property (nonatomic,retain)InfoActivityClass *activityInfo;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)addEventActivityPressed:(id)sender;
-(IBAction)leaveEventActivityPressed:(id)sender;

@end
