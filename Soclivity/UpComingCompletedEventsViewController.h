//
//  UpComingCompletedEventsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpcomingCompletedEvnetsViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface UpComingCompletedEventsViewController : UIViewController{
    id <UpcomingCompletedEvnetsViewDelegate>delegate;
}
@property (nonatomic,retain)id <UpcomingCompletedEvnetsViewDelegate>delegate;
-(IBAction)profileSliderPressed:(id)sender;

@end
