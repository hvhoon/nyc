//
//  MJDetailViewController.h

#import <UIKit/UIKit.h>
#import "PickADateView.h"
#import "PickATimeView.h"
typedef enum {
    PickADateViewAnimation = 1,
    PickATimeViewAnimation,
    PublicViewAnimation
} PickerPopupViewAnimation;


@protocol PickerDetailViewDelegate <NSObject>

@optional
- (void)dismissPickerFromView:(id)sender;
-(void)pickADateSelectionDone:(NSString*)activityDate;
-(void)pickATimeSelectionDone:(NSString*)activityTime;
@end


@interface MJDetailViewController : UIViewController<PickDateViewDelegate,PickTimeViewDelegate>{
    
    IBOutlet PickADateView *pickADateView;
    id<PickerDetailViewDelegate>delegate;
    PickerPopupViewAnimation type;
    IBOutlet PickATimeView *pickATimeView;
}
@property (nonatomic,assign)PickerPopupViewAnimation type;
@property (nonatomic,retain) PickADateView *pickADateView;
@property (nonatomic,retain)id<PickerDetailViewDelegate>delegate;
@end
