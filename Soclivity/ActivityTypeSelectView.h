//
//  ActivityTypeSelectView.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ActivitySelectDelegate <NSObject>

@optional
-(void)timeToScrollUp;
-(void)pushHomeViewCntrlr;
@end

@interface ActivityTypeSelectView : UIView{
    id <ActivitySelectDelegate>delegate;
}
@property (nonatomic,retain)id <ActivitySelectDelegate>delegate;
-(IBAction)sectionViewChanged:(id)sender;
-(IBAction)getStartedClicked:(id)sender;
@end
