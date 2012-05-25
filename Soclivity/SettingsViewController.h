//
//  SettingsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController{
    BOOL isFBlogged;
    
}
@property (nonatomic,assign)BOOL isFBlogged;
-(void)logoutFromTheApp;
- (void)FBlogout;
@end
