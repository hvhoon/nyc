//
//  CameraCustom.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol CustomCameraUploadDelegate <NSObject>

@optional
-(void)dismissPickerModalController;
-(void)imageCapture:(UIImage*)Img;
@end
@interface CameraCustom : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIImagePickerController *m_picker;
    id<CustomCameraUploadDelegate>delegate;
    BOOL galleryImage;
}
@property(nonatomic,retain) UIImagePickerController *m_picker;
@property (nonatomic,retain) id<CustomCameraUploadDelegate>delegate;
@property (nonatomic,assign) BOOL galleryImage;
@end
    