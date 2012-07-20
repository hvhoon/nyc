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
    IBOutlet UIImageView *activityAccessStatusImgView;
    IBOutlet UILabel*activityTextLabel;
    IBOutlet UILabel *organizerLinkLabel;
    IBOutlet UILabel*activityorganizerTextLabel;
    IBOutlet UIImageView *DOSConnectionImgView;
    id <AddEventViewDelegate>delegate;
    IBOutlet UIImageView *profileImgView;
    
    IBOutlet UILabel*calendarDateLabel;
    IBOutlet UILabel*activityTimeLabel;
    IBOutlet UILabel*locationInfoLabel1;
    IBOutlet UILabel*locationInfoLabel2;
    IBOutlet UIView *bottomView;
    IBOutlet UIImageView *calendarIcon;
    IBOutlet UIImageView *clockIcon;
    IBOutlet UIImageView *locationIcon;

}
@property (nonatomic,retain)InfoActivityClass *activityObject;
@property (nonatomic,retain)id <AddEventViewDelegate>delegate;
@property (nonatomic,retain)UILabel*locationInfoLabel2;
-(void)loadViewWithActivityDetails:(InfoActivityClass*)info;
@end
