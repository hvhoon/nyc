//
//  SelectPublicPrivateView.m
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import "SelectPublicPrivateView.h"
#import "SoclivityUtilities.h"
@implementation SelectPublicPrivateView
@synthesize delegate,editActivity,rowSelected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)crossButtonClicked:(id)sender{
    
[delegate dismissPicker:sender];   
}
-(IBAction)tickButtonPressed:(id)sender{
 
    [delegate privacySelection:[privacyPicker selectedRowInComponent:0]];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    cancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    selectButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:17];
    
    switch (rowSelected) {
        case 0:
        {
            [privacyPicker reloadAllComponents];
            [privacyPicker selectRow:0 inComponent:0 animated:YES];
            
        }
            break;
            
        case 1:
        {
            [privacyPicker reloadAllComponents];
            [privacyPicker selectRow:1 inComponent:0 animated:YES];
        }
            break;
    }

}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 2;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"index Selected =%d",[pickerView selectedRowInComponent:0]);
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
   
    
    UIView *myColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)]; //Set desired frame
    myColorView.backgroundColor = [UIColor clearColor]; //Set desired color or add a UIImageView if you want...
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30,8, 20, 20)];
    CGRect privacyLabelRect=CGRectMake(60,7.5,100,22);
    CGRect privacyTextRect=CGRectMake(110,7.5,200, 22);
    
    UILabel *privacyLabel=[[UILabel alloc] initWithFrame:privacyLabelRect];
    privacyLabel.textAlignment=NSTextAlignmentLeft;
    
    UILabel *privacyText=[[UILabel alloc] initWithFrame:privacyTextRect];
    privacyText.textAlignment=NSTextAlignmentLeft;
    
    privacyLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:16];
    privacyLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    privacyLabel.backgroundColor=[UIColor clearColor];
    
    privacyText.font=[UIFont fontWithName:@"Helvetica-Condensed" size:14];
    privacyText.textColor=[SoclivityUtilities returnTextFontColor:5];
    privacyText.backgroundColor=[UIColor clearColor];
    
    
    switch (row) {
            
        case 0:
        {
            privacyLabel.text=[NSString stringWithFormat:@"Public"];
            privacyText.text=[NSString stringWithFormat:@"(Anybody can view this event)"];
            myImageView.image=[UIImage imageNamed:@"S05_public5.png"];
            
        }
            break;
            
        case 1:
        {
            privacyLabel.text=[NSString stringWithFormat:@"Private"];
            privacyText.text=[NSString stringWithFormat:@"(Only invitees can view this event)"];
            myImageView.image=[UIImage imageNamed:@"S05_private5.png"];
            
        }
            break;
            
    }
    
    
    [myColorView addSubview:privacyLabel];
    [privacyLabel release];
    
    [myColorView addSubview:privacyText];
    [privacyText release];
    
    [myColorView addSubview:myImageView];
    [myImageView release];
    
    
    return myColorView;
}
#if 0
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
    componentWidth = 275.0;
    
    return componentWidth;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    CGFloat componentHeight = 0.0;
    componentHeight = 100.0;
    
    return componentHeight;
    
}

#endif

- (void)dealloc {
    [selectButton release];
    [cancelButton release];
    [cancelButton release];
    [super dealloc];
}
@end
