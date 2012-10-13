//
//  PickATimeView.m
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import "PickATimeView.h"

@implementation PickATimeView
@synthesize delegate,editActivity;
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
    if(editActivity){
    pickATimeLabel.text=@"Change time";
    }
     else
    pickATimeLabel.text=@"Pick a time";
    
    pickATimeLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:17];
    pickATimeLabel.textColor=[UIColor whiteColor];
    pickATimeLabel.backgroundColor=[UIColor clearColor];
    pickATimeLabel.shadowColor = [UIColor blackColor];
    pickATimeLabel.shadowOffset = CGSizeMake(0,-1);

}

-(IBAction)crossButtonClicked:(id)sender{
     [delegate dismissPicker:sender];   
}
-(IBAction)tickButtonPressed:(id)sender{
 
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"]; //24hr time format
    NSString *timeString = [outputFormatter stringFromDate:timePicker.date];
    [outputFormatter release];
    
    NSLog(@"Time Selected=%@",timeString);
    
    [delegate activityTimeSelected:timePicker.date];

}



@end
