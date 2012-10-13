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
-(void)activityDateSelected:(NSDate*)activityDate;
@end


@interface PickADateView : UIView<CalendarDateViewDelegate>{
    
    IBOutlet UILabel *pickADateLabel;
    id<PickDateViewDelegate>delegate;
    CalendarDateView *calendarDate;
    BOOL editActivity;
    NSDate *activityDate;
    NSDate *activityTime;
}
-(IBAction)crossButtonClicked:(id)sender;
-(IBAction)tickButtonPressed:(id)sender;
@property (nonatomic,assign)BOOL editActivity;
@property (nonatomic,retain)id<PickDateViewDelegate>delegate;
@property (nonatomic,retain)    NSDate *activityDate;
@property (nonatomic,retain)    NSDate *activityTime;
@end
