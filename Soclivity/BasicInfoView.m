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

#define kNameNot 9
#define kEntryAdded 10
#define kEmailNot 11
#define kPasswordNot 12
#define kConfirmPasswordNot 13
#define kFutureBirthdayDate 14
@implementation BasicInfoView

// Private variables
BOOL validName, validEmail, validPassword, passwordsMatched;

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

// Setting the birthday
-(void)dateSelected:(NSDate*)bDate {
    
    NSLog(@"bDate=%@ and todayDate=%@",bDate,[NSDate date]);
    
    // Really not sure what this interval stuff is here for?
    NSTimeInterval interval = [bDate timeIntervalSinceDate: [NSDate date]];
    NSLog(@"interval=%f",interval);

    // Date selected must be less than today's date
    if ([bDate compare:[NSDate date]] == NSOrderedAscending) {
        
        NSLog(@"date1 is earlier than date2");
        [delegate hidePickerView:nil];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        // Format and set date on the screen
        dateFormatter.dateFormat=@"MMMM d, YYYY";
        NSString*date=[dateFormatter stringFromDate:bDate];
        [birthdayBtn setTitle:date forState:UIControlStateNormal];
        [birthdayBtn setTitleColor:[SoclivityUtilities returnTextFontColor:1] forState:UIControlStateNormal];
        
        // Format and set date in the player object
        dateFormatter.dateFormat=@"d/MM/YYYY";
        NSString*postDate=[dateFormatter stringFromDate:bDate];
        playerObj.birth_date=postDate;
        [dateFormatter release];
    }
    
    // if the date selected is today or in the future
    else {
        
        // Present an alert to the user
        NSLog(@"date1 is later than date2");
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Birthday in the future?"
															message:@"Sorry we haven't invented time travel yet!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            alert.tag=kFutureBirthdayDate;
			[alert show];
			[alert release];
			return;
			
		}
    }
}

-(void)BasicInfoFields{
    
    SoclivityManager *SOC=[SoclivityManager SharedInstance];
    SOC.basicInfoDone=FALSE;
        
    NSLog(@"enterNameTextField=%@",enterNameTextField.text);
    NSLog(@"emailTextField=%@",emailTextField.text);
    NSLog(@"enterPasswordTextField=%@",enterPasswordTextField.text);
    NSLog(@"confirmPasswordTextField=%@",confirmPasswordTextField.text);
    
    
    if(!enterNameTextField.text.length && !emailTextField.text.length && !enterPasswordTextField.text.length && !confirmPasswordTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields"
                                                        message:@"Just need a name, email and password to register."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNameNot;
        [alert show];
        [alert release];
        return;
        
    }
    
    // Alert if the name is not valid
    if(!validName){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really?"
                                                        message:@"Your name must have at least 2 characters."
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kNameNot;
        [alert show];
        [alert release];
        return;
    }
        
     // Alert if the email is not valid
    if(!validEmail){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                        message:@"Promise not to send you spam!"
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kEmailNot;
        [alert show];
        [alert release];
        return;
    }
    
    // Alert is the password is not valid
    if(!validPassword){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Security Alert!"
                                                        message:@"Your password should have at least 6 characters."
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordNot;
        [alert show];
        [alert release];
        return;
    }
        
    if(passwordsMatched){
        
        NSLog(@"Password Matched");
        SOC.basicInfoDone=TRUE;
    }
    else {
        
        enterPasswordTextField.text=@"";
        confirmPasswordTextField.text=@"";
        
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Passwords do not match"
                                                                message:@"Try again......slowly."
                                                                delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
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
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing");
    
    // Checking the name field
    if(textField == enterNameTextField) {
        // Check length of the name
        NSInteger length;
        length = [textField.text length];
        if (length<2)
            validName = NO;
        else
            validName = YES;
    }
    
    // Checking the email field
    if(textField == emailTextField) {
        
        // Make sure the field is no empty
        if(![textField.text isEqualToString:@""]){
            
            // Make sure it contains an '@' and '.'
            NSString *searchForMe = @"@";
            NSRange rangeCheckAtTheRate = [textField.text rangeOfString : searchForMe];
            
            NSString *searchFor = @".";
            NSRange rangeCheckFullStop = [textField.text rangeOfString : searchFor];
            
            if (rangeCheckAtTheRate.location != NSNotFound && rangeCheckFullStop.location !=NSNotFound){
                
                // Ensure it has enough characters
                NSString * charToCount = @"@";
                NSArray * array = [textField.text componentsSeparatedByString:charToCount];
                NSInteger numberOfChar=[array count];
                
                if(numberOfChar==2)
                    validEmail = YES;
            }
        }
        else
            validEmail = NO;
    }
    
    // Checking the password
    if(textField == enterPasswordTextField) {
        // Check length of the password
        NSInteger length;
        length = [textField.text length];
        if (length<6)
            validPassword = NO;
        else
            validPassword = YES;
    }
    
    // Checking to see if the passwords match
    if(textField == confirmPasswordTextField){
        if([textField.text isEqualToString:enterPasswordTextField.text]){
            passwordsMatched = YES;
        }
        else
            passwordsMatched = NO;
    }
}
    
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	 NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    
    // If all the fields are valid, let the user move to the next screen
    if(validName && validEmail && validPassword && passwordsMatched)
        [[NSNotificationCenter defaultCenter] postNotificationName:kStartScrolling object:nil];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:kStopScrolling object:nil];
    
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    CGRect rect = CGRectMake(0, 0, 320, 480);
    self.frame = rect;
    [UIView commitAnimations];
        
    return NO;
}
@end
