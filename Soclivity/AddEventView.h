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
    
    IBOutlet UIImageView *backgroundBoxImgView;
    
    IBOutlet UIImageView *activityAccessStatusImgView;

    IBOutlet UILabel*activityTextLabel;
    IBOutlet UILabel *organizerLinkLabel;
    IBOutlet UIImageView *activityCreatedImgView;
    IBOutlet UILabel*activityorganizerTextLabel;
    IBOutlet UITextView *whatDescTextView;
    IBOutlet UIImageView *DOSConnectionImgView;
    id <AddEventViewDelegate>delegate;
    IBOutlet UIImageView *profileImgView;
    
    IBOutlet UILabel*calendarDateLabel;
    IBOutlet UILabel*activityTimeLabel;
    IBOutlet UILabel*distanceLocationLabel;
    IBOutlet UILabel*locationInfoLabel;
    IBOutlet UIView *bottomView;
    BOOL opened;
    int delta;
    float yTextLabel;
    BOOL collapse;

}
@property (nonatomic,retain)InfoActivityClass *activityObject;
@property (nonatomic,retain)id <AddEventViewDelegate>delegate;
-(void)loadViewWithActivityDetails:(InfoActivityClass*)info;
@end
