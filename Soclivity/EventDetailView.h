//
//  EventDetailView.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoActivityClass;
@interface EventDetailView : UIView{
    IBOutlet UIImageView *activityBarView;
    IBOutlet UILabel*activityTextLabel;
    InfoActivityClass *activityObject;
    IBOutlet UILabel *whenTextLabel;
    IBOutlet UILabel *whereTextLabel;
    IBOutlet UILabel *whatTextLabel;
    IBOutlet UILabel *goingCountLabel;
    IBOutlet UILabel *peopleYouKnowCountLabel;
    IBOutlet UILabel *peopleYouMayKnowCountLabel;
    IBOutlet UIButton *joinButton;
}
@property (nonatomic,retain)InfoActivityClass *activityObject;
- (id)initWithFrame:(CGRect)frame info:(InfoActivityClass*)info;
@end
