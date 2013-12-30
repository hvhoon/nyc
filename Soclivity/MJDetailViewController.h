//
//  MJDetailViewController.h

#import <UIKit/UIKit.h>
#import "PickADateView.h"
#import "PickATimeView.h"
#import "SelectPublicPrivateView.h"
typedef enum {
    PickADateViewAnimationNew = 1,
    PickATimeViewAnimationNew,
    PrivatePublicViewAnimationNew,
    PickADateViewAnimationEdit,
    PickATimeViewAnimationEdit,
    PrivatePublicViewAnimationEdit

} PickerPopupViewAnimation;


@protocol PickerDetailViewDelegate <NSObject>

@optional
- (void)dismissPickerFromView:(id)sender;
-(void)pickADateSelectionDone:(NSString*)activityDate;
-(void)pickATimeSelectionDone:(NSString*)activityTime;
-(void)privacySelectionDone:(int)row;
@end


@interface MJDetailViewController : UIViewController<PickDateViewDelegate,PickTimeViewDelegate,PrivacyViewDelegate>{
    
    IBOutlet PickADateView *pickADateView;
    id<PickerDetailViewDelegate>delegate;
    PickerPopupViewAnimation type;
    IBOutlet PickATimeView *pickATimeView;
    IBOutlet SelectPublicPrivateView *privatePublicView;
    int privacy;
    NSDate *timeOfTheActivity;
    NSDate*dateOfTheActivity;
}
@property (nonatomic,assign)int privacy;
@property (nonatomic,assign)PickerPopupViewAnimation type;
@property (nonatomic,retain) PickADateView *pickADateView;
@property (nonatomic,retain)id<PickerDetailViewDelegate>delegate;
@property (nonatomic,retain)NSDate *timeOfTheActivity;
@property (nonatomic,retain)NSDate *dateOfTheActivity;
@end
