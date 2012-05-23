//
//  BasicInfoView.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraCustom.h"
#import "LocationCustomManager.h"

#define kStopScrolling @"StopScrolling"
#define kStartScrolling @"StartScrolling"

#import "SoclivityManager.h"
@class  GetPlayersClass;
@protocol BasicRegistrationDelegate <NSObject>

@optional
-(void)timeToScrollDown;
-(void)dismissPickerModalController;
-(void)BackButtonClicked;
-(void)presentModal:(UIImagePickerController*)picker;
-(void)setPickerSettings;
-(void)hidePickerView:(id)sender;
-(void)DateisFineNoNeedToWorry;
@end



@interface BasicInfoView : UIView<UITextFieldDelegate,CustomCameraUploadDelegate,UIActionSheetDelegate,CoreLocationDelegate,UIAlertViewDelegate>{
    
    CameraCustom *cameraUpload;
    id <BasicRegistrationDelegate>delegate;
    LocationCustomManager *SocLocation;
    UITextField *enterNameTextField;
    UITextField *emailTextField;
    UITextField *enterPasswordTextField;
    UITextField *confirmPasswordTextField;
    IBOutlet UIButton *locationBtnText;
    IBOutlet UIButton *birthdayBtn;
    IBOutlet UIButton *profileBtn;
    IBOutlet UIButton *maleButton;
    IBOutlet UIButton *femaleButton;
    IBOutlet UIImageView *setYourPic;
    BOOL b_Male;
    BOOL b_Female;
    BOOL footerActivated;
    GetPlayersClass *playerObj;
    SoclivityManager *SOC;
    BOOL facebookTag;
    
}
@property (nonatomic,retain)id <BasicRegistrationDelegate>delegate;
@property (nonatomic,retain)IBOutlet UITextField *enterNameTextField;
@property (nonatomic,retain)IBOutlet UITextField *emailTextField;
@property (nonatomic,retain)IBOutlet UITextField *enterPasswordTextField;
@property (nonatomic,retain)IBOutlet UITextField *confirmPasswordTextField;
@property (nonatomic,retain) GetPlayersClass *playerObj;
@property (nonatomic,assign)BOOL facebookTag;
-(void)showUploadCaptureSheet;
-(void)PushImageGallery;
-(void)PushCamera;
-(IBAction)LocationButtonClicked:(id)sender;
-(IBAction)genderChanged:(UIButton*)sender;
-(IBAction)ProfileBtnClicked:(UIButton*)sender;
-(IBAction)birthdayDateSelection:(id)sender;
-(IBAction)BackButtonClicked:(id)sender;
-(UIImage*)autoCrop:(UIImage*)image;
-(UIImage*)compressImage:(UIImage*)image size:(CGSize)size;
-(void)hideBirthdayPicker;
-(void)dateSelected:(NSDate*)bDate;
-(void)BasicInfoFields;
@end
