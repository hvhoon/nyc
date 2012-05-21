//
//  LoginViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainServiceManager;
@interface LoginViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    UITextField *emailAddress;
    UITextField *password;
    UIImageView *backgroundView;
    int backgroundState;
    BOOL validEmail, validPassword;
    MainServiceManager *devServer;
}
@property (nonatomic,retain)IBOutlet UITextField *emailAddress;
@property (nonatomic,retain)IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressGear;
@property (retain, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (nonatomic,assign) int backgroundState;
-(IBAction)signUpButtonClicked:(id)sender;
-(IBAction)resetPassword:(id)sender;
-(IBAction)BackButtonClicked:(id)sender;
@end
