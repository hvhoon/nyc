//
//  AddEventView.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddEventViewDelegate <NSObject>

@optional
-(void)pushToHomeViewController;
@end


@interface AddEventView : UIView{
    InfoActivityClass *activityObject;
    IBOutlet UIImageView *activityBarImgView;
    IBOutlet UIImageView *activityBarTextImgView;
    IBOutlet UILabel*activityTextLabel;
    IBOutlet UILabel *goingCountLabel;
    IBOutlet UIImageView *activityCreatedImgView;
    IBOutlet UILabel*activityorganizerTextLabel;
    IBOutlet UILabel *peopleYouKnowCountLabel;
    IBOutlet UIButton *DOS1_ArrowButton;
    IBOutlet UILabel *peopleYouMayKnowCountLabel;
    IBOutlet UITextView *whatDescTextView;
    IBOutlet UIImageView *DOSConnectionImgView;
    IBOutlet UIImageView *backgroundBoxImgView;
    id <AddEventViewDelegate>delegate;
    IBOutlet UILabel *whenActivityLabel;
    IBOutlet UILabel *whereAddressActivityLabel;
    IBOutlet UIImageView *profileImgView;
    IBOutlet UIButton *locationButton;
    IBOutlet UIButton *DOS2_ArrowButton;

}
@property (nonatomic,retain)InfoActivityClass *activityObject;
@property (nonatomic,retain)id <AddEventViewDelegate>delegate;
@property (nonatomic,retain)IBOutlet UIButton *DOS2_ArrowButton;
@property (nonatomic,retain)IBOutlet UIButton *locationButton;
-(IBAction)OneDOSFriendListSelect:(id)sender;
-(IBAction)SecondDOSFriendListSelect:(id)sender;
-(IBAction)plotActivityOnMap:(id)sender;
-(void)loadViewWithActivityDetails:(InfoActivityClass*)info;
@end
