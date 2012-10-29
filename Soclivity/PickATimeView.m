//
//  PickATimeView.m
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import "PickATimeView.h"

@implementation PickATimeView
@synthesize delegate,editActivity,activityTime,activityDate;
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
        [timePicker setDate:activityTime animated:YES];
    }
    else
        
    pickATimeLabel.text=@"Pick a time";
    
    NSDate *setFinishDate=nil;
    
    NSLog(@"NSDate=%@",[NSDate date]);
    
    int type=0;
    NSDate * today = [NSDate date];
    NSComparisonResult result = [today compare:activityDate];
    switch (result)
    {
        case NSOrderedAscending:
            NSLog(@"Future Date");
            break;
        case NSOrderedDescending:{
            type=1;
            NSLog(@"Earlier Date");

        }
            break;
        case NSOrderedSame:
        {
            type=1;
            NSLog(@"Today/Null Date Passed");
        }
            break;
        default:
            NSLog(@"Error Comparing Dates");
            break;
    }
    if(type==1){
        NSDate *dateToSet = activityDate;

    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                               fromDate:dateToSet];
    [components setHour: hour];
    [components setMinute:minute];
    [components setSecond:00];
    setFinishDate=[myCalendar dateFromComponents:components];
    }
    else{
        setFinishDate=activityDate;
    }

    [timePicker setMinimumDate:setFinishDate];
    
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
    
    if(!editActivity){
        [[NSUserDefaults standardUserDefaults] setValue:timePicker.date forKey:@"ActivityDate"];

    }
    
    [delegate activityTimeSelected:timePicker.date];

}



@end
