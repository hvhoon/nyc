//
//  LoginViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>{
    UITextField *emailAddress;
    UITextField *password;
    UIButton *checkboxBtn;
    BOOL checkBoxStatus;
    UIImageView *backgroundView;
    int backgroundState;
}
@property (nonatomic,retain)IBOutlet UITextField *emailAddress;
@property (nonatomic,retain)IBOutlet UITextField *password;
@property (nonatomic,retain)IBOutlet UIButton *checkboxBtn;
@property (nonatomic,assign) int backgroundState;
-(IBAction)signUpButtonClicked:(id)sender;
-(IBAction)resetPassword:(id)sender;
-(IBAction)checkBoxClicked:(id)sender;
-(IBAction)BackButtonClicked:(id)sender;
@end
