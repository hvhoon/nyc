//
//  SelectPublicPrivateView.h
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import <UIKit/UIKit.h>

@protocol  PrivacyViewDelegate <NSObject>

@optional
- (void)dismissPicker:(id)sender;
-(void)privacySelection:(NSInteger)index;
@end


@interface SelectPublicPrivateView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>{
    id <PrivacyViewDelegate>delegate;
    IBOutlet UIPickerView *privacyPicker;
    IBOutlet UILabel *privacyTextLabel;
    BOOL editActivity;
    int rowSelected;

}
@property (nonatomic,retain)id <PrivacyViewDelegate>delegate;
@property (nonatomic,assign)BOOL editActivity;
@property (nonatomic,assign)int rowSelected;
-(IBAction)crossButtonClicked:(id)sender;
-(IBAction)tickButtonPressed:(id)sender;

@end
