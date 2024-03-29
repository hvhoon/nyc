//
//  LoginViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainServiceManager;
@class MBProgressHUD;
@class AlertPrompt;

@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    UITextField *emailAddress;
    UITextField *password;
    UIImageView *backgroundView;
    int backgroundState;
    BOOL validEmail, validPassword;
    MainServiceManager *devServer;
    AlertPrompt *prompt;
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)IBOutlet UITextField *emailAddress;
@property (nonatomic,retain)IBOutlet UITextField *password;
@property (nonatomic,assign) int backgroundState;
-(IBAction)signUpButtonClicked:(id)sender;
-(IBAction)resetPassword:(id)sender;
-(IBAction)BackButtonClicked:(id)sender;
-(void)startPasswordResetEmailAnimation;
-(void)LoginInvocation;
-(void)startLoginAnimation;
-(void)SetUpHomeScreen;
@end
