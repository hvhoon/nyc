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
@synthesize delegate;
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
    
    privacyTextLabel.text=@"Pick visibility";
    
    privacyTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    privacyTextLabel.textColor=[UIColor whiteColor];
    privacyTextLabel.backgroundColor=[UIColor clearColor];
    privacyTextLabel.shadowColor = [UIColor blackColor];
    privacyTextLabel.shadowOffset = CGSizeMake(0,-1);

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
    
    UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 7.5, 21, 20)];

    CGRect privacyLabelRect=CGRectMake(60,7.5,260,22);
    UILabel *privacyLabel=[[UILabel alloc] initWithFrame:privacyLabelRect];
    privacyLabel.textAlignment=UITextAlignmentLeft;
    
    privacyLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:14];
    privacyLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
    privacyLabel.backgroundColor=[UIColor clearColor];
    
    
    switch (row) {
            
        case 0:
        {
            privacyLabel.text=[NSString stringWithFormat:@"Public (Anybody can view this event)"];
            myImageView.image=[UIImage imageNamed:@"S05_public5.png"];
            
        }
            break;
            
        case 1:
        {
            privacyLabel.text=[NSString stringWithFormat:@"Private (Only invitees can view this event)"];
            myImageView.image=[UIImage imageNamed:@"S05_private5.png"];
            
        }
            break;
            
            
            
            
    }
    
    
    [myColorView addSubview:privacyLabel];
    [privacyLabel release];
    
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

@end
