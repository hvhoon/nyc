//
//  PickADateView.m
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import "PickADateView.h"
#import "SoclivityUtilities.h"
@implementation PickADateView
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
    [delegate dismissDatePicker:sender];
}

-(IBAction)tickButtonPressed:(id)sender{
    
    NSString *activityDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityDate"];
    
    if((activityDate==(NSString*)[NSNull null])||([activityDate isEqualToString:@""]||activityDate==nil)||([activityDate isEqualToString:@"(null)"])){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Select A Date To Continue" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
    else{

    
        [delegate activityDateSelected:[[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityDate"]];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    pickADateLabel.text=@"Pick a date";
    
    pickADateLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    pickADateLabel.textColor=[UIColor whiteColor];
    pickADateLabel.backgroundColor=[UIColor clearColor];
    pickADateLabel.shadowColor = [UIColor blackColor];
    pickADateLabel.shadowOffset = CGSizeMake(0,-1);

    
    calendarDate=[[CalendarDateView alloc]initWithFrame:CGRectMake(0, 44, 320,254)];
    calendarDate.KALDelegate=self;
    calendarDate.pickADateForActivity=TRUE;
    [self addSubview:calendarDate];


}


@end
