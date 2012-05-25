//
//  ResetPasswordViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainServiceManager;
@class MBProgressHUD;
@interface ResetPasswordViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    IBOutlet UITextField *newPassword;
    IBOutlet UITextField *confirmPassword;
    MainServiceManager *devServer;
    NSInteger idSoc;
    NSString *oldPassword;
    int backgroundState;
    UIImageView *backgroundView;
    MBProgressHUD *HUD;
}
@property (nonatomic,assign)NSInteger idSoc;
@property (nonatomic,retain)NSString *oldPassword;
@property (nonatomic,assign) int backgroundState;
-(void)CrossClicked:(id)sender;
-(void)TickClicked:(id)sender;
-(void)startUpdatePasswordAnimation;
@end
