//
//  PickATimeView.h
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import <UIKit/UIKit.h>


@protocol PickTimeViewDelegate <NSObject>

@optional
- (void)dismissPicker:(id)sender;
-(void)activityTimeSelected:(NSDate*)activityTime;
@end

@interface PickATimeView : UIView{
    IBOutlet UIDatePicker *timePicker;
    id<PickTimeViewDelegate>delegate;
    BOOL editActivity;
    NSDate *activityDate;
}
@property (nonatomic,assign)BOOL editActivity;
@property (nonatomic,retain)id<PickTimeViewDelegate>delegate;
@property (nonatomic,retain)NSDate*activityDate;
-(IBAction)crossButtonClicked:(id)sender;
-(IBAction)tickButtonPressed:(id)sender;

@end
