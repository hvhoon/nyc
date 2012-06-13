//
//  LaterDateView.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LaterDateViewDelegate <NSObject>

@optional
-(void)pushTransformWithAnimation;
@end

@interface LaterDateView : UIView{
     id <LaterDateViewDelegate>delegate;
}
@property (nonatomic,retain) id <LaterDateViewDelegate>delegate;
-(IBAction)backTapped:(id)sender;
@end
