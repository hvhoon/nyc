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
#import "GetPlayersClass.h"
#import "SoclivityManager.h"
#define kPicture 0
#define kName 1
#define kEmail 2
#define kPassword 3
#define kConfirm 4
#define kBirthday 5

#define kMale 6
#define kFemale 7

#define kAllEmptyFields 8
#define kNameNot 9
#define kEntryAdded 10
#define kEmailNot 11
#define kPasswordNot 12
#define kConfirmPasswordNot 13
#define kFutureBirthdayDate 14
@implementation BasicInfoView
@synthesize delegate,enterNameTextField,emailTextField,enterPasswordTextField,confirmPasswordTextField,playerObj;
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
    // Customized fonts
    enterNameTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    enterNameTextField.textColor=[SoclivityUtilities returnTextFontColor:1];
    
    emailTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    emailTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    enterNameTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    enterNameTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    enterPasswordTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    enterPasswordTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    confirmPasswordTextField.font = [UIFont fontWithName:@"Helvetica-Condensed" size:15];
    confirmPasswordTextField.textColor=[SoclivityUtilities returnTextFontColor:1];

    birthdayBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
    
    locationBtnText.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:15];
    
    
}
-(IBAction)BackButtonClicked:(id)sender{
    [delegate BackButtonClicked];
}
-(IBAction)LocationButtonClicked:(id)sender{
    SocLocation=[[LocationCustomManager alloc]init];
    SocLocation.delegate=self;
    SocLocation.theTag=kNoLocation;

}
-(void)LocationAcquired:(NSString*)SoclivityLoc{
    if(SoclivityLoc!=nil){
        [locationBtnText setTitle:SoclivityLoc forState:UIControlStateNormal];
        [locationBtnText setTitleColor:[SoclivityUtilities returnTextFontColor:1] forState:UIControlStateNormal];
    }
}
-(IBAction)genderChanged:(UIButton*)sender{
    
    switch (sender.tag) {
        case kMale:
        {
            
            b_Male=!b_Male;
             [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_F_notselected.png"] forState:UIControlStateNormal];
            
            if(b_Male){
            [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_male.png"] forState:UIControlStateNormal];
                b_Female=FALSE;
            }else{
                [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_M_notselected.png"] forState:UIControlStateNormal];
                
            }
           

        }
            break;
            
        case kFemale:
        {
            b_Female=!b_Female;
            
            [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_M_notselected.png"] forState:UIControlStateNormal];

            if(b_Female){
            [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_female.png"] forState:UIControlStateNormal];
                b_Male=FALSE;
            }
            else{
                [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_F_notselected.png"] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
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
    
    
    [delegate setPickerSettings];
    
    if (!footerActivated) {
         
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect rect = CGRectMake(0, -156, 320, 480);
    self.frame = rect;
    [UIView commitAnimations];
        footerActivated = YES;
     }
}

-(void)dateSelected:(NSDate*)bDate{
    
    NSLog(@"bDate=%@ and todayDate=%@",bDate,[NSDate date]);
//    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
//	
//	NSInteger destinationGMTOffset2 = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];
//    NSInteger destinationGMTOffset1 = [destinationTimeZone secondsFromGMTForDate:bDate];
	
//	NSTimeInterval interval2 = destinationGMTOffset2;
//    
//    NSTimeInterval interval1 = destinationGMTOffset1;
    
    NSTimeInterval interval = [bDate timeIntervalSinceDate: [NSDate date]];
    
     NSLog(@"interval=%f",interval);

    if ([bDate compare:[NSDate date]] == NSOrderedDescending) {
        NSLog(@"date1 is later than date2");
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry,you can't choose a future birthday date"
															message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            alert.tag=kFutureBirthdayDate;
			[alert show];
			[alert release];
			return;
			
		}
        
    } else if ([bDate compare:[NSDate date]] == NSOrderedAscending) {
        NSLog(@"date1 is earlier than date2");
        [delegate hidePickerView:nil];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat=@"MMMM d, YYYY";
        NSString*date=[dateFormatter stringFromDate:bDate];
        [birthdayBtn setTitle:date forState:UIControlStateNormal];
        [birthdayBtn setTitleColor:[SoclivityUtilities returnTextFontColor:1] forState:UIControlStateNormal];
        dateFormatter.dateFormat=@"d/MM/YYYY";
        NSString*postDate=[dateFormatter stringFromDate:bDate];
        playerObj.birth_date=postDate;
        [dateFormatter release];
        
    } 
    

}

-(void)BasicInfoFields{
	
        SoclivityManager *SOC=[SoclivityManager SharedInstance];
	    SOC.basicInfoDone=FALSE;
        NSMutableCharacterSet *alphaSetName = [NSMutableCharacterSet characterSetWithCharactersInString:@"_"];
        [alphaSetName formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
        
        NSMutableCharacterSet *alphaSetEmail = [NSMutableCharacterSet characterSetWithCharactersInString:@"@"];
        [alphaSetEmail formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
		[alphaSetEmail formUnionWithCharacterSet:alphaSetName];
        
    NSLog(@"enterNameTextField=%@",enterNameTextField.text);
    NSLog(@"emailTextField=%@",emailTextField.text);
    NSLog(@"enterPasswordTextField=%@",enterPasswordTextField.text);
    NSLog(@"confirmPasswordTextField=%@",confirmPasswordTextField.text);
    
    
    if(!enterNameTextField.text.length && !emailTextField.text.length && !enterPasswordTextField.text.length && !confirmPasswordTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required to register"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kAllEmptyFields;
        [alert show];
        [alert release];
        return;
        
    }
		
		if(([enterNameTextField.text isEqualToString:@""]) &&(!emailTextField.text.length||![emailTextField.text isEqualToString:@""]) && (!enterPasswordTextField.text.length||![enterPasswordTextField.text isEqualToString:@""]) && (!confirmPasswordTextField.text.length||![confirmPasswordTextField.text isEqualToString:@""]))
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required"
															message:@"Please Enter a name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            alert.tag=kNameNot;
			[alert show];
			[alert release];
			return;
			
		}
    
    NSUInteger newLength = [enterNameTextField.text length]; 
    if(newLength<2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"name must be minimum 2 characters"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNameNot;
        [alert show];
        [alert release];
        return;
        
        
    }
    
    
    
    enterNameTextField.text= [enterNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    BOOL userNameValid = [[enterNameTextField.text stringByTrimmingCharactersInSet:alphaSetName] isEqualToString:@""];
    
    
    if(userNameValid==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"name has invalid characters"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNameNot;
        [alert show];
        [alert release];
        return;
        
        
    }
		
		if((!enterNameTextField.text.length||![enterNameTextField.text isEqualToString:@""]) && ([emailTextField.text isEqualToString:@""]) && (!enterPasswordTextField.text.length||![enterPasswordTextField.text isEqualToString:@""]) && (!confirmPasswordTextField.text.length||![confirmPasswordTextField.text isEqualToString:@""]))
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required"
															message:@"please enter your email address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            alert.tag=kEmailNot;
			[alert show];
			[alert release];
			return;
			
		}
    
    NSString *searchForMe = @"@";
    NSRange rangeCheckAtTheRate = [emailTextField.text rangeOfString : searchForMe];
    
    NSString *searchFor = @".";
    NSRange rangeCheckFullStop = [emailTextField.text rangeOfString : searchFor];
    
    
    if (rangeCheckAtTheRate.location != NSNotFound && rangeCheckFullStop.location !=NSNotFound) {
        NSLog(@"I found @ and .");
    }
    
    
    //	BOOL emailAddressValid = [[emailAddress.text stringByTrimmingCharactersInSet:alphaSetEmail] isEqualToString:@"@"];
    
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a valid email address"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kEmailNot;
        [alert show];
        [alert release];
        return;
    }

    NSString * charToCount = @"@";
    NSArray * array = [emailTextField.text componentsSeparatedByString:charToCount];
    NSInteger numberOfChar=[array count]-1;
    NSLog(@"Count is: %i",[array count] - 1);
    
    if(numberOfChar>1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a valid email address"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kEmailNot;
        [alert show];
        [alert release];
        return;
        
        
    }
    
    BOOL emailAddressValid = [[emailTextField.text stringByTrimmingCharactersInSet:alphaSetEmail] isEqualToString:@""];
    
    
    if(emailAddressValid==NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email has invalid characters"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kEmailNot;
        [alert show];
        [alert release];
        return;
        
        
    }
		if((!enterNameTextField.text.length||![enterNameTextField.text isEqualToString:@""]) && (!emailTextField.text.length||![emailTextField.text isEqualToString:@""]) && ([enterPasswordTextField.text isEqualToString:@""]) && (!confirmPasswordTextField.text.length||![confirmPasswordTextField.text isEqualToString:@""]))
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required"
															message:@"please enter your password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
          alert.tag=kPasswordNot;

			[alert show];
			[alert release];
			return;
			
		}
    
    BOOL passwordValid = [[enterPasswordTextField.text stringByTrimmingCharactersInSet:alphaSetName] isEqualToString:@""];
    
    if(passwordValid==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password has invalid characters"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordNot;
        [alert show];
        [alert release];
        return;
        
        
    }

    
    if([enterPasswordTextField.text length]<6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password must be min of 6 characters"
                                                        message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordNot;
        [alert show];
        [alert release];
        return;
        
        
    }

		if((!enterNameTextField.text.length||![enterNameTextField.text isEqualToString:@""]) && (!emailTextField.text.length||![emailTextField.text isEqualToString:@""]) && (!enterPasswordTextField.text.length||![enterPasswordTextField.text isEqualToString:@""]) && [confirmPasswordTextField.text isEqualToString:@""])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required"
															message:@"please confirm your password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            alert.tag=kConfirmPasswordNot;
            [alert show];
			[alert release];
			return;
			
		}
		
		
		
		
                
        
        //	NSScanner *mainScanner = [NSScanner scannerWithString:emailAddress.text];
        //		NSInteger numberOfChar=0;
        //	while([mainScanner isAtEnd]==NO)
        //	{
        //			if ([mainScanner scanString:@"@" intoString:NULL] )
        //			
        //		numberOfChar++;
        //	}
        
       if([enterPasswordTextField.text isEqualToString:confirmPasswordTextField.text])
        {
            NSLog(@"Password Matched");
            
            SOC.basicInfoDone=TRUE;
        }
        else {
            
           enterPasswordTextField.text=@"";
           confirmPasswordTextField.text=@"";
            
            UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Password does not match" 
            message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
             passwordAlert.tag=kPasswordNot;
            [passwordAlert show];
            [passwordAlert release];
            
            return;
        }
        
}
#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 0) {
 
    switch (alertView.tag) {
        case kAllEmptyFields:
        {
            [enterNameTextField becomeFirstResponder];
        }
            break;
            
        case kNameNot:
        {
            [enterNameTextField becomeFirstResponder];
        }
            break;
        case kEmailNot:
        {
            [emailTextField becomeFirstResponder];
        }
            
            break;
        case kPasswordNot:
        {
            [enterPasswordTextField becomeFirstResponder];
        }
            break;
        case kConfirmPasswordNot:
        {
            [confirmPasswordTextField becomeFirstResponder];
        }
            break;
         default:
            break;
    }
    }
    else{
        NSLog(@"Clicked Cancel Button");
    }
}
-(void)hideBirthdayPicker{
    if (footerActivated) {
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        CGRect rect = CGRectMake(0, 0, 320, 480);
        self.frame = rect;

        [UIView commitAnimations];
        footerActivated=NO;
    }
    
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
        cameraUpload.galleryImage=TRUE;
		cameraUpload.m_picker.sourceType = sourceType;
        [delegate presentModal:cameraUpload.m_picker];
    }
    
}


-(void)PushCamera{
    UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
	if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        cameraUpload.galleryImage=FALSE;
		cameraUpload.m_picker.sourceType = sourceType;
        [delegate presentModal:cameraUpload.m_picker];
        
	}
    
}

-(void)imageCapture:(UIImage*)Img{
    [delegate dismissPickerModalController];
    
    // If the image is not a square please auto crop
    if(Img.size.height != Img.size.width)
        Img = [self autoCrop:Img];
    
    // If the image needs to be compressed
    if(Img.size.height > 100 || Img.size.width > 100)
        Img = [self compressImage:Img size:CGSizeMake(100,100)];
    
    [profileBtn setBackgroundImage:Img forState:UIControlStateNormal];
    [[profileBtn layer] setBorderWidth:1.0];
    [[profileBtn layer] setBorderColor:[SoclivityUtilities returnTextFontColor:4].CGColor];
    setYourPic.hidden=YES;


}
// Function to auto-crop the image if user does not
-(UIImage*) autoCrop:(UIImage*)image{
    
    CGSize dimensions = {0,0};
    float x=0.0,y=0.0;
    
    // Check to see if the image layout is landscape or portrait
    if(image.size.width > image.size.height)
    {
        // if landscape
        x = (image.size.width - image.size.height)/2;
        dimensions.width = image.size.height;
        dimensions.height = image.size.height;
        
    }
    else
    {
        // if portrait
        y = (image.size.height - image.size.width)/2;
        dimensions.height = image.size.width;
        dimensions.width = image.size.width;
                
    }
    
    // Create the mask
    CGRect imageRect = CGRectMake(x,y,dimensions.width,dimensions.height);
    
    // Create the image based on the mask created above
    CGImageRef  imageRef = CGImageCreateWithImageInRect([image CGImage], imageRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
	return image;
}

// Function to compress a large image
-(UIImage*) compressImage:(UIImage *)image size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
     NSLog(@"touchesBegan");
    
    
    
    [emailTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
    [enterNameTextField resignFirstResponder];
    [enterPasswordTextField resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    CGRect rect = CGRectMake(0, 0, 320, 480);
    self.frame = rect;
    [UIView commitAnimations];
    
    if(footerActivated){
        
        [delegate hidePickerView:nil];
        
    }
    
}
#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //set color for placeholder text
    textField.textColor = [SoclivityUtilities returnTextFontColor:1];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
    
    
     SoclivityManager *SOC=[SoclivityManager SharedInstance];
     SOC.basicInfoDone=FALSE;
    
    NSLog(@"textFieldDidBeginEditing");
    if(footerActivated){
    
        [delegate hidePickerView:nil];
    }
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
     NSLog(@"textFieldDidEndEditing");
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.25];
//    CGRect rect = CGRectMake(0, 0, 320, 480);
//    self.frame = rect;
//    [UIView commitAnimations];

    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	 NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    CGRect rect = CGRectMake(0, 0, 320, 480);
    self.frame = rect;
    [UIView commitAnimations];
        
    return NO;
}
@end
