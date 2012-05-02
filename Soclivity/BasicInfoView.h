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

@protocol BasicRegistrationDelegate <NSObject>

@optional
-(void)timeToScrollDown;
-(void)dismissPickerModalController;
-(void)presentModal:(UIImagePickerController*)picker;
@end



@interface BasicInfoView : UIControl<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomCameraUploadDelegate,UIActionSheetDelegate,CoreLocationDelegate>{
    
    UITableView *basicInfoTableView;
    CameraCustom *cameraUpload;
    id <BasicRegistrationDelegate>delegate;
    LocationCustomManager *SocLocation;
    UILabel *locationLabel;
}
@property (nonatomic,retain)id <BasicRegistrationDelegate>delegate;
-(void)showUploadCaptureSheet;
-(void)PushImageGallery;
-(void)PushCamera;
-(void)LocationButtonClicked;
-(IBAction)sectionViewChanged:(id)sender;
@end
