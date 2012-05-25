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
#import "SFHFKeychainUtils.h"
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
#define kFutureBirthdayDate 14
@implementation BasicInfoView

// Private variables
BOOL validName, validEmail, validPassword, passwordsMatched, locationEntered;

@synthesize delegate,enterNameTextField,emailTextField,enterPasswordTextField,confirmPasswordTextField,playerObj,facebookTag;
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
    SOC=[SoclivityManager SharedInstance];
    SOC.basicInfoDone = NO;

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
    
    
    if(facebookTag){
        emailTextField.text=SOC.fbObject.email;
        emailTextField.enabled = NO;
        enterPasswordTextField.enabled=NO;
        confirmPasswordTextField.enabled=NO;
        if(SOC.fbObject.FBProfileImage.size.height != SOC.fbObject.FBProfileImage.size.width)
            SOC.fbObject.FBProfileImage = [self autoCrop:SOC.fbObject.FBProfileImage];
        
        // If the image needs to be compressed
        if(SOC.fbObject.FBProfileImage.size.height > 100 || SOC.fbObject.FBProfileImage.size.width > 100)
            SOC.fbObject.FBProfileImage = [self compressImage:SOC.fbObject.FBProfileImage size:CGSizeMake(100,100)];
        
        SOC.fbObject.profileImageData=UIImagePNGRepresentation(SOC.fbObject.FBProfileImage);
        [profileBtn setBackgroundImage:SOC.fbObject.FBProfileImage forState:UIControlStateNormal];
        [[profileBtn layer] setBorderWidth:1.0];
        [[profileBtn layer] setBorderColor:[SoclivityUtilities returnTextFontColor:4].CGColor];
        setYourPic.hidden=YES;
        
        NSLog(@"firstName=%@",SOC.fbObject.first_name);
        NSLog(@"last_name=%@",SOC.fbObject.last_name);
        NSLog(@"email=%@",SOC.fbObject.email);
        NSLog(@"gender=%@",SOC.fbObject.gender);
        NSLog(@"birth_date=%@",SOC.fbObject.birth_date);
        
        if([SOC.fbObject.gender isEqualToString:@"male"]){
            [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_male.png"] forState:UIControlStateNormal];
            b_Female=FALSE;
            playerObj.gender=@"m";
            b_Male=TRUE;
            [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_F_notselected.png"] forState:UIControlStateNormal];
        }
        else if([SOC.fbObject.gender isEqualToString:@"female"]){
            [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_female.png"] forState:UIControlStateNormal];
            b_Male=FALSE;
            b_Female=TRUE;
            playerObj.gender=@"f";
            [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_M_notselected.png"] forState:UIControlStateNormal];
        }
        else{
            NSLog(@"No gender Selected");
        }
        
        if((SOC.fbObject.birth_date==(NSString*)[NSNull null])||([SOC.fbObject.birth_date isEqualToString:@""]||SOC.fbObject.birth_date==nil)||([SOC.fbObject.birth_date isEqualToString:@"(null)"])){
             NSLog(@"No birth_date Selected");
        }
        
        // We are not pulling location information right now
        /*
        if((SOC.fbObject.current_location==(NSString*)[NSNull null])||([SOC.fbObject.current_location isEqualToString:@""]||SOC.fbObject.current_location==nil)||([SOC.fbObject.current_location isEqualToString:@"(null)"])){
            NSLog(@"No current_location Selected");
        }*/

        
        BOOL fName=TRUE;
        BOOL lName=TRUE;
        if ((SOC.fbObject.first_name==(NSString*)[NSNull null])||([SOC.fbObject.first_name isEqualToString:@""]||SOC.fbObject.first_name==nil)||([SOC.fbObject.first_name isEqualToString:@"(null)"])){
            fName=FALSE;
        }
        
        if ((SOC.fbObject.last_name==(NSString*)[NSNull null])||([SOC.fbObject.last_name isEqualToString:@""]||SOC.fbObject.last_name==nil)||([SOC.fbObject.last_name isEqualToString:@"(null)"])){
            lName=FALSE;
        }
        
        
        if(fName && lName){
            SOC.fbObject.fullName=[NSString stringWithFormat:@"%@ %@",SOC.fbObject.first_name,SOC.fbObject.last_name];
        }
        
        if(fName && !lName){
           SOC.fbObject.fullName=[NSString stringWithFormat:@"%@",SOC.fbObject.first_name];
        }
        
        if(!fName && lName){
            SOC.fbObject.fullName=[NSString stringWithFormat:@"%@",SOC.fbObject.last_name];
        }
        
        enterNameTextField.text=SOC.fbObject.fullName;
        NSInteger length;
        length = [enterNameTextField.text length];
        if (length<2)
            validName = NO;
        else
            validName = YES;
        
        validEmail=YES;
        validPassword = YES;
        passwordsMatched =YES;



   }
    
}
-(IBAction)BackButtonClicked:(id)sender{
    [delegate BackButtonClicked];
    
    // Once you go back you need to re-enter all your basic information.
    SOC.basicInfoDone = NO;
    validName = NO;
    validEmail = NO;
    validPassword = NO;
    passwordsMatched = NO;
    locationEntered = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:kStopScrolling object:nil];
    
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
        locationEntered = YES;
        
        
        // If all the fields are valid, let the user move to the next screen
        if(validName && validEmail && validPassword && passwordsMatched && locationEntered){
            SOC.basicInfoDone = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kStartScrolling object:nil];
        }
        else {
            SOC.basicInfoDone = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kStopScrolling object:nil];
        }
    }
}
-(IBAction)genderChanged:(UIButton*)sender{
    
    playerObj.gender=nil;
    
    switch (sender.tag) {
        case kMale:
        {
            
            b_Male=!b_Male;
             [femaleButton setBackgroundImage:[UIImage imageNamed:@"S02_F_notselected.png"] forState:UIControlStateNormal];
            
            if(b_Male){
            [maleButton setBackgroundImage:[UIImage imageNamed:@"S02_male.png"] forState:UIControlStateNormal];
                b_Female=FALSE;
                 playerObj.gender=@"m";
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
                 playerObj.gender=@"f";
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
            
    NSLog(@"enterNameTextField=%@",enterNameTextField.text);
    NSLog(@"emailTextField=%@",emailTextField.text);
    NSLog(@"enterPasswordTextField=%@",enterPasswordTextField.text);
    NSLog(@"confirmPasswordTextField=%@",confirmPasswordTextField.text);
    
    if(!enterNameTextField.text.length && !emailTextField.text.length && !enterPasswordTextField.text.length && !confirmPasswordTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields"
                                                        message:@"Just need a name, email, location and password to register."
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
        
        // Clear both the password fields if an invalid password is entered
        enterPasswordTextField.text = @"";
        confirmPasswordTextField.text = @"";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Security Alert!"
                                                        message:@"Your password should have at least 6 characters."
                                                        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        alert.tag=kPasswordNot;
        [alert show];
        [alert release];
        return;
    }
    
    // Alert if the passwords do not match
    if(!passwordsMatched){
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
        
    if(locationEntered){
        
        NSLog(@"Information stored in player object");
        playerObj.email=emailTextField.text;
        playerObj.password=enterPasswordTextField.text;
        playerObj.password_confirmation=confirmPasswordTextField.text;
        NSArray *wordsAndEmptyStrings = [enterNameTextField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
        if([words count]>=2){
            playerObj.first_name=[words objectAtIndex:0];
            playerObj.last_name=[words objectAtIndex:1];
        }
        else{
            playerObj.first_name=[words objectAtIndex:0];
        }
        
        if([ SFHFKeychainUtils storeUsername:@"password" andPassword:enterPasswordTextField.text forServiceName:@"Soclivity" updateExisting:YES error:nil])
            NSLog(@"Password Encrypted");
        
        if([ SFHFKeychainUtils storeUsername:@"emailAddress" andPassword:emailTextField.text forServiceName:@"Soclivity" updateExisting:YES error:nil])
            NSLog(@"EmailAddress Encrypted");


    }
    else{
        
        // The user must be alerted that they need to enter a location
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where are you?"
                                                                message:@"Without this we can't show you stuff that's happening in your area!"
                                                               delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        
        [alert show];
        [alert release];
        return;

    }
}

#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView resignFirstResponder];
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
    
    playerObj.profileImageData=UIImagePNGRepresentation(Img);
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
    if(textField == emailTextField)
        validEmail = [SoclivityUtilities validEmail:emailTextField.text];
    
    // Checking the password
    if(textField == enterPasswordTextField)
        validPassword = [SoclivityUtilities validPassword:enterPasswordTextField.text];
    
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
    if(validName && validEmail && validPassword && passwordsMatched && locationEntered){
        SOC.basicInfoDone = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kStartScrolling object:nil];
    }
    else {
        SOC.basicInfoDone = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:kStopScrolling object:nil];
    }
    
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    CGRect rect = CGRectMake(0, 0, 320, 480);
    self.frame = rect;
    [UIView commitAnimations];
        
    return NO;
}
@end
