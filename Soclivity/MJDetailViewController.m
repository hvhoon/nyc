//
//  MJDetailViewController.m

#import "MJDetailViewController.h"

@implementation MJDetailViewController
@synthesize pickADateView;
@synthesize delegate;
@synthesize type;



-(void)viewDidLoad{
    
    switch (type) {
        case PickADateViewAnimationNew:
        {
            pickADateView.delegate=self;
            self.view=pickADateView;
            
        }
            break;
            
        case PickATimeViewAnimationNew:
        {
            pickATimeView.delegate=self;

            self.view=pickATimeView;
            
        }
            break;
        case PrivatePublicViewAnimationNew:
        {
            privatePublicView.delegate=self;
            self.view=privatePublicView;
            
        }
            break;
            
            
        case PickADateViewAnimationEdit:
        {
            pickADateView.delegate=self;
            pickADateView.editActivity=YES;
            self.view=pickADateView;
            
        }
            break;
            
        case PickATimeViewAnimationEdit:
        {
            pickATimeView.delegate=self;
            pickATimeView.editActivity=YES;
            self.view=pickATimeView;
            
        }
            break;
        case PrivatePublicViewAnimationEdit:
        {
            privatePublicView.editActivity=YES;
            privatePublicView.delegate=self;
            self.view=privatePublicView;
            
        }
            break;

    }
}

- (void)dismissPicker:(id)sender
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
-(void)privacySelection:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacySelectionDone:)]) {
        [self.delegate privacySelectionDone:index];
    }
    
}

@end
