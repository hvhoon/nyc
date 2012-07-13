//
//  BlockedListViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BlockedListViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface BlockedListViewController : UIViewController{
    id <BlockedListViewDelegate>delegate;
}
@property (nonatomic,retain)id <BlockedListViewDelegate>delegate;
-(IBAction)profileSliderPressed:(id)sender;

@end
