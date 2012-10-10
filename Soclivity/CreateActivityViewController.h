//
//  CreateActivityViewController.h
//  Soclivity
//
//  Created by Kanav on 10/8/12.
//
//

#import <UIKit/UIKit.h>
#import "MJDetailViewController.h"
@protocol  NewActivityViewDelegate <NSObject>

@optional
-(void)cancelCreateActivityEventScreen;
@end


@interface CreateActivityViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,PickerDetailViewDelegate>{
    id<NewActivityViewDelegate>delegate;
    IBOutlet UILabel *createActivtyStaticLabel;
    IBOutlet UILabel *step1_of2Label;
    NSInteger activityType;
    IBOutlet UILabel *activityNameLabel;
    IBOutlet UITextField *activityNameTextField;
    IBOutlet UIView*backgroundView;
    IBOutlet UITextView*descriptionTextView;
    IBOutlet UILabel *countTextLabel;
    IBOutlet UILabel *totalCountTextLabel;
    BOOL validName;
    UILabel *placeholderLabel;
    IBOutlet UIButton*pickADayButton;
    IBOutlet UIButton*pickATimeButton;
    IBOutlet UIButton*publicPrivateButton;
    IBOutlet UITextField *capacityTextField;
    IBOutlet UILabel *blankTextLabel;
    IBOutlet UIButton*pickALocationButton;
}
@property (nonatomic,retain)id<NewActivityViewDelegate>delegate;
-(IBAction)crossClicked:(id)sender;
-(IBAction)pickADateButtonPressed:(id)sender;
-(IBAction)pickATimeButtonPressed:(id)sender;
-(IBAction)publicOrPrivateActivityButtonPressed:(id)sender;
-(IBAction)pickALocationButtonPressed:(id)sender;
@end
