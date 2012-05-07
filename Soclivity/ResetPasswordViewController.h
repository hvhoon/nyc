//
//  ResetPasswordViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *newPassword;
    IBOutlet UITextField *confirmPassword;
}
-(void)CrossClicked:(id)sender;
-(void)TickClicked:(id)sender;
@end
