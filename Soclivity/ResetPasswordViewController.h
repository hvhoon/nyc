//
//  ResetPasswordViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainServiceManager;
@interface ResetPasswordViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    IBOutlet UITextField *newPassword;
    IBOutlet UITextField *confirmPassword;
     MainServiceManager *devServer;
}
-(void)CrossClicked:(id)sender;
-(void)TickClicked:(id)sender;
@end
