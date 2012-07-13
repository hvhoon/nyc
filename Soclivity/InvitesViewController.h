//
//  InvitesViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InvitesViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface InvitesViewController : UIViewController{
    id <InvitesViewDelegate>delegate;
}
@property (nonatomic,retain)id <InvitesViewDelegate>delegate;
-(IBAction)profileSliderPressed:(id)sender;

@end
