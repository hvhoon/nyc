//
//  BasicInfoView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicInfoView.h"
#import "SoclivityUtilities.h"
#import <QuartzCore/QuartzCore.h>

#define kPicture 0
#define kName 1
#define kEmail 2
#define kPassword 3
#define kConfirm 4
#define kBirthday 5

@implementation BasicInfoView
@synthesize delegate,enterNameTextField,emailTextField,enterPasswordTextField,confirmPasswordTextField;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
-(IBAction)LocationButtonClicked:(id)sender{
    SocLocation=[[LocationCustomManager alloc]init];
    SocLocation.delegate=self;
    SocLocation.theTag=kNoLocation;

}
-(void)LocationAcquired:(NSString*)SoclivityLoc{
    if(SoclivityLoc!=nil){
        
    [locationBtnText setBackgroundImage:nil forState:UIControlStateNormal];
    [locationBtnText setTitle:SoclivityLoc forState:UIControlStateNormal];
    }
}
-(IBAction)sectionViewChanged:(id)sender{
    [delegate timeToScrollDown];
}



        
-(void)showUploadCaptureSheet{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Upload my profile picture"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Image Gallery", @"Photo Capture",nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    [sheet release];
    
    
}


-(IBAction)birthdayDateSelection:(id)sender{
    
}
#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //restore view opacities to normal
    
    switch (buttonIndex) {
        case 0:
        {
            [self PushImageGallery];
        }
            break;
            
        case 1:
        {
            [self PushCamera];
        }
            break;
    }
    
}

#pragma mark -
#pragma  mark CustomCamera Gallery and Capture Methods 

-(void)PushImageGallery{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
	if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        
		cameraUpload.m_picker.sourceType = sourceType;
        [delegate presentModal:cameraUpload.m_picker];
    }
    
}


-(void)PushCamera{
    UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
	if([UIImagePickerController isSourceTypeAvailable:sourceType]){
		cameraUpload.m_picker.sourceType = sourceType;
        [delegate presentModal:cameraUpload.m_picker];
        
	}
    
}

-(void)imageCapture:(NSString*)photoUrl andUIImage:(UIImage*)andUIImage{
    NSLog(@"UIimage from Gallery=%@",andUIImage);
    [delegate dismissPickerModalController];
    
    CGRect bounds = CGRectMake(0,0,30, 30);
    UIImage *capturedImg=[SoclivityUtilities updateResult:bounds.size originalImage:andUIImage switchCaseIndex:0];

}

-(void)dismissPickerModalController{
    
    [delegate dismissPickerModalController];
}


-(IBAction)ProfileBtnClicked:(UIButton*)sender{
    cameraUpload=[[CameraCustom alloc]init];
    cameraUpload.delegate=self;
    [self showUploadCaptureSheet];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[sender resignFirstResponder];
     NSLog(@"touchesBegan");
}
#pragma mark -
#pragma mark UITextFieldDelegate Methods


- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
    NSLog(@"textFieldDidBeginEditing");
    if((textField==enterPasswordTextField)||(textField==confirmPasswordTextField)){
        
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        CGRect rect = CGRectMake(0, -80, 320, 480);
        self.frame = rect;
        [UIView commitAnimations];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	
    [textField resignFirstResponder];
	
    if((textField==enterPasswordTextField)||(textField==confirmPasswordTextField)){
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.25];
		CGRect rect = CGRectMake(0, 0, 320, 480);
		self.frame = rect;
		[UIView commitAnimations];
        
		
        
    }
	return NO;
}


@end
