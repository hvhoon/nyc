//
//  RegistrationViewControler.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicInfoView.h"
#import "ActivityTypeSelectView.h"
@interface RegistrationViewControler : UIViewController<BasicRegistrationDelegate,ActivitySelectDelegate,UIScrollViewDelegate>{
    UIScrollView* scrollView;
    BasicInfoView *basicSectionFirst;
    ActivityTypeSelectView*activitySectionSecond;
}
@property (nonatomic, retain) UIScrollView* scrollView;
@property(nonatomic,retain)IBOutlet BasicInfoView *basicSectionFirst;
@property(nonatomic,retain)IBOutlet ActivityTypeSelectView*activitySectionSecond;
@end
