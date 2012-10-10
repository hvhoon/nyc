//
//  MJDetailViewController.m

#import "MJDetailViewController.h"

@implementation MJDetailViewController
@synthesize pickADateView;
@synthesize delegate;
@synthesize type;



-(void)viewDidLoad{
    
    switch (type) {
        case PickADateViewAnimation:
        {
            pickADateView.delegate=self;
            self.view=pickADateView;
            
        }
            break;
            
        case PickATimeViewAnimation:
        {
            pickATimeView.delegate=self;

            self.view=pickATimeView;
            
        }
            break;
        case PublicViewAnimation:
        {
            self.view=pickADateView;
            
        }
            break;
    }
}

- (void)dismissDatePicker:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissPickerFromView:)]) {
        [self.delegate dismissPickerFromView:sender];
    }
}


-(void)activityDateSelected:(NSString*)date{

    if (self.delegate && [self.delegate respondsToSelector:@selector(pickADateSelectionDone:)]) {
        [self.delegate pickADateSelectionDone:date];
    }

}

-(void)activityTimeSelected:(NSString*)time{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickATimeSelectionDone:)]) {
        [self.delegate pickATimeSelectionDone:time];
    }
    
}

@end
