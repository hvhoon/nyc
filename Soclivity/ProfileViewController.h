//
//  ProfileViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface ProfileViewController : UIViewController{
    id <ProfileScreenViewDelegate>delegate;
}
@property (nonatomic,retain)id <ProfileScreenViewDelegate>delegate;
-(IBAction)profileSliderPressed:(id)sender;
@end