//
//  PickADateView.h
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import <UIKit/UIKit.h>
#import "CalendarDateView.h"

@protocol PickDateViewDelegate <NSObject>

@optional
- (void)dismissPicker:(id)sender;
-(void)activityDateSelected:(NSString*)activityDate;
@end


@interface PickADateView : UIView<CalendarDateViewDelegate>{
    
    IBOutlet UILabel *pickADateLabel;
    id<PickDateViewDelegate>delegate;
    CalendarDateView *calendarDate;
}
-(IBAction)crossButtonClicked:(id)sender;
-(IBAction)tickButtonPressed:(id)sender;
@property (nonatomic,retain)id<PickDateViewDelegate>delegate;
@end
