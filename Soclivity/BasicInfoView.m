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
@synthesize delegate;
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
    
    basicInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 70, 300, 240)];
    [basicInfoTableView setDelegate:self];
    [basicInfoTableView setDataSource:self];
    [basicInfoTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [basicInfoTableView setSeparatorColor:[UIColor blackColor]];
    basicInfoTableView.scrollEnabled=NO;
    basicInfoTableView.layer.borderWidth = 1.0;
    basicInfoTableView.layer.borderColor = [UIColor blackColor].CGColor;
    [self addSubview:basicInfoTableView];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); // yellow line
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 128.0, 350.0); //start point
    CGContextAddLineToPoint(context, 310.0, 350.0);
    CGContextAddLineToPoint(context, 310.0, 400.0);
    CGContextAddLineToPoint(context, 128.0, 400.0); // end path
    
    CGContextClosePath(context); // close path
    
    CGContextSetLineWidth(context, 1.0); // this is set from now on until you explicitly change it
    
    CGContextStrokePath(context); // do actual stroking
    
    //CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5); // green color, half transparent
    //CGContextFillRect(context, CGRectMake(110.0, 330.0, 75, 30.0));
    
    UIButton *locationButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationButton.frame=CGRectMake(132,360,23,15);
    [locationButton addTarget:self action:@selector(LocationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:locationButton];
    
    
    CGRect locationLabelRect=CGRectMake(180,365,100,20);
    locationLabel=[[UILabel alloc] initWithFrame:locationLabelRect];
    locationLabel.textAlignment=UITextAlignmentLeft;
    locationLabel.text=@"Nowhere";
    locationLabel.font=[UIFont systemFontOfSize:13.0f];
    locationLabel.textColor=[UIColor blackColor];
    locationLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:locationLabel];
    [locationLabel release];


}
-(void)LocationButtonClicked{
    SocLocation=[[LocationCustomManager alloc]init];
    SocLocation.delegate=self;
    SocLocation.theTag=kNoLocation;

}
-(void)LocationAcquired:(NSString*)SoclivityLoc{
    locationLabel.text=SoclivityLoc;
}
-(IBAction)sectionViewChanged:(id)sender{
    [delegate timeToScrollDown];
}
#pragma mark -
#pragma  mark Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 40.0f;
}
// customize the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *profilEditIdentifier = @"ProfileEditCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profilEditIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:profilEditIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
	}
	
	UILabel * staticLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2.5, 80, 35)];
	
	staticLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    staticLabel.textColor=[UIColor blackColor];
    staticLabel.backgroundColor=[UIColor clearColor];
    staticLabel.textAlignment=UITextAlignmentLeft;
    UILabel * detailedLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 2.5, 200, 35)];
	detailedLabel.font = [UIFont systemFontOfSize:13.0f];
    detailedLabel.textColor=[UIColor grayColor];
    detailedLabel.backgroundColor=[UIColor clearColor];
    
    UITextField *enterTextField=[[UITextField alloc]initWithFrame:CGRectMake(85, 2.5, 200, 35)];
    enterTextField.font=[UIFont systemFontOfSize:13.0f];
    enterTextField.delegate=self;
    enterTextField.borderStyle=UITextBorderStyleNone;
    enterTextField.tag=indexPath.row;
    enterTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    enterTextField.keyboardType = UIKeyboardTypeDefault;
    enterTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    enterTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
    enterTextField.textColor=[UIColor blackColor];
    enterTextField.backgroundColor=[UIColor clearColor];
    enterTextField.returnKeyType=UIReturnKeyDefault;


    if(indexPath.row==kPicture){
        staticLabel.text=@"Picture";
        detailedLabel.text = @"Set your picture";
        
        UIImageView *profileImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"profile.png"]];
        profileImageView.frame=CGRectMake(270, 0, 40, 40);
        [cell.contentView addSubview:staticLabel];
        [cell.contentView addSubview:detailedLabel];
        
        [cell.contentView addSubview:profileImageView];
        
    }
    
    else if(indexPath.row==kName){
        staticLabel.text = @"Name";
        enterTextField.secureTextEntry=NO;
        enterTextField.placeholder = @"Your name";
        [cell.contentView addSubview:staticLabel];
        [cell.contentView addSubview:enterTextField];
        
    }
    
    else if(indexPath.row==kEmail){
        staticLabel.text =@"Email";
        enterTextField.secureTextEntry=NO;
        enterTextField.placeholder = @"This will be your username";
        [cell.contentView addSubview:staticLabel];
        [cell.contentView addSubview:enterTextField];
        
    }
    
    else if(indexPath.row==kPassword){
        staticLabel.text =@"Password";
        enterTextField.secureTextEntry=YES;
        enterTextField.placeholder = @"Enter your password";
        [cell.contentView addSubview:staticLabel];
        [cell.contentView addSubview:enterTextField];
        
    }
    
    
    else if(indexPath.row==kConfirm){
        staticLabel.text =@"Confirm";
        enterTextField.secureTextEntry=YES;
        enterTextField.placeholder = @"Confirm your password";
        [cell.contentView addSubview:staticLabel];
        [cell.contentView addSubview:enterTextField];
        
    }
    else if(indexPath.row==kBirthday){
        staticLabel.text =@"Birthday";
        detailedLabel.text = @"April 29,1980";
        [cell.contentView addSubview:staticLabel];
        [cell.contentView addSubview:detailedLabel];
        
    }

    
	[staticLabel release];
    [detailedLabel release];
    [enterTextField release];

    
	return cell;
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark -
#pragma mark Table cell image support

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row!=0){
        
        
        NSLog(@"Selection Made");
        
    }
    
    if(indexPath.row==kPicture){
        cameraUpload=[[CameraCustom alloc]init];
        cameraUpload.delegate=self;
        [self showUploadCaptureSheet];
        
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

    [basicInfoTableView reloadData];
}

-(void)dismissPickerModalController{
    
    [delegate dismissPickerModalController];
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[sender resignFirstResponder];
     NSLog(@"touchesBegan");
}
#pragma mark -
#pragma mark UITextFieldDelegate Methods


- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
    NSLog(@"textFieldDidBeginEditing");
    if((textField.tag==kPassword)||(textField.tag==kConfirm)){
        
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        CGRect rect = CGRectMake(0, -70, 320, 480);
        self.frame = rect;
        [UIView commitAnimations];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	
    [textField resignFirstResponder];
	
    if((textField.tag==kPassword)||(textField.tag==kConfirm)){
        
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
