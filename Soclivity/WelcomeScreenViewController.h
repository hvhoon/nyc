//
//  WelcomeScreenViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookLogin.h"
@class MBProgressHUD;

@interface WelcomeScreenViewController : UIViewController<FacebookLoginDelegate>{
    UIView *rootView;
    UIImageView *playImageView;
    UIImageView *eatImageView;
    UIImageView *seeImageView;
    UIImageView *createImageView;
    UIImageView*learnImageView;
    int rnd;
    int backgroundState;
    MBProgressHUD *HUD;
}
-(void)performTransition;
-(void)SignUpButtonClicked;
-(void)SignInUsingFacebookButtonClicked;
-(void)AlreadySignedUpButtonClicked;
@end
